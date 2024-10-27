import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro_flutter/model/session.dart';
import 'package:pomodoro_flutter/service/session_service.dart';

class HistoryCubit extends Cubit<List<Session>> {
  HistoryCubit({required this.sessionService}) : super([]) {
    _authStream = FirebaseAuth.instance.userChanges().listen(_onUserChanged);
  }

  final SessionService sessionService;
  late final StreamSubscription<User?> _authStream;
  StreamSubscription<Iterable<Session>>? _sessionsStream;

  @override
  Future<void> close() {
    _authStream.cancel();
    _sessionsStream?.cancel();
    return super.close();
  }

  Future<void> _onUserChanged(User? user) async {
    await _sessionsStream?.cancel();

    if (user == null) return;

    _sessionsStream = sessionService
        .streamSessionsOf(userId: user.uid)
        .listen((data) => emit(data.toList()));
  }
}
