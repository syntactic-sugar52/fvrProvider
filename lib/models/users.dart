import 'package:firebase_database/firebase_database.dart';

class CurrentUser {
  String id;
  String email;
  String name;
  String phone;
  CurrentUser({this.email, this.id, this.name, this.phone});

  CurrentUser.fromSnapshot(DataSnapshot dataSnapshot) {
    id = dataSnapshot.key;
    email = dataSnapshot.value["email"];
    name = dataSnapshot.value["name"];
    phone = dataSnapshot.value["phone"];
  }
}
