import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fprovider_app/config/configmaps.dart';
import 'package:fprovider_app/constants/colors.dart';
import 'package:fprovider_app/constants/widgets.dart';
import 'package:fprovider_app/data_handler/app_data.dart';
import 'package:fprovider_app/models/address.dart';
import 'package:fprovider_app/models/place_predictions.dart';
import 'package:fprovider_app/services/requestAssistant.dart';
import 'package:fprovider_app/utils/progress_dialog.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  const Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<PlacePredictions> placePredictionsList = [];
  TextEditingController startController = TextEditingController();
  TextEditingController endController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String placeAddress =
        Provider.of<AppData>(context).pickupLocation.placeName ?? "";
    startController.text = placeAddress;
    return Scaffold(
      backgroundColor: kPrimaryWhite,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        elevation: 0,
        title: Text(
          'Location',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: kPrimaryWhite,
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: ListView(physics: NeverScrollableScrollPhysics(), children: [
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.25,
                decoration: BoxDecoration(color: Colors.white24
                    // color: Colors.white
                    // color: kPrimaryWhite,
                    ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 25.0,
                    top: 20.0,
                    right: 25.0,
                    bottom: 20.0,
                  ),
                  child: Column(
                    children: [
                      sizedBox(5.0, 0.0),
                      Stack(
                        children: [
                          Center(
                            child: Text(
                              "Set Drop Off",
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      sizedBox(16.0, 0.0),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: kPrimaryGreen,
                          ),
                          sizedBox(0.0, 18.0),
                          Expanded(
                              child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5.0)),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: TextField(
                                controller: startController,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1.0),
                                  ),
                                  hintText: 'Start',
                                  hintStyle: TextStyle(color: Colors.black),
                                  isCollapsed: false,
                                  isDense: true,
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0)),
                                ),
                              ),
                            ),
                          )),
                        ],
                      ),
                      sizedBox(10.0, 0.0),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: kPrimaryGreen,
                          ),
                          sizedBox(0.0, 18.0),
                          Expanded(
                              child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5.0)),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: TextField(
                                onChanged: (val) {
                                  findPlace(val);
                                },
                                controller: endController,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1.0),
                                  ),
                                  hintText: 'End',
                                  hintStyle: TextStyle(color: Colors.black),
                                  isCollapsed: false,
                                  isDense: true,
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0)),
                                ),
                              ),
                            ),
                          )),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              sizedBox(10.0, 0.0),
              //Tile for displaying predictions
              (placePredictionsList.length > 0)
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: ListView.separated(
                          itemBuilder: (context, index) {
                            return PredictionTile(
                              placePredictions: placePredictionsList[index],
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              Divider(
                                color: Colors.grey,
                              ),
                          itemCount: placePredictionsList.length,
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true),
                    )
                  : Container(),
            ],
          ),
        ]),
      ),
    );
  }

  void findPlace(String placeName) async {
    if (placeName.length > 1) {
      String autoCompleteUrl =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=1234567890&components=country:us';
      var res = await RequestAssistant.getRequest(autoCompleteUrl);
      if (res == "failed") {
        print("failed");
        return;
      }
      if (res["status"] == "OK") {
        var predictions = res["predictions"];
        var placeList = (predictions as List)
            .map((e) => PlacePredictions.fromJson(e))
            .toList();
        setState(() {
          placePredictionsList = placeList;
        });
      }
    }
  }
}

class PredictionTile extends StatelessWidget {
  final PlacePredictions placePredictions;
  const PredictionTile({Key key, this.placePredictions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
      ),
      onPressed: () {
        getPlaceAddressDetails(placePredictions.place_id, context);
      },
      child: Container(
        child: Column(
          children: [
            sizedBox(0.0, 14.0),
            Row(
              children: [
                Icon(Icons.add_location, color: Colors.black),
                sizedBox(0.0, 14.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sizedBox(8.0, 0.0),
                      Text(placePredictions.main_text,
                          overflow: TextOverflow.ellipsis,
                          style:
                              TextStyle(fontSize: 16.0, color: Colors.black)),
                      sizedBox(2.0, 0.0),
                      Text(
                        placePredictions.secondary_text,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12.0, color: Colors.grey),
                      ),
                      sizedBox(8.0, 0.0),
                    ],
                  ),
                )
              ],
            ),
            sizedBox(0.0, 10.0),
          ],
        ),
      ),
    );
  }

  void getPlaceAddressDetails(String placeId, context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              message: "Setting End Location, Please wait..",
            ));

    String placeDetailsUrl =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey';
    var res = await RequestAssistant.getRequest(placeDetailsUrl);
    Navigator.pop(context);
    if (res == 'failed') {
      return;
    }
    if (res["status"] == "OK") {
      Address address = Address();
      address.placeName = res['result']['name'];
      address.placeId = placeId;
      address.latitude = res["result"]["geometry"]["location"]["lat"];
      address.longtitude = res["result"]["geometry"]["location"]["lng"];
      Provider.of<AppData>(context, listen: false)
          .updateDropOffLocation(address);
      print(address.placeName);
      Navigator.pop(context, "obtainDirection");
    }
  }
}
