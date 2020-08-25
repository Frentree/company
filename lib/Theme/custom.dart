import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//Theme
import 'package:companyplaylist/Theme/theme.dart';

Container tabMenu(String title, int tabIndex, int index){
  Container tabContainer = Container(
      height: 40,
      width: 115,
      child: Center(
        child: Text(
          title,
          style: customStyle(14, 'Medium', top_color),
        ),
      ),
      decoration: tabIndex == index ? BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: white_color
      ) : null
  );

  return tabContainer;
}

VerticalDivider tabDivider(double thick, Color color, double startPadding, double endPadding) {
  VerticalDivider tabDivider = VerticalDivider(
    thickness: thick,
    color: color,
    indent: startPadding,
    endIndent: endPadding,
  );

  return tabDivider;
}

ExpansionTile work(String type, String startTime, String endTime, String title, String progress, String writeTime, String project, String detail, BuildContext context, String documentID) {
  ExpansionTile work = ExpansionTile(
    backgroundColor: white_color,
      leading: Chip(
        backgroundColor: schedule_chip_color,
        label: Text(
          type,
          style: customStyle(12, 'Regular', top_color),
        ),
      ),
      title: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 5),
              ),
              Text(
                  startTime,
                  style: customStyleHeigh(13, 'Regular', top_color, 1)
              ),
              Text(
                  '~',
                  style: customStyleHeigh(13, 'Regular', top_color, 1)
              ),
              Text(
                  endTime,
                  style: customStyleHeigh(13, 'Regular', top_color, 1)
              ),
            ],
          ),
          Padding(
              padding: EdgeInsets.only(left: 15)
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: customStyle(15, 'Medium', top_color),
              ),
              Text(
                  progress,
                  style: customStyleHeigh(13, 'Regular', grey_color, 2.1)
              ),
            ],
          )
        ],
      ),
    trailing: Container(
      child: Column(
        children: <Widget>[
          Text(
              '',
              style: customStyleHeigh(12, 'Regular', grey_color, 2.1)
          ),
          Text(
              writeTime,
              style: customStyleHeigh(13, 'Regular', grey_color, 2.1)
          ),
        ],
      ),
    ),
    children: <Widget>[
      Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: EdgeInsets.only(left: 20, top: 10, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                project,
                style: customStyle(13, 'Regular', top_color),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              Text(
                detail,
                style: customStyle(13, 'Regular', top_color),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: 120,
                    child: RaisedButton(
                      child: Text(
                        "수정",
                        style: customStyle(16, 'Regular', top_color),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)
                      ),
                      color: boarder_color,
                      onPressed: (){},
                      elevation: 0.0,
                    ),
                  ),
                  Container(
                    width: 120,
                    child: RaisedButton(
                      child: Text(
                        "삭제",
                        style: customStyle(16, 'Regular', white_color),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                      color: top_color,
                      onPressed: (){
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context){
                            return AlertDialog(
                              title: Text(
                                "삭제 하시겠습니까?",
                                style: customStyle(20, 'Medium', top_color),
                              ),
                              content: Text(
                                "$title이(가) 영구적으로 삭제됩니다.",
                                style: customStyle(16, 'Medium', grey_color),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text(
                                    "취소",
                                    style: customStyle(14, 'Medium', Color(0xff673AB7)),
                                  ),
                                  onPressed: ()



                                  {

                                    Navigator.pop(context);
                                  },
                                ),
                                FlatButton(
                                  child: Text(
                                    "삭제",
                                    style: customStyle(14, 'Medium', red_color),
                                  ),
                                  onPressed: () async {
                                    print(documentID);
                                    Firestore.instance.collection("my_schedule").document(documentID).delete();
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          }
                        );
                      },
                      elevation: 0.0,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      )
    ],

  );

  return work;
}

ListTile conference(String type, String startTime, String endTime, String title, String progress, String writeTime) {
  ListTile conference = ListTile(
      leading: Chip(
        backgroundColor: schedule_chip_color,
        label: Text(
          type,
          style: customStyle(12, 'Regular', top_color),
        ),
      ),
      title: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 5),
              ),
              Text(
                  startTime,
                  style: customStyleHeigh(13, 'Regular', top_color, 1)
              ),
              Text(
                  '~',
                  style: customStyleHeigh(13, 'Regular', top_color, 1)
              ),
              Text(
                  endTime,
                  style: customStyleHeigh(13, 'Regular', top_color, 1)
              ),
            ],
          ),
          Padding(
              padding: EdgeInsets.only(left: 15)
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: customStyle(15, 'Medium', top_color),
              ),
              Container(
                width: 230,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                        progress,
                        style: customStyleHeigh(13, 'Regular', grey_color, 2.1)
                    ),

                    Text(
                        writeTime,
                        style: customStyleHeigh(13, 'Regular', grey_color, 2.1)
                    )
                  ],
                ),
              )
            ],
          )
        ],
      )
  );

  return conference;
}

ListTile request(String type, String startTime, String endTime, String title, String requester) {
  ListTile request = ListTile(

      leading: Chip(
        backgroundColor: schedule_chip_color,
        label: Text(
          type,
          style: customStyle(12, 'Regular', top_color),
        ),
      ),
      title: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 5),
              ),
              Text(
                  startTime,
                  style: customStyleHeigh(13, 'Regular', top_color, 1)
              ),
              Text(
                  '~',
                  style: customStyleHeigh(13, 'Regular', top_color, 1)
              ),
              Text(
                  endTime,
                  style: customStyleHeigh(13, 'Regular', top_color, 1)
              ),
            ],
          ),
          Padding(
              padding: EdgeInsets.only(left: 15)
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: customStyle(15, 'Medium', top_color),
              ),
              Text(
                  "요청자: $requester",
                  style: customStyleHeigh(13, 'Regular', grey_color, 2.1)
              ),
            ],
          )
        ],
      )
  );

  return request;
}

ListTile individual(String type, String startTime, String endTime, String title, String progress, String location) {
  ListTile individual = ListTile(

      leading: Chip(
        backgroundColor: schedule_chip_color,
        label: Text(
          type,
          style: customStyle(12, 'Regular', red_color),
        ),
      ),
      title: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 5),
              ),
              Text(
                  startTime,
                  style: customStyleHeigh(13, 'Regular', top_color, 1)
              ),
              Text(
                  '~',
                  style: customStyleHeigh(13, 'Regular', top_color, 1)
              ),
              Text(
                  endTime,
                  style: customStyleHeigh(13, 'Regular', top_color, 1)
              ),
            ],
          ),
          Padding(
              padding: EdgeInsets.only(left: 15)
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: customStyle(15, 'Medium', top_color),
              ),
              Container(
                width: 230,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                        progress,
                        style: customStyleHeigh(13, 'Regular', grey_color, 2.1)
                    ),

                    Text(
                        location,
                        style: customStyleHeigh(13, 'Regular', grey_color, 2.1)
                    )
                  ],
                ),
              )
            ],
          )
        ],
      )
  );

  return individual;
}


