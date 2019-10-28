import 'package:rmu_space/Model/Data/Question/question_cotroller_model.dart';

class ItemsDataUserPassResponse {
  final List<ItemsDataUserPass> Response;

  ItemsDataUserPassResponse({
    this.Response,
  });

  factory ItemsDataUserPassResponse.fromJson(Map<String, dynamic> json) {
    return ItemsDataUserPassResponse(
      //Response: ItemsDataUserPass.fromJson(json['Response'])
      Response: List<ItemsDataUserPass>.from(json['Response'].map((m) => ItemsDataUserPass.fromJson(m))),
    );
  }
}
class ItemsDataUserPass {
  final String UserID;
  final String NumberOfRepeated;
  final int TopicID;

  ItemsDataUserPass({
    this.UserID,
    this.NumberOfRepeated,
    this.TopicID,
  });

  factory ItemsDataUserPass.fromJson(Map<String, dynamic> json) {
    return ItemsDataUserPass(
        UserID: json['UserID'],
        NumberOfRepeated: json['NumberOfRepeated'],
        TopicID: int.parse(json['TopicID']),
    );
  }
}
