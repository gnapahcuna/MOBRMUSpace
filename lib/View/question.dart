import 'dart:math';

import 'package:dart_random_choice/dart_random_choice.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:chewie/chewie.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rmu_space/Font/font_style.dart';
import 'package:rmu_space/Model/Data/Question/question_model.dart';
import 'package:rmu_space/Model/Data/SubTopic/current_sub_topic_study_model.dart';
import 'package:rmu_space/Model/Data/SubTopic/sub_topic_model.dart';
import 'package:rmu_space/Model/Data/Topic/list_topic_model.dart';
import 'package:rmu_space/Model/Data/Topic/topic_model.dart';
import 'package:rmu_space/Model/Data/login_model.dart';
import 'package:rmu_space/Model/Data/video_model.dart';
import 'package:rmu_space/Model/Future/main_future.dart';
import 'package:rmu_space/Model/UserPass/user_pass_model.dart';
import 'package:rmu_space/Model/background.dart';
import 'package:rmu_space/View/result.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class QuestionScreen extends StatefulWidget {
  List<ItemsDataQuestion> itemsDataQuestion;
  ItemsListTopic itemsDataTopic;
  ItemsDataSubTopic itemsDataSubTopic;
  ItemsDataLoginResponse itemsDataLogin;
  bool IsNotify;
  String Title;
  QuestionScreen({
    Key key,
    @required this.itemsDataQuestion,
    @required this.itemsDataTopic,
    @required this.itemsDataSubTopic,
    @required this.itemsDataLogin,
    @required this.IsNotify,
    @required this.Title,
  }) : super(key: key);
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<QuestionScreen> {

  int total;
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
  }


  @override
  void dispose() {
    super.dispose();
  }

  void _initPrefs()async{
    prefs = await SharedPreferences.getInstance();
    /*double _q = (prefs.getDouble('Q') ?? 0);
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
    }*/
  }


  Widget _buildContent() {
    TextStyle textQuestionStyle = TextStyle(
        fontSize: 18.0,
        color: Color(0xff3d63d2),
        fontFamily: FontStyles().FontFamily,
        fontWeight: FontWeight.w400);
    TextStyle textInputStyleTitle = TextStyle(
        fontSize: 16.0,
        color: Colors.black,
        fontFamily: FontStyles().FontFamily,
        fontWeight: FontWeight.w400);

    EdgeInsets paddingInputBox = EdgeInsets.only(top: 4.0, bottom: 4.0);


    return ListView.builder(
      itemCount: widget.itemsDataQuestion.length,
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
                  bottom: BorderSide(color: Colors.grey[400], width: 0.5),
                ) : Border(
                  bottom: BorderSide(color: Colors.grey[400], width: 0.5),
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
                        widget.itemsDataQuestion[index].Question.toString(),
                    style: textQuestionStyle,),
                ),
                ListView.builder(
                  itemCount: widget.itemsDataQuestion[index].itemsChoice.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int j) {
                    List prefix = ["ก", "ข", "ค", "ง"];
                    return Container(
                        padding: EdgeInsets.only(
                            left: 22.0, top: 8.0, bottom: 8.0, right: 12.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              widget.itemsDataQuestion[index].itemsChoice[j]
                                  .IsCheck =
                              !widget.itemsDataQuestion[index].itemsChoice[j]
                                  .IsCheck;

                              for (int i = 0; i <
                                  widget.itemsDataQuestion[index].itemsChoice
                                      .length; i++) {
                                if (i != j) {
                                  widget.itemsDataQuestion[index].itemsChoice[i]
                                      .IsCheck = false;
                                }
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
                                          widget.itemsDataQuestion[index]
                                              .itemsChoice[j].IsCheck =
                                          !widget.itemsDataQuestion[index]
                                              .itemsChoice[j].IsCheck;

                                          for (int i = 0; i <
                                              widget.itemsDataQuestion[index]
                                                  .itemsChoice.length; i++) {
                                            if (i != j) {
                                              widget.itemsDataQuestion[index]
                                                  .itemsChoice[i].IsCheck =
                                              false;
                                            }
                                          }
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(2.0),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          color: widget.itemsDataQuestion[index]
                                              .itemsChoice[j].IsCheck
                                              ? Color(0xff3b69f3)
                                              : Colors.white,
                                          border: widget
                                              .itemsDataQuestion[index]
                                              .itemsChoice[j].IsCheck
                                              ? Border.all(
                                              color: Color(0xff3b69f3),
                                              width: 1.2)
                                              : Border.all(
                                              color: Colors.grey[700],
                                              width: 1.2),
                                        ),
                                        child: Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child: widget
                                                .itemsDataQuestion[index]
                                                .itemsChoice[j].IsCheck
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
                                  prefix[j] + ". " +
                                      widget.itemsDataQuestion[index]
                                          .itemsChoice[j].ChoiceName.toString()
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
          ),
        );
      },
    );
  }


  void _calUserCF(){
    //block-1
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
    print("EF' : "+(2.5-0.8+0.28*5-0.02*5*2).toString());
    print("CF user : "+cf_a.toString());

    //block-2
    int round;
    if(widget.IsNotify){
      round = (prefs.getInt('Round') ?? 0) + 1;
    }else{
      round = 1;
    }
    _putUserPassStudy(round);
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

    int count = 0;
    widget.itemsDataQuestion.forEach((item) {
      item.itemsChoice.forEach((choice){
        if(choice.IsCheck){
          count++;
        }
      });
    });
    if (count == widget.itemsDataQuestion.length) {
      IsAnswerComplete = true;
    }

    return IsAnswerComplete ? Container(
      width: size.width,
      height: 65,
      color: Color(0xffffcb13),
      child: MaterialButton(
        onPressed: () {
          //pass topic
          _calUserCF();
        },
        child: Center(
          child: Text('ส่งผล', style: textBottomStyle,),
        ),
      ),
    ) : null;
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
      //Navigator.pop(context, "Back");
      _showAlertTopicCompleteDialog(context,"เตือน","เนื้อหาต่อไปโดนปลดล็อค");
    }
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

  List<ItemsDataUserPass> itemsDataUserPass = [];
  Future<bool> onLoadActionUserPassStudy(int _round) async {
    //Add Current Topic Log
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

    //Add UserPass Topic Log
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


    //Add Current SubTopic Log
    ItemsDataSubTopicCurrentStudy itemsDataSubTopicCurrentStudy;
    FormData formData = new FormData.from({
      "UserID": widget.itemsDataLogin.UserID,
    });
    await MainFuture().apiRequestSubCurrentStudygetByCon(formData).then((
        onValue) {
      if (onValue != null) {
        itemsDataSubTopicCurrentStudy = onValue.Response;
      }
    });
    List<ItemsDataSubTopic> _itemsSubTopic = [];
    ItemsDataSubTopic subTopic;
    _formData = FormData.from({"TopicID":topic.TopicID});
    await MainFuture().apiRequestSubTopicgetByCon(_formData).then((onValue) {
      _itemsSubTopic = onValue.Response;
    });
    _itemsSubTopic.forEach((item) {
      if (itemsDataSubTopicCurrentStudy != null) {
        if (itemsDataSubTopicCurrentStudy.SubTopicID == item.SubTopicID) {
          print("A");
          item.IsTopic = true;
          subTopic = item;
        }else{
          print("C");
          if (item.SubTopicID == _itemsSubTopic.first.SubTopicID) {
            item.IsTopic = true;
            subTopic = item;
          }
        }
      } else {
        print("B");
        if (item.SubTopicID == _itemsSubTopic.first.SubTopicID) {
          item.IsTopic = true;
          subTopic = item;
        }
      }
    });
    if(subTopic!=null) {
      _formData = new FormData.from({
        "UserID": widget.itemsDataLogin.UserID,
        "SubTopicID": subTopic.SubTopicID,
        "SubTopicReach": subTopic.SubTopicName,
      });

      await MainFuture().apiRequestSubCurrentStudyupdAll(_formData).then((
          onValue) {
        print(onValue.Response.SubTopicReach);
      });
    }

    setState(() {});
    return true;
  }


  void _showAlertTopicCompleteDialog(mContext,title,content) {
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
      context: mContext,
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
            Navigator.pop(context,"NextTopic");
          },
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
    TextStyle textInputStyleNo = TextStyle(fontSize: FontStyles().FontSizeData,
        color: Colors.grey[500],
        fontFamily: FontStyles().FontFamily);

    return new WillPopScope(
      onWillPop: () {
        //
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.Title, style: textTitleStyl,),
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
                        child: new Text('ระดับข้อสอบ : ' +
                            widget.itemsDataQuestion.first.LevelName.toString(),
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
}
