import 'package:flutter/material.dart';
import 'package:fprovider_app/constants/widgets.dart';
import 'package:fprovider_app/models/favrHistory.dart';
import 'package:fprovider_app/services/methods.dart';

class HistoryItem extends StatelessWidget {
  final FavrHistory favrHistory;
  const HistoryItem({Key key, this.favrHistory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  child: Text(
                    favrHistory.pickup ?? '',
                    overflow: TextOverflow.ellipsis,
                  ),
                )),
                sizedBox(0.0, 5.0),
                Text('\$${favrHistory.fares ?? ''}')
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [Text(favrHistory.dropoff ?? '')],
          ),
          sizedBox(15, 0),
          Container(
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  child: Text(
                    favrHistory.details ?? '',
                    overflow: TextOverflow.ellipsis,
                  ),
                )),
              ],
            ),
          ),
          sizedBox(15, 0),
          Text(
            Methods.formatFavrDate(favrHistory.createdAt ?? ''),
            style: TextStyle(color: Colors.grey),
          )
        ],
      ),
    );
  }
}
