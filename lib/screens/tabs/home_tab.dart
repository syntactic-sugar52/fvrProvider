import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fprovider_app/config/configmaps.dart';
import 'package:fprovider_app/constants/colors.dart';
import 'package:fprovider_app/constants/widgets.dart';
import 'package:fprovider_app/models/favrProviders.dart';
import 'package:fprovider_app/screens/notification/push_notification_service.dart';
import 'package:fprovider_app/services/methods.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';

class HomeTab extends StatefulWidget {
  HomeTab({Key key}) : super(key: key);
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  bool state = false;
  GoogleMapController _newGoogleMapController;
  bool val = false;
  String textValStatus = '';
  var geoLocator = Geolocator();

  String providerStatusText = "Offline";

  Color providerStatusColor = Colors.blueGrey;

  bool isProviderAvailable = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sharedPrefState();
    // providerStatusText = prefs.getString('providerStatusText');
    getCurrentProviderInfo();
  }

  sharedPrefState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      state = prefs.getBool('isProviderAvailable') ?? false;
    });
  }

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    LatLng latLngPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14);
    _newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  getRating() {
    //update ratings
    providerRef
        .child(currentFirebaseUser.uid)
        .child("ratings")
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        double ratings = double.parse(snapshot.value.toString());
        setState(() {
          starCounter = ratings;
        });
        if (starCounter <= 1.5) {
          setState(() {
            title = "Very Bad";
          });

          return;
        }
        if (starCounter <= 2.5) {
          setState(() {
            title = "Bad";
          });

          return;
        }
        if (starCounter <= 3.5) {
          setState(() {
            title = "Good";
          });

          return;
        }
        if (starCounter <= 4.5) {
          setState(() {
            title = "Very Good";
          });

          return;
        }

        if (starCounter <= 5.5) {
          setState(() {
            title = "Excellent";
          });

          return;
        }
      }
    });
  }

  void getCurrentProviderInfo() async {
    currentFirebaseUser = await FirebaseAuth.instance.currentUser;

    providerRef
        .child(currentFirebaseUser.uid)
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        favrProvidersInfo = FavrProviders.fromSnapshot(dataSnapshot);
      }
    });
    PushNotificationService pushNotificationService = PushNotificationService();
    pushNotificationService.initialize(context);
    pushNotificationService.getToken();
    Methods.retrieveHistoryInfo(context);
    getRating();
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        GoogleMap(
          // padding: EdgeInsets.only(bottom: 550),
          mapType: MapType.normal,
          myLocationEnabled: true,
          zoomGesturesEnabled: true,
          zoomControlsEnabled: true,
          myLocationButtonEnabled: true,
          initialCameraPosition: HomeTab._kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controllerGoogleMap.complete(controller);
            _newGoogleMapController = controller;
            locatePosition();
          },
        ),
        Container(
          height: 140.0,
          width: double.infinity,
          color: Colors.black54,
        ),
        Positioned(
          top: 60.0,
          left: 0.0,
          right: 0.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(17.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      // providerStatusText,
                      // prefs.getString('providerStatusText'),
                      state ? "Online" : "Offline",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700),
                    ),
                    Icon(Icons.online_prediction, color: Colors.white)
                  ],
                ),
              ),
              CupertinoSwitch(
                value: state,
                onChanged: (value) {
                  setState(() {
                    state = value;
                  });
                  print(state);
                  if (isProviderAvailable != true) {
                    setState(() {
                      providerStatusColor = kPrimaryMint;
                      providerStatusText = "Online ";
                      state = true;
                      isProviderAvailable = true;
                      prefs.setBool('isProviderAvailable', true);
                      prefs.setString('providerStatusText', "Online ");
                    });
                    makeProviderOnline();
                    getLocationLiveUpdates();
                    displayToastMessage("You are Online");
                  } else {
                    setState(() {
                      providerStatusColor = Colors.blueGrey;
                      providerStatusText = "Offline ";
                      state = false;
                      isProviderAvailable = false;
                      prefs.setBool('isProviderAvailable', false);
                      prefs.setString('providerStatusText', "Offline ");
                    });
                    makeProviderOffline();
                    displayToastMessage("You are Offline");
                  }
                },
              ),
            ],
          ),
        )
      ],
    );
  }

  void makeProviderOnline() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentPosition = position;
    });
    Geofire.initialize("availableProviders");
    Geofire.setLocation(currentFirebaseUser.uid, currentPosition.latitude,
            currentPosition.longitude)
        .whenComplete(() {
      requestRef.set('searching');
      requestRef.onValue.listen((event) {});
    });
  }

  void getLocationLiveUpdates() {
    homeTabSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;
      if (isProviderAvailable != true) {
        Geofire.setLocation(
            currentFirebaseUser.uid, position.latitude, position.longitude);
        LatLng latLng = LatLng(position.latitude, position.longitude);
        _newGoogleMapController.animateCamera(CameraUpdate.newLatLng(latLng));
      }
    });
  }

  void makeProviderOffline() {
    Geofire.removeLocation(currentFirebaseUser.uid).whenComplete(() {
      requestRef.onDisconnect();
      requestRef.remove();
      displayToastMessage("You are Offline");
    });
  }
}
