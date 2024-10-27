import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pomodoro_flutter/model/session.dart';

class SessionService {
  SessionService();

  final _crud = SessionCRUD._();

  Future<void> saveSession({required Session session}) =>
      _crud.create(data: session);

  Stream<Iterable<Session>> streamSessionsOf({required String userId}) =>
      _crud.streamQuery(
        query: (collection) => collection.where(
          Filter(SessionJsonKeys.userId, isEqualTo: userId),
        ),
      );
}

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

  /// Tells the server to union the given elements with any array value
  /// that already exists on the server.
  ///
  /// Each specified element that doesn't already exist in the array
  /// will be added to the end. If the field being modified is not already
  /// an array it will be overwritten with an array containing exactly
  /// the specified elements.
  Future<void> arrayUnion({
    required String documentId,
    required String key,
    required List<dynamic> elements,
  }) =>
      _collection
          .doc(documentId)
          .update({key: FieldValue.arrayUnion(elements)});

  /// Tells the server to remove the given elements from any array value
  /// that already exists on the server.
  ///
  /// All instances of each element specified will be removed from the array.
  /// If the field being modified is not already an array it will be
  /// overwritten with an empty array.
  Future<void> arrayRemove({
    required String documentId,
    required String key,
    required List<dynamic> elements,
  }) =>
      _collection
          .doc(documentId)
          .update({key: FieldValue.arrayRemove(elements)});

  Future<int?> count({
    required Query<T?> Function(CollectionReference<T?>) filter,
  }) async =>
      (await filter(_collection).count().get()).count;

  Future<void> create({required T data}) => _collection.add(data);

  Future<void> createOrOverwrite({
    required T data,
    required String documentId,
  }) =>
      _collection.doc(documentId).set(data, SetOptions(merge: false));

  Future<void> createOrThrow({
    required T data,
    required String documentId,
  }) async {
    if (documentId.isEmpty) return;
    try {
      final data = await read(documentId: documentId);
      if (data != null) {
        throw Exception('Firebase document already exists');
      }
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        // raised because the document doesn't exist yet
      } else {
        rethrow;
      }
    }

    return _collection.doc(documentId).set(data);
  }

  Future<void> createOrUpdate({
    required T data,
    required String documentId,
  }) =>
      _collection.doc(documentId).set(data, SetOptions(merge: true));

  Future<void> delete({required String documentId}) =>
      _collection.doc(documentId).delete();

  Future<void> deleteKey({
    required String documentId,
    required String key,
  }) =>
      _collection.doc(documentId).update({key: FieldValue.delete()});

  String generateUid() => _collection.doc().id;

  /// Tells the server to increment the field’s current value
  /// by the given value.
  Future<void> numberIncrement({
    required String documentId,
    required String key,
    num increment = 1,
  }) =>
      _collection
          .doc(documentId)
          .update({key: FieldValue.increment(increment)});

  Future<T?> read({required String documentId}) async {
    if (documentId.isEmpty) return null;

    return _collection.doc(documentId).get().then(
          (snapshot) => snapshot.data(),
        );
  }

  Future<Iterable<T>> readAll() => _collection.get().then(
        (query) => query.docs.map((doc) => doc.data()).whereType<T>(),
      );

  Future<Iterable<T>> readFiltered({
    required Query<T?> Function(CollectionReference<T?>) filter,
  }) =>
      filter(_collection).get().then(
            (query) => query.docs.map((doc) => doc.data()).whereType<T>(),
          );

  Stream<T?> stream({required String documentId}) {
    if (documentId.isEmpty) return Stream.value(null);

    return _collection.doc(documentId).snapshots().map((doc) => doc.data());
  }

  Stream<Iterable<T>> streamAll() => _collection.snapshots().map(
        (query) => query.docs.map((doc) => doc.data()).whereType<T>(),
      );

  Stream<Iterable<T>> streamByIds({required Iterable<String> documentIds}) =>
      streamQuery(
        query: (collection) => collection.where(
          FieldPath.documentId,
          whereIn: documentIds.take(30),
        ),
      );

  Stream<Iterable<T>> streamQuery({
    required Query<T?> Function(CollectionReference<T?>) query,
  }) =>
      query(_collection).snapshots().map(
            (query) => query.docs.map((doc) => doc.data()).whereType<T>(),
          );

  Future<void> update({required String documentId, required T data}) async {
    if (documentId.isEmpty) return;

    await _collection.doc(documentId).update(modelToJson(data, null));
  }

  /// Updates data on the document.
  /// Data will be merged with any existing document data.
  ///
  /// Objects key can be a String or a FieldPath.
  ///
  /// If no document exists yet, the update will fail.
  Future<void> updatePart({
    required String documentId,
    required Map<String, Object?> part,
  }) =>
      _collection.doc(documentId).update(part);
}
