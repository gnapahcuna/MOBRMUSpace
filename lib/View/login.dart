import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'package:rmu_space/Alert/issue_alert.dart';
import 'package:rmu_space/Font/font_style.dart';
import 'package:rmu_space/Model/Data/login_model.dart';
import 'package:rmu_space/Model/Future/main_future.dart';
import 'package:rmu_space/Model/background.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';

class LoginScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}
class _SplashScreenState extends State<LoginScreen> {

  //set Font
  FontStyles _fontStyles = FontStyles();

  final FocusNode myFocusNodeUsername = FocusNode();
  final FocusNode myFocusNodePassword = FocusNode();
  TextEditingController editUsername = new TextEditingController();
  TextEditingController editPassword = new TextEditingController();
  bool _obscureText = true;

  String version_text = "0.0.2+8";

  @override
  void initState() {
    super.initState();

    /*editUsername.text="xxxx";
    editPassword.text="yyyy";*/

  }

  @override
  void dispose() {
    myFocusNodeUsername.dispose();
    myFocusNodePassword.dispose();
    super.dispose();
  }

  void _getUserLogin(String user,String pass) async {
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
    await onLoadActionLogin(user,pass);
    Navigator.pop(context);


    if (itemsDataLoginResponse != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
            /*HomeScreen(
                itemsDataVideo: itemsDataVideo,
            )*/
        Home1Screen(
          itemsDataLogin: itemsDataLoginResponse,
        )),
      );
    } else {
      new ShowDialog(context, "เตือน", "ชื่อผู้ใช้งานหรือรหัสผ่านไม่ถูกต้อง", 1);
    }
  }


  //on show dialog
  ItemsDataLoginResponse itemsDataLoginResponse;
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

    setState(() {});
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    TextStyle textStyleLogin = TextStyle(
        fontSize: FontStyles().FontSizeTitle,
        color: Colors.white,
        fontWeight: FontWeight.w400,
        fontFamily: _fontStyles.FontFamily);
    TextStyle textInputStyle = TextStyle(fontSize: FontStyles().FontSizeData,
        color: Color(0xff242021),
        fontFamily: _fontStyles.FontFamily);
    TextStyle textInputStyleVersion = TextStyle(
        fontSize: FontStyles().FontSizeSubData,
        color: Color(0xff242021),
        fontFamily: _fontStyles.FontFamily);
    EdgeInsets paddingInputBox = EdgeInsets.only(top: 8.0, bottom: 8.0);

    var size = MediaQuery
        .of(context)
        .size;
    double width = (size.width * 85) / 100;

    final _button_login = Container(
      width: width,
      padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(14.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Color(0xFF00000),
            offset: Offset(1.0, 6.0),
            blurRadius: 20.0,
          ),
          BoxShadow(
            color: Color(0xFF00000),
            offset: Offset(1.0, 6.0),
            blurRadius: 20.0,
          ),
        ],
        gradient: new LinearGradient(
            colors: [
              Color(0xff242021),
              Color(0xff242021),
              //Color(0xff2984b9),
            ],
            begin: const FractionalOffset(0.2, 0.2),
            end: const FractionalOffset(1.0, 1.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: MaterialButton(
          highlightColor: Colors.transparent,
          splashColor: Color(0xFF00000),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 10.0, horizontal: 42.0),
            child: Text(
              "เข้าสู่ระบบ",
              style: textStyleLogin,
            ),
          ),
          onPressed: () {
            if(editUsername.text.isEmpty||editPassword.text.isEmpty){
              new ShowDialog(context,"เตือน","กรุณากรอกข้อมูลล็อกอินให้ครับ",0);
            }else{
              _getUserLogin(editUsername.text, editPassword.text);
            }
          } //
      ),
    );

    final _logo = Container(
      height: 160.0,
      width: 160.0,
      decoration: new BoxDecoration(
        image: DecorationImage(
          image: new AssetImage(
              'assets/icons/icon_splash.png'),
          fit: BoxFit.contain,
        ),
        shape: BoxShape.circle,
      ),
    );

    final _buildLine = Container(
      padding: EdgeInsets.only(top: 0.0, bottom: 4.0),
      width: width,
      height: 1.0,
      color: Colors.grey,
    );

    final _inputBox = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: width,
          padding: paddingInputBox,
          child: TextField(
            focusNode: myFocusNodeUsername,
            controller: editUsername,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.words,
            style: textInputStyle,
            decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'ชื่อผู้ใช้งาน',
                labelStyle: textInputStyle
            ),
          ),
        ),
        _buildLine,
        Container(
          width: width,
          padding: paddingInputBox,
          child: TextField(
            focusNode: myFocusNodePassword,
            controller: editPassword,
            obscureText: _obscureText,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.words,
            style: textInputStyle,
            decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'รหัสผ่าน',
                labelStyle: textInputStyle
            ),
          ),
        ),
        _buildLine,
      ],
    );

    return WillPopScope(
      onWillPop: () {
        new ShowDialog(context, "เตือน", "ต้องการปิดแอพฯ RMU-Space", 2);
      }, child: Scaffold(
      body: Stack(
        children: <Widget>[
          BackgroundContent(),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(left: 52.0,right: 52.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                            width: width,
                            child: Center(
                                child: _logo
                            )
                        ),
                        Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(version_text, style: textInputStyleVersion,)
                              ],
                            )
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: (size.height * 7) / 100,
                              bottom: (size.height * 7) / 100),
                          child: _inputBox,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: (size.height * 5) / 100,
                              bottom: (size.height * 5) / 100),
                          child: _button_login,
                        )
                      ],
                    ),
                  )
                )
            ),
          ),
        ],
      ),
    ),
    );
  }
}