import 'package:flutter/material.dart';
import 'package:fprovider_app/config/configmaps.dart';
import 'package:fprovider_app/constants/colors.dart';
import 'package:fprovider_app/constants/widgets.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class RatingTab extends StatefulWidget {
  const RatingTab({Key key}) : super(key: key);

  @override
  State<RatingTab> createState() => _RatingTabState();
}

class _RatingTabState extends State<RatingTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryWhite,
      body: Dialog(
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
                "Your Rating",
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700),
              ),
              sizedBox(22.0, 0.0),
              Divider(),
              sizedBox(16.0, 0.0),
              SmoothStarRating(
                rating: starCounter,
                color: kPrimaryGreen,
                allowHalfRating: true,
                starCount: 5,
                size: 45,
                borderColor: kPrimaryGreen,
                isReadOnly: true,
              ),
              sizedBox(16.0, 0.0),
              Text(
                title,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700),
              ),
              sizedBox(16.0, 0.0),
            ],
          ),
        ),
      ),
    );
  }
}
