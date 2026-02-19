import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:memo_app/model/memo.dart';
import 'package:memo_app/vm/memo_model.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final TextEditingController titleController =
      TextEditingController();
  final TextEditingController contentController =
      TextEditingController();

  final memoHandler = Get.find<MemoHandler>();
  @override
  Widget build(BuildContext context) {
    //final memoHandler = context.watch<MemoModel>();
    // final memoList = memoModel.memos;

    return Scaffold(
      appBar: AppBar(title: Text("Memo")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => memoHandler.memoList.isEmpty
                    ? Center(child: Text("메모가 없습니다."))
                    : ListView.builder(
                        itemCount:
                            memoHandler.memoList.length,
                        itemBuilder: (context, index) {
                          Memo memo =
                              memoHandler.memoList[index];
                          return ListTile(
                            title: Text(memo.title),
                            subtitle: Text(memo.content),
                            trailing: IconButton(
                              onPressed: () async {
                                await memoHandler
                                    .deleteMemo(memo.id);
                                _snackBar(
                                  "삭제",
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
                        await memoHandler.addMemo(
                          titleController.text,
                          contentController.text,
                        );
                        titleController.clear();
                        contentController.clear();
                        if (!context.mounted)
                          return; // await 이후에는 context가 여전히 유효한지 확인
                        _snackBar(
                          "입력",
                          "메모가 추가 되었습니다.",
                          Colors.blue,
                        );
                      } else {
                        if (!context.mounted)
                          return; // await 이후에는 context가 여전히 유효한지 확인
                        _snackBar(
                          "오류",
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
  void _snackBar(String label, String str, Color color) {
    Get.snackbar(label, str, backgroundColor: color);
  }
} // class
