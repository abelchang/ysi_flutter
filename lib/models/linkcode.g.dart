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
    );

Map<String, dynamic> _$LinkcodeToJson(Linkcode instance) => <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'count': instance.count,
    };
