import 'package:flutter/material.dart';
import 'package:fprovider_app/models/address.dart';

class AppData extends ChangeNotifier {
  Address pickupLocation;
  Address dropOffLocation;
  void updatePickUpLocationAddress(Address pickupAddress) {
    pickupLocation = pickupAddress;
    notifyListeners();
  }

  void updateDropOffLocation(Address dropOffLocationAddress) {
    dropOffLocation = dropOffLocationAddress;
    notifyListeners();
  }
}
