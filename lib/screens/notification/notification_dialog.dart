import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fprovider_app/constants/colors.dart';
import 'package:fprovider_app/constants/widgets.dart';
import 'package:fprovider_app/main.dart';
import 'package:fprovider_app/models/favr_details.dart';
import 'package:fprovider_app/screens/new_favr_screen.dart';
import 'package:fprovider_app/services/methods.dart';

class NotificationDialog extends StatelessWidget {
  final FavrDetails favrDetails;

  NotificationDialog({Key key, this.favrDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: Colors.transparent,
      elevation: 1.0,
      child: Container(
        margin: const EdgeInsets.all(5.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  sizedBox(15.0, 0.0),
                  Text(
                    "New Favr Request",
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700),
                  ),
                  sizedBox(10.0, 0.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'DO NOT FORGET TO RECORD OR TAKE PICTURES FOR PROOF.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0XFFD90B14), fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Price: ",
                              style: TextStyle(fontSize: 16.0),
                            ),
                            sizedBox(0.0, 20.0),
                            Expanded(
                              child: Container(
                                child: Text(
                                  '₱${favrDetails.price}',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Start here: ",
                              style: TextStyle(fontSize: 16.0),
                            ),
                            sizedBox(0.0, 20.0),
                            Expanded(
                              child: Container(
                                child: Text(
                                  favrDetails.pickupaddress,
                                  style: TextStyle(fontSize: 18.0),
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "End here: ",
                              style: TextStyle(fontSize: 16.0),
                            ),
                            sizedBox(0.0, 20.0),
                            Expanded(
                              child: Container(
                                child: Text(
                                  favrDetails.dropoffAddress,
                                  style: TextStyle(fontSize: 18.0),
                                ),
                              ),
                            )
                          ],
                        ),
                        sizedBox(15.0, 0.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Details",
                              style: TextStyle(fontSize: 16.0),
                            ),
                            sizedBox(0.0, 20.0),
                            Expanded(
                              child: Container(
                                child: Text(
                                  favrDetails.details,
                                  style: TextStyle(fontSize: 18.0),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  sizedBox(15.0, 0.0),
                  Divider(
                    color: Colors.grey,
                  ),
                  Text(
                    'YOU HAVE 40 SECONDS TO ACCEPT',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0XFFD90B14), fontSize: 16),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.pink.shade600, // background
                            onPrimary: kPrimaryWhite, // foreground
                            fixedSize:
                                Size(MediaQuery.of(context).size.width / 3, 50),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Decline".toUpperCase(),
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ),
                        sizedBox(0.0, 10.0),
                        acceptButton(context)
                      ],
                    ),
                  ),
                ],
              ),
            ]),
      ),
    );
  }

  Padding acceptButton(context) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: kPrimaryGreen, // background
                onPrimary: kPrimaryWhite, // foreground
                fixedSize: Size(MediaQuery.of(context).size.width / 3, 50),
              ),
              onPressed: () {
                checkAvailability(context);
              },
              child: Text(
                "Accept".toUpperCase(),
                style: TextStyle(fontSize: 14.0),
              ),
            )
          ],
        ),
      );
  void checkAvailability(context) {
    requestRef.once().then((DataSnapshot dataSnapshot) {
      Navigator.pop(context);
      String reqId = '';
      if (dataSnapshot.value != null) {
        reqId = dataSnapshot.value.toString();
      } else {
        displayToastMessage("Favr no longer exists");
      }
      if (reqId == favrDetails.rideRequestId) {
        print('reqId checkAvail');
        print(reqId);
        requestRef.set("accepted").then((value) {
          Methods.disableHomeTabLiveLocationUpdates();
        });

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewFavrScreen(
                      favrDetails: favrDetails,
                    )));
        // prefs.setBool('checkAvailability', true);

      } else if (reqId == "cancelled") {
        // prefs.setBool('checkAvailability', false);
        displayToastMessage("Favr has been Cancelled");
      } else if (reqId == "timeout") {
        // prefs.setBool('checkAvailability', false);
        displayToastMessage("Favr has timed out");
      } else {
        // prefs.setBool('checkAvailability', false);
        displayToastMessage("Favr no longer exists");
      }
    });
  }
}
