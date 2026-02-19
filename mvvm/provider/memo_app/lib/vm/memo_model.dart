import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memo_app/model/memo.dart';

class MemoModel extends ChangeNotifier {
  //with
  final CollectionReference memos = FirebaseFirestore
      .instance
      .collection("memos");
  List<Memo> memoList = [];

  MemoModel() {
    _listenToMemos();
  } //생성시 실행 ..대신//생성자를 통해서

  void _listenToMemos() {
    memos.snapshots().listen((snapshot) {
      memoList = snapshot.docs
          .map(
            (doc) => Memo.fromMap(
              doc.data() as Map<String, dynamic>,
              doc.id,
            ),
          )
          .toList();
      notifyListeners();
    });
  }

  Future<void> addMemo(String title, String content) async {
    await memos.add({'title': title, 'content': content});
  }

  Future<void> deleteMemo(String id) async {
    await memos.doc(id).delete();
  }
}
