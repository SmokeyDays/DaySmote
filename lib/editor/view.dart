import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '/menu/state.dart';
import 'logic.dart';

class EditorPage extends StatelessWidget {
  final logic = Get.put(EditorLogic());
  final state = Get.find<EditorLogic>().state;


  @override
  Widget build(BuildContext context) {
    logic.initState();
    state.versions.add(Article(Get.arguments.title, Get.arguments.tags, Get.arguments.contain));
    return Scaffold(
      appBar: AppBar(
        title: Text('Editor'), centerTitle: true,
        leading: Builder(builder: (context) {
          return IconButton(
            icon: Icon(Icons.keyboard_return), //自定义图标
            onPressed: () {
              // 打开抽屉菜单
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
            icon: Icon(Icons.done), //自定义图标
            onPressed: () {
              Get.back(result: state.versions[state.versionPointer]);
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
          return NoteEditor(state.versions[state.versionPointer]);
        },
      ),
    );
  }
}

class NoteEditor extends StatelessWidget {
  final logic = Get.find<EditorLogic>();
  final state = Get.find<EditorLogic>().state;
  final _controller = TextEditingController();
  NoteEditor(
      this.article, {
    Key? key
  }): super(key: key);
  Article article;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          children: <Widget>[
            TextFormField(
              initialValue: article.title,
              maxLength: 50,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              decoration: InputDecoration(
                labelText: "标题",
                hintText: "请输入笔记的标题",
              ),
              onChanged: (v) {
                article.title = v;
                logic.modifyArticle(article);
              },
            ),
            TextFormField(
              initialValue: article.contain,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: "正文",
                hintText: "请输入笔记内容",
              ),
              onChanged: (v) {
                article.contain = v;
                logic.modifyArticle(article);
              },
            ),
          ],
      ),
    );
  }
}

class NoteCard extends StatelessWidget {
  const NoteCard(
      this.title,
      this.tags,
      this.contain,{
        Key? key,

      }) : super(key: key);
  final String title;
  final List<String> tags;
  final String contain;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0), //3像素圆角
          boxShadow: [ //阴影
            BoxShadow(
                color:Colors.black54,
                offset: Offset(2.0,2.0),
                blurRadius: 4.0
            )
          ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textScaleFactor: 1.8,
          ),
          NoteCardTagList(tags),
          Text(
            contain,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textScaleFactor: 1.1,
          )
        ],
      ),
    );
  }
}

class NoteCardTagList extends StatelessWidget {
  const NoteCardTagList(
      this.tags,{
        Key? key,

      }) : super(key: key);
  final List tags;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
          children: List.generate(tags.length, (index) {
            return Opacity(
              opacity: 0.75,
              child: Container(
                margin: EdgeInsets.all(2),
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.circular(5.0), //3像素圆角
                    boxShadow: [ //阴影
                      BoxShadow(
                          color:Colors.black54,
                          offset: Offset(1.0,1.0),
                          blurRadius: 1.0
                      )
                    ]
                ),
                child: Text(
                  tags[index],
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textScaleFactor: 0.9,
                ),
              ),
            );
          }),
        )
    );
  }
}
