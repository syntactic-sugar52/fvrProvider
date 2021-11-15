import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fprovider_app/config/configmaps.dart';
import 'package:fprovider_app/constants/colors.dart';
import 'package:fprovider_app/constants/widgets.dart';
import 'package:fprovider_app/screens/mainscreen.dart';
import 'package:fprovider_app/utils/progress_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../main.dart';
import '../car_info_screen.dart';

class RegistrationScreen extends StatelessWidget {
  static const String idScreen = "register";
  RegistrationScreen({Key key}) : super(key: key);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  registerNewUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(
            message: "Creating Account, Please wait a moment..",
          );
        });
    final User firebaseUser = (await _firebaseAuth
            .createUserWithEmailAndPassword(
                email: emailController.text, password: pwController.text)
            .catchError((err) {
      Navigator.pop(context);
      displayToastMessage('Error:' + err.toString());
    }))
        .user;
    if (firebaseUser != null) {
//user created
      Map usersDataMap = {
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "phone": phoneController.text.trim(),
        "password": pwController.text.trim()
      };
      providerRef.child(firebaseUser.uid).set(usersDataMap);
      currentFirebaseUser = firebaseUser;
      displayToastMessage('Account created');
      Navigator.pushNamed(context, MainScreen.idScreen);
    } else {
      Navigator.pop(context);
      displayToastMessage('New user has not been created');
      //display error msg
    }
  }

  buildBody(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: ListView(
          physics: NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(18.0),
          children: [
            Column(
              children: [
                Text(
                  'FAVR',
                  style: GoogleFonts.dmSans(
                      textStyle: TextStyle(
                          fontSize: 36,
                          color: kPrimaryGreen,
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold)),
                ),
                sizedBox(70.0, 0.0),
                Text(
                  'Register as Favr Provider',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                ),
                sizedBox(40.0, 0.0),
                SizedBox(
                  height: 50,
                  width: size.width * 0.9,
                  child: TextFormField(
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    style: TextStyle(color: Colors.black),
                    autofocus: false,
                    decoration: InputDecoration(
                      isDense: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                      ),
                      hintText: 'Full Name',
                      hintStyle: TextStyle(color: Colors.black),
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                    ),
                  ),
                ),
                sizedBox(30.0, 0.0),
                SizedBox(
                  height: 50,
                  width: size.width * 0.9,
                  child: TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: Colors.black),
                    autofocus: false,
                    decoration: InputDecoration(
                      isDense: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                      ),
                      hintText: 'Email',
                      hintStyle: TextStyle(color: Colors.black),
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                    ),
                  ),
                ),
                sizedBox(30.0, 0.0),
                SizedBox(
                  height: 50,
                  width: size.width * 0.9,
                  child: TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(color: Colors.black),
                    autofocus: false,
                    decoration: InputDecoration(
                      isDense: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                      ),
                      hintText: 'Phone Number',
                      hintStyle: TextStyle(color: Colors.black),
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                    ),
                  ),
                ),
                sizedBox(30.0, 0.0),
                Container(
                  height: 50,
                  width: size.width * 0.9,
                  child: TextFormField(
                    controller: pwController,
                    style: TextStyle(color: Colors.black),
                    keyboardType: TextInputType.visiblePassword,
                    autofocus: false,
                    obscureText: true,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                      ),
                      hintText: 'Password',
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
                      "Create Account",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      if (nameController.text.length < 3) {
                        displayToastMessage(
                            'Name must be atleast 3 characters long');
                      } else if (!emailController.text.contains('@')) {
                        displayToastMessage('Email address is not valid');
                      } else if (phoneController.text.isEmpty) {
                        displayToastMessage('Phone Number is required');
                      } else if (pwController.text.length < 6) {
                        displayToastMessage(
                            'Password must be atleast 6 characters');
                      } else
                        registerNewUser(context);
                    },
                  ),
                ),
              ],
            ),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        elevation: 0,
        backgroundColor: kPrimaryWhite,
        automaticallyImplyLeading: true,
      ),
      backgroundColor: kPrimaryWhite,
      body: buildBody(context),
    );
  }
}
