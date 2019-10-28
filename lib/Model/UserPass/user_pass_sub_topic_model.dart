import 'package:rmu_space/Model/Data/Question/question_cotroller_model.dart';

class ItemsDataUserPassSubTopicResponse {
  final List<ItemsDataUserPassSubTopic> Response;

  ItemsDataUserPassSubTopicResponse({
    this.Response,
  });

  factory ItemsDataUserPassSubTopicResponse.fromJson(Map<String, dynamic> json) {
    return ItemsDataUserPassSubTopicResponse(
      Response: List<ItemsDataUserPassSubTopic>.from(json['Response'].map((m) => ItemsDataUserPassSubTopic.fromJson(m))),
    );
  }
}
class ItemsDataUserPassSubTopic {
  final String SubPassID;
  final String UserID;
  final String TopicID;
  final String SubTopicID;
  final String NumberOfRepeated;

  ItemsDataUserPassSubTopic({
    this.SubPassID,
    this.UserID,
    this.TopicID,
    this.SubTopicID,
    this.NumberOfRepeated,
  });

  factory ItemsDataUserPassSubTopic.fromJson(Map<String, dynamic> json) {
    return ItemsDataUserPassSubTopic(
      SubPassID: json['SubPassID'],
      UserID: json['UserID'],
      TopicID: json['TopicID'],
      SubTopicID: json['SubTopicID'],
      NumberOfRepeated: json['NumberOfRepeated'],
    );
  }
}
