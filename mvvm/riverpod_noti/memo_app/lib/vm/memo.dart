import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memo_app/model/memo.dart'; //legacy 구형

//FireStore collection provider//중요
final memosCollectionProvider =
    Provider<CollectionReference>(
      (ref) =>
          FirebaseFirestore.instance.collection('memos'),
    );
//실시간 메모 목록 provider(streamProvider)
final memoListProvider = StreamProvider<List<Memo>>((ref) {
  final col = ref.watch(memosCollectionProvider);

  return col.snapshots().map((snapshot) {
    return snapshot.docs
        .map(
          (doc) => Memo.fromMap(
            doc.data() as Map<String, dynamic>,
            doc.id,
          ),
        )
        .toList();
  });
});

//MemoActionNotifier
class MemoActionNotifier extends Notifier<void> {
  @override
  void build() {}

  CollectionReference get _memos =>
      ref.read(memosCollectionProvider);

  Future<void> addMemo(String title, String content) async {
    await _memos.add({'title': title, 'content': content});
  }

  Future<void> deleteMemo(String id) async {
    await _memos.doc(id).delete();
  }
} //memonotifier

final memoActionProvider =
    NotifierProvider<MemoActionNotifier, void>(
      MemoActionNotifier.new,
    );
