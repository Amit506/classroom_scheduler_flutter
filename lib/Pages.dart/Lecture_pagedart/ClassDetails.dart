import 'package:classroom_scheduler_flutter/services/hub_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassDetails extends StatelessWidget {
  final String id;

  final TextEditingController teacherNameController = TextEditingController();
  final TextEditingController subCodeController = TextEditingController();

  ClassDetails({Key key, this.id}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: [Text('class details'), Divider()],
      ),
      content: Container(
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextField(
              controller: teacherNameController,
              decoration: InputDecoration(
                labelText: 'Teacher name',
                labelStyle: TextStyle(
                  color: Colors.black54,
                ),
                hintText: 'Teacher  name',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                filled: true,
                hintStyle: TextStyle(
                  color: Colors.black38,
                ),
              ),
            ),
            TextField(
              controller: subCodeController,
              decoration: InputDecoration(
                labelText: 'Course code',
                labelStyle: TextStyle(
                  color: Colors.black54,
                ),
                hintText: 'Course code',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                filled: true,
                hintStyle: TextStyle(
                  color: Colors.black38,
                ),
              ),
            ),
            TextButton(
                style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.greenAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0))),
                onPressed: () {
                  Provider.of<HubDataProvider>(context, listen: false)
                      .addClassDetails(id, subCodeController.text,
                          teacherNameController.text);
                },
                child: Text('update'))
          ],
        ),
      ),
    );
  }
}
