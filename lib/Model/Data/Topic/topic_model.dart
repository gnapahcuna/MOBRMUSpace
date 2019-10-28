import 'package:rmu_space/Model/Data/Question/question_cotroller_model.dart';

class ItemsDataTopicResponse {
  final List<ItemsDataTopic> Response;

  ItemsDataTopicResponse({
    this.Response,
  });

  factory ItemsDataTopicResponse.fromJson(Map<String, dynamic> json) {
    return ItemsDataTopicResponse(
      Response: List<ItemsDataTopic>.from(json['Response'].map((m) => ItemsDataTopic.fromJson(m))),
    );
  }
}
class ItemsDataTopic {
  final int TopicID;
  final String TopicName;
  final String IsActive;
  bool IsUnlock;
  bool IsTopic;

  ItemsDataTopic({
    this.TopicID,
    this.TopicName,
    this.IsActive,
    this.IsUnlock,
    this.IsTopic,
  });

  factory ItemsDataTopic.fromJson(Map<String, dynamic> json) {
    return ItemsDataTopic(
        TopicID: int.parse(json['TopicID']),
        TopicName: json['TopicName'],
        IsActive: json['IsActive'],
        IsUnlock: false,
        IsTopic: false
    );
  }
}
