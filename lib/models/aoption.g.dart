// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aoption.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Aoption _$AoptionFromJson(Map<String, dynamic> json) => Aoption(
      title: json['title'] as String?,
      score: json['score'] as int?,
      id: json['id'] as int?,
      no: json['no'] as int?,
    );

Map<String, dynamic> _$AoptionToJson(Aoption instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'score': instance.score,
      'no': instance.no,
    };
