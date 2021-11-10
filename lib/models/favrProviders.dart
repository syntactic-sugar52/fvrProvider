import 'package:firebase_database/firebase_database.dart';

class FavrProviders {
  String name;
  String phone;
  String email;
  String id;
  String carColor;
  String carModel;
  String carNumber;
  FavrProviders(
      {this.name,
      this.carColor,
      this.carModel,
      this.carNumber,
      this.email,
      this.id,
      this.phone});

  FavrProviders.fromSnapshot(DataSnapshot dataSnapshot) {
    id = dataSnapshot.key;
    phone = dataSnapshot.value['phone'];
    email = dataSnapshot.value['email'];
    name = dataSnapshot.value['name'];
    carColor = dataSnapshot.value['car_details']['car_color'];
    carModel = dataSnapshot.value['car_details']['car_model'];
    carNumber = dataSnapshot.value['car_details']['car_number'];
  }
}
