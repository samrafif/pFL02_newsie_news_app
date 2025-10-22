import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'bookmarks_controller.dart';

class BookmarksView extends GetView<BookmarksController> {
  const BookmarksView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BookmarksView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'BookmarksView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
