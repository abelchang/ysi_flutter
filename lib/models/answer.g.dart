// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Answer _$AnswerFromJson(Map<String, dynamic> json) => Answer(
      score: json['score'] as int?,
      qnumber: json['qnumber'] as int?,
      id: json['id'] as int?,
      linkcodeid: json['linkcode_id'] as int?,
      projectid: json['project_id'] as int?,
    );

Map<String, dynamic> _$AnswerToJson(Answer instance) => <String, dynamic>{
      'id': instance.id,
      'score': instance.score,
      'qnumber': instance.qnumber,
      'linkcode_id': instance.linkcodeid,
      'project_id': instance.projectid,
    };
