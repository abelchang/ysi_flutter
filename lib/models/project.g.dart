// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Project _$ProjectFromJson(Map<String, dynamic> json) => Project(
      end: json['end'] == null ? null : DateTime.parse(json['end'] as String),
      start: json['start'] == null
          ? null
          : DateTime.parse(json['start'] as String),
      qa: json['qa'] == null
          ? null
          : Qa.fromJson(json['qa'] as Map<String, dynamic>),
      company: json['company'] == null
          ? null
          : Company.fromJson(json['company'] as Map<String, dynamic>),
      answers: (json['answers'] as List<dynamic>?)
          ?.map((e) => Answer.fromJson(e as Map<String, dynamic>))
          .toList(),
      linkcodes: (json['linkcodes'] as List<dynamic>?)
          ?.map((e) => Linkcode.fromJson(e as Map<String, dynamic>))
          .toList(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
      'name': instance.name,
      'start': instance.start?.toIso8601String(),
      'end': instance.end?.toIso8601String(),
      'qa': instance.qa,
      'company': instance.company,
      'answers': instance.answers,
      'linkcodes': instance.linkcodes,
    };
