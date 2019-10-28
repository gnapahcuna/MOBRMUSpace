import 'package:rmu_space/Model/Data/Question/question_cotroller_model.dart';

class ItemsDataUserPassTopicResponse {
  final ItemsDataUserPassTopic Response;

  ItemsDataUserPassTopicResponse({
    this.Response,
  });

  factory ItemsDataUserPassTopicResponse.fromJson(Map<String, dynamic> json) {
    return ItemsDataUserPassTopicResponse(
      //Response: ItemsDataUserPass.fromJson(json['Response'])
      Response: ItemsDataUserPassTopic.fromJson(json['Response']),
    );
  }
}
class ItemsDataUserPassTopic {
  final bool TopicPass;

  ItemsDataUserPassTopic({
    this.TopicPass,
  });

  factory ItemsDataUserPassTopic.fromJson(Map<String, dynamic> json) {
    return ItemsDataUserPassTopic(
      TopicPass: json['TopicPass'],
    );
  }
}
