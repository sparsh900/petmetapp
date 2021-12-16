import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  Future<void> setData({@required String path, Map<String, dynamic> data}) async {
    final reference = Firestore.instance.document(path);
    print('$path : $data');
    await reference.setData(data);
  }

  Future<DocumentSnapshot> getData({@required String path, String documentId}) async {
    final document = Firestore.instance.collection(path).document(documentId);
    final snapshot = document.get();
    return snapshot;
  }

  Future<void> operationsOnAParticularField({@required String path, @required Map<String, dynamic> fieldObject}) async {
    await Firestore.instance.document(path).updateData(fieldObject).whenComplete(() {
      print('Field Deleted/Added/Updated');
    });
  }

  Future<void> deleteData({@required String path}) async {
    final reference = Firestore.instance.document(path);
    await reference.delete();
  }

  Future<void> deleteCollection({@required String path}) async {
    Firestore.instance.collection(path).getDocuments().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.documents) {
        doc.reference.delete();
      }
    });
  }

  Future<void> updateData({@required String path, Map<String, dynamic> data}) async {
    final reference = Firestore.instance.document(path);
    print('$path : $data');
    await reference.updateData(data);
  }

  Stream<List<T>> collectionStream<T>({@required String path, @required T builder(Map<String, dynamic> data, String documentId)}) {
    print(path);
    final reference = Firestore.instance.collection(path);
    final snapshots = reference.snapshots(includeMetadataChanges: true);
    snapshots.first.then((value) => print("isFromCache :: " + value.metadata.isFromCache.toString()));

    return snapshots.map((snapshot) => snapshot.documents.map((snapshot) => builder(snapshot.data, snapshot.documentID)).toList());
  }

  Future<List<T>> collectionList<T>({@required String path, @required T builder(Map<String, dynamic> data, String documentId)}) async {
    final reference = Firestore.instance.collection(path);
    final snapshots = await reference.getDocuments();
    // snapshots.first.then((value) => print("isFromCache :: "+ value.metadata.isFromCache.toString()));
    return snapshots.documents.map((snapshot) => builder(snapshot.data, snapshot.documentID)).toList();
  }

  Stream<List<T>> whereCollectionStream<T>({@required String path, @required String whereField, @required T builder(Map<String, dynamic> data, String documentId)}) {
    final reference = Firestore.instance.collection(path).where(whereField, isEqualTo: true);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.documents.map((snapshot) => builder(snapshot.data, snapshot.documentID)).toList());
  }

  Future<List<T>> whereCollectionList<T>({@required String path, @required String whereField, @required T builder(Map<String, dynamic> data, String documentId)}) async {
    final reference = Firestore.instance.collection(path).where(whereField, isEqualTo: true);
    final snapshots = await reference.getDocuments();
    return snapshots.documents.map((snapshot) => builder(snapshot.data, snapshot.documentID)).toList();
  }
  Future<List<T>> whereCollectionListWithValue<T>({@required String path, @required String whereField,@required String whereFieldValue, @required T builder(Map<String, dynamic> data, String documentId)}) async {
    final reference = Firestore.instance.collection(path).where(whereField, isEqualTo: whereFieldValue);
    final snapshots = await reference.getDocuments();
    return snapshots.documents.map((snapshot) => builder(snapshot.data, snapshot.documentID)).toList();
  }
  Future<List<T>> whereCollectionListArray<T>(
      {@required String path, @required String whereField, @required List statuses, @required T builder(Map<String, dynamic> data, String documentId)}) async {
    final reference = Firestore.instance.collection(path).where(whereField, whereIn: statuses);
    final snapshots = await reference.getDocuments();
    return snapshots.documents.map((snapshot) => builder(snapshot.data, snapshot.documentID)).toList();
  }

  Stream<List<T>> verifiedVetsCollectionStream<T>({@required String path, @required T builder(Map<String, dynamic> data, String documentId)}) {
    final reference = Firestore.instance.collection(path).where('verified', isEqualTo: true);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.documents.map((snapshot) => builder(snapshot.data, snapshot.documentID)).toList());
  }

  Stream<List<T>> orderedCollectionStream<T>(
      {@required String path, @required String field, bool descending = false, @required T builder(Map<String, dynamic> data, String documentId)}) {
    final reference = Firestore.instance.collection(path).orderBy(field, descending: descending);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.documents.map((snapshot) => builder(snapshot.data, snapshot.documentID)).toList());
  }

  Stream<List<T>> limitedCollectionStream<T>({@required String path, @required T builder(Map<String, dynamic> data, String documentId), String order, @required int limitLength}) {
    final reference = Firestore.instance.collection(path).limit(limitLength);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.documents.map((snapshot) => builder(snapshot.data, snapshot.documentID)).toList());
  }
}
