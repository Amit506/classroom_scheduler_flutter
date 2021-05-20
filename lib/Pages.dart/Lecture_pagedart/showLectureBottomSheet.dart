import 'package:classroom_scheduler_flutter/Pages.dart/Lecture_pagedart/bottom_sheet.dart';
import 'package:classroom_scheduler_flutter/models/Lecture.dart';
import 'package:flutter/material.dart';

class ShowLectureBottomSheet extends StatelessWidget {
  final Lecture sheetLectureData;

  const ShowLectureBottomSheet({Key key, this.sheetLectureData})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(6.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.42,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                child: Image.asset('image/calender.gif'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.greenAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0))),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) {
                          return CustomBottomSheet(
                            sheetLectureData: sheetLectureData,
                            isSpecicifTime: false,
                          );
                        },
                      );
                    },
                    child: Text('weekly schedule'),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.greenAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0))),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) {
                          return CustomBottomSheet(
                            sheetLectureData: sheetLectureData,
                            isSpecicifTime: true,
                          );
                        },
                      );
                    },
                    child: Text('one time schedule'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
