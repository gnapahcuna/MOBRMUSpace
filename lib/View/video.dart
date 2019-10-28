import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:chewie/chewie.dart';
import 'package:rmu_space/Alert/issue_alert.dart';
import 'package:rmu_space/Config/config_server.dart';
import 'package:rmu_space/Font/font_style.dart';
import 'package:rmu_space/Model/Data/Exercise/exercise_model.dart';
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
import 'package:rmu_space/Model/background.dart';
import 'package:rmu_space/View/question.dart';
import 'package:rmu_space/View/topic_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import 'exercise.dart';

class VideoScreen extends StatefulWidget {
  List<ItemsDataVideo> itemsDataVideo;
  ItemsListTopic itemsDataTopic;
  ItemsDataSubTopic itemsDataSubTopic;
  ItemsDataLoginResponse itemsDataLogin;
  bool IsNotify;
  VideoScreen({
    Key key,
    @required this.itemsDataVideo,
    @required this.itemsDataTopic,
    @required this.itemsDataSubTopic,
    @required this.itemsDataLogin,
    @required this.IsNotify,
  }) : super(key: key);
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<VideoScreen> {
  int _playingIndex = -1;
  bool _disposed = false;
  var _isPlaying = false;
  var _isEndPlaying = false;

  @override
  void initState() {
    print("INITSTARTE");
    _onPlay();
    _getRound();
    super.initState();
  }


  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  void _onPlay() {
    if (widget.itemsDataTopic.TopicType != 0) {
      videoPlayerController = VideoPlayerController.network(
          new Server().IPAddressVideoContent + widget.itemsDataVideo.first.URL);
    } else {
      videoPlayerController = VideoPlayerController.network(
          new Server().IPAddressVideoDefaultContent +
              widget.itemsDataTopic.Link);
    }

    videoPlayerController.addListener(_controllerListener);
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 3 / 2,
      autoPlay: false,
      looping: false,
      // Prepare the video to be played and display the first frame
      autoInitialize: true,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );

    playerWidget = Chewie(
      controller: chewieController,
    );
  }

  //test video player
  VideoPlayerController videoPlayerController;
  ChewieController chewieController;
  Chewie playerWidget;


// tracking status
  Future<void> _controllerListener() async {
    if (videoPlayerController == null || _disposed) {
      return;
    }
    if (!videoPlayerController.value.initialized) {
      return;
    }
    final position = await videoPlayerController.position;
    final duration = videoPlayerController.value.duration;
    final isPlaying = position.inMilliseconds < duration.inMilliseconds;
    final isEndPlaying = position.inMilliseconds > 0 &&
        position.inSeconds == duration.inSeconds;

    if (_isPlaying != isPlaying || _isEndPlaying != isEndPlaying) {
      _isPlaying = isPlaying;
      _isEndPlaying = isEndPlaying;
      print(
          "$_playingIndex -----> isPlaying=$isPlaying / isCompletePlaying=$isEndPlaying");
      if (isEndPlaying) {
        IsReBackNextSubTopic = false;
        //_startPlay();
      }
    }
    setState(() {});
    if (!mounted) return;
  }

  Widget _buildBottom() {
    TextStyle textBottomStyle = TextStyle(
        fontSize: FontStyles().FontSizeTitle,
        color: Color(0xff242021),
        fontWeight: FontWeight.w400,
        fontFamily: FontStyles().FontFamily);

    if (widget.IsNotify) {
      _isEndPlaying = true;
    }

    var size = MediaQuery
        .of(context)
        .size;
    return !IsReBackNextSubTopic&&_isEndPlaying ? Container(
      width: size.width,
      height: 65,
      color: Color(0xffffcb13),
      child: MaterialButton(
        onPressed: () {
          if (widget.itemsDataTopic.TopicType == 0) {
            _nextTopice();
          } else {
            _getQuestion();
          }
        },
        child: Center(
          child: Text(widget.itemsDataTopic.TopicType == 0
              ? 'เรียนรู้หัวข้อถัดไป'
              : 'ทำแบบฝึกหัด', style: textBottomStyle,),
        ),
      ),
    ) : null;
  }

  void _nextTopice() async {
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
    await onLoadActionNext();
    await onLoadActionTopic();
    Navigator.pop(context);
    List _listResp = [itemsListTopic,dataSubTopic];
    Navigator.pop(context, _listResp);
  }

  void _getQuestion() async {
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
    await onLoadAction();
    Navigator.pop(context);

    if(IsPassTopic){
      new ShowDialog(context, "เตือน", "คุณทำแบบฝึกหัดและข้อสอบของหัวข้อนี้แล้ว", 0);
    }else {
      if (itemsDataExercise.length > 0) {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
              ExerciseScreen(
                itemsDataExercise: itemsDataExercise,
                Title: widget.itemsDataVideo.first.SubTopicName,
                itemsDataTopic: widget.itemsDataTopic,
                itemsDataSubTopic: widget.itemsDataSubTopic,
                itemsDataLogin: widget.itemsDataLogin,
                IsNotify: widget.IsNotify,
              )),
        );
        if (result.toString().endsWith("Back")) {
          //Navigator.pop(context);
          //_navigateBackToTopic(context);
        } else if (result.toString().endsWith("Next")) {
          IsReBackNextSubTopic = true;
          _navigateBackToTopic(context, 0);
        } else if (result.toString().endsWith("NextTopic")) {
          //print("NextTopic vdo : "+result.toString());
          //Navigator.pop(context,"NextTopic");
          _navigateBackToTopic(context, 1);
        }
      } else {
        new ShowDialog(context, "เตือน",
            widget.itemsDataTopic.TopicName + "ไม่มีข้อมูลแบบทดสอบ", 1);
      }
    }
  }

  _navigateBackToTopic(mContext,int type) async {
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
    await onLoadActionTopic();
    if(type==0) {
      Navigator.pop(context);
    }else if(type==1){
      if (itemsListTopic.length > 0) {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
              TopicScreen(
                itemsDataTopic: itemsListTopic,
                itemsDataLogin: widget.itemsDataLogin,
                Title: "หัวข้อบทเรียน",
                IsNext: true,
                IsFirst: false,
              )),
        );
      } else {
        new ShowDialog(context, "เตือน", "การเชื่อมต่อมีปัญหา", 1);
      }
    }
  }

  ItemsDataSubTopic dataSubTopic;
  ItemsDataCurrentStudy itemsDataCurrentStudy;
  List<ItemsListTopic> itemsListTopic = [];
  bool IsReBackNextSubTopic = false;

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
        if (item.TopicID <= itemsDataCurrentStudy.TopicID) {
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


    //get sub topic
    ItemsDataSubTopicCurrentStudy itemsDataSubTopicCurrentStudy;
    formData = new FormData.from({
      "UserID": widget.itemsDataLogin.UserID,
    });
    await MainFuture().apiRequestSubCurrentStudygetByCon(formData).then((onValue) {
      if (onValue != null) {
        itemsDataSubTopicCurrentStudy = onValue.Response;
      }
    });
    List<ItemsDataSubTopic> itemsDataSubTopic = [];
    formData = FormData.from({"TopicID": widget.itemsDataTopic.TopicID});
    await MainFuture().apiRequestSubTopicgetByCon(formData).then((onValue) {
      itemsDataSubTopic = onValue.Response;
    });
    itemsDataSubTopic.forEach((item) {
      if (itemsDataSubTopicCurrentStudy != null) {
        print("B : "+itemsDataSubTopicCurrentStudy.SubTopicID.toString()+" :: "+item.SubTopicID.toString());
        if (itemsDataSubTopicCurrentStudy.SubTopicID == item.SubTopicID) {
          item.IsTopic = true;
          dataSubTopic = item;
          widget.itemsDataSubTopic = item;
        }
      } else {
        print("b");
        if(itemsDataSubTopic.length>0) {
          if (item.SubTopicID == itemsDataSubTopic.first.SubTopicID) {
            item.IsTopic = true;
            dataSubTopic = item;
            widget.itemsDataSubTopic = item;
          }
        }
      }
    });

    if(widget.itemsDataTopic.TopicType!=0){
      formData = new FormData.from({
        "UserID":widget.itemsDataLogin.UserID,
      });
      await MainFuture().apiRequestUserLogingetByCon(formData).then((onValue) {
        if(onValue.LoginPass){
          widget.itemsDataLogin = onValue.Response;
        }
      });
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
      formData = new FormData.from({
        "SubTopicID":widget.itemsDataSubTopic.SubTopicID,
        "LevelID":_CF==0?2:levelID,
      });
      await MainFuture().apiRequestVideoContentgetByCon(formData).then((onValue) {
        print(onValue.Response.length);
        if(onValue.Success){
          widget.itemsDataVideo = onValue.Response;
        }
      });

      if(widget.itemsDataVideo.length>0){
        _onPlay();
        _getRound();
      }
    }

    setState(() {});
    return true;
  }


  //on show dialog
  List<ItemsDataExercise> itemsDataExercise = [];
  bool IsPassTopic = false;
  Future<bool> onLoadAction() async {
    IsPassTopic = false;
    FormData formData = new FormData.from({
      "UserID":widget.itemsDataLogin.UserID,
      "TopicID":widget.itemsDataTopic.TopicID,
    });
    await MainFuture().apiRequestUserPassStudygetByCon(formData).then((onValue) {
      IsPassTopic = onValue.Response.TopicPass;
    });

    if(!IsPassTopic) {
      /*formData = new FormData.from({
        "UserID": widget.itemsDataLogin.UserID,
        "SubTopicID": widget.itemsDataSubTopic.SubTopicID,
        "SubTopicReach": widget.itemsDataSubTopic.SubTopicName,
      });
      await MainFuture().apiRequestSubCurrentStudyupdAll(formData).then((
          onValue) {
        print(onValue.Response.SubTopicReach);
      });*/

      double _CF = double.parse(widget.itemsDataLogin.UserCF);
      formData = new FormData.from({
        "SubTopicID": widget.itemsDataSubTopic.SubTopicID,
        "IsFirst": widget.IsNotify ? 0 : 1
      });
      print(formData.toString());

      await MainFuture().apiRequestExercisegetByCon(formData).then((onValue) {
        print(onValue);
        if (onValue.Success) {
          itemsDataExercise = onValue.Response;
        }
      });

      itemsDataExercise.forEach((item) {
        var randomChoice = (item.itemsChoice..shuffle());
        item.itemsChoice = randomChoice;
      });
    }

    setState(() {});
    return true;
  }

  int _round = 0;

  _getRound() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (widget.IsNotify) {
      _round = (prefs.getInt('Round') ?? 0);
    } else {
      _round = 0;
    }
  }


  //Next Topic
  Future<bool> onLoadActionNext() async {
    FormData _formData = new FormData.from({
      "UserID": widget.itemsDataLogin.UserID,
      "TopicID": '0',
      "TopicReach": 'null',
    });

    await MainFuture().apiRequestCurrentStudyupdAll(_formData).then((onValue) {
      print(onValue.Response.TopicReach);
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
    TextStyle textQuestionStyle = TextStyle(
        fontSize: 16.0,
        color: Color(0xff3d63d2),
        fontFamily: FontStyles().FontFamily,
        fontWeight: FontWeight.w400);


    return new WillPopScope(
      onWillPop: () {
        //
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            widget.itemsDataTopic.TopicType == 0
                ? widget.itemsDataTopic.TopicName
                : ("บทเรียน" + widget.itemsDataTopic.TopicName),
            style: textTitleStyl,),
          centerTitle: true,
          leading: !widget.IsNotify
              ? IconButton(
              icon: Icon(Icons.arrow_back,), onPressed: () {
            Navigator.pop(context,"Back");
          })
              : null,
          actions: <Widget>[
            //
          ],
        ),
        body: /*Center(
          child: playerWidget
        ),*/
        Stack(
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
                        //bottom: BorderSide(color: Colors.grey[400], width: 1.0),
                      )
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      widget.itemsDataTopic.TopicType != 0 ?
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: new Text("หัวข้อย่อย : " +
                              widget.itemsDataSubTopic.SubTopicName.toString(),
                            style: textQuestionStyle,),
                        ),
                      )
                          : Container(),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: new Text(_round == 0 ? '' : 'ทวนซ้ำรอบที่ : I(' +
                            _round.toString() + ")",
                          style: textInputStyleNo,),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: playerWidget,
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
