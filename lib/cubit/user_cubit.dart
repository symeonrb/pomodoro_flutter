import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCubit extends Cubit<User?> {
  UserCubit() : super(FirebaseAuth.instance.currentUser) {
    _authStream = FirebaseAuth.instance.userChanges().listen(emit);
  }

  late final StreamSubscription<User?> _authStream;

  @override
  Future<void> close() {
    _authStream.cancel();
    return super.close();
  }
}
