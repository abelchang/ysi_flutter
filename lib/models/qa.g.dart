// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qa.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Qa _$QaFromJson(Map<String, dynamic> json) => Qa(
      name: json['name'] as String?,
      questions: (json['questions'] as List<dynamic>?)
          ?.map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: json['_id'] as String?,
    );

Map<String, dynamic> _$QaToJson(Qa instance) => <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'questions': instance.questions,
    };
