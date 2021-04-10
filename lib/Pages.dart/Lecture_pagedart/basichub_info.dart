import 'package:classroom_scheduler_flutter/models/RootCollection.dart';
import 'package:classroom_scheduler_flutter/services/hub_root_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class HubExtraInfoDialogue extends StatefulWidget {
  final HubRootData hubrootHub;
  final String hubCode;
  final String hubName;

  const HubExtraInfoDialogue(
      {Key key, this.hubrootHub, this.hubCode, this.hubName})
      : super(key: key);

  @override
  _HubExtraInfoDialogueState createState() => _HubExtraInfoDialogueState();
}

class _HubExtraInfoDialogueState extends State<HubExtraInfoDialogue> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  HubRootData hubRootData = HubRootData();

  final TextEditingController _textEditingController1 = TextEditingController();

  final TextEditingController _textEditingController2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _textEditingController1,
                  validator: (value) {
                    return value.isNotEmpty ? null : "Enter any text";
                  },
                  decoration: InputDecoration(
                      labelText: "Teacher Name", hintText: "Please Enter Text"),
                ),
                TextFormField(
                  controller: _textEditingController2,
                  validator: (value) {
                    return value.isNotEmpty ? null : "Enter any text";
                  },
                  decoration: InputDecoration(
                      labelText: "Subject Code", hintText: "Please Enter Text"),
                ),
              ],
            )),
      ),
      title: Text('Hub Info'),
      actions: <Widget>[
        InkWell(
          child: Text('NEXT'),
          onTap: () async {
            if (_formKey.currentState.validate()) {
              await hubRootData.extraRootHubDetail(
                  widget.hubrootHub,
                  widget.hubCode,
                  widget.hubName,
                  _textEditingController1.text,
                  _textEditingController2.text);
            }
          },
        ),
      ],
    );
  }
}
