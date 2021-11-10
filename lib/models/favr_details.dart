import 'package:google_maps_flutter/google_maps_flutter.dart';

class FavrDetails {
  String pickupaddress;
  String dropoffAddress;
  LatLng pickup;
  LatLng dropoff;
  String rideRequestId;
  String details;
  String time;
  String paymentMethod;
  String price;
  String favrOwnerName;
  String favrOwnerPhone;

  FavrDetails(
      {this.paymentMethod,
      this.details,
      this.dropoff,
      this.dropoffAddress,
      this.favrOwnerName,
      this.favrOwnerPhone,
      this.pickup,
      this.pickupaddress,
      this.price,
      this.rideRequestId,
      this.time});
}
