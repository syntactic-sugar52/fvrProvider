import 'package:flutter/material.dart';
import 'package:fprovider_app/models/userfields.dart';
import 'package:gsheets/gsheets.dart';

class ReportSheetsApi {
  static const _credentials = r'''
  {
  "type": "service_account",
  "project_id": "gsheets-333202",
  "private_key_id": "7af598bd86296de9a41a9ca56ae56044854ee707",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC8tpOJPw7gN/5O\nr+PHToZFE23s+pKToN87cuEhIOIJtWHfzlnmSgdu0lBcXMIA8TqT76w+Ym6+FU+D\nmoJDGmepwa/h/RbGBrTuBVZ+C6qUCuRxS+Kby9qVTyaKCYT46YYcEp0rtkxqBOkJ\nJkluVxo6rMc8tmeUoXFgYNU5/ezj2dibtFBVxxLx83xDoIK+nxOS2Cg5pm/af5nY\nqXhY0/8yj6kVIZsdR7LGL6KPEwg763dZsLa4+i/3w6ilD91X/VwNebVI+2ojuxAp\nlSTfJWt4T7NvG958lkIOMLejcOYecz4B7m+X5riZuymAl3Yp+IJOmdKzvKJ6OLkQ\nq7GzvOFVAgMBAAECggEACiNxRd/FppL+M7oxjakLanrKqSnlcI7QF231UuCPoZpl\nTaRqLNwKzgUjYfGYzvtRceu1MFfSSnOIz/xKexztd0+2KY5oPWTUWRpKeonuv4vd\n7d6ivXXZrTOxUXFapmhzYZ7iuJu6EL2+oFTL1U9S09appeUd0lIhw3Ndrph/Xtaj\nFfdz3VPmmmpx8YnF5yLiwwlKu+T9jyvQI7V+ggyeg4p5ZmWoD+UuGPklf0JpY95n\nSbHyTasABzrV9nuJU4T+iIhrQO1J68XOIuQGW/T2/oqKBS94bUeay9XRKp+q79Ks\nltsETEyXRXqE2hdGAY1bxegjvJk6FDKQTzxQyg6VsQKBgQDo5cyc9HEHUXeXhZiT\nEPP5WVzAwHlUG9JBKotGEDBU+4CXO90WZbetUnm0EU9OHrRDPTX+CVN0jYO5UOWU\n000I5y5sfl0sgQ1hrDdUL39BZb3IPeYnsoNdngx52jYOEbpqLd9M2rl+P538/vhq\nyLjRwwUlBvQDO/U/UpN9QVJh5QKBgQDPbsHWhsSGUswyr9ZOEpEJsGYQFSGizQpO\nQD71wcfEHKFYUxYb9v0zDyx0VHXy0X+05RCMl6KuuQuQl0TamPBgg4o5DiYjPOUB\n1Fs4z9XXH772j5FXtHuyJXxxR6z3p33lzacwHlp3L4c2jmvChUeRI+MJE4Rj+rN7\ndCQdd99KsQKBgQCKyuf1YXc6dUJf+i3C9wduQeMUu5+SkEHss/3r8xnai0dG2VYY\nUuXzVINS3D32wDWNHJ1glw41F2C4v40R9Bqkg6EW5vd/3iirXIZclTGxN4CyJLFU\nVv4SfG3S8EfmeootXMkGdBK3OhJdA1XnzVbXKvGV717bzo+I/R0IODVwQQKBgBLB\nqxlg2khjGD/FEpXArAi6QKBXqND1xWbJ/GdwfEXJaPV5ndgtfzustZJXSMsKEogi\n5lowI++0n80VQI6bobC4dDkwhFZPXU3LC+yZLnbjUfsthDDwCvdS2GvN1WAXbxTm\ngaWiOP/p9koCms/eCVigbBkYALKhqrURDWr0ueYhAoGBAMcF0iAWYkiSrlkhBuMD\nUv6X7LLp3Hoa1RlTDYrLR4AAWMY0ezAWd86F1uAPhEuS0wS94Cd25dsSE1Ikv8dI\nOnnpT9qXKLv9HpyDx54857xdyE+6flSpkpvIyV78fxlHXrgQ0k1dHJ5QtlCuvUcz\n+7qI8CyXpZ14rOGDDPP7p08t\n-----END PRIVATE KEY-----\n",
  "client_email": "gsheetsfavr@gsheets-333202.iam.gserviceaccount.com",
  "client_id": "116330616300110763945",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/gsheetsfavr%40gsheets-333202.iam.gserviceaccount.com"
}
  ''';
  static final _spreadSheetId = '1avCkWOb3SWF7QovU95Hji9hjexC4FleUzQYuMlR7Pfs';
  static final _gsheets = GSheets(_credentials);
  static Worksheet _userSheet;
  static Future init() async {
    try {
      final spreadsheet = await _gsheets.spreadsheet(_spreadSheetId);
      _userSheet = await _getWorkSheet(spreadsheet, title: 'favrprovider');
      final firstRow = UserFields.getFields();
      _userSheet.values.insertRow(1, firstRow);
    } catch (e) {
      print('init error: ${e.toString()}');
    }
  }

  static Future<Worksheet> _getWorkSheet(Spreadsheet spreadsheet,
      {@required String title}) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title);
    }
  }

  static Future insert(List<Map<String, dynamic>> rowList) async {
    if (_userSheet == null) return;
    _userSheet.values.map.appendRows(rowList);
  }

  static Future<int> getRowCount() async {
    if (_userSheet == null) return 0;
    final lastRow = await _userSheet.values.lastRow();
    return lastRow == null ? 0 : int.tryParse(lastRow.first) ?? 0;
  }
}
