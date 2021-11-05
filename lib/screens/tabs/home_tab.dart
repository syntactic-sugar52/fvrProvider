import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fprovider_app/config/configmaps.dart';
import 'package:fprovider_app/constants/colors.dart';
import 'package:fprovider_app/constants/widgets.dart';
import 'package:fprovider_app/models/favrProviders.dart';
import 'package:fprovider_app/screens/notification/push_notification_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

  GoogleMapController _newGoogleMapController;

  Position currentPosition;

  var geoLocator = Geolocator();

  String providerStatusText = "Offline";

  Color providerStatusColor = Colors.blueGrey;

  bool isProviderAvailable = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentProviderInfo();
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
    // String address = await Methods.searchCoordinateAddress(position, context);
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
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        GoogleMap(
          // padding: EdgeInsets.only(bottom: 550),
          mapType: MapType.normal,
          myLocationEnabled: true,
          // zoomGesturesEnabled: true,
          // zoomControlsEnabled: true,
          // polylines: polyLineSet,
          // markers: markerSet,
          // circles: circleSet,
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
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: RaisedButton(
                  onPressed: () {
                    if (isProviderAvailable != true) {
                      makeDriverOnline();
                      getLocationLiveUpdates();
                      setState(() {
                        providerStatusColor = kPrimaryMint;
                        providerStatusText = "Online ";
                        isProviderAvailable = true;
                      });
                      displayToastMessage("You are Online");
                    } else {
                      makeDriverOffline();
                      setState(() {
                        providerStatusColor = Colors.blueGrey;
                        providerStatusText = "Offline ";
                        isProviderAvailable = false;
                      });
                    }
                  },
                  color: providerStatusColor,
                  child: Padding(
                    padding: const EdgeInsets.all(17.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          providerStatusText,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700),
                        ),
                        Icon(Icons.online_prediction, color: Colors.white)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  void makeDriverOnline() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    Geofire.initialize("availableProviders");
    Geofire.setLocation(currentFirebaseUser.uid, currentPosition.latitude,
        currentPosition.longitude);
    requestRef.set('searching');
    requestRef.onValue.listen((event) {});
  }

  void getLocationLiveUpdates() {
    homeTabSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;
      if (!isProviderAvailable) {
        Geofire.setLocation(
            currentFirebaseUser.uid, position.latitude, position.longitude);
        LatLng latLng = LatLng(position.latitude, position.longitude);
        _newGoogleMapController.animateCamera(CameraUpdate.newLatLng(latLng));
      }
    });
  }

  void makeDriverOffline() {
    Geofire.removeLocation(currentFirebaseUser.uid);
    requestRef.onDisconnect();
    requestRef.remove();
    requestRef = null;
    displayToastMessage("You are Offline");
  }
}
