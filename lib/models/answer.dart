import 'package:json_annotation/json_annotation.dart';

/// This allows the `Answer` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'answer.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable(explicitToJson: true)
class Answer {
  int? id;
  int? score;
  int? qnumber;
  Answer({this.score, this.qnumber, this.id});

  /// A necessary factory constructor for creating a new Answer instance
  /// from a map. Pass the map to the generated `_$AnswerFromJson()` constructor.
  /// The constructor is named after the source class, in this case, Answer.
  factory Answer.fromJson(Map<String, dynamic> json) => _$AnswerFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$AnswerToJson`.
  Map<String, dynamic> toJson() => _$AnswerToJson(this);
}
