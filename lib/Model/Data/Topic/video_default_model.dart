import 'package:rmu_space/Model/Data/Question/question_cotroller_model.dart';

class ItemsDataVideoDefaultResponse {
  final List<ItemsDataVideoDefault> Response;

  ItemsDataVideoDefaultResponse({
    this.Response,
  });

  factory ItemsDataVideoDefaultResponse.fromJson(Map<String, dynamic> json) {
    return ItemsDataVideoDefaultResponse(
      Response: List<ItemsDataVideoDefault>.from(json['Response'].map((m) => ItemsDataVideoDefault.fromJson(m))),
    );
  }
}
class ItemsDataVideoDefault {
  final int VideoDefaultID;
  final String VideoDefaultName;
  final String URL;
  final String IsActive;

  ItemsDataVideoDefault({
    this.VideoDefaultID,
    this.VideoDefaultName,
    this.URL,
    this.IsActive,
  });

  factory ItemsDataVideoDefault.fromJson(Map<String, dynamic> json) {
    return ItemsDataVideoDefault(
      VideoDefaultID: int.parse(json['VideoDefaultID']),
      VideoDefaultName: json['VideoDefaultName'],
      URL: json['URL'],
      IsActive: json['IsActive'],
    );
  }
}
