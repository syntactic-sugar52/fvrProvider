import 'package:flutter/material.dart';
import 'package:fprovider_app/constants/colors.dart';
import 'package:fprovider_app/constants/widgets.dart';
import 'package:fprovider_app/data_handler/app_data.dart';
import 'package:fprovider_app/screens/history.dart';
import 'package:provider/provider.dart';

class EarningsTab extends StatelessWidget {
  const EarningsTab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: kPrimaryGreen,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 70),
              child: Column(
                children: [
                  sizedBox(10.0, 0.0),
                  Text(
                    "Total Profit",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w700),
                  ),
                  sizedBox(10.0, 0.0),
                  Text(
                    '\₱${Provider.of<AppData>(context, listen: false).earnings}',
                    style: TextStyle(color: Colors.white, fontSize: 24.0),
                  ),
                  sizedBox(10.0, 0.0),
                  sizedBox(10.0, 0.0),
                  Text(
                    "NOTE: Earnings will be sent to your account every Wednesday of the week",
                    style: TextStyle(color: Colors.white, fontSize: 14.0),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => History()));
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(kPrimaryWhite),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Row(
                    children: [
                      Text("Total Favrs",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                          )),
                      Expanded(
                          child: Container(
                        child: Text(
                          Provider.of<AppData>(context, listen: false)
                              .favrCount
                              .toString(),
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      )),
                      sizedBox(10.0, 0.0)
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
