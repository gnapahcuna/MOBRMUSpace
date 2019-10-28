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
import 'package:rmu_space/Model/Data/SubTopic/current_sub_topic_study_model.dart';
import 'package:rmu_space/Model/Data/SubTopic/sub_topic_model.dart';
import 'package:rmu_space/Model/Data/Topic/current_study_model.dart';
import 'package:rmu_space/Model/Data/Topic/list_topic_model.dart';
import 'package:rmu_space/Model/Data/Topic/topic_model.dart';
import 'package:rmu_space/Model/Data/Topic/video_default_model.dart';
import 'package:rmu_space/Model/Data/login_model.dart';
import 'package:rmu_space/Model/Data/video_model.dart';
import 'package:rmu_space/Model/Future/main_future.dart';
import 'package:rmu_space/Model/UserPass/user_pass_sub_topic_model.dart';
import 'package:rmu_space/Model/background.dart';
import 'package:rmu_space/View/question.dart';
import 'package:rmu_space/View/video.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import 'home.dart';

class TopicScreen extends StatefulWidget {
  List<ItemsListTopic> itemsDataTopic;
  ItemsDataLoginResponse itemsDataLogin;
  String Title;
  bool IsNext;
  bool IsFirst;
  TopicScreen({
    Key key,
    @required this.itemsDataTopic,
    @required this.itemsDataLogin,
    @required this.Title,
    @required this.IsNext,
    @required this.IsFirst,
  }) : super(key: key);
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<TopicScreen> {

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
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


    return ListView.builder(
      itemCount: widget.itemsDataTopic.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: (){
            widget.itemsDataTopic[index].IsUnlock
                ?_getQuestion(widget.itemsDataTopic[index])
                :null;
          },
          child: Padding(
            padding: EdgeInsets.only(top: 0.0, bottom: 0.0),
            child: Container(
              padding: EdgeInsets.all(32.0),
              decoration: BoxDecoration(
                  /*color: widget.itemsDataTopic[index].IsUnlock
                      ?Colors.white
                      :Colors.grey[200],*/
                  shape: BoxShape.rectangle,
                  border: widget.itemsDataTopic[index].IsTopic
                      ?(index == 0 ? Border(
                    //top: BorderSide(color: Colors.grey[400], width: 1.0),
                    bottom: BorderSide(color: Colors.grey[400], width: 0.5),
                    left: BorderSide(color: Color(0xff3d63d2), width: 10.0),
                  ) : Border(
                    bottom: BorderSide(color: Colors.grey[400], width: 0.5),
                    left: BorderSide(color: Color(0xff3d63d2), width: 10.0),
                  ))
                      :index == 0 ? Border(
                    //top: BorderSide(color: Colors.grey[400], width: 1.0),
                    bottom: BorderSide(color: Colors.grey[400], width: 0.5),
                  ) : Border(
                    bottom: BorderSide(color: Colors.grey[400], width: 0.5),
                  )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      widget.itemsDataTopic[index].TopicName.toString(),
                      style: textInputStyleTitle,),
                  ),
                  widget.itemsDataTopic[index].IsUnlock
                      ?Icon(Icons.lock_open,color: Color(0xff18aa75),size: 32,)
                      :Icon(Icons.lock,color: Colors.red,size: 32,)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  ItemsDataSubTopic dataSubTopic;
  List<ItemsDataVideo> itemsDataVideo = [];
  Future<bool> onLoadActionVideo(ItemsListTopic itemsDataTopic) async {
    dataSubTopic =null;
    itemsDataVideo=[];

    if(IsCheckFullData) {
      //get level user
      //SharedPreferences prefs = await SharedPreferences.getInstance();
      //double _CF = (prefs.getDouble('CF') ?? 0);
      double _CF = double.parse(widget.itemsDataLogin.UserCF);
      print("UserCF : " + _CF.toString());
      int levelID = 0;
      if (_CF >= 0.34 && _CF <= 1) {
        //เก่ง
        levelID = 3;
      } else if (_CF >= -0.34 && _CF <= 0.34) {
        //กลาง
        levelID = 2;
      } else if (_CF >= -1 && _CF <= -0.33) {
        //อ่อน
        levelID = 1;
      }

      //get sub topic
      /*ItemsDataSubTopicCurrentStudy itemsDataSubTopicCurrentStudy;
      FormData formData = new FormData.from({
        "UserID": widget.itemsDataLogin.UserID,
      });
      await MainFuture().apiRequestSubCurrentStudygetByCon(formData).then((
          onValue) {
        if (onValue != null) {
          itemsDataSubTopicCurrentStudy = onValue.Response;
        }
      });
      List<ItemsDataSubTopic> itemsDataSubTopic = [];
      formData = FormData.from({"TopicID": itemsDataTopic.TopicID});
      await MainFuture().apiRequestSubTopicgetByCon(formData).then((onValue) {
        itemsDataSubTopic = onValue.Response;
      });
      itemsDataSubTopic.forEach((item) {
        if (itemsDataSubTopicCurrentStudy != null) {
          print(itemsDataSubTopicCurrentStudy.SubTopicID.toString() + " :: " +
              item.SubTopicID.toString());
          if (itemsDataSubTopicCurrentStudy.SubTopicID == item.SubTopicID) {
            item.IsTopic = true;
            dataSubTopic = item;
          }
        } else {
          print("b");
          if (item.SubTopicID == itemsDataSubTopic.first.SubTopicID) {
            item.IsTopic = true;
            dataSubTopic = item;
          }
        }
      });*/
      List<ItemsDataUserPassSubTopic> _itemsSubTopicPass = [];
      FormData formData = new FormData.from({
        "UserID": widget.itemsDataLogin.UserID,
      });
      await MainFuture().apiRequestUserSubTopicPassStudygetByCon(formData).then((
          onValue) {
        _itemsSubTopicPass = onValue.Response;
      });
      List<ItemsDataSubTopic> itemsDataSubTopic = [];
      formData = FormData.from({"TopicID": itemsDataTopic.TopicID});
      await MainFuture().apiRequestSubTopicgetByCon(formData).then((onValue) {
        itemsDataSubTopic = onValue.Response;
      });
      _itemsSubTopicPass.forEach((item){
        for(int i=0;i<itemsDataSubTopic.length;i++){
          if(item.SubTopicID == itemsDataSubTopic[i].SubTopicID){
            itemsDataSubTopic[i].IsTopic = true;
            dataSubTopic = itemsDataSubTopic[i];
            break;
          }
        }
      });

      if(itemsDataSubTopic.length>0) {
        if (dataSubTopic == null) {
          itemsDataSubTopic.first.IsTopic = true;
          dataSubTopic = itemsDataSubTopic.first;
        }

        print("dataSubTopic : " + dataSubTopic.toString());
        if (dataSubTopic != null) {
          formData = new FormData.from({
            "SubTopicID": dataSubTopic.SubTopicID,
            "LevelID": widget.IsFirst && _CF == 0 ? 2 : levelID,
          });
          Map map = {
            "SubTopicID": dataSubTopic.SubTopicID,
            "LevelID": widget.IsFirst && _CF == 0 ? 2 : levelID,
          };
          print(map);
          await MainFuture().apiRequestVideoContentgetByCon(formData).then((
              onValue) {
            print(onValue);
            if (onValue.Success) {
              itemsDataVideo = onValue.Response;
            }
          });
        }
      }
    }

    setState(() {});
    return true;
  }

  void _getQuestion(ItemsListTopic itemsDataTopic) async {
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
    if(itemsDataTopic.TopicType!=0) {
      await onLoadActionCheckDataInSubTopic(itemsDataTopic);
      await onLoadActionVideo(itemsDataTopic);
    }
    Navigator.pop(context);

    if(itemsDataTopic.TopicType!=0&&!IsCheckFullData) {
      new ShowDialog(context, "เตือน", itemsDataTopic.TopicName+" ข้อมูลเนื้อหาไม่ครบตามหัวข้อย่อย", 1);
    }else{
      var result = null;

      if(itemsDataTopic.TopicType==1){
        if(itemsDataVideo.length>0) {
          result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                VideoScreen(
                  itemsDataVideo: itemsDataVideo,
                  itemsDataTopic: itemsDataTopic,
                  itemsDataSubTopic: dataSubTopic,
                  itemsDataLogin: widget.itemsDataLogin,
                  IsNotify: false,
                )),
          );
        }else{
          new ShowDialog(context, "เตือน", itemsDataTopic.TopicName+" ไม่มีข้อมูลแบบทดสอบ", 1);
        }
      }else{
        result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
              VideoScreen(
                itemsDataVideo: itemsDataVideo,
                itemsDataTopic: itemsDataTopic,
                itemsDataSubTopic: dataSubTopic,
                itemsDataLogin: widget.itemsDataLogin,
                IsNotify: false,
              )),
        );
      }
      if(result.toString()!="Back"){
        if(result!=null) {
          List _item = result;
          setState(() {
            if (_item.length > 0) {
              widget.itemsDataTopic = _item.first;
              dataSubTopic = _item.last;
            }
          });
        }
      }
    }
  }

  bool IsCheckFullData = false;
  Future<bool> onLoadActionCheckDataInSubTopic(ItemsListTopic dataTopic) async {
    IsCheckFullData = false;
    List<ItemsDataSubTopic> itemsDataSubTopic = [];
    FormData formData = FormData.from({"TopicID": dataTopic.TopicID});
    await MainFuture().apiRequestSubTopicgetByCon(formData).then((onValue) {
      itemsDataSubTopic = onValue.Response;
    });


    List<ItemsDataVideo> itemsDataVideo = [];
    double _CF = double.parse(widget.itemsDataLogin.UserCF);
    print("UserCF : "+_CF.toString());
    int levelID = 0;
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
    for(int i=0;i<itemsDataSubTopic.length;i++){
      formData = new FormData.from({
        "SubTopicID": itemsDataSubTopic[i].SubTopicID,
        "LevelID": widget.IsFirst && _CF == 0 ? 2 : levelID,
      });
      await MainFuture().apiRequestVideoContentgetByCon(formData).then((onValue) {
        if(onValue.Response.length>0) {
          itemsDataVideo.add(onValue.Response.first);
        }
      });
    }

    print("1 :> "+itemsDataSubTopic.length.toString());
    print("2 :> "+itemsDataVideo.length.toString());

    if(itemsDataSubTopic.length == itemsDataVideo.length){
      IsCheckFullData = true;
    }

    setState(() {});
    return true;
  }

  void _checkUserCF()async{
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
    await onLoadActioncheckUserCF();
    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>
          Home1Screen(
            itemsDataLogin: widget.itemsDataLogin,
          )),
    );
  }

  Future<bool> onLoadActioncheckUserCF() async {
    FormData formData = new FormData.from({
      "UserID":widget.itemsDataLogin.UserID,
    });
    await MainFuture().apiRequestUserLogingetByCon(formData).then((onValue) {
      if(onValue.LoginPass){
        widget.itemsDataLogin = onValue.Response;
      }
    });

    setState(() {});
    return true;
  }


  @override
  Widget build(BuildContext mContext) {
    TextStyle textTitleStyl = TextStyle(
        fontSize: FontStyles().FontSizeTitle,
        color: Colors.white,
        fontWeight: FontWeight.w400,
        fontFamily: FontStyles().FontFamily);
    TextStyle textInputStyle = TextStyle(fontSize: FontStyles().FontSizeData,
        color: Color(0xff242021),
        fontFamily: FontStyles().FontFamily);
    TextStyle textInputStyleNo = TextStyle(fontSize: FontStyles().FontSizeData,
        color: Color(0xff3d63d2),
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
            if(widget.IsNext) {
              _checkUserCF();
            }else{
              Navigator.pop(context);
            }
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
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: new Text('รวมทั้งหมด : ' +
                            widget.itemsDataTopic.length.toString()+" หัวข้อ",
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
        )
      ),
    );
  }
}
