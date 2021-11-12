import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'state.dart';
import 'logic.dart';
import '/editor/view.dart';
class MenuPage extends StatelessWidget {
  final logic = Get.put(MenuLogic());
  final state = Get.find<MenuLogic>().state;

  List<Widget> tagListGenerator(String filter) {
    List ret = List.generate(0, (index) => Article("",[],""));
    state.list.forEach((element) {
      bool bo = false;
      element.tags.forEach((tag) {
        if(tag == filter) {
          bo = true;
        }
      });
      if(bo) {
        ret.add(element);
      }
    });
    if(ret.isEmpty) {
      return List.generate(1, (index) => Text("No Note Found"));
    }
    return List.generate(ret.length, (index) {
      return NoteCard(ret[index], index);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      drawer: GetBuilder<MenuLogic>(
        builder: (_) {
          state.tagMap.clear();
          for(var element in state.list) {
            for(var tag in element.tags) {
              if(state.tagMap[tag] == null){
                state.tagMap[tag] = 1;
              } else {
                ++state.tagMap[tag];
              }
            }
          }
          return TagFilterList();
        }
      ),
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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.home), //自定义图标
            onPressed: () {
              logic.setFilter("");
            },
          ),
        ],
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
            : tagListGenerator(state.tagFilter),
          ),
        )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          Article newArticle = await Get.to(EditorPage(), arguments: Article("",[],""));
          print(newArticle.title);
          print(newArticle.contain);
          if("" != newArticle.title) {
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
        if("" != newArticle.title) {
          logic.modifyArticle(newArticle, index);
        } else {
          print("Article " + index.toString() + "deleted");
          logic.deleteArticle(index);
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
        child: Wrap(
          direction: Axis.horizontal,
          children: List.generate(tags.length, (index) {
            return NoteTag(tags[index], 0.9);
          }),
        )
    );
  }
}

class NoteTag extends StatelessWidget {
  NoteTag(
      this.tag,
      this.size,
      {Key? key
      }) : super(key: key);
  final String tag;
  final double size;
  Widget build(BuildContext context) {
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
          tag,
          style: TextStyle(
            color: Colors.white,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textScaleFactor: size,
        ),
      ),
    );
  }
}

class TagFilterList extends StatelessWidget {
  final state = Get.find<MenuLogic>().state;
  TagFilterList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List tagList = List.generate(0, (index) => null);
    state.tagMap.forEach((key, value) {
      tagList.add({"name": key, "count": value});
    });
    return Drawer(
      child: ListView(
        children: List.generate(tagList.length, (index) {
          print(tagList[index]);
          return TagFilter(tagList[index]['name'], tagList[index]['count']);
        }),
      ),
    );
  }
}

class TagFilter extends StatelessWidget {
  final logic = Get.find<MenuLogic>();
  TagFilter(this.name, this.count, {Key? key}) : super(key: key);
  final String name;
  final int count;
  Widget build(BuildContext context) {
    return Card(
      child: GestureDetector(
        child: ListTile(
          title: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textScaleFactor: 1.8,
              ),
              Expanded(child: Container()),
              Text(
                count.toString(),
                textScaleFactor: 1.5,
              )
            ],
          ),
        ),
        onTap: () {
          logic.setFilter(name);
          Navigator.of(context).pop();
        },
      )
    );
  }
}