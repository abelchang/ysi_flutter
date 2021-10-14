import 'package:json_annotation/json_annotation.dart';

/// This allows the `Company` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'company.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class Company {
  Company({this.name, this.id});
  int? id;
  String? name;

  /// A necessary factory constructor for creating a new Company instance
  /// from a map. Pass the map to the generated `_$CompanyFromJson()` constructor.
  /// The constructor is named after the source class, in this case, Company.
  factory Company.fromJson(Map<String, dynamic> json) =>
      _$CompanyFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$CompanyToJson`.
  Map<String, dynamic> toJson() => _$CompanyToJson(this);
}
