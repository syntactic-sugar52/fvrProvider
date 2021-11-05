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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "New Favr Request",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Start here",
                        style: TextStyle(fontSize: 16.0),
                      ),
                      sizedBox(0.0, 20.0),
                      Expanded(
                        child: Container(
                          child: Text(
                            favrDetails.pickup_address,
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
                        "End here",
                        style: TextStyle(fontSize: 16.0),
                      ),
                      sizedBox(0.0, 20.0),
                      Expanded(
                        child: Container(
                          child: Text(
                            favrDetails.dropoff_address,
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                      )
                    ],
                  ),
                  sizedBox(15.0, 0.0)
                ],
              ),
            ),
            sizedBox(15.0, 0.0),
            Divider(
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  RaisedButton(
                    onPressed: () {},
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.pink)),
                    color: Colors.white,
                    textColor: Colors.red,
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Cancel".toUpperCase(),
                      style: TextStyle(fontSize: 14.0),
                    ),
                  )
                ],
              ),
            ),
            sizedBox(0.0, 10.0),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  RaisedButton(
                    onPressed: () {
                      checkAvailability(context);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: kPrimaryMint)),
                    color: Colors.white,
                    textColor: Colors.red,
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Accept".toUpperCase(),
                      style: TextStyle(fontSize: 14.0),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

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
        requestRef.set("accepted");
        Methods.disableHomeTabLiveLocationUpdates();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewFavrScreen(
                      favrDetails: favrDetails,
                    )));
      } else if (reqId == "canceled") {
        displayToastMessage("Favr has been Cancelled");
      } else if (reqId == "timeout") {
        displayToastMessage("Favr has Timed Out");
      } else {
        displayToastMessage("Favr no longer exists");
      }
    });
  }
}
