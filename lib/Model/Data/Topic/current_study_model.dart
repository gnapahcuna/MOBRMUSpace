import 'package:rmu_space/Model/Data/Question/question_cotroller_model.dart';

class ItemsDataCurrentStudyResponse {
  final ItemsDataCurrentStudy Response;

  ItemsDataCurrentStudyResponse({
    this.Response,
  });

  factory ItemsDataCurrentStudyResponse.fromJson(Map<String, dynamic> json) {
    return json['Response'] != null
        ? ItemsDataCurrentStudyResponse(
        Response: ItemsDataCurrentStudy.fromJson(json['Response'])
    )
        : null;
  }
}
class ItemsDataCurrentStudy {
  final String UserID;
  final String TopicReach;
  final int TopicID;

  ItemsDataCurrentStudy({
    this.UserID,
    this.TopicReach,
    this.TopicID,
  });

  factory ItemsDataCurrentStudy.fromJson(Map<String, dynamic> json) {
    return ItemsDataCurrentStudy(
      UserID: json['UserID'],
      TopicReach: json['TopicReach'],
      TopicID: int.parse(json['TopicID']),
    );
  }
}
