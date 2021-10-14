import 'package:json_annotation/json_annotation.dart';

part 'aoption.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class Aoption {
  Aoption({this.title, this.score, this.id, this.no});
  int? id;
  String? title;
  int? score;
  int? no;

  factory Aoption.fromJson(Map<String, dynamic> json) =>
      _$AoptionFromJson(json);

  Map<String, dynamic> toJson() => _$AoptionToJson(this);
}
