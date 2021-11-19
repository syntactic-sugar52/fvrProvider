import 'package:flutter/material.dart';
import 'package:fprovider_app/constants/colors.dart';
import 'package:fprovider_app/constants/widgets.dart';
import 'package:fprovider_app/services/methods.dart';

class CollectFareDialog extends StatelessWidget {
  final String paymentMethod;
  final int fareAmount;
  const CollectFareDialog({Key key, this.fareAmount, this.paymentMethod})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(5.0),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            sizedBox(22.0, 0.0),
            Text(
              "Fee Recieved",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            sizedBox(22.0, 0.0),
            Divider(),
            sizedBox(16.0, 0.0),
            Text(
              "₱$fareAmount",
              style: TextStyle(
                fontSize: 45.0,
              ),
            ),
            sizedBox(16.0, 0.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Total Amount",
                textAlign: TextAlign.center,
              ),
            ),
            sizedBox(16.0, 0.0),
            TextButton(
                onPressed: () {},
                child: Text(
                  'REPORT',
                  style: TextStyle(fontSize: 16, letterSpacing: 1),
                )),
            sizedBox(16.0, 0.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.bottomCenter,
              height: 90,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: kPrimaryGreen, // background
                  onPrimary: kPrimaryWhite, // foreground
                  fixedSize: Size(MediaQuery.of(context).size.width * 0.9, 50),
                ),
                child: Text(
                  "Collect Payment",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Methods.enableHomeTabLiveLocationUpdates();
                },
              ),
            ),
            sizedBox(30, 0.0)
          ],
        ),
      ),
    );
  }
}
