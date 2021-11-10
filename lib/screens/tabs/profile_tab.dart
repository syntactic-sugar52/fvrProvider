import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fprovider_app/config/configmaps.dart';
import 'package:fprovider_app/constants/colors.dart';
import 'package:fprovider_app/constants/widgets.dart';
import 'package:fprovider_app/main.dart';
import 'package:fprovider_app/screens/auth/login_screen.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryWhite,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 1,
        backgroundColor: kPrimaryGreen,
        title: Text(
          favrProvidersInfo.name,
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Column(
              children: [
                sizedBox(40, 0.0),
                InfoCard(
                  text: favrProvidersInfo.phone,
                  icon: Icons.phone,
                  onPressed: () async {},
                ),
                sizedBox(20, 0.0),
                InfoCard(
                  text: favrProvidersInfo.email,
                  icon: Icons.email,
                  onPressed: () async {},
                ),
                sizedBox(20, 0.0),
                InfoCard(
                  text: "Log out",
                  icon: Icons.exit_to_app_outlined,
                  onPressed: () {
                    Geofire.removeLocation(currentFirebaseUser.uid);
                    requestRef.onDisconnect();
                    requestRef.remove();
                    requestRef = null;
                    FirebaseAuth.instance.signOut();
                    Navigator.pushNamedAndRemoveUntil(
                        context, LoginScreen.idScreen, (route) => false);
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String text;
  final IconData icon;
  Function onPressed;
  InfoCard({Key key, this.icon, this.onPressed, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed,
        child: Card(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
          child: ListTile(
            leading: Icon(
              icon,
              color: Colors.black87,
            ),
            title: Text(
              text,
              // textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black87, fontSize: 16.0),
            ),
          ),
        ));
  }
}
