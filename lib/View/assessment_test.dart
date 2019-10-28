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
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rmu_space/Alert/issue_alert.dart';
import 'package:rmu_space/Font/font_style.dart';
import 'package:rmu_space/Model/Data/Exercise/exercise_model.dart';
import 'package:rmu_space/Model/Data/Question/question_model.dart';
import 'package:rmu_space/Model/Data/SubTopic/current_sub_topic_study_model.dart';
import 'package:rmu_space/Model/Data/SubTopic/sub_topic_model.dart';
import 'package:rmu_space/Model/Data/Topic/current_study_model.dart';
import 'package:rmu_space/Model/Data/Topic/list_topic_model.dart';
import 'package:rmu_space/Model/Data/Topic/topic_model.dart';
import 'package:rmu_space/Model/Data/login_model.dart';
import 'package:rmu_space/Model/Data/video_model.dart';
import 'package:rmu_space/Model/Future/main_future.dart';
import 'package:rmu_space/Model/UserPass/user_pass_model.dart';
import 'package:rmu_space/Model/background.dart';
import 'package:rmu_space/View/question.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:video_player/video_player.dart';


FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class AssessmentTestScreen extends StatefulWidget {
  List<ItemsDataExercise> itemsDataExercise;
  ItemsDataLoginResponse itemsDataLogin;
  ItemsListTopic itemsDataTopic;
  ItemsDataSubTopic itemsDataSubTopic;
  bool IsNotify;
  String Title;
  AssessmentTestScreen({
    Key key,
    @required this.itemsDataExercise,
    @required this.itemsDataLogin,
    @required this.itemsDataTopic,
    @required this.itemsDataSubTopic,
    @required this.IsNotify,
    @required this.Title,
  }) : super(key: key);
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<AssessmentTestScreen> {

  String message_result;
  int total;

  String message;
  String channelId = "1000";
  String channelName = "FLUTTER_NOTIFICATION_CHANNEL";
  String channelDescription = "FLUTTER_NOTIFICATION_CHANNEL_DETAIL";

  //ค่า EF ประมาณ
  double EF = 0;
  double Q = 0;
  int Round = 0;

  SharedPreferences prefs;
  List<ItemsChoiceRating> itemChoiceRatingCorrect = [
    new ItemsChoiceRating(
      RatingType: 1,
      RatingName: "ตอบถูกได้ง่ายมาก",
      Rating: 6,
      IsCheck: false,
    ),
    new ItemsChoiceRating(
      RatingType: 1,
      RatingName: "ตอบถูกได้แม้จะลังเลเล็กน้อย",
      Rating: 5,
      IsCheck: false,
    ),
    new ItemsChoiceRating(
      RatingType: 1,
      RatingName: "ตอบถูกได้แต่ต้องคิดอย่างหนัก",
      Rating: 4,
      IsCheck: false,
    ),
  ];
  List<ItemsChoiceRating> itemChoiceRatingInCorrect = [
    new ItemsChoiceRating(
      RatingType: 0,
      RatingName: "ตอบผิดและข้อที่ถูกดูเหมือนจะตอบได้",
      Rating: 3,
      IsCheck: false,
    ),
    new ItemsChoiceRating(
      RatingType: 0,
      RatingName: "ตอบผิดและได้เรียนรู้จากข้อที่ถูก",
      Rating: 2,
      IsCheck: false,
    ),
    new ItemsChoiceRating(
      RatingType: 0,
      RatingName: "ไม่สามารถตอบได้เลย",
      Rating: 1,
      IsCheck: false,
    )
  ];
  @override
  void initState() {
    super.initState();

    _initPrefs();

    //EF = 0;
    //Q = 0;

    print(widget.itemsDataLogin.UserName);

    total = 0;
    widget.itemsDataExercise.forEach((item) {
      item.itemsChoice.forEach((choice){
        item.IsQuestionCorrect=false;
        //ตอบถูก
        if(choice.IsCheck&&choice.IsCorrect){
          total++;
          setState(() {
            item.IsQuestionCorrect=true;
          });
        }
      });
    });
    //test q
    //Q = 5;

    print("EF' : "+(2.5-0.8+0.28*5-0.02*5*2).toString());
    if(total>0) {
      message_result = "คุณตอบถูก";
    }else{
      message_result = "คุณตอบผิด";
    }

    //notification
    message = "No message.";
    var initializationSettingsAndroid =
    AndroidInitializationSettings('ic_launcher');

    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) {
          print("onDidReceiveLocalNotification called.");
        });
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (payload) {
          // when user tap on notification.
          print("onSelectNotification called.");
          setState(() {
            message = payload;
          });
        });
  }

  void _initPrefs()async{
    prefs = await SharedPreferences.getInstance();

    double _q = (prefs.getDouble('Q') ?? 0);
    if(widget.IsNotify){
      int round = (prefs.getInt('Round') ?? 0) + 1;
      if(round>3) {
        double _ef = (prefs.getDouble('EF') ?? 0);
        EF = (_ef - 0.8 + 0.28 * _q - 0.02 * _q * 2);
      }else{
        EF = (2.5-0.8+0.28*_q-0.02*_q*2);
      }
    }else{
      //EF = 2.5;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  sendNotificationWithScheduling(double second,bool isReLoop) async {
    int round;
    if(widget.IsNotify){
      if(isReLoop){
        round = 1;
      }else{
        round = (prefs.getInt('Round') ?? 0) + 1;
      }
    }else{
      round = 1;
    }

      var scheduledNotificationDateTime =
      new DateTime.now().add(new Duration(seconds: second.toInt()));
      var androidPlatformChannelSpecifics =
      new AndroidNotificationDetails(channelId, channelName, channelDescription,
          importance: Importance.Max, priority: Priority.High);
      var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
      NotificationDetails platformChannelSpecifics = new NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.schedule(
          0,
          'RMU Space',
          'แจ้งเตือนการทวนซ้ำ รอบที่ '+round.toString(),
          scheduledNotificationDateTime,
          platformChannelSpecifics,
          payload: 'Looping'
      );

      //เก็บข้อมูล data ฝั่ง client
      await _putDataClient(second,round);
  }

  _putDataClient(double second,int _round) async {
    //add data in local base
    await prefs.setString('UserID', widget.itemsDataLogin.UserID);
    await prefs.setString('UserName', widget.itemsDataLogin.UserName);
    await prefs.setString('Password', widget.itemsDataLogin.Password);
    await prefs.setDouble('EF', EF);
    await prefs.setDouble('Q', Q);
    await prefs.setInt('Round', _round);
    await prefs.setInt('I', second.toInt());

    //add log answer
    _putAnswerLog();
  }


  Widget _buildContent() {
    TextStyle textInputStyleTitle = TextStyle(
        fontSize: 16.0,
        color: Colors.black,
        fontFamily: FontStyles().FontFamily,
        fontWeight: FontWeight.w400);
    TextStyle textInputStyleSub1 = TextStyle(fontSize: 20.0,
        color: Colors.black54,
        fontFamily: FontStyles().FontFamily);
    TextStyle textInputStyleSub2 = TextStyle(fontSize: 16.0,
        color: Colors.grey[400],
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
    TextStyle textInputStyleSubCorrect = TextStyle(fontSize: 16.0,
        color: Color(0xff00b300),
        fontFamily: FontStyles().FontFamily);
    TextStyle textStar = TextStyle(fontSize: 16.0,
        color: Colors.red,
        fontFamily: FontStyles().FontFamily);
    TextStyle textQuestionStyle = TextStyle(
        fontSize: 18.0,
        color: Color(0xff3d63d2),
        fontFamily: FontStyles().FontFamily,
        fontWeight: FontWeight.w400);

    EdgeInsets paddingInputBox = EdgeInsets.only(top: 4.0, bottom: 4.0);

    SmoothStarRating smoothStarRating;
    return SingleChildScrollView(
      child: Center(
          child: Column(
            children: <Widget>[
              Center(
                  child: Column(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.only(top: 22.0, bottom: 12.0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(bottom: 12.0),
                                child: total != 0
                                    ? Container(
                                  padding: EdgeInsets.only(right: 8),
                                  child: Container(
                                    padding: EdgeInsets.all(2.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xff00b300),
                                      border: Border.all(
                                          color: Color(0xff00b300),
                                          width: 1.3),
                                    ),
                                    child: Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: Icon(
                                          Icons.check,
                                          size: 52.0,
                                          color: Colors.white,
                                        )
                                    ),
                                  ),
                                )
                                    : Container(
                                  padding: EdgeInsets.only(right: 8),
                                  child: Container(
                                    padding: EdgeInsets.all(2.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red,
                                      border: Border.all(
                                          color: Colors.red,
                                          width: 1.3),
                                    ),
                                    child: Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: Icon(
                                          Icons.clear,
                                          size: 52.0,
                                          color: Colors.white,
                                        )
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: paddingInputBox,
                                child: Text(
                                  message_result,
                                  style: textInputStyleSub1,),
                              ),
                            ],
                          )
                      ),
                    ],
                  )
              ),
              /*Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: paddingInputBox,
                        child: Text(
                          "★ 6 ตอบถูกได้ง่ายมาก",
                          style: textInputStyleSub1,),
                      ),
                      Padding(
                        padding: paddingInputBox,
                        child: Text(
                          "★ 5 ตอบถูกได้แม้จะลังเลเล็กน้อย",
                          style: textInputStyleSub1,),
                      ),
                      Padding(
                        padding: paddingInputBox,
                        child: Text(
                          "★ 4 ตอบถูกได้แต่ต้องคิดอย่างหนัก",
                          style: textInputStyleSub1,),
                      ),
                      Padding(
                        padding: paddingInputBox,
                        child: Text(
                          "★ 3 ตอบผิดและข้อที่ถูกดูเหมือนจะตอบได้",
                          style: textInputStyleSub1,),
                      ),
                      Padding(
                        padding: paddingInputBox,
                        child: Text(
                          "★ 2 ตอบผิดและได้เรียนรู้จากข้อที่ถูก",
                          style: textInputStyleSub1,),
                      ),
                      Padding(
                        padding: paddingInputBox,
                        child: Text(
                          "★ 1 ไม่สามารถตอบได้เลย",
                          style: textInputStyleSub1,),
                      ),
                    ],
                  )
              ),*/
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.itemsDataExercise.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  bool IsCorrect = false;
                  widget.itemsDataExercise[index].itemsChoice.forEach((choice) {
                    if (choice.IsCheck && choice.IsCorrect) {
                      IsCorrect = true;
                    }
                  });

                  List<ItemsChoiceRating> itemChoiceRating = [];
                  if(/*widget.itemsDataExercise[index].IsQuestionCorrect*/total>0){
                    itemChoiceRating = itemChoiceRatingCorrect;
                  }else{
                    itemChoiceRating = itemChoiceRatingInCorrect;
                  }
                  return Padding(
                    padding: EdgeInsets.only(top: 0.0, bottom: 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.all(22.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                border: index == 0 ? Border(
                                  top: BorderSide(
                                      color: Colors.grey[400], width: 0.5),
                                  bottom: BorderSide(
                                      color: Colors.grey[400], width: 0.5),
                                ) : Border(
                                  bottom: BorderSide(
                                      color: Colors.grey[400], width: 0.5),
                                )
                            ),
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: widget.itemsDataExercise.length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: EdgeInsets.only(top: 0.0, bottom: 0.0),
                                  child: Container(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                            padding: EdgeInsets.only(bottom: 12.0),
                                            child: Center(
                                              child: Padding(
                                                padding: paddingInputBox,
                                                child: Text(
                                                  "เฉลย",
                                                  style: textInputStyleSub1,
                                                ),
                                              ),
                                            )
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(bottom: 12.0),
                                          child: Text(
                                            (index + 1).toString() + '. ' +
                                                widget.itemsDataExercise[index]
                                                    .Question.toString(),
                                            style: textQuestionStyle,),
                                        ),
                                        ListView.builder(
                                          itemCount: widget.itemsDataExercise[index]
                                              .itemsChoice.length,
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemBuilder: (BuildContext context,
                                              int j) {
                                            List prefix = ["ก", "ข", "ค", "ง"];
                                            return Container(
                                                padding: EdgeInsets.only(
                                                    left: 22.0,
                                                    top: 8.0,
                                                    bottom: 8.0,
                                                    right: 12.0),
                                                child: InkWell(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .start,
                                                    children: <Widget>[
                                                      Container(
                                                        padding: EdgeInsets.only(
                                                            right: 18.0),
                                                        child: Center(
                                                            child: InkWell(
                                                              child: Container(
                                                                padding: EdgeInsets
                                                                    .all(2.0),
                                                                decoration: BoxDecoration(
                                                                  shape: BoxShape
                                                                      .rectangle,
                                                                  color: widget
                                                                      .itemsDataExercise[index]
                                                                      .itemsChoice[j]
                                                                      .IsCheck
                                                                      ? Color(
                                                                      0xff3b69f3)
                                                                      : (widget.itemsDataExercise[index].itemsChoice[j].IsCorrect
                                                                      ?Color(0xff00b300)
                                                                      :Colors.grey[400]),
                                                                  border: widget
                                                                      .itemsDataExercise[index]
                                                                      .itemsChoice[j]
                                                                      .IsCheck
                                                                      ? Border.all(
                                                                      color: Color(
                                                                          0xff3b69f3),
                                                                      width: 1.2)
                                                                      : widget
                                                                      .itemsDataExercise[index]
                                                                      .itemsChoice[j]
                                                                      .IsCorrect
                                                                      ? Border.all(
                                                                      color: Color(
                                                                          0xff00b300),
                                                                      width: 1.2)
                                                                      : Border.all(
                                                                      color: Colors
                                                                          .grey[500],
                                                                      width: 1.2),
                                                                ),
                                                                child: Padding(
                                                                    padding: const EdgeInsets
                                                                        .all(0.0),
                                                                    child: widget
                                                                        .itemsDataExercise[index]
                                                                        .itemsChoice[j]
                                                                        .IsCheck
                                                                        ? Icon(
                                                                      Icons.check,
                                                                      size: 22.0,
                                                                      color: Colors
                                                                          .white,
                                                                    )
                                                                        : widget
                                                                        .itemsDataExercise[index]
                                                                        .itemsChoice[j]
                                                                        .IsCorrect
                                                                        ? Icon(
                                                                      Icons.check,
                                                                      size: 22.0,
                                                                      color: Colors
                                                                          .white,
                                                                    )
                                                                        : Container(
                                                                      height: 22.0,
                                                                      width: 22.0,
                                                                      color: Colors
                                                                          .transparent,
                                                                    )
                                                                ),
                                                              ),
                                                            )
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Padding(
                                                          padding: paddingInputBox,
                                                          child: Text(
                                                            prefix[j] + ". " +
                                                                widget
                                                                    .itemsDataExercise[index]
                                                                    .itemsChoice[j]
                                                                    .ChoiceName
                                                                    .toString()
                                                                    .toString(),
                                                            style: widget
                                                                .itemsDataExercise[index]
                                                                .itemsChoice[j]
                                                                .IsCorrect
                                                                ? textInputStyleSubCorrect
                                                                : textInputStyleTitle,),
                                                        ),
                                                      ),
                                                      /*widget
                                                          .itemsDataExercise[index]
                                                          .itemsChoice[j].IsCheck
                                                          ? Container(
                                                        padding: EdgeInsets.only(
                                                            left: 18, right: 18.0),
                                                        child: Center(
                                                            child: InkWell(
                                                              child: Container(
                                                                padding: EdgeInsets
                                                                    .all(2.0),
                                                                decoration: BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: widget
                                                                      .itemsDataExercise[index]
                                                                      .itemsChoice[j]
                                                                      .IsCheck
                                                                      && widget
                                                                          .itemsDataExercise[index]
                                                                          .itemsChoice[j]
                                                                          .IsCorrect
                                                                      ? Color(
                                                                      0xff00b300)
                                                                      : Colors.red,
                                                                  border: widget
                                                                      .itemsDataExercise[index]
                                                                      .itemsChoice[j]
                                                                      .IsCheck
                                                                      && widget
                                                                          .itemsDataExercise[index]
                                                                          .itemsChoice[j]
                                                                          .IsCorrect
                                                                      ? Border.all(
                                                                      color: Color(
                                                                          0xff00b300),
                                                                      width: 1.2)
                                                                      : Border.all(
                                                                      color: Colors
                                                                          .red,
                                                                      width: 1.2),
                                                                ),
                                                                child: Padding(
                                                                    padding: const EdgeInsets
                                                                        .all(0.0),
                                                                    child: widget
                                                                        .itemsDataExercise[index]
                                                                        .itemsChoice[j]
                                                                        .IsCheck
                                                                        && widget
                                                                            .itemsDataExercise[index]
                                                                            .itemsChoice[j]
                                                                            .IsCorrect
                                                                        ? Icon(
                                                                      Icons.check,
                                                                      size: 22.0,
                                                                      color: Colors
                                                                          .white,
                                                                    )
                                                                        : Icon(
                                                                      Icons.clear,
                                                                      size: 22.0,
                                                                      color: Colors
                                                                          .white,
                                                                    )
                                                                ),
                                                              ),
                                                            )
                                                        ),
                                                      )
                                                          : Container()*/
                                                    ],
                                                  ),
                                                )
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 32.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border(
                                top: BorderSide(
                                    color: Colors.grey[400], width: 0.5),
                                bottom: BorderSide(
                                    color: Colors.grey[400], width: 0.5),
                              )
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  padding: EdgeInsets.only(top: 22.0, bottom: 12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                          padding: paddingInputBox,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                "ประเมิน",
                                                style: textInputStyleSub1,),
                                              Text(
                                                "*",
                                                style: textStar,),
                                            ],
                                          )
                                      )
                                    ],
                                  )
                              ),
                              ListView.builder(
                                itemCount: itemChoiceRating.length,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int j) {
                                  return Container(
                                      padding: EdgeInsets.only(
                                          left: 22.0, top: 8.0, bottom: 8.0, right: 12.0),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            itemChoiceRating[j].IsCheck =
                                            !itemChoiceRating[j].IsCheck;
                                            if(!itemChoiceRating[j].IsCheck){
                                              widget.itemsDataExercise[index].Rating = 0;
                                            }

                                            for (int i = 0; i < itemChoiceRating.length; i++) {
                                              if (i != j) {
                                                itemChoiceRating[i].IsCheck = false;
                                              }
                                            }

                                            if(itemChoiceRating[j].IsCheck){
                                              widget.itemsDataExercise[index].Rating = itemChoiceRating[j].Rating;
                                              double q_total = 0;
                                              for(int i=0;i<widget.itemsDataExercise.length;i++){
                                                double rating = widget.itemsDataExercise[i].Rating-1;
                                                q_total+=rating;
                                              }
                                              Q = q_total/widget.itemsDataExercise.length;
                                            }

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
                                                        itemChoiceRating[j].IsCheck = !itemChoiceRating[j].IsCheck;
                                                        if(!itemChoiceRating[j].IsCheck){
                                                          widget.itemsDataExercise[index].Rating = 0;
                                                        }

                                                        for (int i = 0; i <
                                                            itemChoiceRating.length; i++) {
                                                          if (i != j) {
                                                            itemChoiceRating[i].IsCheck =
                                                            false;
                                                          }
                                                        }

                                                        if(itemChoiceRating[j].IsCheck){
                                                          widget.itemsDataExercise[index].Rating = itemChoiceRating[j].Rating;
                                                          double q_total = 0;
                                                          for(int i=0;i<widget.itemsDataExercise.length;i++){
                                                            double rating = widget.itemsDataExercise[i].Rating-1;
                                                            q_total+=rating;
                                                          }
                                                          Q = q_total/widget.itemsDataExercise.length;
                                                        }
                                                      });
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.all(2.0),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.rectangle,
                                                        color: itemChoiceRating[j].Rating==widget.itemsDataExercise[index].Rating
                                                            ? Color(0xff3b69f3)
                                                            : Colors.white,
                                                        border: itemChoiceRating[j].Rating==widget.itemsDataExercise[index].Rating
                                                            ? Border.all(
                                                            color: Color(0xff3b69f3),
                                                            width: 1.2)
                                                            : Border.all(
                                                            color: Colors.grey[700],
                                                            width: 1.2),
                                                      ),
                                                      child: Padding(
                                                          padding: const EdgeInsets.all(0.0),
                                                          child: itemChoiceRating[j].Rating==widget.itemsDataExercise[index].Rating
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
                                                itemChoiceRating[j].RatingName.toString()
                                                    .toString(),
                                                style: textInputStyleTitle,),
                                            ),
                                          ],
                                        ),
                                      )
                                  );
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  );
                },
              ),
            ],
          )
      ),
    );
  }
  Future<bool> onLoadActionAnswerLog() async {
    Map formData;
    List<Map> items = [];


    for(int i=0;i<widget.itemsDataExercise.length;i++){
      double _rating = widget.itemsDataExercise[i].Rating-1;
      bool IsCorrect = false;
      widget.itemsDataExercise[i].itemsChoice.forEach((choice){
        if(choice.IsCheck&&choice.IsCorrect){
          IsCorrect=true;
        }
      });

      double ef = double.parse(widget.itemsDataExercise[i].EF)-0.8+0.28*_rating-0.02*_rating*2;
      var item = {
        "UserID": widget.itemsDataLogin.UserID,
        "ExerciseID": widget.itemsDataExercise[i].ExerciseID,
        "Answer": IsCorrect,
        "q": _rating,
        "EF": ef
      };
      items.add(item);
    }
    formData  = {
      "Params":items,
    };

    //Add Answer Question Log
    await MainFuture().apiRequestUserAnswerExerciseloginsAll(items).then((onValue) {
      //print(onValue);
    });

    int _i = (prefs.getInt('I') ?? 1);
    double _ef = (prefs.getDouble('EF') ?? 1);

    /*FormData _formData = new FormData.from({
      "UserID":widget.itemsDataLogin.UserID,
      "CF":cf_a,
    });
    //Update UserCF
    await MainFuture().apiRequestUserCFupdAll(_formData).then((onValue) {
      print("UserCF : "+onValue.Response.UserCF);
    });*/


    //Add Test Log
    FormData _formData = new FormData.from({
      "UserID":widget.itemsDataLogin.UserID,
      "SubTopicID":widget.itemsDataSubTopic.SubTopicID,
      "I":_i,
      "EF":_ef,
    });
    //add Log
    await MainFuture().apiRequestAddLog(_formData).then((onValue) {
      //print(onValue.Response.TopicReach);
    });


    setState(() {});
    return true;
  }

  void _putAnswerLog() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return
            WillPopScope(
              onWillPop: () {
                //
              },
              child: Center(
                child: CupertinoActivityIndicator(
                ),
              ),
            );
        });
    await onLoadActionAnswerLog();
    Navigator.pop(context);

    //ปิดแอพ
    exit(0);
  }



  bool IsAnswerComplete = false;
  Widget _buildBottom() {
    IsAnswerComplete = false;

    TextStyle textTitleStyl = TextStyle(
        fontSize: FontStyles().FontSizeTitle,
        color: Colors.white,
        fontWeight: FontWeight.w400,
        fontFamily: FontStyles().FontFamily);

    TextStyle textBottomStyle = TextStyle(
        fontSize: FontStyles().FontSizeTitle,
        color: Color(0xff242021),
        fontWeight: FontWeight.w400,
        fontFamily: FontStyles().FontFamily);
    var size = MediaQuery
        .of(context)
        .size;

    bool isCheck=false;
    int count=0;
    widget.itemsDataExercise.forEach((item){
      if(item.Rating>0){
        count++;
      }
    });
    print(count);
    if(count==widget.itemsDataExercise.length){
      isCheck=true;
    }

    if(isCheck){
      double q_total = 0;
      for(int i=0;i<widget.itemsDataExercise.length;i++){
        double rating = widget.itemsDataExercise[i].Rating-1;
        q_total+=rating;
      }
      setState(() {
        Q = q_total/widget.itemsDataExercise.length;
      });
    }

    if(!widget.IsNotify){
      setState(() {
        EF = (2.5-0.8+0.28*Q-0.02*Q*2);
      });
    }

    return isCheck ? Container(
      width: size.width,
      height: 65,
      color: Color(0xffffcb13),
      child: MaterialButton(
        onPressed: () {

          int round;
          if(widget.IsNotify){
            round = (prefs.getInt('Round') ?? 0) + 1;
          }else{
            round = 1;
          }

          int unit = (prefs.getInt('UnitValue') ?? 1);
          int _i = (prefs.getInt('I') ?? 1);
          double _ef = (prefs.getDouble('EF') ?? 0);
          double second;

          if(round==1){
            second = unit.toDouble();
          }else if(round==2){
            second = unit.toDouble()*6;
          }else if(round==3){
            second = _i*(2.5);
          }else if(round>3){
            second = _i*_ef;
          }
          print("minutes : "+second.toString());

          bool _continue = false;
          bool _next = false;
          bool _start = false;

          if(Q.toInt()<3){
            _start = true;
          }else if(Q.toInt()==3){
            _continue = true;
          }else if(Q.toInt()>=4){
            _next = true;
          }

          /*round = 3;
          _start = false;
          _next = true;
          _continue = false;*/

          String _second = "";
          if(second.toInt()<59){
            _second = "ภายใน "+second.toInt().toString()+" วินาที และปิดแอพฯ";
          }else{
            _second = "ภายใน "+(second.toInt()/59).toString()+" นาที และปิดแอพฯ";
          }

          //test
          //round =4;

          if(round>3){
            if(_continue){
              _showAlertDialog(context,"เตือน","ระบบจะทำการทวนซ้ำรอบที่ "+round.toString()+"\n"+_second,second,false);
            }else if(_start){
              second = unit.toDouble();
              if(second.toInt()<59){
                _second = "ภายใน "+second.toInt().toString()+" วินาที และปิดแอพฯ";
              }else{
                _second = "ภายใน "+(second.toInt()/59).toString()+" นาที และปิดแอพฯ";
              }
              round = 1;
              _showAlertDialog(context,"เตือน","ระบบจะทำการทวนซ้ำรอบที่ "+round.toString()+"\n"+_second,second,true);
            }else if(_next){
              //pass topic
              int round;
              if(widget.IsNotify){
                round = (prefs.getInt('Round') ?? 0) + 1;
              }else{
                round = 1;
              }

              //เมื่อทำแบบฝึกหัดแตละ path เสร้จ
              //_putUserPassStudy(round);
              _checkNextTopic(round);

            }else{
              _showAlertDialog(context,"เตือน","ไม่เข้าเงื่อนไขใดๆ : "+Q.toString()+", "+_continue.toString()+", "+_start.toString()+", "+_next.toString(),second,true);
            }
          }else{
            _showAlertDialog(context,"เตือน","ระบบจะทำการทวนซ้ำรอบที่ "+round.toString()+"\n"+_second,second,false);
          }

          setState(() {});
        },
        child: Center(
          child: Text('ส่งผลประเมิน ( EF : '+NumberFormat("#,##0.00").format(EF).toString()+', Q : '+ Q.toInt().toString() +' )', style: textBottomStyle,),
        ),
      ),
    ) : null;
  }

  void _checkNextTopic(round) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return
            WillPopScope(
              onWillPop: () {
                //
              },
              child: Center(
                child: CupertinoActivityIndicator(
                ),
              ),
            );
        });
    await onLoadActionCheckSubTopic();
    Navigator.pop(context);

    if(IsNextSubTopic==true){
      _showAlertSubTopicCompleteDialog(context, "เตือน", "เรียนครบหัวข้อย่อยเตรียมทำข้อสอบ", round);
    }else{
      _showAlertNextSubTopicDialog(context, "เตือน", "เรียนรู้หัวข้อย่อยถัดไป", round);
    }
  }

  bool IsNextSubTopic =false;
  Future<bool> onLoadActionCheckSubTopic()async{
    IsNextSubTopic =false;
    //get sub topic
    List<ItemsDataSubTopic> itemsDataSubTopic = [];
    FormData formData = FormData.from({"TopicID": widget.itemsDataTopic.TopicID});
    await MainFuture().apiRequestSubTopicgetByCon(formData).then((onValue) {
      itemsDataSubTopic = onValue.Response;
    });
    if(widget.itemsDataSubTopic.SubTopicID == itemsDataSubTopic.last.SubTopicID){
      IsNextSubTopic = true;
    }else{
      IsNextSubTopic = false;
    }

    setState(() {});
    return true;
  }


  List<ItemsDataUserPass> itemsDataUserPass = [];
  Future<bool> onLoadActionUserPassStudy(int _round) async {
    List<ItemsDataSubTopic> _itemsSubTopic = [];
    ItemsDataSubTopic subTopic;
    FormData _formData = FormData.from({"TopicID":widget.itemsDataTopic.TopicID});
    await MainFuture().apiRequestSubTopicgetByCon(_formData).then((onValue) {
      _itemsSubTopic = onValue.Response;
    });
    for(int i=0;i<_itemsSubTopic.length;i++){
      if(_itemsSubTopic[i].SubTopicID==widget.itemsDataSubTopic.SubTopicID){
        if((i+1)>_itemsSubTopic.length-1){
          subTopic = _itemsSubTopic[i];
        }else{
          subTopic = _itemsSubTopic[i+1];
        }
      }
    }

    _formData = new FormData.from({
      "UserID":widget.itemsDataLogin.UserID,
      "SubTopicID":subTopic.SubTopicID,
      "SubTopicReach":subTopic.SubTopicName,
    });

    await MainFuture().apiRequestSubCurrentStudyupdAll(_formData).then((onValue) {
      print(onValue.Response.SubTopicReach);
    });


    _formData = new FormData.from({
      "UserID":widget.itemsDataLogin.UserID,
      "SubTopicID":widget.itemsDataSubTopic.SubTopicID,
      "TopicID":widget.itemsDataTopic.TopicID,
      "I":_round,
    });

    await MainFuture().apiRequestUserSubTopicPassStudyupdAll(_formData).then((onValue) {
      itemsDataUserPass = onValue.Response;
      itemsDataUserPass.forEach((item){
        print("NumberOfRepeated : ["+item.TopicID.toString()+"] "+item.NumberOfRepeated);
      });
    });


    //Clear EF,Q,I,CF_A
    await prefs.setDouble('EF', 0);
    await prefs.setDouble('Q', 0);
    await prefs.setDouble('CF', 0);
    await prefs.setInt('Round', 0);
    await prefs.setInt('I', 0);

    setState(() {});
    return true;
  }

  void _putUserPassStudy(int _round) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return
            WillPopScope(
              onWillPop: () {
                //
              },
              child: Center(
                child: CupertinoActivityIndicator(
                ),
              ),
            );
        });
    //Add && Update Log
    await onLoadActionAnswerLog();
    //Update && Get Current Topic
    await onLoadActionUserPassStudy(_round);
    Navigator.pop(context);

    //back to topic screen
    if(itemsDataUserPass!=null) {
      Navigator.pop(context, "Next");
    }
  }


  void _showAlertDialog(context,title,content,double second,bool isReLoop) {
    TextStyle textTitleStyle = TextStyle(fontSize: 18,
        color: Color(0xff242021),
        fontFamily: new FontStyles().FontFamily);
    TextStyle textContentStyle = TextStyle(fontSize: 16,
        color: Color(0xff242021),
        fontFamily: new FontStyles().FontFamily);
    TextStyle textButtonStyle = TextStyle(fontSize: 16,
        color: Colors.white,
        fontFamily: new FontStyles().FontFamily);

    Alert(
      context: context,
      type: AlertType.info,
      title: title,
      desc: content,
      style: AlertStyle(
        titleStyle: textTitleStyle,
        descStyle: textContentStyle,
      ),
      buttons: [
        DialogButton(
          child: Text(
            "ตกลง, ปิดแอพฯ",
            style: textButtonStyle,
          ),
          onPressed: (){
            Navigator.pop(context);
            sendNotificationWithScheduling(second,isReLoop);
          },
          //width: 120,
        )
      ],
    ).show();
  }

  void _showAlertNextSubTopicDialog(context,title,content,round) {
    TextStyle textTitleStyle = TextStyle(fontSize: 18,
        color: Color(0xff242021),
        fontFamily: new FontStyles().FontFamily);
    TextStyle textContentStyle = TextStyle(fontSize: 16,
        color: Color(0xff242021),
        fontFamily: new FontStyles().FontFamily);
    TextStyle textButtonStyle = TextStyle(fontSize: 16,
        color: Colors.white,
        fontFamily: new FontStyles().FontFamily);

    Alert(
      context: context,
      type: AlertType.success,
      title: title,
      desc: content,
      style: AlertStyle(
        titleStyle: textTitleStyle,
        descStyle: textContentStyle,
      ),
      buttons: [
        DialogButton(
          child: Text(
            "ตกลง",
            style: textButtonStyle,
          ),
          onPressed: (){
            Navigator.pop(context);
            _putUserPassStudy(round);
          },
          //width: 120,
        )
      ],
    ).show();
  }

  void _showAlertSubTopicCompleteDialog(mContext,title,content,round) {
    TextStyle textTitleStyle = TextStyle(fontSize: 18,
        color: Color(0xff242021),
        fontFamily: new FontStyles().FontFamily);
    TextStyle textContentStyle = TextStyle(fontSize: 16,
        color: Color(0xff242021),
        fontFamily: new FontStyles().FontFamily);
    TextStyle textButtonStyle = TextStyle(fontSize: 16,
        color: Colors.white,
        fontFamily: new FontStyles().FontFamily);

    Alert(
      context: context,
      type: AlertType.success,
      title: title,
      desc: content,
      style: AlertStyle(
        titleStyle: textTitleStyle,
        descStyle: textContentStyle,
      ),
      buttons: [
        DialogButton(
          child: Text(
            "ตกลง",
            style: textButtonStyle,
          ),
          onPressed: (){
            Navigator.pop(context);
            _navigateToQuestion(context,round);
          },
        )
      ],
    ).show();
  }

  _navigateToQuestion(context,round) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return
            WillPopScope(
              onWillPop: () {
                //
              },
              child: Center(
                child: CupertinoActivityIndicator(
                ),
              ),
            );
        });
    //Add && Update Log
    await onLoadActionAnswerLog();
    //Update && Get Current Topic
    await onLoadActionUserPassStudy(round);
    //Get Question
    await onLoadActiongetQuestion();
    Navigator.pop(context);

    if(itemDataQuestion.length>0) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
            QuestionScreen(
              itemsDataQuestion: itemDataQuestion,
              Title: "ข้อสอบ"+widget.itemsDataTopic.TopicName,
              itemsDataTopic: widget.itemsDataTopic,
              itemsDataSubTopic: widget.itemsDataSubTopic,
              itemsDataLogin: widget.itemsDataLogin,
              IsNotify: widget.IsNotify,
            )),
      );
      if(result.toString().endsWith("NextTopic")){
        print("NextTopic asses : "+result.toString());
        Navigator.pop(context,"NextTopic");
      }
    }else{
      new ShowDialog(context, "เตือน", widget.itemsDataTopic.TopicName+" ไม่มีข้อมูลข้อสอบ", 1);
    }
  }

  List<ItemsDataQuestion> itemDataQuestion = [];
  Future<bool> onLoadActiongetQuestion() async {
    itemDataQuestion = [];
    int levelID = 0;
    double _CF = double.parse(widget.itemsDataLogin.UserCF);
    if(_CF==0){
      //กลาง
      levelID = 2;
    }else{
      if(_CF>=0.34&&_CF<=1){
        //เก่ง
        levelID = 3;
      }else if(_CF>=-0.34&&_CF<=0.34){
        //กลาง
        levelID = 2;
      }else if(_CF>=-1&&_CF<=-0.33){
        //อ่อน
        levelID = 1;
      }
    }

    FormData _formData = FormData.from({
      "LevelID":levelID,
      "TopicID":widget.itemsDataTopic.TopicID
    });
    await MainFuture().apiRequestQuestiongetByCon(_formData).then((onValue) {
      itemDataQuestion = onValue.Response;
    });

    itemDataQuestion.forEach((item) {
      var randomChoice = (item.itemsChoice..shuffle());
      item.itemsChoice = randomChoice;
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

    return new WillPopScope(
      onWillPop: () {
        //
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.Title, style: textTitleStyl,),
          centerTitle: true,
          automaticallyImplyLeading: false,
          /*leading: IconButton(
              icon: Icon(Icons.arrow_back,), onPressed: () {
            Navigator.pop(context);
          }),*/
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
                      /*Padding(
                    padding: EdgeInsets.all(8.0),
                    child: new Text('ระดับข้อสอบ : ' +
                        widget.itemsDataQuestion.first.LevelName.toString(),
                      style: textInputStyle,),
                  )*/
                    ],
                  ),
                ),
                Expanded(
                  child: _buildContent(),
                ),
              ],
            ),
          ],
        ),
        bottomNavigationBar: _buildBottom(),
      ),
    );
  }
}

//choice แบบประเมิน
class ItemsChoiceRating{
  String RatingName;
  double Rating;
  int RatingType; //1=Corrct, 0=InCorrect
  bool IsCheck;

  ItemsChoiceRating({
    this.RatingName,
    this.Rating,
    this.RatingType,
    this.IsCheck,
  });
}
