import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:homestay_raya1/views/loginscreen.dart';
import 'package:homestay_raya1/views/newhomestay.dart';
import 'package:homestay_raya1/views/registrationscreen.dart';
import 'package:geocoding/geocoding.dart';

import '../models/user.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({super.key, required this.user});


  @override
  State<MainScreen> createState() => _MainScreenState();
  
}

class _MainScreenState extends State<MainScreen> {
  var _lat, lng;
  late Position _position;
  var placemarks;
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HomeStay Raya",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic)),
        actions: [
          IconButton(
              onPressed: _registration,
              icon: const Icon(Icons.app_registration)),
              IconButton(
              onPressed: _loginForm,
              icon: const Icon(Icons.login)),
               IconButton(
              onPressed: _newHome,
              icon: const Icon(Icons.home)),
        ],
      ),
      body: const Center(
        child: Text("Main page"),
      ),
    );
  }

  void _registration() {
    Navigator.push(context,
        MaterialPageRoute(builder: ((context) => const RegistrationScreen())));
  }
  

  void _loginForm() {
    Navigator.push(context,
        MaterialPageRoute(builder: ((context) => const loginscreen())));
  }


Future<void> _newHome() async {
  
    
    if (await _checkPermissionGetLoc()) {
      
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (content) => NewHomeScreen(
                  position: _position,
                  user: widget.user,
                  placemarks: placemarks)));
      _loadProducts();
    } else {
      Fluttertoast.showToast(
          msg: "Please allow the app to access the location",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
    }
  }

//check permission,get location,get address return false if any problem.
  Future<bool> _checkPermissionGetLoc() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(
            msg: "Please allow the app to access the location",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        Geolocator.openLocationSettings();
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg: "Please allow the app to access the location",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      Geolocator.openLocationSettings();
      return false;
    }
    _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    try {
      placemarks = await placemarkFromCoordinates(
          _position.latitude, _position.longitude);
    } catch (e) {
      Fluttertoast.showToast(
          msg:
              "Error in fixing your location. Make sure internet connection is available and try again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return false;
    }
    return true;
  }
  
  void _loadProducts() {}
}


