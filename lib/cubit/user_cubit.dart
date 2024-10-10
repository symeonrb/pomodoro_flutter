import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

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
