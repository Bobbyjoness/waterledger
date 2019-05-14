import "package:flutter/material.dart";

//Constants
import "package:waterledger/constants/legalConst.dart";

class LegalDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Legal Notices"),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Text(privacyPolicy),
                  Container(
                      padding: EdgeInsets.only(top: 15.0),
                      child: Text(termsAndConditions))
                ],
              ),
            ),
          ],
        ));
  }
}
