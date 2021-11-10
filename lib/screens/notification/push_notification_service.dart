import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fprovider_app/config/configmaps.dart';
import 'package:fprovider_app/main.dart';
import 'package:fprovider_app/models/favr_details.dart';
import 'package:fprovider_app/screens/notification/notification_dialog.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PushNotificationService {
  final FirebaseMessaging messaging = FirebaseMessaging();
  Future initialize(context) async {
    messaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        // getRideRequestId(message);
        return retrieveFavrRequest(getRideRequestId(message), context);
      },
      onLaunch: (Map<String, dynamic> message) async {
        // getRideRequestId(message);
        return retrieveFavrRequest(getRideRequestId(message), context);
      },
      onResume: (Map<String, dynamic> message) async {
        // getRideRequestId(message);
        return retrieveFavrRequest(getRideRequestId(message), context);
      },
    );
  }

  Future<String> getToken() async {
    String token = await messaging.getToken();
    print('token');
    print(token);
    providerRef.child(currentFirebaseUser.uid).child("token").set(token);
    messaging.subscribeToTopic("allproviders");
    messaging.subscribeToTopic("allusers");
    return token;
  }

  String getRideRequestId(Map<String, dynamic> message) {
    String rideRequestId = '';
    if (Platform.isAndroid) {
      print('ride request');
      rideRequestId = message['data']['ride_request_id'];
      print(rideRequestId);
    } else {
      print('ride request');
      rideRequestId = message['ride_request_id'];
      print(rideRequestId);
    }
    return rideRequestId;
  }

//add time?
//! fix payment
  void retrieveFavrRequest(String rideRequestId, BuildContext context) {
    newRequestRef.child(rideRequestId).once().then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        double pickupLocationLat =
            double.parse(dataSnapshot.value['pickUp']['latitude'].toString());
        double pickupLocationLong =
            double.parse(dataSnapshot.value['pickUp']['longitude'].toString());
        String pickupAddress = dataSnapshot.value['pickup_address'].toString();
        String pickupDetails = dataSnapshot.value['details'].toString();
        double dropOffLocationLat =
            double.parse(dataSnapshot.value['dropOff']['latitude'].toString());
        double dropOffLocationLong =
            double.parse(dataSnapshot.value['dropOff']['longitude'].toString());
        String dropOffAddress =
            dataSnapshot.value['dropoff_address'].toString();
        String paymentMethod = dataSnapshot.value['payment_method'].toString();
        String fproviderName = dataSnapshot.value['favr_owner_name'];
        String fproviderPhone = dataSnapshot.value['favr_owner_phone'];
        FavrDetails favrDetails = FavrDetails();
        favrDetails.details = pickupDetails;
        favrDetails.rideRequestId = rideRequestId;
        favrDetails.pickupaddress = pickupAddress;
        favrDetails.dropoffAddress = dropOffAddress;
        favrDetails.pickup = LatLng(pickupLocationLat, pickupLocationLong);
        favrDetails.dropoff = LatLng(dropOffLocationLat, dropOffLocationLong);
        favrDetails.paymentMethod = paymentMethod;
        favrDetails.favrOwnerName = fproviderName;
        favrDetails.favrOwnerPhone = fproviderPhone;
        print('info');
        print(favrDetails.details);
        print(favrDetails.pickupaddress);
        print(favrDetails.dropoffAddress);
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) =>
                NotificationDialog(favrDetails: favrDetails));
      }
    });
  }
}
