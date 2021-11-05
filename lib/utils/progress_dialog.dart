import 'package:flutter/material.dart';
import 'package:fprovider_app/constants/colors.dart';
import 'package:fprovider_app/constants/widgets.dart';

class ProgressDialog extends StatelessWidget {
  final String message;
  ProgressDialog({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // backgroundColor: kPrimaryMint,
      child: Container(
        margin: const EdgeInsets.all(15.0),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(6.0)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              sizedBox(0.0, 6.0),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryGreen),
              ),
              sizedBox(0.0, 26.0),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(color: Colors.black, fontSize: 14.0),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
