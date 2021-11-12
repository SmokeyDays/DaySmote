import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'state.dart';
import 'logic.dart';
import '/editor/view.dart';
class MenuPage extends StatelessWidget {
  final logic = Get.put(MenuLogic());
  final state = Get.find<MenuLogic>().state;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('DaySmote'), centerTitle: true,
        leading: Builder(builder: (context) {
          return IconButton(
            icon: Icon(Icons.view_list, color: Colors.white), //自定义图标
            onPressed: () {
              // 打开抽屉菜单
              Scaffold.of(context).openDrawer();
            },
          );
        }),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(20),
        child: GetBuilder<MenuLogic>(
          builder: (_) => ListView(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: (null == state.tagFilter || "" == state.tagFilter)
            ? List.generate(state.list.length, (index) {
              return NoteCard(state.list[index], index);
            })
            : List.generate(state.list.length, (index) {
              return NoteCard(state.list[index], index); // Todo: Filter by tag.
            }),
          ),
        )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          Article newArticle = await Get.to(EditorPage(), arguments: Article("",[],""));
          if("" != newArticle.title && "" != newArticle.contain) {
            logic.insertArticle(newArticle);
          } else {
            print("Returned Null Article");
          }
        },
      ),
    );
  }
}
class NoteCard extends StatelessWidget {
  NoteCard(
      this.article,
      this.index, {
        Key? key,
      }) : super(key: key);
  final Article article;
  final int index;
  final logic = Get.find<MenuLogic>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        // 此处添加点击事件。
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
              article.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textScaleFactor: 1.8,
            ),
            NoteCardTagList(article.tags),
            Text(
              article.contain,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textScaleFactor: 1.1,
            )
          ],
        ),
      ),
      onTap: () async {
        Article newArticle = await Get.to(EditorPage(), arguments: article);
        if("" != newArticle.title && "" != newArticle.contain) {
          logic.modifyArticle(newArticle, index);
        } else {
          print("Edited Null Article");
        }
      }
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