import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fprovider_app/config/configmaps.dart';
import 'package:fprovider_app/screens/auth/login_screen.dart';
import 'package:fprovider_app/screens/auth/registration_screen.dart';
import 'package:fprovider_app/screens/car_info_screen.dart';
import 'package:fprovider_app/screens/helpers/detail_helper.dart';
import 'package:fprovider_app/screens/mainscreen.dart';
import 'package:fprovider_app/screens/new_favr_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'constants/colors.dart';
import 'data_handler/app_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  currentFirebaseUser = FirebaseAuth.instance.currentUser;
  runApp(MyApp());
}

// DatabaseReference usersRef =
//     FirebaseDatabase.instance.reference().child('users');
DatabaseReference providerRef =
    FirebaseDatabase.instance.reference().child('fprovider');
DatabaseReference requestRef = FirebaseDatabase.instance
    .reference()
    .child("fprovider")
    .child(currentFirebaseUser.uid)
    .child("newRequest");
DatabaseReference newRequestRef =
    FirebaseDatabase.instance.reference().child("Favr Requests");

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(

    //     // statusBarColor is used to set Status bar color in Android devices.
    //     statusBarColor: kPrimaryGreen,

    //     // To make Status bar icons color white in Android devices.
    //     statusBarIconBrightness: Brightness.light,

    //     // statusBarBrightness is used to set Status bar icon color in iOS.
    //     statusBarBrightness: Brightness.light
    //     // Here light means dark color Status bar icons.

    //     ));

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppData>(create: (_) => AppData()),
        ChangeNotifierProvider<DetailHelper>(create: (_) => DetailHelper()),
      ],
      child: MaterialApp(
        builder: (context, widget) => ResponsiveWrapper.builder(
          widget,
          maxWidth: 1200,
          minWidth: 480,
          defaultScale: true,
          breakpoints: [
            ResponsiveBreakpoint.resize(480, name: MOBILE),
            ResponsiveBreakpoint.autoScale(800, name: TABLET),
            ResponsiveBreakpoint.resize(1000, name: DESKTOP),
          ],
        ),
        title: 'Favr Provider',
        theme: ThemeData(
            textTheme: GoogleFonts.robotoTextTheme(),
            visualDensity: VisualDensity.adaptivePlatformDensity),
        initialRoute: FirebaseAuth.instance.currentUser == null
            ? LoginScreen.idScreen
            : MainScreen.idScreen,
        routes: {
          RegistrationScreen.idScreen: (context) => RegistrationScreen(),
          LoginScreen.idScreen: (context) => LoginScreen(),
          MainScreen.idScreen: (context) => MainScreen(),
          CarInfoScreen.idScreen: (context) => CarInfoScreen(),
          NewFavrScreen.idScreen: (context) => NewFavrScreen()
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
