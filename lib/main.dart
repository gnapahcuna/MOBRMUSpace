import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rmu_space/test.dart';
import 'package:rmu_space/test_video.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Alert/issue_alert.dart';
import 'Font/font_style.dart';
import 'Model/Data/SubTopic/current_sub_topic_study_model.dart';
import 'Model/Data/SubTopic/sub_topic_model.dart';
import 'Model/Data/Topic/current_study_model.dart';
import 'Model/Data/Topic/list_topic_model.dart';
import 'Model/Data/Topic/topic_model.dart';
import 'Model/Data/Topic/video_default_model.dart';
import 'Model/Data/login_model.dart';
import 'Model/Data/video_model.dart';
import 'Model/Future/main_future.dart';
import 'View/video.dart';
import 'View/home.dart';
import 'View/login.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RMU Space',
      theme: ThemeData(
        primaryColor: Color(0xff242021),
      ),
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        //intent เกี่ยวข้อง
        '/Test': (BuildContext context) => new TestPage(),
        '/TestVideo': (BuildContext context) => new TestVideoPage(),
        '/Login': (BuildContext context) => new LoginScreen(),
        '/Video': (BuildContext context) => new VideoScreen(),
        '/Home': (BuildContext context) => new Home1Screen(),
      },
    );
  }
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  startTime() async {
    var _duration = new Duration(seconds: 4);
    return new Timer(_duration, navigationPage);
  }
  //set Font
  FontStyles _fontStyles = FontStyles();

  Animation animation;
  AnimationController animationController;
  int factcounter = 0;
  int colorcounter = 0;



  //notification
  String message;
  String channelId = "1000";
  String channelName = "FLUTTER_NOTIFICATION_CHANNEL";
  String channelDescription = "FLUTTER_NOTIFICATION_CHANNEL_DETAIL";
  bool IsNotify=false;

  void navigationPage() async {
    //intent
    if(!IsNotify) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userID = (prefs.getString('UserID') ?? "");
      if(userID.isEmpty){
        Navigator.of(context).pushReplacementNamed('/Login');
        //Navigator.of(context).pushReplacementNamed('/TestVideo');
      }else{
        String user = prefs.getString('UserName');
        String pass = prefs.getString('Password');
        _getUserCurrentUserLogin(user,pass);
      }
    }else{
    }
  }


  //on current user login
  ItemsDataLoginResponse itemsDataLoginResponse;
  Future<bool> onLoadActionCurrentUserLogin(username, password) async {
    FormData formData = new FormData.from({
      "Username":username,
      "Password":password,
      "LastLogin":DateTime.now().toString()
    });
    await MainFuture().apiRequestUserLogin(formData).then((onValue) {
      print(onValue);
      if(onValue.LoginPass){
        itemsDataLoginResponse = onValue.Response;
      }
    });

    setState(() {});
    return true;
  }

  void _getUserCurrentUserLogin(String user,String pass) async {
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
    await onLoadActionCurrentUserLogin(user,pass);
    Navigator.pop(context);


    if (itemsDataLoginResponse != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
        Home1Screen(
          itemsDataLogin: itemsDataLoginResponse,
        )),
      );
    } else {
      new ShowDialog(context, "เตือน", "ชื่อผู้ใช้งานหรือรหัสผ่านไม่ถูกต้อง", 1);
    }
  }



  _getDataClient() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('UserName');
    String pass = prefs.getString('Password');
    _getUserLogin(user,pass);
  }
  void _getUserLogin(String user,String pass) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () {
                //
              },
              child: Center(
                child: CupertinoActivityIndicator(
                ),
              ),
            );
        });
    await onLoadActionLogin(user, pass);
    Navigator.pop(context);


    if (itemsDataLoginResponse != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
            VideoScreen(
              itemsDataVideo: itemsDataVideo,
              itemsDataTopic: dataTopic,
              itemsDataSubTopic: dataSubTopic,
              itemsDataLogin: itemsDataLoginResponse,
              IsNotify: true,
            )),
      );
    } else {
      new ShowDialog(context, "เตือน", "การเชื่อมต่อมีปัญหา", 1);
    }
  }

  //on show dialog
  //ItemsDataLoginResponse itemsDataLoginResponse;
  ItemsDataSubTopic dataSubTopic;
  List<ItemsDataVideo> itemsDataVideo = [];

  ItemsDataCurrentStudy itemsDataCurrentStudy;
  List<ItemsListTopic> itemsListTopic = [];
  ItemsListTopic dataTopic;

  Future<bool> onLoadActionLogin(username, password) async {
    FormData formData = new FormData.from({
      "Username":username,
      "Password":password,
      "LastLogin":DateTime.now().toString()
    });
    await MainFuture().apiRequestUserLogin(formData).then((onValue) {
      print(onValue);
      if(onValue.LoginPass){
        itemsDataLoginResponse = onValue.Response;
      }
    });

    itemsListTopic=[];
    itemsDataCurrentStudy=null;

    formData = new FormData.from({
      "UserID": itemsDataLoginResponse.UserID,
    });
    await MainFuture().apiRequestCurrentStudygetByCon(formData).then((onValue) {
      if(onValue!=null) {
        itemsDataCurrentStudy = onValue.Response;
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

    itemsListTopic.forEach((topic){
      if(topic.IsTopic){
        dataTopic = topic;
      }
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    double _CF = (prefs.getDouble('CF') ?? 0);
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


    //get sub topic
    ItemsDataSubTopicCurrentStudy itemsDataSubTopicCurrentStudy;
    formData = new FormData.from({
      "UserID": itemsDataLoginResponse.UserID,
    });
    await MainFuture().apiRequestSubCurrentStudygetByCon(formData).then((onValue) {
      if (onValue != null) {
        itemsDataSubTopicCurrentStudy = onValue.Response;
      }
    });
    List<ItemsDataSubTopic> itemsDataSubTopic = [];
    formData = FormData.from({"TopicID": dataTopic.TopicID});
    await MainFuture().apiRequestSubTopicgetByCon(formData).then((onValue) {
      itemsDataSubTopic = onValue.Response;
    });
    itemsDataSubTopic.forEach((item) {
      if (itemsDataSubTopicCurrentStudy != null) {
        print(itemsDataSubTopicCurrentStudy.SubTopicID.toString()+" :: "+item.SubTopicID.toString());
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
    });


    itemsDataVideo=[];
    formData = new FormData.from({
      "SubTopicID":dataSubTopic.SubTopicID,
      "LevelID": levelID,
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
  void initState() {
    super.initState();

    IsNotify = false;

    var initializationSettingsAndroid =
    AndroidInitializationSettings('ic_launcher');

    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) {
          print("onDidReceiveLocalNotification called.");
        });
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    if(!IsNotify) {
      animationController = new AnimationController(
          vsync: this, duration: new Duration(seconds: 2));
      animation = new CurvedAnimation(
          parent: animationController, curve: Curves.fastOutSlowIn);
      animation.addListener(() {
        this.setState(() {});
      });
      animationController.forward();

      startTime();
    }
  }

  Future onSelectNotification(String payload) async {
    setState(() {
      IsNotify = true;
    });
    _getDataClient();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void showfacts() {
    setState(() {
      animationController.reset();
      animationController.forward();
    });
  }
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(0xffffffff),
      body: new Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 60.0),
        child: new Center(
          child: new Opacity(
            opacity: animation.value * 1,
            child: new Transform(
              transform: new Matrix4.translationValues(
                  0.0, animation.value * -50.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 160.0,
                    width: 160.0,
                    decoration: new BoxDecoration(
                      image: DecorationImage(
                        image: new AssetImage(
                            'assets/icons/icon_app.png'),
                        fit: BoxFit.contain,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                  /*new Transform(
                    transform: new Matrix4.translationValues(
                        0.0, animation.value * -50.0, 0.0),
                    child: Padding(
                      padding: EdgeInsets.only(top: 80.0),
                      child: Text(_text.text_splash,
                        style: TextStyle(
                            fontSize: 18.0, color:_textColor.text_splash_color,fontFamily: _fontStyles.FontFamily),
                      ),
                    ),
                  ),*/
                ],
              ),
            ),),
        ),
      ),
    );
  }
}