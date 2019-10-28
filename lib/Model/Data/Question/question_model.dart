
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'choice_model.dart';

class ItemsDataQuestionResponse {
  final bool Success;
  final List<ItemsDataQuestion> Response;

  ItemsDataQuestionResponse({
    this.Success,
    this.Response,
  });

  factory ItemsDataQuestionResponse.fromJson(Map<String, dynamic> json) {
    return ItemsDataQuestionResponse(
      Success: json['Success'],
      Response: List<ItemsDataQuestion>.from(json['Response'].map((m) => ItemsDataQuestion.fromJson(m))),
    );
  }
}
class ItemsDataQuestion {
  final String QuestionID;
  final String Question;
  final String CF;
  final String LevelName;
  final String EF;
  final String Answer;
  final String TopicID;
  final String TopicName;
  List<ItemsDataChoice> itemsChoice;
  bool IsQuestionCorrect;
  double Rating;

  ItemsDataQuestion({
    this.QuestionID,
    this.Question,
    this.CF,
    this.LevelName,
    this.EF,
    this.Answer,
    this.TopicID,
    this.TopicName,
    this.itemsChoice,
    this.IsQuestionCorrect,
    this.Rating
  });

  factory ItemsDataQuestion.fromJson(Map<String, dynamic> json) {
    return ItemsDataQuestion(
        QuestionID: json['QuestionID'],
        Question: json['Question'],
        CF: json['CF'],
        LevelName: json['LevelName'],
        EF: json['EF'],
        Answer: json['Answer'],
        TopicID: json['TopicID'],
        TopicName: json['TopicName'],
        itemsChoice: [
          new ItemsDataChoice(
              ChoiceName: json['ChoiceA'],
              IsCorrect: json['Answer'].toString().trim().endsWith("ก")
                  ? true
                  : false,
              IsCheck: false
          ),
          new ItemsDataChoice(
              ChoiceName: json['ChoiceB'],
              IsCorrect: json['Answer'].toString().trim().endsWith("ข")
                  ? true
                  : false,
              IsCheck: false
          ),
          new ItemsDataChoice(
              ChoiceName: json['ChoiceC'],
              IsCorrect: json['Answer'].toString().trim().endsWith("ค")
                  ? true
                  : false,
              IsCheck: false
          ),
          new ItemsDataChoice(
              ChoiceName: json['ChoiceD'],
              IsCorrect: json['Answer'].toString().trim().endsWith("ง")
                  ? true
                  : false,
              IsCheck: false
          ),
        ],
        IsQuestionCorrect: false,
        Rating: 0
    );
  }
}
