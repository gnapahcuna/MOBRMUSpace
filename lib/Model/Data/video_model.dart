class ItemsDataVideoResponse {
  final bool Success;
  final List<ItemsDataVideo> Response;

  ItemsDataVideoResponse({
    this.Success,
    this.Response,
  });

  factory ItemsDataVideoResponse.fromJson(Map<String, dynamic> json) {
    return ItemsDataVideoResponse(
      Success: json['Success'],
      Response: List<ItemsDataVideo>.from(json['Response'].map((m) => ItemsDataVideo.fromJson(m))),
    );
  }
}
class ItemsDataVideo {
  final String VideoID;
  final String VideoName;
  final String URL;
  final String SubTopicID;
  final String SubTopicName;

  ItemsDataVideo({
    this.VideoID,
    this.VideoName,
    this.URL,
    this.SubTopicID,
    this.SubTopicName,
  });

  factory ItemsDataVideo.fromJson(Map<String, dynamic> json) {
    return ItemsDataVideo(
      VideoID: json['VideoID'],
      VideoName: json['VideoName'],
      URL: json['URL'],
      SubTopicID: json['SubTopicID'],
      SubTopicName: json['SubTopicName'],
    );
  }
}
