// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'linkcode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Linkcode _$LinkcodeFromJson(Map<String, dynamic> json) => Linkcode(
      code: json['code'] as String?,
      count: json['count'] as int?,
      name: json['name'] as String?,
      id: json['id'] as int?,
      url: json['url'] as String?,
      done: json['done'] as int?,
      projectid: json['project_id'] as int?,
    );

Map<String, dynamic> _$LinkcodeToJson(Linkcode instance) => <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'count': instance.count,
      'url': instance.url,
      'done': instance.done,
      'project_id': instance.projectid,
    };
