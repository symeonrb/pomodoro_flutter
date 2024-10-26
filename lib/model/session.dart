import 'package:freezed_annotation/freezed_annotation.dart';

part 'session.freezed.dart';
part 'session.g.dart';

@freezed
class Session with _$Session {
  factory Session({
    required String id,
    required String userId,
    // TODO : use TimeStamp
    required DateTime startedAt,
    required DateTime endedAt,
    required int workMinutes,
    required int restMinutes,
  }) = _Session;

  /// Required for the override getter
  const Session._();

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);

  // --

  DateTime get day => startedAt.copyWith(
        hour: 0,
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );

  Duration get timeElapsed => endedAt.difference(startedAt);

  bool get wasWorkingWhenStopped {
    final minutesElapsed = timeElapsed.inMinutes;
    final fullStepMinutes = workMinutes + restMinutes;

    final currentFullStepMinutes = minutesElapsed % fullStepMinutes;

    return currentFullStepMinutes < workMinutes;
  }

  /// Return the number of full steps, completed or started.
  /// Ex : on a 45/15 rythm, and 2h30 in total, this will return 3
  int get fullSteps {
    final minutesElapsed = (timeElapsed.inSeconds / 60).ceil();

    final fullStepMinutes = workMinutes + restMinutes;

    return (minutesElapsed / fullStepMinutes).ceil();
  }

  /// Return the number of working steps, completed or started.
  /// Ex : on a 45/15 rythm, and 2h30 in total, this will return 3
  int get workingSteps => fullSteps;

  /// Return the number of resting steps, completed or started.
  /// Ex : on a 45/15 rythm, and 2h30 in total, this will return 2
  int get restingSteps => wasWorkingWhenStopped ? fullSteps - 1 : fullSteps;
}

typedef SessionJsonKeys = _$$SessionImplJsonKeys;
