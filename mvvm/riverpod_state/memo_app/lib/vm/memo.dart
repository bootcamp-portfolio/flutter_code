import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memo_app/model/memo.dart'; //legacy 구형
import 'package:riverpod/legacy.dart';

class MemoNotifier extends StateNotifier<List<Memo>> {
  MemoNotifier() : super([]) {
    _listenToMemos();
  }
  //with//여기 매우 중요 노티파이어 notifier
  final CollectionReference memos = FirebaseFirestore
      .instance
      .collection("memos");

  void _listenToMemos() {
    memos.snapshots().listen((snapshot) {
      state = snapshot.docs
          .map(
            (doc) => Memo.fromMap(
              doc.data() as Map<String, dynamic>,
              doc.id,
            ),
          )
          .toList();
    }); //state중요
  }

  Future<void> addMemo(String title, String content) async {
    await memos.add({'title': title, 'content': content});
  }

  Future<void> deleteMemo(String id) async {
    await memos.doc(id).delete();
  }
} //memonotifier

final memonotifierProvider =
    StateNotifierProvider<MemoNotifier, List<Memo>>(
      (ref) => MemoNotifier(),
    );
