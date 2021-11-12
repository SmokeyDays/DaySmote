import 'package:get/get.dart';

import 'state.dart';

class MenuLogic extends GetxController {
  final MenuState state = MenuState();
  void insertArticle(Article article) {
    state.list.add(article.copy());
    update();
  }
  void deleteArticle(int index) {
    state.list.removeAt(index);
    update();
  }
  void modifyArticle(Article article, int index) {
    if(index < 0 || index >= state.list.length){
      print("Error: Index out of range.");
      return;
    }
    state.list[index] = article.copy();
    update();
  }
}