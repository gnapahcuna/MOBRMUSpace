import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rmu_space/Font/font_style.dart';

class ShowDialog {
  BuildContext context;
  String Title;
  String Content;
  int Type;
  //type = 0 warning
  //type = 1 error
  //type = 2 error
  //type = 3 logout

  ShowDialog(this.context,this.Title,this.Content,this.Type){
    _showAlertDialog(this.context,this.Title,this.Content,this.Type);
  }

  void _showAlertDialog(context,title,content,type) {
    TextStyle textTitleStyle = TextStyle(fontSize: 18,
        color: Color(0xff242021),
        fontFamily: new FontStyles().FontFamily);
    TextStyle textContentStyle = TextStyle(fontSize: 16,
        color: Color(0xff242021),
        fontFamily: new FontStyles().FontFamily);
    TextStyle textButtonStyle = TextStyle(fontSize: 16,
        color: Colors.white,
        fontFamily: new FontStyles().FontFamily);


    AlertType alertType;
    if(type==0){
      alertType = AlertType.warning;
    }else if(type==1){
      alertType = AlertType.error;
    }else{
      alertType = AlertType.info;
    }
    Alert(
      context: context,
      type: alertType,
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
            if(type==2) {
              exit(0);
            }else if(type==2) {
              Navigator.pop(context);
            }else if(type==3) {
              Navigator.of(context).pushReplacementNamed('/Login');
            }
          },
          //width: 120,
        )
      ],
    ).show();
  }
}