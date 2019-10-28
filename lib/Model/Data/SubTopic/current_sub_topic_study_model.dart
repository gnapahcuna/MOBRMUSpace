import 'package:rmu_space/Model/Data/Question/question_cotroller_model.dart';

class ItemsDataCurrentSubTopicStudyResponse {
  final ItemsDataSubTopicCurrentStudy Response;

  ItemsDataCurrentSubTopicStudyResponse({
    this.Response,
  });

  factory ItemsDataCurrentSubTopicStudyResponse.fromJson(Map<String, dynamic> json) {
    return json['Response'] != null
        ? ItemsDataCurrentSubTopicStudyResponse(
        Response: ItemsDataSubTopicCurrentStudy.fromJson(json['Response'])
    )
        : null;
  }
}
class ItemsDataSubTopicCurrentStudy {
  final String UserID;
  final String SubTopicReach;
  final int SubTopicID;

  ItemsDataSubTopicCurrentStudy({
    this.UserID,
    this.SubTopicReach,
    this.SubTopicID,
  });

  factory ItemsDataSubTopicCurrentStudy.fromJson(Map<String, dynamic> json) {
    return ItemsDataSubTopicCurrentStudy(
      UserID: json['UserID'],
      SubTopicReach: json['SubTopicReach'],
      SubTopicID: int.parse(json['SubTopicID']),
    );
  }
}
