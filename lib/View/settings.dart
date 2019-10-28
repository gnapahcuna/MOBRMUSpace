import 'dart:math';

import 'package:dart_random_choice/dart_random_choice.dart';
import 'package:dio/dio.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:chewie/chewie.dart';
import 'package:rmu_space/Alert/issue_alert.dart';
import 'package:rmu_space/Font/font_style.dart';
import 'package:rmu_space/Model/Data/Question/question_model.dart';
import 'package:rmu_space/Model/Data/Topic/topic_model.dart';
import 'package:rmu_space/Model/Data/login_model.dart';
import 'package:rmu_space/Model/Data/video_model.dart';
import 'package:rmu_space/Model/Future/main_future.dart';
import 'package:rmu_space/Model/Setting/unit_model.dart';
import 'package:rmu_space/Model/background.dart';
import 'package:rmu_space/View/question.dart';
import 'package:rmu_space/View/video.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class SettingScreen extends StatefulWidget {
  List<ItemsDataUnit> itemsDataUnit;
  ItemsDataLoginResponse itemsDataLogin;
  SettingScreen({
    Key key,
    @required this.itemsDataUnit,
    @required this.itemsDataLogin,
  }) : super(key: key);
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<SettingScreen> {

  int UnitValue;

  @override
  void initState() {
    super.initState();
    _getDataUnit();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _getDataUnit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UnitValue = (prefs.getInt('UnitValue') ?? 1);
    print(UnitValue);
    widget.itemsDataUnit.forEach((f){
      if(f.UnitValue==UnitValue){
        f.IsCheck=true;
      }
    });
    setState(() {});
  }

  _putDataUnit(UnitValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //int unit = (prefs.getInt('UnitValue') ?? 1);
    //int unit_user = (prefs.getInt('UnitUser') ?? 0);
    await prefs.setInt('UnitValue', UnitValue);
    await prefs.setString('UnitUserID', widget.itemsDataLogin.UserID);
  }


  Widget _buildContent() {
    TextStyle textInputStyleTitle = TextStyle(
        fontSize: 20.0,
        color: Colors.black,
        fontFamily: FontStyles().FontFamily,
        fontWeight: FontWeight.w400);
    TextStyle textInputStyleSub = TextStyle(fontSize: 18.0,
        color: Colors.black54,
        fontFamily: FontStyles().FontFamily);
    TextStyle styleTextSearch = TextStyle(
        fontSize: 16.0, fontFamily: FontStyles().FontFamily);
    TextStyle textStyleCreate = TextStyle(color: Color(0xff087de1),
        fontSize: 18.0,
        fontFamily: FontStyles().FontFamily);
    TextStyle textStylePageName = TextStyle(
        fontSize: 12.0,
        color: Colors.grey[400],
        fontFamily: FontStyles().FontFamily);
    TextStyle textCheckAllStyle = TextStyle(fontSize: 16.0,
        color: Color(0xff2e76bc),
        fontFamily: FontStyles().FontFamily);

    EdgeInsets paddingInputBox = EdgeInsets.only(top: 4.0, bottom: 4.0);


    return Container(
      padding: EdgeInsets.all(22.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Padding(
              padding: paddingInputBox,
              child: Text(
                "กำหนดหน่วยเวลาในการทวนซ้ำ",
                style: textInputStyleTitle,),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 22.0),
            child: ListView.builder(
              itemCount: widget.itemsDataUnit.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    padding: EdgeInsets.only(
                        left: 22.0, top: 8.0, bottom: 8.0, right: 12.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          widget.itemsDataUnit[index].IsCheck = true;
                          for (int i = 0; i < widget.itemsDataUnit.length; i++) {
                            if (i != index) {
                              widget.itemsDataUnit[i].IsCheck = false;
                            }
                          }
                          //print(widget.itemsDataUnit[index].IsCheck);
                          _putDataUnit(widget.itemsDataUnit[index].UnitValue);
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(right: 18.0),
                            child: Center(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      widget.itemsDataUnit[index].IsCheck = true;
                                      for (int i = 0; i <
                                          widget.itemsDataUnit.length; i++) {
                                        if (i != index) {
                                          widget.itemsDataUnit[i].IsCheck = false;
                                        }
                                      }
                                      _putDataUnit(widget.itemsDataUnit[index].UnitValue);
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(2.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: widget.itemsDataUnit[index].IsCheck
                                          ? Color(0xff3b69f3)
                                          : Colors.white,
                                      border: widget.itemsDataUnit[index].IsCheck
                                          ? Border.all(
                                          color: Color(0xff3b69f3),
                                          width: 1.3)
                                          : Border.all(
                                          color: Colors.grey[500],
                                          width: 1.3),
                                    ),
                                    child: Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: widget.itemsDataUnit[index].IsCheck
                                            ? Icon(
                                          Icons.check,
                                          size: 22.0,
                                          color: Colors.white,
                                        )
                                            : Container(
                                          height: 22.0,
                                          width: 22.0,
                                          color: Colors.transparent,
                                        )
                                    ),
                                  ),
                                )
                            ),
                          ),
                          Padding(
                            padding: paddingInputBox,
                            child: Text(
                              widget.itemsDataUnit[index].UnitName.toString(),
                              style: textInputStyleSub,),
                          ),
                        ],
                      ),
                    )
                );
              },
            ),
          )
        ],
      ),
    );
  }
  List<ItemsDataVideo> itemsDataVideo = [];
  Future<bool> onLoadActionVideo(ItemsDataTopic itemsDataTopic) async {
    itemsDataVideo=[];
    FormData formData = new FormData.from({
      "TopicID":itemsDataTopic.TopicID,
      "LevelID":2,
    });
    await MainFuture().apiRequestVideoContentgetByCon(formData).then((onValue) {
      print(onValue);
      if(onValue.Success){
        itemsDataVideo = onValue.Response;
      }
    });


    setState(() {});
    return true;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textTitleStyl = TextStyle(
        fontSize: FontStyles().FontSizeTitle,
        color: Colors.white,
        fontWeight: FontWeight.w400,
        fontFamily: FontStyles().FontFamily);
    TextStyle textInputStyle = TextStyle(fontSize: FontStyles().FontSizeData,
        color: Color(0xff242021),
        fontFamily: FontStyles().FontFamily);
    TextStyle textInputStyleNo = TextStyle(fontSize: FontStyles().FontSizeData,
        color: Colors.grey[500],
        fontFamily: FontStyles().FontFamily);

    return new WillPopScope(
      onWillPop: () {
        //
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("ตั้งค่า", style: textTitleStyl,),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back,), onPressed: () {
            Navigator.pop(context);
          }),
        ),
        body: Stack(
          children: <Widget>[
            BackgroundContent(),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    //color: Colors.grey[200],
                      border: Border(
                        top: BorderSide(
                            color: Colors.grey[300], width: 1.0),
                        bottom: BorderSide(color: Colors.grey[400], width: 1.0),
                      )
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                    ],
                  ),
                ),
                Expanded(
                  child: _buildContent(),
                ),
              ],
            ),
          ],
        )
      ),
    );
  }
}
