import 'package:json_annotation/json_annotation.dart';
import 'package:ysi/models/answer.dart';
import 'package:ysi/models/company.dart';
import 'package:ysi/models/linkcode.dart';
import 'package:ysi/models/qa.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'project.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class Project {
  Project({
    this.end,
    this.start,
    this.qa,
    this.company,
    this.answers,
    this.linkcodes,
    required this.name,
  });
  String name;
  DateTime? start;
  DateTime? end;
  Qa? qa;
  Company? company;
  List<Answer>? answers;
  List<Linkcode>? linkcodes;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
