import 'dart:math';

import 'package:dart_random_choice/dart_random_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:chewie/chewie.dart';
import 'package:rmu_space/Font/font_style.dart';
import 'package:rmu_space/Model/Data/Exercise/exercise_model.dart';
import 'package:rmu_space/Model/Data/Question/question_model.dart';
import 'package:rmu_space/Model/Data/SubTopic/sub_topic_model.dart';
import 'package:rmu_space/Model/Data/Topic/list_topic_model.dart';
import 'package:rmu_space/Model/Data/Topic/topic_model.dart';
import 'package:rmu_space/Model/Data/login_model.dart';
import 'package:rmu_space/Model/Data/video_model.dart';
import 'package:rmu_space/Model/background.dart';
import 'package:rmu_space/View/result.dart';
import 'package:video_player/video_player.dart';

import 'assessment_test.dart';

class ExerciseScreen extends StatefulWidget {
  List<ItemsDataExercise> itemsDataExercise;
  ItemsListTopic itemsDataTopic;
  ItemsDataSubTopic itemsDataSubTopic;
  ItemsDataLoginResponse itemsDataLogin;
  bool IsNotify;
  String Title;
  ExerciseScreen({
    Key key,
    @required this.itemsDataExercise,
    @required this.itemsDataTopic,
    @required this.itemsDataSubTopic,
    @required this.itemsDataLogin,
    @required this.IsNotify,
    @required this.Title,
  }) : super(key: key);
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<ExerciseScreen> {

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
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
                        widget.itemsDataExercise[index].Question.toString(),
                    style: textQuestionStyle,),
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
                          onTap: () {
                            setState(() {
                              widget.itemsDataExercise[index].itemsChoice[j]
                                  .IsCheck =
                              !widget.itemsDataExercise[index].itemsChoice[j]
                                  .IsCheck;

                              for (int i = 0; i <
                                  widget.itemsDataExercise[index].itemsChoice
                                      .length; i++) {
                                if (i != j) {
                                  widget.itemsDataExercise[index].itemsChoice[i]
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
                                          widget.itemsDataExercise[index]
                                              .itemsChoice[j].IsCheck =
                                          !widget.itemsDataExercise[index]
                                              .itemsChoice[j].IsCheck;

                                          for (int i = 0; i <
                                              widget.itemsDataExercise[index]
                                                  .itemsChoice.length; i++) {
                                            if (i != j) {
                                              widget.itemsDataExercise[index]
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
                                          color: widget.itemsDataExercise[index]
                                              .itemsChoice[j].IsCheck
                                              ? Color(0xff3b69f3)
                                              : Colors.white,
                                          border: widget
                                              .itemsDataExercise[index]
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
                                                .itemsDataExercise[index]
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
                              Expanded(
                                child: Padding(
                                  padding: paddingInputBox,
                                  child: Text(
                                    prefix[j] + ". " +
                                        widget.itemsDataExercise[index]
                                            .itemsChoice[j].ChoiceName.toString()
                                            .toString(),
                                    style: textInputStyleTitle,),
                                ),
                              )
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
    widget.itemsDataExercise.forEach((item) {
      item.itemsChoice.forEach((choice){
        if(choice.IsCheck){
          count++;
        }
      });
    });
    if (count == widget.itemsDataExercise.length) {
      IsAnswerComplete = true;
    }

    return IsAnswerComplete ? Container(
      width: size.width,
      height: 65,
      color: Color(0xffffcb13),
      child: MaterialButton(
        onPressed: () {
          _gotoResult();
        },
        child: Center(
          child: Text('เฉลยและประเมิน', style: textBottomStyle,),
        ),
      ),
    ) : null;
  }


  void _gotoResult() async {
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

    final result = await Navigator.push(
      context,
      /*MaterialPageRoute(builder: (context) =>
          ResultScreen(
            itemsDataExercise: widget.itemsDataExercise,
            itemsDataLogin: widget.itemsDataLogin,
            itemsDataTopic: widget.itemsDataTopic,
            IsNotify: widget.IsNotify,
          )),*/
      MaterialPageRoute(builder: (context) =>
          AssessmentTestScreen(
            itemsDataLogin: widget.itemsDataLogin,
            itemsDataExercise: widget.itemsDataExercise,
            itemsDataTopic: widget.itemsDataTopic,
            itemsDataSubTopic: widget.itemsDataSubTopic,
            Title: "ประเมิน",
            IsNotify: widget.IsNotify,
          )),
    );
    if(result.toString().endsWith("Back")){
      Navigator.pop(context,"Back");
    }else if(result.toString().endsWith("Next")){
      Navigator.pop(context,"Next");
    }else if(result.toString().endsWith("NextTopic")){
      print("NextTopic ex : "+result.toString());
      Navigator.pop(context,"NextTopic");
    }

  }

  Future<bool> onLoadAction() async {
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
          title: Text(widget.Title, style: textTitleStyl,),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back,), onPressed: () {
            Navigator.pop(context);
          }),
          actions: <Widget>[
            /*FlatButton(
            onPressed: ()=> exit(0),
            child: Text('ปิดแอพฯ',style: TextStyle(color: Colors.white,fontSize: 18),),
          )*/
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
                            widget.itemsDataExercise.first.LevelName.toString(),
                          style: textInputStyleNo,),
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
