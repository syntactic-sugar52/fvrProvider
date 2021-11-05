import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fprovider_app/config/configmaps.dart';
import 'package:fprovider_app/constants/colors.dart';
import 'package:fprovider_app/constants/widgets.dart';
import 'package:fprovider_app/data_handler/app_data.dart';
import 'package:fprovider_app/main.dart';
import 'package:fprovider_app/models/favr_details.dart';
import 'package:fprovider_app/services/mapsToolKit.dart';
import 'package:fprovider_app/services/methods.dart';
import 'package:fprovider_app/utils/collect_fare_dialog.dart';
import 'package:fprovider_app/utils/progress_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class NewFavrScreen extends StatefulWidget {
  final FavrDetails favrDetails;
  static const String idScreen = 'newfavr';

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  const NewFavrScreen({Key key, this.favrDetails}) : super(key: key);

  @override
  _NewFavrScreenState createState() => _NewFavrScreenState();
}

class _NewFavrScreenState extends State<NewFavrScreen> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  String status = "accepted";
  GoogleMapController _newFavrGoogleMapController;
  Set<Marker> markerSet = Set<Marker>();
  String btnTitle = 'Arrived';
  Color btnColor = kPrimaryGreen;
  Set<Circle> circleSet = Set<Circle>();
  Set<Polyline> polylineSet = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Position fPosition;
  var geoLocator = Geolocator();
  bool isRequestingDirections = false;
  String durationProvider = '';
  Timer timer;
  int durationCounter = 0;
  var locationOptions =
      LocationOptions(accuracy: LocationAccuracy.bestForNavigation);
  BitmapDescriptor animatingMarkerIcon;

  void createIconMarker() {
    if (animatingMarkerIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: Size(2, 2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "assets/smiley.png")
          .then((value) => animatingMarkerIcon = value);
    }
  }

  void getProviderLocationLiveUpdates() {
    LatLng oldPos = LatLng(0, 0);
    providerSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;
      fPosition = position;

      LatLng fpPosition = LatLng(position.latitude, position.longitude);
      var rot = MapsToolKit.getMarkerRotaion(oldPos.latitude, oldPos.longitude,
          fPosition.latitude, fPosition.longitude);
      Marker animatedMarker = Marker(
          markerId: MarkerId("animating"),
          position: fpPosition,
          rotation: rot,
          icon: animatingMarkerIcon,
          infoWindow: InfoWindow(title: "Current Location"));
      setState(() {
        CameraPosition cameraPosition =
            CameraPosition(target: fpPosition, zoom: 17);
        _newFavrGoogleMapController
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
        markerSet.removeWhere((marker) => marker.markerId.value == "animating");
        markerSet.add(animatedMarker);
      });

      oldPos = fpPosition;
      updateRideDetails();
      String rideRequestId = widget.favrDetails.rideRequestId;
      Map locMap = {
        "latitude": currentPosition.latitude.toString(),
        "longitude": currentPosition.longitude.toString()
      };
      newRequestRef.child(rideRequestId).child("provider_location").set(locMap);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    acceptRideRequest();
  }

  @override
  Widget build(BuildContext context) {
    // createIconMarker();
    return Scaffold(
      backgroundColor: kPrimaryWhite,
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: 500),
            mapType: MapType.normal,
            myLocationEnabled: true,
            // zoomGesturesEnabled: true,
            // zoomControlsEnabled: true,
            polylines: polylineSet,
            markers: markerSet,
            circles: circleSet,
            myLocationButtonEnabled: true,
            initialCameraPosition: NewFavrScreen._kGooglePlex,
            onMapCreated: (GoogleMapController controller) async {
              _controllerGoogleMap.complete(controller);
              _newFavrGoogleMapController = controller;
              var currentLatLang =
                  LatLng(currentPosition.latitude, currentPosition.longitude);
              var pickupLatLang = widget.favrDetails.pickup;
              await getPlaceDirection(currentLatLang, pickupLatLang);
              getProviderLocationLiveUpdates();
            },
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0))),
              height: MediaQuery.of(context).size.height / 2,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 18.0),
                  child: Column(
                    children: [
                      //remove?
                      Text(durationProvider),
                      sizedBox(6.0, 0.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.favrDetails.favr_owner_name,
                            style: TextStyle(
                                fontSize: 24.0, fontWeight: FontWeight.w700),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Icon(FontAwesomeIcons.phone),
                          ),
                        ],
                      ),
                      sizedBox(26.0, 0.0),
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                            child: Text(
                              widget.favrDetails.pickup_address,
                              style: TextStyle(
                                  fontSize: 18.0,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ))
                        ],
                      ),
                      sizedBox(26.0, 0.0),
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                            child: Text(
                              widget.favrDetails.dropoff_address,
                              style: TextStyle(
                                  fontSize: 18.0,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ))
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                            child: Text(
                              widget.favrDetails.details,
                              style: TextStyle(
                                  fontSize: 18.0,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          )),
                        ],
                      ),
                      sizedBox(26.0, 0.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: RaisedButton(
                              onPressed: () async {
                                if (status == "accepted") {
                                  status = "arrived";
                                  String rideRequestId =
                                      widget.favrDetails.rideRequestId;
                                  newRequestRef
                                      .child(rideRequestId)
                                      .child("status")
                                      .set(status);
                                  setState(() {
                                    btnColor = Colors.amberAccent;
                                    btnTitle = "Start Favr";
                                  });

                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          ProgressDialog(
                                              message: "Please Wait..."),
                                      barrierDismissible: false);
                                  await getPlaceDirection(
                                      widget.favrDetails.pickup,
                                      widget.favrDetails.dropoff);
                                  Navigator.pop(context);
                                } else if (status == "arrived") {
                                  status = "onride";
                                  String rideRequestId =
                                      widget.favrDetails.rideRequestId;
                                  newRequestRef
                                      .child(rideRequestId)
                                      .child("status")
                                      .set(status);
                                  setState(() {
                                    btnColor = Colors.red;
                                    btnTitle = "End Favr";
                                  });
                                  initTimer();

                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          ProgressDialog(
                                              message: "Please Wait..."),
                                      barrierDismissible: false);
                                  await getPlaceDirection(
                                      widget.favrDetails.pickup,
                                      widget.favrDetails.dropoff);
                                  Navigator.pop(context);
                                } else if (status == "onride") {
                                  endFavr();
                                }
                              },
                              color: btnColor,
                              child: Padding(
                                padding: const EdgeInsets.all(17.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      btnTitle,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> getPlaceDirection(
      LatLng pickupLapLang, LatLng dropOffLapLang) async {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            ProgressDialog(message: "Please wait.."));

    var details =
        await Methods.obtainDirectionDetails(pickupLapLang, dropOffLapLang);
    // setState(() {
    //   tripDirectionDetails = details;
    // });

    Navigator.pop(context);
    print(details.encodedPoints);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodePolyLinePointsResult =
        polylinePoints.decodePolyline(details.encodedPoints);
    polylineCoordinates.clear();
    if (decodePolyLinePointsResult.isNotEmpty) {
      decodePolyLinePointsResult.forEach((PointLatLng pointLatLng) {
        polylineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }
    polylineSet.clear();
    setState(() {
      Polyline polyline = Polyline(
        color: Colors.pink,
        polylineId: PolylineId("PolylineId"),
        jointType: JointType.round,
        points: polylineCoordinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );
      polylineSet.add(polyline);
    });
    LatLngBounds latLngBounds;
    if (pickupLapLang.latitude > dropOffLapLang.latitude &&
        pickupLapLang.longitude > dropOffLapLang.longitude) {
      latLngBounds =
          LatLngBounds(southwest: dropOffLapLang, northeast: pickupLapLang);
    } else if (pickupLapLang.longitude > dropOffLapLang.longitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(pickupLapLang.latitude, dropOffLapLang.longitude),
          northeast: LatLng(dropOffLapLang.latitude, pickupLapLang.longitude));
    } else if (pickupLapLang.latitude > dropOffLapLang.latitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(dropOffLapLang.latitude, pickupLapLang.longitude),
          northeast: LatLng(pickupLapLang.latitude, dropOffLapLang.longitude));
    } else {
      latLngBounds =
          LatLngBounds(southwest: pickupLapLang, northeast: dropOffLapLang);
    }
    _newFavrGoogleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

    Marker pickupLocMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        position: pickupLapLang,
        markerId: MarkerId("pickUpId"));
    Marker dropOffLocMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
        position: dropOffLapLang,
        markerId: MarkerId("dropOffId"));

    setState(() {
      markerSet.add(pickupLocMarker);
      markerSet.add(dropOffLocMarker);
    });

    Circle pickUpCircle = Circle(
        fillColor: Colors.blue,
        center: pickupLapLang,
        radius: 12,
        strokeWidth: 4,
        strokeColor: Colors.blueAccent,
        circleId: CircleId("pickUpId"));

    Circle dropOffCircle = Circle(
        fillColor: Colors.green,
        center: dropOffLapLang,
        radius: 12,
        strokeWidth: 4,
        strokeColor: Colors.greenAccent,
        circleId: CircleId("dropOffId"));

    setState(() {
      circleSet.add(pickUpCircle);
      circleSet.add(dropOffCircle);
    });
  }

  void acceptRideRequest() {
    String rideRequestId = widget.favrDetails.rideRequestId;
    newRequestRef.child(rideRequestId).child("status").set("accepted");
    newRequestRef
        .child(rideRequestId)
        .child("fProvider_name")
        .set(favrProvidersInfo.name);
    newRequestRef
        .child(rideRequestId)
        .child("fProvider_phone")
        .set(favrProvidersInfo.phone);
    newRequestRef
        .child(rideRequestId)
        .child("fProvider_id")
        .set(favrProvidersInfo.id);
    newRequestRef.child(rideRequestId).child("car_details").set(
        '${favrProvidersInfo.carModel} -  ${favrProvidersInfo.carColor} - ${favrProvidersInfo.carNumber}');

    Map locMap = {
      "latitude": currentPosition.latitude.toString(),
      "longitude": currentPosition.longitude.toString()
    };
    newRequestRef.child(rideRequestId).child("provider_location").set(locMap);
    providerRef
        .child(currentFirebaseUser.uid)
        .child("history")
        .child(rideRequestId)
        .set(true);
  }

  void updateRideDetails() async {
    if (isRequestingDirections) {
      setState(() {
        isRequestingDirections = true;
      });
      if (fPosition == null) {
        return;
      }
      var posLatLang = LatLng(fPosition.latitude, fPosition.longitude);
      LatLng destinationLatLng;
      if (status == "accepted") {
        destinationLatLng = widget.favrDetails.pickup;
      } else {
        destinationLatLng = widget.favrDetails.dropoff;
      }
      var directionDetails =
          await Methods.obtainDirectionDetails(posLatLang, destinationLatLng);
      if (directionDetails != null) {
        setState(() {
          durationProvider = directionDetails.durationText;
        });
      }
      setState(() {
        isRequestingDirections = false;
      });
    }
  }

  void initTimer() {
    const interval = Duration(seconds: 1);
    timer = Timer.periodic(interval, (timer) {
      durationCounter = durationCounter + 1;
    });
  }

  endFavr() async {
    timer.cancel();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => ProgressDialog(
              message: "Please Wait...",
            ));
    var currentLatLng = LatLng(fPosition.latitude, fPosition.longitude);
    var directionDetails = await Methods.obtainDirectionDetails(
        widget.favrDetails.pickup, currentLatLng);
    Navigator.pop(context);
    int fareAmount = Methods.calculateRideFare(directionDetails);
    String rideRequestId = widget.favrDetails.rideRequestId;
    newRequestRef
        .child(rideRequestId)
        .child("fares")
        .set(fareAmount.toString());
    newRequestRef.child(rideRequestId).child("status").set("ended");
    providerSubscription.cancel();
    showDialog(
        context: context,
        builder: (BuildContext context) => CollectFareDialog(
              paymentMethod: widget.favrDetails.payment_method,
              fareAmount: fareAmount,
            ));
    saveEarnings(fareAmount);
  }

  void saveEarnings(int fareAmount) {
    providerRef
        .child(currentFirebaseUser.uid)
        .child("earnings")
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        double oldEarnings = double.parse(dataSnapshot.value.toString());
        double totalEarnings = fareAmount + oldEarnings;
        providerRef
            .child(currentFirebaseUser.uid)
            .child("earnings")
            .set(totalEarnings.toStringAsFixed(2));
      } else {
        double totalEarnings = fareAmount.toDouble();
        providerRef
            .child(currentFirebaseUser.uid)
            .child("earnings")
            .set(totalEarnings.toStringAsFixed(2));
      }
    });
  }
}
