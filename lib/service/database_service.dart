import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pomodoro_flutter/model/session.dart';

/// This service is an API between the app Firestore
class DatabaseService {
  DatabaseService();

  final _sessionCrud = SessionCRUD._();

  Future<void> saveSession({required Session session}) =>
      _sessionCrud.create(data: session);

  Stream<Iterable<Session>> streamSessionsOf({required String userId}) =>
      _sessionCrud.streamQuery(
        query: (collection) => collection.where(
          Filter(SessionJsonKeys.userId, isEqualTo: userId),
        ),
      );
}

/// This crud simplifies the Create Read Update Delete operations
/// in the session table.
class SessionCRUD extends CollectionCRUD<Session> {
  SessionCRUD._() : super(collectionName: 'session');

  @override
  Session? jsonToModel(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? _,
  ) {
    try {
      final json = snapshot.data() ?? {};
      json['id'] = snapshot.id;
      return Session.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, Object?> modelToJson(
    Session? data,
    SetOptions? setOptions,
  ) {
    final json = data?.toJson();
    json?.removeWhere((key, value) => key == 'id');
    return json ?? {};
  }
}

/// This crud simplifies the Create Read Update Delete operations in a table.
abstract class CollectionCRUD<T> {
  CollectionCRUD({required this.collectionName}) {
    _collection =
        FirebaseFirestore.instance.collection(collectionName).withConverter<T?>(
              toFirestore: modelToJson,
              fromFirestore: jsonToModel,
            );
  }

  final String collectionName;
  late final CollectionReference<T?> _collection;

  T? jsonToModel(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? _,
  );

  /// Default recommended behavior is to remove null fields,
  /// unless setOptions.merge is set to false
  Map<String, Object?> modelToJson(T? data, SetOptions? setOptions);

  // --

  Future<void> create({required T data}) => _collection.add(data);

  Stream<Iterable<T>> streamQuery({
    required Query<T?> Function(CollectionReference<T?>) query,
  }) =>
      query(_collection).snapshots().map(
            (query) => query.docs.map((doc) => doc.data()).whereType<T>(),
          );
}
