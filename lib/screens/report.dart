import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:fprovider_app/config/configmaps.dart';
import 'package:fprovider_app/constants/colors.dart';
import 'package:fprovider_app/constants/widgets.dart';
import 'package:fprovider_app/models/userfields.dart';
import 'package:fprovider_app/sheetsapi/reportsheet.dart';

class Report extends StatelessWidget {
  Report({Key key}) : super(key: key);
  final TextEditingController _reportController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: kPrimaryWhite,
        resizeToAvoidBottomInset: true,
        appBar: buildAppBar(context),
        body: buildBody(size));
  }

  Widget buildBody(Size size) => SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            sizedBox(30.0, 0.0),
            Container(
              alignment: Alignment.centerLeft,
              child: Text("What seems to be the problem? ",
                  style: TextStyle(
                    fontSize: 18.0,
                  )),
            ),
            sizedBox(20.0, 0.0),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                  "List down specific details about the event and the Favr Owner",
                  style: TextStyle(
                    fontSize: 18.0,
                  )),
            ),
            sizedBox(30.0, 0.0),
            Container(
              constraints: BoxConstraints(
                maxHeight: 800,
                maxWidth: size.width,
              ),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: kPrimaryGreen),
              ),
              child: Form(
                key: formKey,
                child: AutoSizeTextField(
                  controller: _reportController,
                  fullwidth: true,
                  minFontSize: 16,
                  maxLines: null,
                  style: TextStyle(fontSize: 16),
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                      hintText: "",
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true,
                      isDense: true,
                      contentPadding: const EdgeInsets.all(20)),
                  keyboardType: TextInputType.multiline,
                ),
              ),
            ),
          ]),
        ),
      ));
  AppBar buildAppBar(context) => AppBar(
        elevation: 1,
        title: Text(
          'Report',
          style: TextStyle(
              color: Colors.white,
              fontSize: 22.0,
              fontWeight: FontWeight.w600,
              letterSpacing: 1),
        ),
        backgroundColor: kPrimaryGreen,
        leading: IconButton(
            onPressed: () {
              // Navigator.pop(context, "close");
            },
            // },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 24.0,
            )),
        actions: [
          _reportController.text != null
              ? IconButton(
                  onPressed: () async {
                    ReportModel reportModel = ReportModel();

                    // final form = formKey.currentState;
                    // final isValid = form.validate();
                    if (_reportController.text != null) {
                      final id = await ReportSheetsApi.getRowCount() + 1;
                      final newReport = reportModel.copy(id: id);
                      final report = ReportModel(
                          id: newReport.id,
                          uid: favrProvidersInfo.id,
                          name: favrProvidersInfo.name,
                          email: favrProvidersInfo.email,
                          issue: _reportController.text,
                          createdAt: DateTime.now().toString());
                      await ReportSheetsApi.insert([report.toJson()]);
                      Navigator.pop(context);
                      // onSavedUser(report);
                    }
                  },
                  // },
                  icon: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 28,
                  ))
              : Container()
        ],
      );
}
