import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DBServices {
  DBServices() {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
  }

  //Future _dataStream(String )
}

typedef Widget CSFBuilder(BuildContext context, value);

class CSFStreamBuilder extends StatelessWidget {
  final Stream stream;
  final CSFBuilder customBuilder;
  CSFStreamBuilder({this.stream, this.customBuilder});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          //TODO: Make a refactored loading indicator
          //return LoadingWidget();
        }
        if (snapshot.hasError) {
          //TODO: Make a refactored error indicator
          return Text('Error Occurred');
        }
        return customBuilder(context, snapshot.data);
      },
    );
  }
}
