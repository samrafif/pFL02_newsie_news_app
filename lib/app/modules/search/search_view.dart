import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:p02_newsie_news_app/app/widgets/article_tile.dart';

import 'search_controller.dart';

class SearchView extends GetView<SearcherController> {
  const SearchView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
        centerTitle: true,
      ),
      body: Obx(() {
      if (controller.isLoading.value && (controller.articles.isEmpty)) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.error.value != null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Failed to load articles.'),
              Text(controller.error.value!),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  controller.searchAndFetch(Get.parameters['query'] ?? '');
                },
                child: const Text('Try Again'),
              ),
            ],
          ),
        );
      }

      if (controller.articles.isEmpty) {
        return const Center(child: Text('No articles available.'));
      }

      return ListView.builder(
        itemCount: controller.articles.length,
        itemBuilder: (ctx, i) {
          final article = controller.articles[i];
          return ArticleTile(article: article, onTap: controller.openArticleDetails);
        },
      );
    })
    );
  }
}
