import 'package:flutter/material.dart';
import 'package:fprovider_app/models/favrHistory.dart';

class AppData extends ChangeNotifier {
  String earnings = "0";
  int favrCount = 0;
  List<String> favrHistoryKeys = [];
  List<FavrHistory> favrHistoryDataList = [];
  void updateEarnings(String updatedEarnings) {
    earnings = updatedEarnings;
    notifyListeners();
  }

  void updateFavrCounter(int favrCounter) {
    favrCount = favrCounter;
    notifyListeners();
  }

  void updateFavrKeys(List<String> newkeys) {
    favrHistoryKeys = newkeys;
    notifyListeners();
  }

  void updateFavrHistoryData(FavrHistory history) {
    favrHistoryDataList.add(history);
    notifyListeners();
  }
}
