// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SessionImpl _$$SessionImplFromJson(Map<String, dynamic> json) =>
    _$SessionImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      workMinutes: (json['workMinutes'] as num).toInt(),
      restMinutes: (json['restMinutes'] as num).toInt(),
      startedAt:
          const TimestampConverter().fromJson(json['startedAt'] as Timestamp),
      endedAt:
          const TimestampConverter().fromJson(json['endedAt'] as Timestamp),
    );

abstract final class _$$SessionImplJsonKeys {
  static const String id = 'id';
  static const String userId = 'userId';
  static const String workMinutes = 'workMinutes';
  static const String restMinutes = 'restMinutes';
  static const String startedAt = 'startedAt';
  static const String endedAt = 'endedAt';
}

Map<String, dynamic> _$$SessionImplToJson(_$SessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'workMinutes': instance.workMinutes,
      'restMinutes': instance.restMinutes,
      'startedAt': const TimestampConverter().toJson(instance.startedAt),
      'endedAt': const TimestampConverter().toJson(instance.endedAt),
    };
