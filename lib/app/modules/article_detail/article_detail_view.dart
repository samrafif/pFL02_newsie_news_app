import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'article_detail_controller.dart';

class ArticleDetailView extends GetView<ArticleDetailController> {
  const ArticleDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ArticleDetailView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ArticleDetailView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
