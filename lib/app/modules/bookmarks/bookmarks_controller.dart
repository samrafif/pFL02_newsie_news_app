import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:p02_newsie_news_app/app/data/top_headlines_response.dart';

class BookmarksController extends GetxController {
  //TODO: Implement BookmarksController

  final count = 0.obs;
  GetStorage box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    box.writeIfNull('bookmarks', <String>[]);
  }

  void addToBookmarks(String articleJson) {
    List<String> bookmarks = List<String>.from(box.read('bookmarks'));
    if (!bookmarks.contains(articleJson)) {
      bookmarks.add(articleJson);
      box.write('bookmarks', bookmarks);
    }
  }

  List<Article> getBookmarks() {
    List<String> bookmarksJson = List<String>.from(box.read('bookmarks'));
    return bookmarksJson.map((json) => Article.fromJson(jsonDecode(json))).toList();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
