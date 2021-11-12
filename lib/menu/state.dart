class Article {
  Article(
      this.title,
      this.tags,
      this.contain,
  );
  String title;
  final List<String> tags;
  String contain;
  Article copy() {
    return Article(title, List.generate(tags.length, (index) => tags[index]), contain);
  }
}

class MenuState {
  List list = List.generate(0, (index) => null, growable: true);
  String tagFilter = "";
  MenuState() {
    list.add(Article("TestTitle",["text","article","note","note"],"Hello World!"*20));
    list.add(Article("TestTitle",["text","article","note"],"Hello World!"));
    list.add(Article("TestTitle",["text","article","note"],"Hello World!"));
    list.add(Article("TestTitle",["text","article","note"],"Hello World!"));
    list.add(Article("TestTitle",["text","article","note"],"Hello World!"));
    list.add(Article("TestTitle",["text","article","note"],"Hello World!"));
    list.add(Article("TestTitle",["text","article","note"],"Hello World!"));
  }
}
