import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '/menu/state.dart';
import 'logic.dart';
import '/menu/view.dart';

class EditorPage extends StatelessWidget {
  final logic = Get.put(EditorLogic());
  final state = Get.find<EditorLogic>().state;

  @override
  Widget build(BuildContext context) {
    logic.initState();
    state.versions.add(Get.arguments.copy());
    return Scaffold(
      appBar: AppBar(
        title: Text('Editor'), centerTitle: true,
        leading: Builder(builder: (context) {
          return IconButton(
            icon: Icon(Icons.done), //自定义图标
            onPressed: () {
              print(state.versionPointer);
              print(state.versions[state.versionPointer].title);
              Get.back(result: state.versions[state.versionPointer].copy());
            },
          );
        }),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.undo), //自定义图标
            onPressed: () {
              logic.undo();
            },
          ),
          IconButton(
            icon: Icon(Icons.redo), //自定义图标
            onPressed: () {
              logic.redo();
            },
          ),
          IconButton(
            icon: Icon(Icons.clear), //自定义图标
            onPressed: () {
              Get.back(result: state.versions[0].copy());
            },
          ),
          IconButton(
            icon: Icon(Icons.delete), //自定义图标
            onPressed: () {
              Get.back(result: logic.init());
            },
          ),
        ],
      ),
      body: GetBuilder<EditorLogic>(
        builder: (_) {
          print(state.versionPointer);
          return NoteEditor();
        },
      ),
    );
  }
}

class NoteEditor extends StatefulWidget {
  const NoteEditor(
      {
    Key? key
  }) : super(key: key);

  @override
  _NoteEditorState createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  final logic = Get.find<EditorLogic>();
  final state = Get.find<EditorLogic>().state;
  final _titleController = TextEditingController();
  final _containController = TextEditingController();
  _NoteEditorState(
      {
    Key? key
  });


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _containController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(state.versionPointer);
    Article article = state.versions[state.versionPointer];
    _titleController.text = article.title;
    _containController.text = article.contain;
    return Container(
        child: ListView(
          children: <Widget>[
            TextFormField(
              controller: _titleController,
              maxLength: 50,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              decoration: InputDecoration(
                labelText: "标题",
                hintText: "请输入笔记的标题",
              ),
              onChanged: (v) {
                article = article.copy();
                article.title = v;
                logic.modifyArticle(article);
              },
            ),
            NoteEditorTagList(
              article.tags,
            ),
            TextFormField(
              controller: _containController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: "正文",
                hintText: "请输入笔记内容",
              ),
              onChanged: (v) {
                article = article.copy();
                article.contain = v;
                logic.modifyArticle(article);
              },
            ),
          ],
      ),
    );
  }
}

class NoteEditorTagList extends StatelessWidget {
  final logic = Get.find<EditorLogic>();
  final state = Get.find<EditorLogic>().state;
  final _tagController = TextEditingController();
  NoteEditorTagList(
      this.tags,{
        Key? key,
      }) : super(key: key);
  final List tags;

  @override
  Widget build(BuildContext context) {
    Article article = state.versions[state.versionPointer];
    return Container(
        child: Row(
          children: <Widget>[
            Row(
              children: List.generate(tags.length, (index) {
                return GestureDetector(
                  child: NoteTag(tags[index], 1.2),
                  onTap: () {
                    print("Tag Deleted");
                    article = article.copy();
                    article.tags.removeAt(index);
                    print(article.tags.length);
                    logic.modifyArticle(article);
                    logic.update();
                  },
                );
              }),
            ),
            GestureDetector(
              child: NoteTag(" + ", 1.2),
              onTap: () {
                showDialog<bool>(context: context, builder: (context) {
                  return AlertDialog(
                    title: Text("添加标签"),
                    content: Container(
                      child: TextField(
                        controller: _tagController,
                        maxLength: 10,
                        decoration: const InputDecoration(
                          labelText: '新建标签',
                          hintText: '输入标签名',
                        ),
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text("确定"),
                        onPressed: () {
                          if (_tagController.text != '') {
                            article = article.copy();
                            article.tags.add(_tagController.text);
                            _tagController.text = '';
                            logic.modifyArticle(article);
                            logic.update();
                            print("Create " + _tagController.text + "successfully");
                          } else {
                            print("Create failed: Null Tag");
                          }
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text(
                          "取消",
                        ),
                        onPressed: () {
                          print("Create Tag Cancelled");
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                });
              },
            ),
          ]
        )
    );
  }
}
