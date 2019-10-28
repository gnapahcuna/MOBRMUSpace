import 'package:rmu_space/Model/Data/Question/question_cotroller_model.dart';

class ItemsDataUnitResponse {
  final List<ItemsDataUnit> Response;

  ItemsDataUnitResponse({
    this.Response,
  });

  factory ItemsDataUnitResponse.fromJson(Map<String, dynamic> json) {
    return ItemsDataUnitResponse(
      Response: List<ItemsDataUnit>.from(json['Response'].map((m) => ItemsDataUnit.fromJson(m))),
    );
  }
}
class ItemsDataUnit {
  final int UnitID;
  final String UnitName;
  final int UnitValue;
  bool IsCheck;

  ItemsDataUnit({
    this.UnitID,
    this.UnitName,
    this.UnitValue,
    this.IsCheck
  });

  factory ItemsDataUnit.fromJson(Map<String, dynamic> json) {
    return ItemsDataUnit(
        UnitID: int.parse(json['UnitID']),
        UnitName: json['UnitName'],
        UnitValue: int.parse(json['UnitValue']),
        IsCheck: false
    );
  }
}
