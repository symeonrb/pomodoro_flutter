import 'package:freezed_annotation/freezed_annotation.dart';

part 'session.freezed.dart';
part 'session.g.dart';

@freezed
class Session with _$Session {
  factory Session({
    required String id,
    required String userId,
    required DateTime startedAt,
    required DateTime endedAt,
    required int workMinutes,
    required int restMinutes,
  }) = _Session;

  /// Required for the override getter
  const Session._();

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);
}

typedef SessionJsonKeys = _$$SessionImplJsonKeys;
