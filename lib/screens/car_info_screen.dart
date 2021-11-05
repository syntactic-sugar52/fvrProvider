import 'package:flutter/material.dart';
import 'package:fprovider_app/config/configmaps.dart';
import 'package:fprovider_app/constants/colors.dart';
import 'package:fprovider_app/constants/widgets.dart';
import 'package:fprovider_app/screens/mainscreen.dart';

import '../main.dart';

class CarInfoScreen extends StatelessWidget {
  static const String idScreen = 'carinfo';
  CarInfoScreen({Key key}) : super(key: key);
  final TextEditingController carModelController = TextEditingController();
  final TextEditingController carNumberController = TextEditingController();
  final TextEditingController carColorController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              sizedBox(22.0, 0.0),
              Container(width: 390.0, height: 250.0, child: Text("logo")),
              Padding(
                padding: const EdgeInsets.fromLTRB(22.0, 22.0, 22.0, 32.0),
                child: Column(
                  children: [
                    sizedBox(12.0, 0.0),
                    Text(
                      "Enter Car Details",
                      style: TextStyle(fontSize: 24.0),
                    ),
                    sizedBox(26.0, 0.0),
                    Container(
                      height: 50,
                      width: size.width * 0.9,
                      child: TextFormField(
                        controller: carModelController,
                        style: TextStyle(color: Colors.black),
                        keyboardType: TextInputType.text,
                        autofocus: false,
                        obscureText: false,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                          ),
                          hintText: 'Enter Car Model',
                          hintStyle: TextStyle(color: Colors.black),
                          isCollapsed: false,
                          isDense: true,
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: size.width * 0.9,
                      child: TextFormField(
                        controller: carNumberController,
                        style: TextStyle(color: Colors.black),
                        keyboardType: TextInputType.number,
                        autofocus: false,
                        obscureText: false,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                          ),
                          hintText: 'Enter Plate Number',
                          hintStyle: TextStyle(color: Colors.black),
                          isCollapsed: false,
                          isDense: true,
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: size.width * 0.9,
                      child: TextFormField(
                        controller: carColorController,
                        style: TextStyle(color: Colors.black),
                        keyboardType: TextInputType.text,
                        autofocus: false,
                        obscureText: false,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                          ),
                          hintText: 'Enter Car Color',
                          hintStyle: TextStyle(color: Colors.black),
                          isCollapsed: false,
                          isDense: true,
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                        ),
                      ),
                    ),
                    sizedBox(50.0, 0.0),
                    Container(
                      alignment: Alignment.bottomCenter,
                      height: 90,
                      width: size.width * 0.9,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: kPrimaryGreen, // background
                          onPrimary: kPrimaryWhite, // foreground
                          fixedSize:
                              Size(MediaQuery.of(context).size.width * 0.9, 50),
                        ),
                        child: Text(
                          "NEXT",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          if (carModelController.text.isEmpty) {
                            displayToastMessage("Enter Vehicle Model");
                          } else if (carNumberController.text.isEmpty) {
                            displayToastMessage("Enter Vehicle Number");
                          } else if (carColorController.text.isEmpty) {
                            displayToastMessage("Enter Vehicle Color");
                          } else {
                            saveCarInfo(context);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void saveCarInfo(context) {
    String userId = currentFirebaseUser.uid;
    Map carInfoMap = {
      "car_color": carColorController.text.trim(),
      "car_model": carModelController.text.trim(),
      "car_number": carNumberController.text.trim()
    };
    providerRef.child(userId).child("car_details").set(carInfoMap);
    Navigator.pushNamedAndRemoveUntil(
        context, MainScreen.idScreen, (route) => false);
  }
}
