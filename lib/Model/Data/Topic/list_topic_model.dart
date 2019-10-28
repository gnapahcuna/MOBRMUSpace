import 'package:rmu_space/Model/Data/Question/question_cotroller_model.dart';


class ItemsListTopic {
  final int TopicID;
  final String TopicName;
  final String IsActive;
  final int TopicType; //0=media default
  final String Link; //only type 0
  bool IsUnlock;
  bool IsTopic;

  ItemsListTopic({
    this.TopicID,
    this.TopicName,
    this.IsActive,
    this.TopicType,
    this.Link,
    this.IsUnlock,
    this.IsTopic,
  });
}
