
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'exercise_choice_model.dart';

class ItemsDataExerciseResponse {
  final bool Success;
  final List<ItemsDataExercise> Response;

  ItemsDataExerciseResponse({
    this.Success,
    this.Response,
  });

  factory ItemsDataExerciseResponse.fromJson(Map<String, dynamic> json) {
    return ItemsDataExerciseResponse(
      Success: json['Success'],
      Response: List<ItemsDataExercise>.from(json['Response'].map((m) => ItemsDataExercise.fromJson(m))),
    );
  }
}
class ItemsDataExercise {
  final String ExerciseID;
  final String Question;
  final String EF;
  final String Answer;
  final String SubTopicID;
  final String SubTopicName;
  List<ItemsDataExerciseChoice> itemsChoice;
  bool IsQuestionCorrect;
  double Rating;

  ItemsDataExercise({
    this.ExerciseID,
    this.Question,
    this.EF,
    this.Answer,
    this.SubTopicID,
    this.SubTopicName,
    this.itemsChoice,
    this.IsQuestionCorrect,
    this.Rating
  });

  factory ItemsDataExercise.fromJson(Map<String, dynamic> json) {
    return ItemsDataExercise(
        ExerciseID: json['ExerciseID'],
        Question: json['Question'],
        EF: json['EF'],
        Answer: json['Answer'],
        SubTopicID: json['SubTopicID'],
        SubTopicName: json['SubTopicName'],
        itemsChoice: [
          new ItemsDataExerciseChoice(
              ChoiceName: json['ChoiceA'],
              IsCorrect: json['Answer'].toString().trim().endsWith("ก")
                  ? true
                  : false,
              IsCheck: false
          ),
          new ItemsDataExerciseChoice(
              ChoiceName: json['ChoiceB'],
              IsCorrect: json['Answer'].toString().trim().endsWith("ข")
                  ? true
                  : false,
              IsCheck: false
          ),
          new ItemsDataExerciseChoice(
              ChoiceName: json['ChoiceC'],
              IsCorrect: json['Answer'].toString().trim().endsWith("ค")
                  ? true
                  : false,
              IsCheck: false
          ),
          new ItemsDataExerciseChoice(
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
