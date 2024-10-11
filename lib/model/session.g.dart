// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SessionImpl _$$SessionImplFromJson(Map<String, dynamic> json) =>
    _$SessionImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
      endedAt: DateTime.parse(json['endedAt'] as String),
      workMinutes: (json['workMinutes'] as num).toInt(),
      restMinutes: (json['restMinutes'] as num).toInt(),
    );

abstract final class _$$SessionImplJsonKeys {
  static const String id = 'id';
  static const String userId = 'userId';
  static const String startedAt = 'startedAt';
  static const String endedAt = 'endedAt';
  static const String workMinutes = 'workMinutes';
  static const String restMinutes = 'restMinutes';
}

Map<String, dynamic> _$$SessionImplToJson(_$SessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'startedAt': instance.startedAt.toIso8601String(),
      'endedAt': instance.endedAt.toIso8601String(),
      'workMinutes': instance.workMinutes,
      'restMinutes': instance.restMinutes,
    };
