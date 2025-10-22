import 'package:get/get.dart';
import 'package:p02_newsie_news_app/app/data/top_headlines_response.dart' as top;
import 'package:p02_newsie_news_app/app/routes/app_pages.dart';

import 'package:p02_newsie_news_app/core/api.dart';

class SearcherController extends GetxController {

  final count = 0.obs;
  final articles = <top.Article>[].obs; // current visible articles (for selected tab)
  final topicArticles = <String, List<top.Article>>{}.obs; // all topics -> articles
  final isLoading = false.obs;
  final error = RxnString();

  void searchAndFetch(String query) {
    future() async { 
      APIService.fetchEverything(query: query).then((response) {
        articles.assignAll((response.articles) as Iterable<top.Article>);
      }).catchError((err) {
        error.value = err.toString();
      });
    }

    Future.wait([future()]).whenComplete(() {
      isLoading.value = false;
    });
  }

  void openArticleDetails(top.Article article) {
    Get.toNamed(Routes.ARTICLE_DETAIL, arguments: article);
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    searchAndFetch(Get.parameters['query'] ?? '');
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
