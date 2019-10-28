import 'package:dio/dio.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rmu_space/Font/font_style.dart';
import 'package:rmu_space/Model/Data/Exercise/exercise_model.dart';
import 'package:rmu_space/Model/Data/Question/question_model.dart';
import 'package:rmu_space/Model/Data/Topic/list_topic_model.dart';
import 'package:rmu_space/Model/Data/Topic/topic_model.dart';
import 'package:rmu_space/Model/Data/login_model.dart';
import 'package:rmu_space/Model/Future/main_future.dart';
import 'package:rmu_space/Model/background.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import 'assessment.dart';
import 'assessment_test.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
class ResultScreen extends StatefulWidget {
  List<ItemsDataExercise> itemsDataExercise;
  ItemsDataLoginResponse itemsDataLogin;
  ItemsListTopic itemsDataTopic;
  bool IsNotify;
  String Title;
  ResultScreen({
    Key key,
    @required this.itemsDataExercise,
    @required this.itemsDataLogin,
    @required this.itemsDataTopic,
    @required this.IsNotify,
    @required this.Title,
  }) : super(key: key);
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<ResultScreen> {

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
    EF = 0;
    Q = 0;

    print(widget.itemsDataLogin.UserName);

    total = 0;
    /*widget.itemsDataExercise.forEach((item) {
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
            cf_a = (cf_a+cf_b)-(cf_a*cf_b);
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
            print(cf_a.toString()+" + "+cf_b.toString()+" / "+1.toString()+" - "+cf_min.toString());
          }
          print(type +":: "+cf_a.toString());
        }
      });
    });*/


    //test q
    //Q = 5;

    print("EF' : "+(2.5-0.8+0.28*5-0.02*5*2).toString());
    print("CF user : "+cf_a.toString());
    message_result="คุณตอบถูก "+total.toString()+" ข้อ";

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
      EF = 2.5;
    }
  }


  @override
  void dispose() {
    super.dispose();
  }

  Widget build_answer() {
    var size = MediaQuery
        .of(context)
        .size;
    TextStyle textInputStyle = TextStyle(fontSize: 18.0,
        color: Colors.black54,
        fontFamily: FontStyles().FontFamily);
    TextStyle textInputStyleTitle = TextStyle(
        fontSize: 16.0,
        color: Colors.black,
        fontFamily: FontStyles().FontFamily,
        fontWeight: FontWeight.w400);
    TextStyle textInputStyleSub = TextStyle(fontSize: 16.0,
        color: Colors.black54,
        fontFamily: FontStyles().FontFamily);
    TextStyle textInputStyleSubCorrect = TextStyle(fontSize: 16.0,
        color: Color(0xff00b300),
        fontFamily: FontStyles().FontFamily);

    EdgeInsets paddingInputBox = EdgeInsets.only(top: 4.0, bottom: 4.0);

    buildCollapsed() {
      return Container(
        padding: EdgeInsets.only(top:8.0,bottom: 12.0,left: 12.0,right: 100.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  child: Text(
                    "เฉลย", style: textInputStyle,),
                ),
              ],
            )
          ],
        ),
      );
    }

    buildExpanded() {
      return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: widget.itemsDataExercise.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.only(top: 0.0, bottom: 0.0),
            child: Container(
              padding: EdgeInsets.all(22.0),
              decoration: BoxDecoration(
                //color: Colors.white,
                  shape: BoxShape.rectangle,
                  border: index == 0 ? Border(
                    //top: BorderSide(color: Colors.grey[400], width: 1.0),
                    bottom: BorderSide(color: Colors.grey[400], width: 1.0),
                  ) : Border(
                    bottom: BorderSide(color: Colors.grey[400], width: 1.0),
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
                          widget.itemsDataExercise[index].Question.toString(),
                      style: textInputStyleTitle,),
                  ),
                  ListView.builder(
                    itemCount: widget.itemsDataExercise[index].itemsChoice.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int j) {
                      List prefix = ["ก", "ข", "ค", "ง"];
                      return Container(
                          padding: EdgeInsets.only(
                              left: 22.0, top: 8.0, bottom: 8.0, right: 12.0),
                          child: InkWell(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(right: 18.0),
                                  child: Center(
                                      child: InkWell(
                                        child: Container(
                                          padding: EdgeInsets.all(2.0),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color: widget.itemsDataExercise[index]
                                                .itemsChoice[j].IsCheck
                                                ? Color(0xff3b69f3)
                                                : Colors.white,
                                            border: widget
                                                .itemsDataExercise[index]
                                                .itemsChoice[j].IsCheck
                                                ? Border.all(
                                                color: Color(0xff3b69f3),
                                                width: 1.3)
                                                : widget.itemsDataExercise[index]
                                                .itemsChoice[j].IsCorrect
                                                ? Border.all(
                                                color: Color(0xff00b300),
                                                width: 1.3)
                                                :Border.all(
                                                color: Colors.grey[500],
                                                width: 1.3),
                                          ),
                                          child: Padding(
                                              padding: const EdgeInsets.all(0.0),
                                              child: widget
                                                  .itemsDataExercise[index]
                                                  .itemsChoice[j].IsCheck
                                                  ? Icon(
                                                Icons.check,
                                                size: 22.0,
                                                color: Colors.white,
                                              )
                                                  : widget.itemsDataExercise[index]
                                                  .itemsChoice[j].IsCorrect
                                                  ? Icon(
                                                Icons.check,
                                                size: 22.0,
                                                color: Color(0xff00b300),
                                              )
                                                  :Container(
                                                height: 22.0,
                                                width: 22.0,
                                                color: Colors.transparent,
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
                                          widget.itemsDataExercise[index]
                                              .itemsChoice[j].ChoiceName.toString()
                                              .toString(),
                                      style: widget.itemsDataExercise[index].itemsChoice[j].IsCorrect
                                          ?textInputStyleSubCorrect:textInputStyleSub,),
                                  ),
                                ),
                                widget.itemsDataExercise[index].itemsChoice[j].IsCheck
                                    ?Container(
                                  padding: EdgeInsets.only(left: 18,right: 18.0),
                                  child: Center(
                                      child: InkWell(
                                        child: Container(
                                          padding: EdgeInsets.all(2.0),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: widget.itemsDataExercise[index].itemsChoice[j].IsCheck
                                                && widget.itemsDataExercise[index].itemsChoice[j].IsCorrect
                                                ? Color(0xff00b300)
                                                : Colors.red,
                                            border: widget.itemsDataExercise[index].itemsChoice[j].IsCheck
                                                && widget.itemsDataExercise[index].itemsChoice[j].IsCorrect
                                                ? Border.all(
                                                color: Color(0xff00b300),
                                                width: 1.3)
                                                : Border.all(
                                                color: Colors.red,
                                                width: 1.3),
                                          ),
                                          child: Padding(
                                              padding: const EdgeInsets.all(0.0),
                                              child: widget.itemsDataExercise[index].itemsChoice[j].IsCheck
                                            && widget.itemsDataExercise[index].itemsChoice[j].IsCorrect
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
                                )
                                    :Container()
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
      );
    }

    return Container(
      padding: EdgeInsets.only(top: 0.0, bottom: 12.0),
      child: Container(
        //key: stickyKey,
        //height: size.height / 3,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border(
              top: BorderSide(color: Colors.grey[300], width: 1.0),
              bottom: BorderSide(
                  color: Colors.grey[300], width: 1.0),
            )
        ),
        child: Container(
          padding: EdgeInsets.only(
              top: 12.0, bottom: 12.0, right: 12.0),
          child: Stack(children: <Widget>[
            ExpandableNotifier(
              child: Stack(
                children: <Widget>[
                  Expandable(
                    collapsed: buildCollapsed(),
                    expanded: buildExpanded(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Builder(
                        builder: (context) {
                          var exp = ExpandableController.of(context);
                          return FlatButton(
                              onPressed: () {
                                exp.toggle();
                              },
                              child: Icon(
                                  exp.expanded ? Icons.keyboard_arrow_up : Icons
                                      .keyboard_arrow_down)
                          );
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
          ),
        ),
      ),
    );
  }


  Widget _buildContent() {
    TextStyle textInputStyleTitle = TextStyle(
        fontSize: 16.0,
        color: Colors.black,
        fontFamily: FontStyles().FontFamily,
        fontWeight: FontWeight.w400);
    TextStyle textInputStyleSub = TextStyle(fontSize: 22.0,
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

    return SingleChildScrollView(
      child: Center(
          child: Column(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(top: 32.0,bottom: 32.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(bottom: 22.0),
                        child: total!=0
                            ?Container(
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
                            :Container(
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
                          style: textInputStyleSub,),
                      ),
                    ],
                  )
              ),
              build_answer(),
            ],
          )
      ),
    );
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

    bool isCheck=true;

    return isCheck ? Container(
      width: size.width,
      height: 65,
      color: Color(0xffffcb13),
      child: MaterialButton(
        onPressed: () {
          _navigate_next();
          /*if(widget.IsNotify){
            _navigate_next();
          }else{
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

            *//*round = 3;
          _start = false;
          _next = true;
          _continue = false;*//*
            String _second = "";
            if(second.toInt()<59){
              _second = second.toInt().toString()+" วินาที";
            }else{
              _second = (second.toInt()/59).toInt().toString()+" นาที";
            }

            if(round>3){
              if(_continue){
                _showAlertDialog(context,"เตือน","ผู้เรียนรอการทวนซ้ำ "+_second,second,false);
              }else if(_start){
                second = unit.toDouble();
                if(second.toInt()<59){
                  _second = second.toInt().toString()+" วินาที";
                }else{
                  _second = (second.toInt()/59).toInt().toString()+" วินาที";
                }

                _showAlertDialog(context,"เตือน","ผู้เรียนรอการทวนซ้ำ "+_second+" วินาที",second,true);
              }else if(_next){
                //pass topic
                int round;
                if(widget.IsNotify){
                  round = (prefs.getInt('Round') ?? 0) + 1;
                }else{
                  round = 1;
                }
                //_putUserPassStudy(round);
              }else{
                _showAlertDialog(context,"เตือน","ไม่เข้าเงื่อนไขใดๆ : "+Q.toString()+", "+_continue.toString()+", "+_start.toString()+", "+_next.toString(),second,true);
              }
            }else{
              _showAlertDialog(context,"เตือน","ผู้เรียนรอการทวนซ้ำ "+_second,second,false);
            }

            setState(() {});
          }*/
        },
        /*child: Center(
          child: Text(widget.IsNotify?'ประเมินความรู้สึกต่อข้อสอบ':'ยืนยัน', style: textBottomStyle,),
        ),*/
        child: Center(
          child: Text('เฉลยและประเมิน', style: textBottomStyle,),
        ),
      ),
    ) : null;
  }

  _navigate_next()async{
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>
          AssessmentTestScreen(
            itemsDataLogin: widget.itemsDataLogin,
            itemsDataExercise: widget.itemsDataExercise,
            itemsDataTopic: widget.itemsDataTopic,
            Title: "ประเมิน",
            IsNotify: widget.IsNotify,
          )),
    );
    if(result.toString().endsWith("Back")){
      Navigator.pop(context,"Back");
    }
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
          title: Text("คำตอบของคุณ", style: textTitleStyl,),
          centerTitle: true,
          /*leading: IconButton(
              icon: Icon(Icons.arrow_back,), onPressed: () {
            Navigator.pop(context);
          }),*/
          automaticallyImplyLeading: false,
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
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: new Text('ค่า CF : ' + NumberFormat("#,##0.00").format(cf_a).toString(),
                          style: textInputStyleNo,),
                      )
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
        'คลิกที่นี่!! เพื่อทำแบบทดสอบอีกครั้ง ในรอบที่ '+round.toString(),
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
    await prefs.setDouble('CF', cf_a);
    await prefs.setInt('Round', _round);
    await prefs.setInt('I', second.toInt());

    //add log answer
    _putAnswerLog();
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

  Future<bool> onLoadActionAnswerLog() async {
    FormData _formData = new FormData.from({
      "UserID":widget.itemsDataLogin.UserID,
      "CF":cf_a,
    });
    //Update UserCF
    await MainFuture().apiRequestUserCFupdAll(_formData).then((onValue) {
      print("UserCF : "+onValue.Response.UserCF);
    });
    setState(() {});
    return true;
  }
}
