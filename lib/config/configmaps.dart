import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fprovider_app/models/favrProviders.dart';
import 'package:fprovider_app/models/users.dart';
import 'package:geolocator/geolocator.dart';

String mapKey = "AIzaSyAL3YJqQVfcPOawCSRN4d7eeBx3pPEMxtc";
// String mapKeyIos = "AIzaSyBc3khBmx08aBtLo6xhpli6Sjow8sYCTe4";

User currentFirebaseUser;
CurrentUser userCurrentInfo;
StreamSubscription<Position> homeTabSubscription;
StreamSubscription<Position> providerSubscription;
Position currentPosition;
FavrProviders favrProvidersInfo;
String title = '';
double starCounter = 0.0;
