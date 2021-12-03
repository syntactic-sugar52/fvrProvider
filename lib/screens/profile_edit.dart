import 'package:flutter/material.dart';
import 'package:fprovider_app/config/configmaps.dart';
import 'package:fprovider_app/constants/colors.dart';
import 'package:fprovider_app/constants/widgets.dart';
import 'package:fprovider_app/main.dart';

class ProfileEdit extends StatefulWidget {
  ProfileEdit({Key key}) : super(key: key);

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _numberController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  String name = '';

  String number = '';

  String email = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _emailController.text = favrProvidersInfo.email;
    _nameController.text = favrProvidersInfo.name;
    _numberController.text = favrProvidersInfo.phone;
    return Scaffold(
        backgroundColor: kPrimaryWhite,
        appBar: buildAppBar(),
        body: buildBody(size));
  }

  AppBar buildAppBar() => AppBar(
        automaticallyImplyLeading: true,
        elevation: 1,
        backgroundColor: kPrimaryGreen,
        title: Text(
          'Edit Profile',
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
              onPressed: () {
                if (name != null && email != null && number != null) {
                  Map<String, dynamic> updateInfpo = {
                    "name": _nameController.text.trim(),
                    "email": _emailController.text.trim(),
                    "phone": _numberController.text.trim()
                  };
                  providerRef
                      .child(currentFirebaseUser.uid)
                      .update(updateInfpo)
                      .whenComplete(() {
                    setState(() {
                      favrProvidersInfo.phone = _numberController.text;
                      favrProvidersInfo.email = _emailController.text;
                      favrProvidersInfo.name = _nameController.text;
                    });

                    displayToastMessage("Profile Updated");
                  });

                  Navigator.pop(context);
                }
              },
              icon: Icon(Icons.check))
        ],
      );

  SafeArea buildBody(Size size) => SafeArea(
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  sizedBox(50, 0.0),
                  buildName(size),
                  sizedBox(40.0, 0.0),
                  buildEmail(size),
                  sizedBox(30.0, 0.0),
                  buildNumber(size)
                ],
              ),
            )
          ],
        ),
      );
  SizedBox buildName(Size size) => SizedBox(
        height: 50,
        width: size.width * 0.9,
        child: TextFormField(
          controller: _nameController,
          onSaved: (val) {
            setState(() {
              name = val;
            });
          },
          keyboardType: TextInputType.name,
          style: TextStyle(color: Colors.black),
          autofocus: false,
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            isDense: true,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kPrimaryGreen, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kPrimaryGreen, width: 1.0),
            ),
            hintText: 'Enter Full Name',
            hintStyle: TextStyle(color: Colors.black54),
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          ),
        ),
      );

  SizedBox buildEmail(Size size) => SizedBox(
        height: 50,
        width: size.width * 0.9,
        child: TextFormField(
          onSaved: (val) {
            setState(() {
              email = val;
            });
          },
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(color: Colors.black),
          autofocus: false,
          decoration: InputDecoration(
            isDense: true,
            fillColor: Colors.white,
            filled: true,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kPrimaryGreen, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kPrimaryGreen, width: 1.0),
            ),
            hintText: 'Enter Email',
            hintStyle: TextStyle(color: Colors.black54),
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          ),
        ),
      );

  SizedBox buildNumber(Size size) => SizedBox(
        height: 50,
        width: size.width * 0.9,
        child: TextFormField(
          onSaved: (val) {
            setState(() {
              number = val;
            });
          },
          controller: _numberController,
          keyboardType: TextInputType.phone,
          style: TextStyle(color: Colors.black),
          autofocus: false,
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            isDense: true,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kPrimaryGreen, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kPrimaryGreen, width: 1.0),
            ),
            hintText: 'Enter Phone Number',
            hintStyle: TextStyle(color: Colors.black54),
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          ),
        ),
      );
}
