import 'package:cloud_firestore/cloud_firestore.dart';

//basic collection neede for each hub
class RootCollection {
  final CollectionReference notice;
  final CollectionReference lectures;
  final CollectionReference people;
  final CollectionReference hub;
  final CollectionReference rootData;

  RootCollection(
      {this.lectures, this.notice, this.people, this.hub, this.rootData});
}
