import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fprovider_app/config/configmaps.dart';
import 'package:fprovider_app/constants/colors.dart';
import 'package:fprovider_app/constants/widgets.dart';
import 'package:fprovider_app/screens/auth/registration_screen.dart';
import 'package:fprovider_app/utils/progress_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../main.dart';
import '../mainscreen.dart';

class LoginScreen extends StatelessWidget {
  static const String idScreen = "login";
  LoginScreen({Key key}) : super(key: key);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();

  buildBody(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: ListView(
          physics: NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(18.0),
          children: [
            Column(
              children: [
                sizedBox(60.0, 0.0),
                Text(
                  'FAVR',
                  style: GoogleFonts.dmSans(
                      textStyle: TextStyle(
                          fontSize: 40,
                          color: kPrimaryGreen,
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold)),
                ),
                sizedBox(80.0, 0.0),
                Text(
                  "Log in as Favr Provider",
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1),
                ),
                sizedBox(40.0, 0.0),
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
                sizedBox(40.0, 0.0),
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
                      "LOGIN",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      if (!emailController.text.contains('@')) {
                        displayToastMessage('Email address is not valid');
                      } else if (pwController.text.isEmpty) {
                        displayToastMessage('Enter password');
                      } else {
                        loginAndAuthenticateUser(context);
                      }
                    },
                  ),
                ),
                sizedBox(30.0, 0.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Dont have an account?",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegistrationScreen())),
                        child: Text(
                          "Register here",
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                              color: kPrimaryMint),
                        )),
                  ],
                )
              ],
            ),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryWhite,
      body: buildBody(context),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void loginAndAuthenticateUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(
            message: "Authenticating, Please wait a moment..",
          );
        });

    final User firebaseUser = (await _firebaseAuth
            .signInWithEmailAndPassword(
                email: emailController.text, password: pwController.text)
            .catchError((err) {
      Navigator.pop(context);
      displayToastMessage('Error:' + err.toString());
    }))
        .user;
    if (firebaseUser != null) {
      providerRef.child(firebaseUser.uid).once().then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          currentFirebaseUser = firebaseUser;
          Navigator.pushNamedAndRemoveUntil(
              context, MainScreen.idScreen, (route) => false);
          displayToastMessage('Logged In');
        } else {
          Navigator.pop(context);
          _firebaseAuth.signOut();
          displayToastMessage('No record exists. Create new account.');
          //display error msg
        }
      });
    } else {
      Navigator.pop(context);
      displayToastMessage('An Error Occured');
      //display error msg
    }
  }
}
