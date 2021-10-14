// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
      no: json['no'] as int?,
      title: json['title'] as String?,
      aoptions: (json['aoptions'] as List<dynamic>?)
          ?.map((e) => Aoption.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: json['id'] as int?,
    );

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'no': instance.no,
      'aoptions': instance.aoptions,
    };
