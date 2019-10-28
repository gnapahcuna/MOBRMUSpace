import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:chewie/chewie.dart';
import 'package:rmu_space/Alert/issue_alert.dart';
import 'package:rmu_space/Font/font_style.dart';
import 'package:rmu_space/Model/Data/Question/question_model.dart';
import 'package:rmu_space/Model/Data/Topic/current_study_model.dart';
import 'package:rmu_space/Model/Data/Topic/list_topic_model.dart';
import 'package:rmu_space/Model/Data/Topic/topic_model.dart';
import 'package:rmu_space/Model/Data/Topic/video_default_model.dart';
import 'package:rmu_space/Model/Data/login_model.dart';
import 'package:rmu_space/Model/Data/video_model.dart';
import 'package:rmu_space/Model/Future/main_future.dart';
import 'package:rmu_space/Model/Setting/unit_model.dart';
import 'package:rmu_space/Model/background.dart';
import 'package:rmu_space/View/question.dart';
import 'package:rmu_space/View/settings.dart';
import 'package:rmu_space/View/topic_list.dart';
import 'package:video_player/video_player.dart';
import 'package:intl/intl.dart';

import 'video.dart';

class Home1Screen extends StatefulWidget {
  ItemsDataLoginResponse itemsDataLogin;
  Home1Screen({
    Key key,
    @required this.itemsDataLogin,
  }) : super(key: key);
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<Home1Screen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  /*void _getQuestion() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return
            Center(
              child: CupertinoActivityIndicator(
              ),
            );
        });
    await onLoadAction();
    Navigator.pop(context);


    if (itemsDataQuestion != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
            QuestionScreen(
              itemsDataQuestion: itemsDataQuestion,
              //Title: widget.itemsDataVideo.first.TopicName,
            )),
      );
    } else {
      new ShowDialog(context, "เตือน", "การเชื่อมต่อมีปัญหา", 1);
    }
  }*/


  void _getTopic() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return
            Center(
              child: CupertinoActivityIndicator(
              ),
            );
        });
    await onLoadActionTopic();
    Navigator.pop(context);


    if (itemsListTopic.length>0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
            TopicScreen(
              itemsDataTopic: itemsListTopic,
              itemsDataLogin: widget.itemsDataLogin,
              Title: "หัวข้อบทเรียน",
              IsNext: false,
              IsFirst: true,
            )),
      );
    } else {
      new ShowDialog(context, "เตือน", "การเชื่อมต่อมีปัญหา", 1);
    }
  }

  ItemsDataCurrentStudy itemsDataCurrentStudy;
  List<ItemsListTopic> itemsListTopic = [];

  Future<bool> onLoadActionTopic() async {
    itemsListTopic = [];
    itemsDataCurrentStudy = null;


    FormData formData = new FormData.from({
      "UserID": widget.itemsDataLogin.UserID,
    });
    await MainFuture().apiRequestCurrentStudygetByCon(formData).then((onValue) {
      if (onValue != null) {
        //if(onValue.Response!=null) {
          itemsDataCurrentStudy = onValue.Response;
        //}
      }
    });

    //check topic no
    /*if(itemsDataCurrentStudy != null){
      new FormData.from({
        "LevelID": widget.itemsDataVideo.first.LevelID,
        "TopicID": itemsDataCurrentStudy.TopicID,
      });
    }else{
      new FormData.from({
        "LevelID": widget.itemsDataVideo.first.LevelID,
        "TopicID": 1,
      });
    }*/
    List<ItemsDataVideoDefault> itemsDataVideoDefault = [];
    formData = FormData.from({"text": ""});
    await MainFuture().apiRequestVideoDefaultgetByCon(formData).then((onValue) {
      itemsDataVideoDefault = onValue.Response;
    });

    List<ItemsDataTopic> itemsDataTopic = [];
    formData = FormData.from({"text": ""});
    await MainFuture().apiRequestTopicgetByCon(formData).then((onValue) {
      itemsDataTopic = onValue.Response;
    });

    itemsDataTopic.forEach((item) {
      if (itemsDataCurrentStudy != null) {
        print(itemsDataCurrentStudy.TopicID.toString()+" :: "+item.TopicID.toString());
        if (item.TopicID<=itemsDataCurrentStudy.TopicID) {
          item.IsUnlock = true;
        }
        if (itemsDataCurrentStudy.TopicID == item.TopicID) {
          item.IsTopic = true;
        }
      } else {
        print("b");
        /*if (item.TopicID == itemsDataTopic.first.TopicID) {
          item.IsUnlock = true;
          item.IsTopic = true;
        } else {
          item.IsUnlock = false;
        }*/
      }
    });

    itemsDataVideoDefault.forEach((f) {
      itemsListTopic.add(
          new ItemsListTopic(
            TopicID: f.VideoDefaultID,
            TopicName: f.VideoDefaultName,
            TopicType: 0,
            IsActive: f.IsActive,
            Link: f.URL,
            IsTopic: false,
            IsUnlock: true,
          )
      );
    });
    itemsDataTopic.forEach((f) {
      itemsListTopic.add(
          new ItemsListTopic(
            TopicID: f.TopicID,
            TopicName: f.TopicName,
            TopicType: 1,
            IsActive: f.IsActive,
            IsTopic: f.IsTopic,
            IsUnlock: f.IsUnlock,
          )
      );
    });

    setState(() {});
    return true;
  }

  void _getSettings() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return
            Center(
              child: CupertinoActivityIndicator(
              ),
            );
        });
    await onLoadActionUnit();
    Navigator.pop(context);


    if (itemsListTopic != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
            SettingScreen(
              itemsDataUnit: itemsDataUnit,
              itemsDataLogin: widget.itemsDataLogin,
            )),
      );
    } else {
      new ShowDialog(context, "เตือน", "การเชื่อมต่อมีปัญหา", 1);
    }
  }

  List<ItemsDataUnit> itemsDataUnit=[];
  Future<bool> onLoadActionUnit() async {
    itemsDataUnit = [];
    FormData formData = FormData.from({"text": ""});
    await MainFuture().apiRequestUnitgetByCon(formData).then((onValue) {
      itemsDataUnit = onValue.Response;
    });
    setState(() {});
    return true;
  }


  //on show dialog
  /*List<ItemsDataQuestion> itemsDataQuestion = [];
  Future<bool> onLoadAction() async {
    FormData formData = new FormData.from({
      "LevelID": widget.itemsDataVideo.first.LevelID,
    });
    await MainFuture().apiRequestQuestiongetByCon(formData).then((onValue) {
      print(onValue);
      if (onValue.Success) {
        itemsDataQuestion = onValue.Response;
      }
    });

    itemsDataQuestion.forEach((item){
      var randomChoice = (item.itemsChoice..shuffle());
      item.itemsChoice = randomChoice;
    });


    setState(() {});
    return true;
  }*/


  @override
  Widget build(BuildContext context) {
    TextStyle textTitleStyl = TextStyle(
        fontSize: FontStyles().FontSizeTitle,
        color: Colors.white,
        fontWeight: FontWeight.w400,
        fontFamily: FontStyles().FontFamily);
    TextStyle textInputStyle = TextStyle(fontSize: 22,
        color: Color(0xff242021),
        fontFamily: FontStyles().FontFamily);
    TextStyle textInputStyleNo = TextStyle(fontSize: 18,
        color: Color(0xff3d63d2),
        fontFamily: FontStyles().FontFamily);

    var size = MediaQuery
        .of(context)
        .size;

    return new WillPopScope(
        onWillPop: () {
          //
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text("RMU Space", style: textTitleStyl,),
            centerTitle: true,
            leading: IconButton(onPressed: (){
              _getSettings();
            },icon: Icon(Icons.settings,color: Colors.white,),color: Colors.transparent,tooltip: "ตั้งค่าหน่วยเวลาในการทวนซ้ำ",),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 12.0),
                child: IconButton(onPressed: () {
                  new ShowDialog(
                      context, "Logout", "ต้องการออกจากระบบ RMU-Space", 3);
                },
                  icon: Icon(Icons.exit_to_app, color: Colors.white,),
                  color: Colors.transparent,tooltip: "ออกจากระบบ",),
              )
            ],
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
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: new Text('ค่า CF ของคุณ : ' +
                              widget.itemsDataLogin.UserCF,
                            style: textInputStyleNo,),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(22.0),
                            child: new ButtonTheme(
                              minWidth: 44.0,
                              padding: new EdgeInsets.all(0.0),
                              child: Container(
                                width: size.width / 1.7,
                                child: Column(
                                  children: <Widget>[
                                    FlatButton(
                                        highlightColor: Color(0xffffcb13),
                                        onPressed: () {
                                          _getTopic();
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(32.0),
                                          child: Column(
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Image(
                                                  image: AssetImage(
                                                      "assets/images/video.png"),
                                                  fit: BoxFit.fitWidth,
                                                ),
                                              ),
                                              Text(
                                                'เริ่มเรียน',
                                                style: textInputStyle,
                                              ),
                                            ],
                                          ),
                                        )
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        )
    );
  }
}
