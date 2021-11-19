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
                Text(
                  'Start: ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Expanded(
                    child: Container(
                  child: Text(
                    favrHistory.pickup ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                )),
                sizedBox(0.0, 5.0),
                Text('₱${favrHistory.price ?? ''}')
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'End: ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Text(
                favrHistory.dropoff ?? '',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              )
            ],
          ),
          sizedBox(15, 0),
          // Row(
          //   mainAxisSize: MainAxisSize.max,
          //   children: [
          //     Text(
          //       'Details: ',
          //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          //     ),
          //      Text(
          //        favrHistory.details ?? '',
          //        overflow: TextOverflow.ellipsis,
          //        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          //      ),
          //   ],
          // ),
          Text(
            'Details: ',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Container(
            child: Text(
              favrHistory.details ?? '',
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
