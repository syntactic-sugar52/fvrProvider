import 'package:flutter/material.dart';
import 'package:fprovider_app/constants/colors.dart';
import 'package:fprovider_app/data_handler/app_data.dart';
import 'package:fprovider_app/utils/history_item.dart';
import 'package:provider/provider.dart';

class History extends StatefulWidget {
  const History({Key key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Favr History",
          style: TextStyle(
              color: Colors.white,
              letterSpacing: 1,
              fontSize: 22.0,
              fontWeight: FontWeight.w700),
        ),
        backgroundColor: kPrimaryGreen,
        elevation: 1,
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(0.0),
          itemBuilder: (context, index) => HistoryItem(
            favrHistory: Provider.of<AppData>(context, listen: false)
                .favrHistoryDataList[index],
          ),
          // },
          separatorBuilder: (BuildContext context, int index) =>
              Divider(thickness: 1, height: 3.0),
          itemCount: Provider.of<AppData>(context, listen: false)
              .favrHistoryDataList
              .length,
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
        ),
      ),
    );
  }
}
