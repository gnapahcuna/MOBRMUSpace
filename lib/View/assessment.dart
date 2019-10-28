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
import 'package:rmu_space/Font/font_style.dart';
import 'package:rmu_space/Model/Data/Question/question_model.dart';
import 'package:rmu_space/Model/Data/Topic/current_study_model.dart';
import 'package:rmu_space/Model/Data/Topic/topic_model.dart';
import 'package:rmu_space/Model/Data/login_model.dart';
import 'package:rmu_space/Model/Data/video_model.dart';
import 'package:rmu_space/Model/Future/main_future.dart';
import 'package:rmu_space/Model/UserPass/user_pass_model.dart';
import 'package:rmu_space/Model/background.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:video_player/video_player.dart';


FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class AssessmentScreen extends StatefulWidget {
  List<ItemsDataQuestion> itemsDataQuestion;
  ItemsDataLoginResponse itemsDataLogin;
  ItemsDataTopic itemsDataTopic;
  bool IsNotify;
  String Title;
  AssessmentScreen({
    Key key,
    @required this.itemsDataQuestion,
    @required this.itemsDataLogin,
    @required this.itemsDataTopic,
    @required this.IsNotify,
    @required this.Title,
  }) : super(key: key);
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<AssessmentScreen> {

  String message_result;
  int total;

  String message;
  String channelId = "1000";
  String channelName = "FLUTTER_NOTIFICATION_CHANNEL";
  String channelDescription = "FLUTTER_NOTIFICATION_CHANNEL_DETAIL";

  //ค่า CF ผู้เรียน
  double cf_a = 0;
  //ค่า EF ประมาณ
  double EF = 0;
  double Q = 0;
  int Round = 0;

  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();

    _initPrefs();

    cf_a = double.parse(widget.itemsDataLogin.UserCF);
    //EF = 0;
    //Q = 0;

    print(widget.itemsDataLogin.UserName);

    total = 0;
    widget.itemsDataQuestion.forEach((item) {
      item.itemsChoice.forEach((choice){
        item.IsQuestionCorrect=false;
        //ตอบถูก
        if(choice.IsCheck&&choice.IsCorrect){
          total++;
          //ค่า CF คำถาม เมื่อตอบถูก
          double cf_b = double.parse(item.CF)*1;

          if(cf_a>=0&&cf_b>=0){
            cf_a = (cf_a+cf_b)-(cf_a*cf_b);
          }else if(cf_a<0&&cf_b<0){
            cf_a = (cf_a+cf_b)+(cf_a*cf_b);
          }else{
            //min
            double cf_min = 0;
            if(cf_a>double.parse(item.CF)){
              cf_min = double.parse(item.CF);
            }else{
              cf_min = cf_a;
            }
            cf_a = (cf_a+cf_b)/(1-cf_min);
          }
          setState(() {
            item.IsQuestionCorrect=true;
          });
        }
        //ตอบผิด
        else if(choice.IsCheck&&!choice.IsCorrect){
          String type="";

          //ค่า CF คำถาม เมื่อตอบผิด
          double cf_b = double.parse(item.CF)*-1;

          if(cf_a>=0&&cf_b>=0){
            type="a";
            cf_a = cf_a+(cf_b)-cf_a*(cf_b);
          }else if(cf_a<0&&cf_b<0){
            type="b";
            cf_a = (cf_a+cf_b)+(cf_a*cf_b);
          }else{
            type="c";
            //min
            double cf_min = 0;
            if(cf_a>cf_b){
              cf_min = cf_b;
            }else{
              cf_min = cf_a;
            }
            cf_a = (cf_a+cf_b)/(1-cf_min);
          }
          print(type +":: "+cf_a.toString());
        }
      });
    });


    //test q
    //Q = 5;

    print("EF' : "+(2.5-0.8+0.28*5-0.02*5*2).toString());
    print("CF user : "+cf_a.toString());
    message_result="คุณตอบถูก "+total.toString()+" ข้อ";

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

  sendNotificationWithScheduling(double minutes,bool isReLoop) async {
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
      new DateTime.now().add(new Duration(minutes: minutes.toInt()));
      var androidPlatformChannelSpecifics =
      new AndroidNotificationDetails(channelId, channelName, channelDescription,
          importance: Importance.Max, priority: Priority.High);
      var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
      NotificationDetails platformChannelSpecifics = new NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.schedule(
          0,
          'RMU Space',
          'คลิกที่นี่!! เพื่อทำแบบทดสอบอีกครั้ง ในรอบที่ '+round.toString(),
          scheduledNotificationDateTime,
          platformChannelSpecifics,
          payload: 'Looping'
      );

      //เก็บข้อมูล data ฝั่ง client
      await _putDataClient(minutes,round);
  }

  _putDataClient(double minutes,int _round) async {
    //add data in local base
    await prefs.setString('UserID', widget.itemsDataLogin.UserID);
    await prefs.setString('UserName', widget.itemsDataLogin.UserName);
    await prefs.setString('Password', widget.itemsDataLogin.Password);
    await prefs.setDouble('EF', EF);
    await prefs.setDouble('Q', Q);
    await prefs.setDouble('CF', cf_a);
    await prefs.setInt('Round', _round);
    await prefs.setInt('I', minutes.toInt());

    //add log answer
    _putAnswerLog();
  }


  Widget _buildContent() {
    TextStyle textInputStyleTitle = TextStyle(
        fontSize: 16.0,
        color: Colors.black,
        fontFamily: FontStyles().FontFamily,
        fontWeight: FontWeight.w400);
    TextStyle textInputStyleSub = TextStyle(fontSize: 20.0,
        color: Colors.black54,
        fontFamily: FontStyles().FontFamily);
    TextStyle textInputStyleSub1 = TextStyle(fontSize: 16.0,
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

    EdgeInsets paddingInputBox = EdgeInsets.only(top: 4.0, bottom: 4.0);

    SmoothStarRating smoothStarRating;
    return SingleChildScrollView(
      child: Center(
          child: Column(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(top: 22.0, bottom: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: paddingInputBox,
                        child: Text(
                          "เกณฑ์การประเมิน",
                          style: textInputStyleSub,),
                      ),
                    ],
                  )
              ),
              Container(
                  //padding: EdgeInsets.only(top: 32.0, bottom: 32.0),
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
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.itemsDataQuestion.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {

                  bool IsCorrect = false;
                  widget.itemsDataQuestion[index].itemsChoice.forEach((choice){
                     if(choice.IsCheck&&choice.IsCorrect){
                       IsCorrect=true;
                     }
                  });

                  String text_rating;
                  if(widget.itemsDataQuestion[index].Rating==6){
                    text_rating = "ตอบถูกได้ง่ายมาก";
                  }else if(widget.itemsDataQuestion[index].Rating==5){
                    text_rating = "ตอบถูกได้แม้จะลังเลเล็กน้อย";
                  }else if(widget.itemsDataQuestion[index].Rating==4){
                    text_rating = "ตอบถูกได้แต่ต้องคิดอย่างหนัก ";
                  }else if(widget.itemsDataQuestion[index].Rating==3){
                    text_rating = "ตอบผิดและข้อที่ถูกดูเหมือนจะตอบได้";
                  }else if(widget.itemsDataQuestion[index].Rating==2){
                    text_rating = "ตอบผิดและได้เรียนรู้จากข้อที่ถูก";
                  }else if(widget.itemsDataQuestion[index].Rating==1){
                    text_rating = "ไม่สามารถตอบได้เลย";
                  }

                  return Padding(
                    padding: EdgeInsets.only(top: 0.0, bottom: 0.0),
                    child: Container(
                      padding: EdgeInsets.all(22.0),
                      decoration: BoxDecoration(
                        //color: Colors.white,
                          shape: BoxShape.rectangle,
                          border: index == 0 ? Border(
                            //top: BorderSide(color: Colors.grey[400], width: 1.0),
                            bottom: BorderSide(
                                color: Colors.grey[400], width: 1.0),
                          ) : Border(
                            bottom: BorderSide(
                                color: Colors.grey[400], width: 1.0),
                          )
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(bottom: 12.0),
                            child: Text(
                              (index + 1).toString() + '. ' +
                                  widget.itemsDataQuestion[index].Question
                                      .toString(),
                              style: textInputStyleTitle,),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(right: 18.0),
                                child: Center(
                                    child: InkWell(
                                      child: Container(
                                        padding: EdgeInsets.all(2.0),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: IsCorrect
                                              ? Color(0xff00b300)
                                              : Colors.red,
                                          border: IsCorrect
                                              ? Border.all(
                                              color: Color(0xff00b300),
                                              width: 1.3)
                                              : Border.all(
                                              color: Colors.red,
                                              width: 1.3),
                                        ),
                                        child: Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child: IsCorrect
                                                ? Icon(
                                              Icons.check,
                                              size: 22.0,
                                              color: Colors.white,
                                            )
                                                : Icon(
                                              Icons.clear,
                                              size: 22.0,
                                              color: Colors.white,
                                            )
                                        ),
                                      ),
                                    )
                                ),
                              ),
                              Padding(
                                padding: paddingInputBox,
                                child: Text(
                                  widget.itemsDataQuestion[index].IsQuestionCorrect
                                      ?"ตอบถูก"
                                      :"ตอบผิด",
                                  style: textInputStyleSub1,),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 18,bottom: 8.0),
                            child: SmoothStarRating(
                                allowHalfRating: false,
                                onRatingChanged: (v) {
                                  //
                                  setState(() {
                                    widget.itemsDataQuestion[index].Rating = v;

                                    double q_total = 0;
                                    for(int i=0;i<widget.itemsDataQuestion.length;i++){
                                      double rating = widget.itemsDataQuestion[i].Rating-1;
                                      q_total+=rating;
                                    }
                                    Q = q_total/widget.itemsDataQuestion.length;
                                  });
                                },
                                starCount: 6,
                                rating: widget.itemsDataQuestion[index].Rating,
                                size: 38.0,
                                color: Color(0xff087de1),
                                borderColor: Colors.grey[400],
                                spacing: 0.0
                            ),
                          ),
                          Padding(
                            padding: paddingInputBox,
                            child: Text(
                              widget.itemsDataQuestion[index].Rating!=0
                                  ?text_rating
                                  :"",
                              style: textInputStyleSub2,),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            ],
          )
      ),
    );
  }
  Future<bool> onLoadActionAnswerLog() async {
    Map formData;
    List<Map> items = [];


    for(int i=0;i<widget.itemsDataQuestion.length;i++){
      double _rating = widget.itemsDataQuestion[i].Rating-1;
      bool IsCorrect = false;
      widget.itemsDataQuestion[i].itemsChoice.forEach((choice){
        if(choice.IsCheck&&choice.IsCorrect){
          IsCorrect=true;
        }
      });

      double ef = double.parse(widget.itemsDataQuestion[i].CF)-0.8+0.28*_rating-0.02*_rating*2;
      var item = {
        "UserID": widget.itemsDataLogin.UserID,
        "QuestionID": widget.itemsDataQuestion[i].QuestionID,
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
    await MainFuture().apiRequestUserAnswerQuestionloginsAll(items).then((onValue) {
      //print(onValue);
    });

    int _i = (prefs.getInt('I') ?? 1);
    //double _cf = (prefs.getDouble('CF') ?? 1);
    //double _cf = double.parse(widget.itemsDataLogin.UserCF);
    double _ef = (prefs.getDouble('EF') ?? 1);

    FormData _formData = new FormData.from({
      "UserID":widget.itemsDataLogin.UserID,
      "CF":cf_a,
    });
    //Update UserCF
    await MainFuture().apiRequestUserCFupdAll(_formData).then((onValue) {
      print("UserCF : "+onValue.Response.UserCF);
    });


    //Add Test Log
    _formData = new FormData.from({
      "UserID":widget.itemsDataLogin.UserID,
      "TopicID":widget.itemsDataTopic.TopicID,
      "LevelName":widget.itemsDataQuestion.first.LevelName,
      "I":_i,
      "CF":cf_a,
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
    widget.itemsDataQuestion.forEach((item){
      if(item.Rating>0){
        count++;
      }
    });
    print(count);
    if(count==widget.itemsDataQuestion.length){
      isCheck=true;
    }

    if(isCheck){
      double q_total = 0;
      for(int i=0;i<widget.itemsDataQuestion.length;i++){
        double rating = widget.itemsDataQuestion[i].Rating-1;
        q_total+=rating;
      }
      setState(() {
        Q = q_total/widget.itemsDataQuestion.length;
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
          double minutes;

          if(round==1){
            minutes = unit.toDouble();
          }else if(round==2){
            minutes = unit.toDouble()*6;
          }else if(round==3){
            minutes = _i*(2.5);
          }else if(round>3){
            minutes = _i*_ef;
          }
          print("minutes : "+minutes.toString());

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

          if(round>3){
            if(_continue){
              _showAlertDialog(context,"เตือน","ผู้เรียนรอการทวนซ้ำ "+minutes.toInt().toString()+" นาที",minutes,false);
            }else if(_start){
              minutes = unit.toDouble();
              _showAlertDialog(context,"เตือน","ผู้เรียนรอการทวนซ้ำ "+minutes.toInt().toString()+" นาที",minutes,true);
            }else if(_next){
              //pass topic
              int round;
              if(widget.IsNotify){
                round = (prefs.getInt('Round') ?? 0) + 1;
              }else{
                round = 1;
              }
              _putUserPassStudy(round);
            }else{
              _showAlertDialog(context,"เตือน","ไม่เข้าเงื่อนไขใดๆ : "+Q.toString()+", "+_continue.toString()+", "+_start.toString()+", "+_next.toString(),minutes,true);
            }
          }else{
            _showAlertDialog(context,"เตือน","ผู้เรียนรอการทวนซ้ำ "+minutes.toInt().toString()+" นาที",minutes,false);
          }

          setState(() {});
        },
        child: Center(
          child: Text('ยืนยัน ( EF : '+NumberFormat("#,##0.00").format(EF).toString()+', Q : '+ Q.toInt().toString() +' )', style: textBottomStyle,),
        ),
      ),
    ) : null;
  }


  List<ItemsDataUserPass> itemsDataUserPass = [];
  Future<bool> onLoadActionUserPassStudy(int _round) async {
    List<ItemsDataTopic> _itemsTopic = [];
    ItemsDataTopic topic;
    FormData _formData = FormData.from({"text":""});
    await MainFuture().apiRequestTopicgetByCon(_formData).then((onValue) {
      _itemsTopic = onValue.Response;
    });
    for(int i=0;i<_itemsTopic.length;i++){
      if(_itemsTopic[i].TopicID==widget.itemsDataTopic.TopicID){
        if((i+1)>_itemsTopic.length-1){
          topic = _itemsTopic[i];
        }else{
          topic = _itemsTopic[i+1];
        }

      }
    }

    _formData = new FormData.from({
      "UserID":widget.itemsDataLogin.UserID,
      "TopicID":topic.TopicID,
      "TopicReach":topic.TopicName,
    });

    await MainFuture().apiRequestCurrentStudyupdAll(_formData).then((onValue) {
      print(onValue.Response.TopicReach);
    });


    _formData = new FormData.from({
      "UserID":widget.itemsDataLogin.UserID,
      "TopicID":widget.itemsDataTopic.TopicID,
      "I":_round,
    });

    await MainFuture().apiRequestUserPassStudyupdAll(_formData).then((onValue) {
      itemsDataUserPass = onValue.Response;
      itemsDataUserPass.forEach((item){
        print("NumberOfRepeated : ["+item.TopicID.toString()+"] "+item.NumberOfRepeated);
      });
    });

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
      Navigator.pop(context, "Back");
    }
  }


  void _showAlertDialog(context,title,content,double minutes,bool isReLoop) {
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
            sendNotificationWithScheduling(minutes,isReLoop);
          },
          //width: 120,
        )
      ],
    ).show();
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
          //automaticallyImplyLeading: false,
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
