
class ItemsDataSubTopicResponse {
  final List<ItemsDataSubTopic> Response;

  ItemsDataSubTopicResponse({
    this.Response,
  });

  factory ItemsDataSubTopicResponse.fromJson(Map<String, dynamic> json) {
    return ItemsDataSubTopicResponse(
      Response: List<ItemsDataSubTopic>.from(json['Response'].map((m) => ItemsDataSubTopic.fromJson(m))),
    );
  }
}
class ItemsDataSubTopic {
  final int SubTopicID;
  final String SubTopicName;
  final String IsActive;
  //bool IsUnlock;
  bool IsTopic;

  ItemsDataSubTopic({
    this.SubTopicID,
    this.SubTopicName,
    this.IsActive,
    //this.IsUnlock,
    this.IsTopic,
  });

  factory ItemsDataSubTopic.fromJson(Map<String, dynamic> json) {
    return ItemsDataSubTopic(
        SubTopicID: int.parse(json['SubTopicID']),
        SubTopicName: json['SubTopicName'],
        IsActive: json['IsActive'],
        //IsUnlock: false,
        IsTopic: false
    );
  }
}
