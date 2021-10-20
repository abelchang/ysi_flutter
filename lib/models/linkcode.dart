import 'package:json_annotation/json_annotation.dart';

/// This allows the `Linkcode` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'linkcode.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class Linkcode {
  Linkcode(
      {this.code,
      this.count,
      this.name,
      this.id,
      this.url,
      this.done,
      this.projectid});
  int? id;
  String? code;
  String? name;
  int? count;
  String? url;
  int? done;
  @JsonKey(name: 'project_id')
  int? projectid;

  /// A necessary factory constructor for creating a new Linkcode instance
  /// from a map. Pass the map to the generated `_$LinkcodeFromJson()` constructor.
  /// The constructor is named after the source class, in this case, Linkcode.
  factory Linkcode.fromJson(Map<String, dynamic> json) =>
      _$LinkcodeFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$LinkcodeToJson`.
  Map<String, dynamic> toJson() => _$LinkcodeToJson(this);
}
