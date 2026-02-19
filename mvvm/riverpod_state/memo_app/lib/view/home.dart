import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memo_app/model/memo.dart';
import 'package:memo_app/vm/memo.dart';

class Home extends ConsumerWidget {
  //<<<<<<<<<<<<<
  Home({super.key});

  final TextEditingController titleController =
      TextEditingController();
  final TextEditingController contentController =
      TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memoList = ref.watch(memonotifierProvider);
    final MemoNotifier = ref.read(
      memonotifierProvider.notifier,
    );

    return Scaffold(
      appBar: AppBar(title: Text("Memo")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: memoList.isEmpty
                  ? Center(child: Text("메모가 없습니다."))
                  : ListView.builder(
                      itemCount:
                          memoList.length, //memomodel지움
                      itemBuilder: (context, index) {
                        Memo memo = memoList[index];
                        return ListTile(
                          title: Text(memo.title),
                          subtitle: Text(memo.content),
                          trailing: IconButton(
                            onPressed: () async {
                              // await context
                              //     .read<MemoModel>()
                              //     .deleteMemo(memo.id);
                              await MemoNotifier.deleteMemo(
                                memo.id,
                              );
                              if (!context.mounted)
                                return; // await 이후에는 context가 여전히 유효한지 확인
                              _snackBar(
                                context,
                                "${memo.title} 메모가 삭제 되었습니다.",
                                Colors.blue,
                              );
                            },
                            icon: Icon(Icons.delete),
                          ),
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: '제목을 입력 하세요',
                    ),
                  ),
                  TextField(
                    controller: contentController,
                    decoration: InputDecoration(
                      labelText: '내용을 입력 하세요',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (titleController.text.isNotEmpty &&
                          contentController
                              .text
                              .isNotEmpty) {
                        await MemoNotifier.addMemo(
                          titleController.text,
                          contentController.text,
                        ); //
                        titleController.clear();
                        contentController.clear();
                        if (!context.mounted)
                          return; // await 이후에는 context가 여전히 유효한지 확인
                        _snackBar(
                          context,
                          "메모가 추가 되었습니다.",
                          Colors.blue,
                        );
                      } else {
                        if (!context.mounted)
                          return; // await 이후에는 context가 여전히 유효한지 확인
                        _snackBar(
                          context,
                          "제목과 내용을 모두 입력 해주세요",
                          Colors.red,
                        );
                      }
                    },
                    child: Text("메모 추가"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  } // build

  // --- Functions
  void _snackBar(
    BuildContext context,
    String str,
    Color color,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(str),
        duration: Duration(seconds: 1),
        backgroundColor: color,
      ),
    );
  }
} // class
