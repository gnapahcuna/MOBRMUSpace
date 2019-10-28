import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:rmu_space/Config/config_server.dart' as serv;
import 'package:http/http.dart' as http;
import 'package:rmu_space/Model/Data/Exercise/exercise_model.dart';
import 'package:rmu_space/Model/Data/SubTopic/current_sub_topic_study_model.dart';
import 'package:rmu_space/Model/Data/SubTopic/sub_topic_model.dart';
import 'package:rmu_space/Model/Data/Topic/current_study_model.dart';
import 'package:rmu_space/Model/Data/Topic/topic_model.dart';
import 'package:rmu_space/Model/Data/Topic/video_default_model.dart';
import 'package:rmu_space/Model/Data/login_model.dart';
import 'package:rmu_space/Model/Data/Question/question_model.dart';
import 'package:rmu_space/Model/Data/video_model.dart';
import 'dart:io';

import 'package:rmu_space/Model/Setting/unit_model.dart';
import 'package:rmu_space/Model/UserPass/user_pass_model.dart';
import 'package:rmu_space/Model/UserPass/user_pass_sub_topic_model.dart';
import 'package:rmu_space/Model/UserPass/user_pass_topic_model.dart';

class MainFuture{
  MainFuture() : super();

  //Login
  Future<ItemsDataLogin> apiRequestUserLogin(FormData formData) async {
    Response response;
    Dio dio = new Dio();

    response = await dio.post(serv.Server().IPAddress+"/UserLogin.php", data: formData);
    if(response.statusCode==200){
      return ItemsDataLogin.fromJson(json.decode(response.data));
    }else{
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
    print(response.data.toString());
  }

  //User get Login
  Future<ItemsDataLogin> apiRequestUserLogingetByCon(FormData formData) async {
    Response response;
    Dio dio = new Dio();

    response = await dio.post(serv.Server().IPAddress+"/UserLogingetByCon.php", data: formData);
    if(response.statusCode==200){
      return ItemsDataLogin.fromJson(json.decode(response.data));
    }else{
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
    print(response.data.toString());
  }


  //get Video Content
  Future<ItemsDataVideoResponse> apiRequestVideoContentgetByCon(FormData formData) async {
    Response response;
    Dio dio = new Dio();

    response = await dio.post(serv.Server().IPAddress+"/VideoContentgetByCon.php", data: formData);
    if(response.statusCode==200){
      return ItemsDataVideoResponse.fromJson(json.decode(response.data));
    }else{
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
    print(response.data.toString());
  }

  //get SubCurrentStudy
  Future<ItemsDataCurrentSubTopicStudyResponse> apiRequestSubCurrentStudygetByCon(FormData formData) async {
    Response response;
    Dio dio = new Dio();

    response = await dio.post(serv.Server().IPAddress+"/SubCurrentStudygetByCon.php", data: formData);
    print("Sub Current Resp : "+response.data.toString());
    if(response.statusCode==200){
      return ItemsDataCurrentSubTopicStudyResponse.fromJson(
          json.decode(response.data));
    }else{
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
    print(response.data.toString());
  }

  //get CurrentStudy
  Future<ItemsDataCurrentStudyResponse> apiRequestCurrentStudygetByCon(FormData formData) async {
    Response response;
    Dio dio = new Dio();

    response = await dio.post(serv.Server().IPAddress+"/CurrentStudygetByCon.php", data: formData);
    print("Current Resp : "+response.data.toString());
    if(response.statusCode==200){
      return ItemsDataCurrentStudyResponse.fromJson(
          json.decode(response.data));
    }else{
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
    print(response.data.toString());
  }

  //Update Current SubTopic
  Future<ItemsDataCurrentSubTopicStudyResponse> apiRequestSubCurrentStudyupdAll(FormData formData) async {
    Response response;
    Dio dio = new Dio();

    response = await dio.post(serv.Server().IPAddress+"/SubCurrentStudyupdAll.php", data: formData);
    if(response.statusCode==200){
      return ItemsDataCurrentSubTopicStudyResponse.fromJson(json.decode(response.data));
    }else{
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
    print(response.data.toString());
  }
  //Update Current Topic
  Future<ItemsDataCurrentStudyResponse> apiRequestCurrentStudyupdAll(FormData formData) async {
    Response response;
    Dio dio = new Dio();

    response = await dio.post(serv.Server().IPAddress+"/CurrentStudyupdAll.php", data: formData);
    if(response.statusCode==200){
      return ItemsDataCurrentStudyResponse.fromJson(json.decode(response.data));
    }else{
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
    print(response.data.toString());
  }

  //get sub topic master
  Future<ItemsDataSubTopicResponse> apiRequestSubTopicgetByCon(FormData formData) async {
    Response response;
    Dio dio = new Dio();
    response = await dio.post(serv.Server().IPAddress+"/SubTopicgetByCon.php", data: formData);
    if(response.statusCode==200){
      return ItemsDataSubTopicResponse.fromJson(json.decode(response.data));
    }else{
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
    print(response.data.toString());
  }

  //get topic master
  Future<ItemsDataTopicResponse> apiRequestTopicgetByCon(FormData formData) async {
    Response response;
    Dio dio = new Dio();
    response = await dio.post(serv.Server().IPAddress+"/TopicgetByCon.php", data: formData);
    if(response.statusCode==200){
      return ItemsDataTopicResponse.fromJson(json.decode(response.data));
    }else{
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
    print(response.data.toString());
  }

  Future<ItemsDataVideoDefaultResponse> apiRequestVideoDefaultgetByCon(FormData formData) async {
    Response response;
    Dio dio = new Dio();
    response = await dio.post(serv.Server().IPAddress+"/VideoDefaultgetByCon.php", data: formData);
    if(response.statusCode==200){
      return ItemsDataVideoDefaultResponse.fromJson(json.decode(response.data));
    }else{
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
    print(response.data.toString());
  }

  //get CurrentStudy
  Future<ItemsDataUnitResponse> apiRequestUnitgetByCon(FormData formData) async {
    Response response;
    Dio dio = new Dio();
    response = await dio.post(serv.Server().IPAddress+"/UnitgetByCon.php", data: formData);
    if(response.statusCode==200){
      return ItemsDataUnitResponse.fromJson(json.decode(response.data));
    }else{
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
    print(response.data.toString());
  }

  //get Question
  Future<ItemsDataQuestionResponse> apiRequestQuestiongetByCon(Map formData) async {
    Response response;
    Dio dio = new Dio();

    response = await dio.post(serv.Server().IPAddress+"/QuestiongetByCon.php", data: formData);
    if(response.statusCode==200){
      return ItemsDataQuestionResponse.fromJson(json.decode(response.data));
    }else{
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
    print(response.data.toString());
  }


  //get Exercise
  Future<ItemsDataExerciseResponse> apiRequestExercisegetByCon(Map formData) async {
    Response response;
    Dio dio = new Dio();

    response = await dio.post(serv.Server().IPAddress+"/ExercisegetByCon.php", data: formData);
    if(response.statusCode==200){
      return ItemsDataExerciseResponse.fromJson(json.decode(response.data));
    }else{
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
    print(response.data.toString());
  }


  //Add Log Exercise
  Future<ItemsDataQuestionResponse> apiRequestUserAnswerExerciseloginsAll(List<Map> jsonMap) async {
    //encode Map to JSON
    var body = json.encode(jsonMap);
    try {
      final response = await http.post(
        serv
            .Server()
            .IPAddress + "/UserAnswerExerciseloginsAll.php",
        headers: {"Content-Type": "application/json"},
        body: body,
      );
      if (response.statusCode == 200) {
        print(response.body);
        //return ItemsArrestResponseMessage.fromJson(json.decode(response.body));
      } else {
        print('Something went wrong. \nResponse Code : ${response.statusCode}');
      }
    } on SocketException catch (_) {
      print('not connected');
    } on NoSuchMethodError catch(_){
      print('sql error : '+_.stackTrace.toString());
    }
  }

  //Add Log Question
  Future<ItemsDataQuestionResponse> apiRequestUserAnswerQuestionloginsAll(List<Map> jsonMap) async {
    //encode Map to JSON
    var body = json.encode(jsonMap);
    try {
      final response = await http.post(
        serv
            .Server()
            .IPAddress + "/UserAnswerQuestionloginsAll.php",
        headers: {"Content-Type": "application/json"},
        body: body,
      );
      if (response.statusCode == 200) {
        print(response.body);
        //return ItemsArrestResponseMessage.fromJson(json.decode(response.body));
      } else {
        print('Something went wrong. \nResponse Code : ${response.statusCode}');
      }
    } on SocketException catch (_) {
      print('not connected');
    } on NoSuchMethodError catch(_){
      print('sql error : '+_.stackTrace.toString());
    }
  }

  //get user sub topic pass study
  Future<ItemsDataUserPassSubTopicResponse> apiRequestUserSubTopicPassStudygetByCon(Map formData) async {
    Response response;
    Dio dio = new Dio();

    response = await dio.post(serv.Server().IPAddress+"/UserSubTopicPassStudygetByCon.php", data: formData);
    if(response.statusCode==200){
      return ItemsDataUserPassSubTopicResponse.fromJson(json.decode(response.data));
    }else{
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
    print(response.data.toString());
  }

  //get user sub topic pass study
  Future<ItemsDataUserPassTopicResponse> apiRequestUserPassStudygetByCon(Map formData) async {
    Response response;
    Dio dio = new Dio();

    response = await dio.post(serv.Server().IPAddress+"/UserPassStudygetByCon.php", data: formData);
    if(response.statusCode==200){
      return ItemsDataUserPassTopicResponse.fromJson(json.decode(response.data));
    }else{
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
    print(response.data.toString());
  }

  //Add user sub topic pass study
  Future<ItemsDataUserPassResponse> apiRequestUserSubTopicPassStudyupdAll(Map formData) async {
    Response response;
    Dio dio = new Dio();

    response = await dio.post(serv.Server().IPAddress+"/UserSubTopicPassStudyupdAll.php", data: formData);
    if(response.statusCode==200){
      return ItemsDataUserPassResponse.fromJson(json.decode(response.data));
    }else{
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
    print(response.data.toString());
  }

  //Add user pass study
  Future<ItemsDataUserPassResponse> apiRequestUserPassStudyupdAll(Map formData) async {
    Response response;
    Dio dio = new Dio();

    response = await dio.post(serv.Server().IPAddress+"/UserPassStudyupdAll.php", data: formData);
    if(response.statusCode==200){
      return ItemsDataUserPassResponse.fromJson(json.decode(response.data));
    }else{
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
    print(response.data.toString());
  }


  //Add user pass study
  Future<ItemsDataLogin> apiRequestUserCFupdAll(Map formData) async {
    Response response;
    Dio dio = new Dio();

    response = await dio.post(serv.Server().IPAddress+"/UserCFupdAll.php", data: formData);
    if(response.statusCode==200){
      return ItemsDataLogin.fromJson(json.decode(response.data));
    }else{
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
    print(response.data.toString());
  }













  //add log by user
  Future<String> apiRequestAddLog(Map formData) async {
    Response response;
    Dio dio = new Dio();

    response = await dio.post(serv.Server().IPAddress+"/AddLog.php", data: formData);
    if(response.statusCode==200){
      //return ItemsDataQuestionResponse.fromJson(json.decode(response.data));
    }else{
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
    print(response.data.toString());
  }
}