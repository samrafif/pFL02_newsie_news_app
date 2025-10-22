// ...existing code...
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:p02_newsie_news_app/app/data/everything_response.dart';
import 'package:p02_newsie_news_app/app/routes/app_pages.dart';
import 'package:p02_newsie_news_app/core/api.dart';
import 'package:p02_newsie_news_app/app/data/top_headlines_response.dart' as top;
import 'package:p02_newsie_news_app/core/config.dart';

class HomeController extends GetxController with GetSingleTickerProviderStateMixin {
  final count = 0.obs;

  // Data
  final articles = <top.Article>[].obs; // current visible articles (for selected tab)
  final topicArticles = <String, List<top.Article>>{}.obs; // all topics -> articles
  final isLoading = false.obs;
  final error = RxnString();

  // Tabs
  final tabs = ['Feed', ...Config.topics.sublist(1).map((e) => e.capitalizeFirst!)];
  final currentIndex = 0.obs;
  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    // tab count should match tabs length
    tabController = TabController(length: tabs.length, vsync: this);
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        currentIndex.value = tabController.index;
        // update visible articles when tab changes
        final topic = _topicForIndex(tabController.index);
        articles.assignAll(topicArticles[topic] ?? []);
        //print(topicArticles);
        print('Switched to tab index ${tabController.index} ($topic)');
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    loadTopHeadlines();
  }

  String _topicForIndex(int index) {
    // guard index and map to Config.topics
    final idx = index.clamp(0, Config.topics.length - 1);
    return Config.topics[idx];
  }

  void openArticleDetails(top.Article article) {
    Get.toNamed(Routes.ARTICLE_DETAIL, arguments: article);
  }

  /// Load articles for every topic and store them in [topicArticles].
  /// After load, set the current `articles` list to the currently selected tab.
  Future<void> loadTopHeadlines() async {
    isLoading.value = true;
    error.value = null;
    try {
      final topics = Config.topics;
      // Fetch all topics in parallel, but handle per-topic errors so one failure doesn't drop everything.
      final futures = topics.map((topic) async {
        try {
          if (topic == 'general') {
            final resp = await APIService.fetchTopHeadlines();
            topicArticles[topic] = resp.articles;
          } else {
            final resp = await APIService.fetchTopicHeadlines(topic);
            topicArticles[topic] = resp.articles;
          }
        } catch (e) {
          // on error for this topic, store empty list and record error
          topicArticles[topic] = <top.Article>[];
          error.value = e.toString();
          print('Error loading topic "$topic": $e');
        }
      }).toList();

      await Future.wait(futures);

      // set current visible articles according to current tab
      final currentTopic = _topicForIndex(currentIndex.value);
      articles.assignAll(topicArticles[currentTopic] ?? []);
      print('Loaded topics: ${topicArticles.keys.length}');
    } catch (e, st) {
      error.value = e.toString();
      print('Error loading headlines: $e\n$st');
    } finally {
      isLoading.value = false;
    }
  }

  void changeTab(int i) {
    // keep tab controller and currentIndex in sync
    tabController.animateTo(i);
    currentIndex.value = i;
    final topic = _topicForIndex(i);
    articles.assignAll(topicArticles[topic] ?? []);
  }

  void increment() => count.value++;

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
// ...existing code...