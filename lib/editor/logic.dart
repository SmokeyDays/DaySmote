import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'state.dart';
import '/menu/state.dart';

class EditorLogic extends GetxController {
  final EditorState state = EditorState();
  void initState() {
    state.versions.clear();
    state.versionPointer = 0;
    print("initState");
  }

  void modifyArticle(Article article) {
    while(state.versions.length > state.versionPointer + 1) {
      state.versions.removeLast();
    }
    state.versions.add(article);
    ++state.versionPointer;
  }

  void undo() {
    if(state.versionPointer > 0) {
      --state.versionPointer;
    }
    update();
  }

  void redo() {
    if(state.versionPointer + 1 < state.versions.length) {
      ++state.versionPointer;
    }
    update();
  }

  Article init() {
    state.versions.clear();
    state.versionPointer = 0;
    print(state.versions.length);
    return Article("",[],"");
  }

  @override
  void onReady() {
    update();
    super.onReady();
  }

  @override
  void onClose() {

  }
}
