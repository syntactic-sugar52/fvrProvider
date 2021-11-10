import 'package:firebase_database/firebase_database.dart';

class FavrHistory {
  String paymentMethod;
  String createdAt;
  String status;
  String fares;
  String dropoff;
  String details;
  String pickup;
  FavrHistory({
    this.paymentMethod,
    this.createdAt,
    this.details,
    this.dropoff,
    this.fares,
    this.pickup,
    this.status,
  });

  FavrHistory.fromSnapshot(DataSnapshot snapshot) {
    paymentMethod = snapshot.value["payment_method"];
    createdAt = snapshot.value["created_at"];
    status = snapshot.value["status"];
    fares = snapshot.value["fares"];
    pickup = snapshot.value["pickup_address"];
    dropoff = snapshot.value["dropoff_address"];
    details = snapshot.value["details"];
  }
}