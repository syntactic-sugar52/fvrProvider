import 'package:google_maps_flutter/google_maps_flutter.dart';

class FavrDetails {
  String pickup_address;
  String dropoff_address;
  LatLng pickup;
  LatLng dropoff;
  String rideRequestId;
  String details;
  String time;
  String payment_method;
  String price;
  String favr_owner_name;
  String favr_owner_phone;

  FavrDetails(
      {this.payment_method,
      this.details,
      this.dropoff,
      this.dropoff_address,
      this.favr_owner_name,
      this.favr_owner_phone,
      this.pickup,
      this.pickup_address,
      this.price,
      this.rideRequestId,
      this.time});
}
