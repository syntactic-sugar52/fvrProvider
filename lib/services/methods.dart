import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fprovider_app/config/configmaps.dart';
import 'package:fprovider_app/data_handler/app_data.dart';
import 'package:fprovider_app/main.dart';
import 'package:fprovider_app/models/address.dart';
import 'package:fprovider_app/models/direction_details.dart';
import 'package:fprovider_app/models/favrHistory.dart';
import 'package:fprovider_app/models/users.dart';
import 'package:fprovider_app/services/requestAssistant.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class Methods {
  // static Future<String> searchCoordinateAddress(
  //     Position position, context) async {
  //   String placeAddress = "";
  //   String st1, st2, st3, st4;
  //   String url =
  //       'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey';
  //   var response = await RequestAssistant.getRequest(url);
  //   if (response != "failed") {
  //     placeAddress = response["results"][0]["formatted_address"];
  //     // st1 = response["results"][0]["address_components"][4]["long_name"];
  //     // st2 = response["results"][0]["address_components"][7]["long_name"];
  //     // st3 = response["results"][0]["address_components"][6]["long_name"];
  //     // st4 = response["results"][0]["address_components"][9]["long_name"];
  //     // placeAddress = st1 + ", " + st2 + ", " + st3 + ", " + st4;
  //     Address userPickedAddress = Address();
  //     userPickedAddress.latitude = position.latitude;
  //     userPickedAddress.longtitude = position.longitude;
  //     userPickedAddress.placeName = placeAddress;
  //     Provider.of<AppData>(context, listen: false)
  //         .updatePickUpLocationAddress(userPickedAddress);
  //   }
  //   return placeAddress;
  // }

  static Future<DirectionDetails> obtainDirectionDetails(
      LatLng initialPosition, LatLng finalPosition) async {
    String directionUrl =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=$mapKey';
    var res = await RequestAssistant.getRequest(directionUrl);
    if (res == "failed") {
      return null;
    }
    DirectionDetails directionDetails = DirectionDetails();
    directionDetails.encodedPoints =
        res["routes"][0]["overview_polyline"]["points"];

    directionDetails.distanceText =
        res["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.distanceValue =
        res["routes"][0]["legs"][0]["distance"]["value"];

    directionDetails.durationValue =
        res["routes"][0]["legs"][0]["duration"]["value"];
    directionDetails.durationText =
        res["routes"][0]["legs"][0]["duration"]["text"];

    return directionDetails;
  }

  static int calculateRideFare(DirectionDetails directionDetails) {
    double timeTravelledFare = (directionDetails.durationValue / 60) * 0.20;
    double distanceTravelledFare =
        (directionDetails.distanceValue / 1000) * 0.20;
    double totalFareAmount = timeTravelledFare + distanceTravelledFare;
    return totalFareAmount.truncate();
  }

  // static void getCurrentOnlineUserInfo() async {
  //   currentFirebaseUser = await FirebaseAuth.instance.currentUser;
  //   String userId = currentFirebaseUser.uid;
  //   DatabaseReference reference =
  //       FirebaseDatabase.instance.reference().child("users").child(userId);
  //   reference.once().then((DataSnapshot dataSnapshot) {
  //     if (dataSnapshot.value != null) {
  //       userCurrentInfo = CurrentUser.fromSnapshot(dataSnapshot);
  //     }
  //   });
  // }

  static void disableHomeTabLiveLocationUpdates() {
    homeTabSubscription.pause();
    Geofire.removeLocation(currentFirebaseUser.uid);
  }

  static void enableHomeTabLiveLocationUpdates() {
    homeTabSubscription.resume();
    Geofire.setLocation(currentFirebaseUser.uid, currentPosition.latitude,
        currentPosition.longitude);
  }

  static void retrieveHistoryInfo(context) {
    //retrieve and display profit
    providerRef
        .child(currentFirebaseUser.uid)
        .child("earnings")
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        String earnings = snapshot.value.toString();
        Provider.of<AppData>(context, listen: false).updateEarnings(earnings);
      }
    });
    //retieve and display history
    providerRef
        .child(currentFirebaseUser.uid)
        .child("history")
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        //update total number of favr count
        Map<dynamic, dynamic> keys = snapshot.value;
        int favrCounter = keys.length;
        Provider.of<AppData>(context, listen: false)
            .updateFavrCounter(favrCounter);
        List<String> favrHistoryKeys = [];
        keys.forEach((key, value) {
          favrHistoryKeys.add(key);
        });
        Provider.of<AppData>(context, listen: false)
            .updateFavrKeys(favrHistoryKeys);
        obtainFavrRequestHistoryData(context);
      }
    });
  }

  static void obtainFavrRequestHistoryData(context) {
    var keys = Provider.of<AppData>(context, listen: false).favrHistoryKeys;
    for (var key in keys) {
      newRequestRef.child(key).once().then((DataSnapshot snap) {
        if (snap.value != null) {
          var history = FavrHistory.fromSnapshot(snap);
          Provider.of<AppData>(context, listen: false)
              .updateFavrHistoryData(history);
        }
      });
    }
  }

  static String formatFavrDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate =
        "${DateFormat.MMMd().format(dateTime)}, ${DateFormat.y().format(dateTime)} - ${DateFormat.jm().format(dateTime)}";
    return formattedDate;
  }
}
