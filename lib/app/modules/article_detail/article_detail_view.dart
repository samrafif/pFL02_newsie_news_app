// ...existing code...
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'article_detail_controller.dart';
import 'package:p02_newsie_news_app/app/data/top_headlines_response.dart' as top;

class ArticleDetailView extends GetView<ArticleDetailController> {
  const ArticleDetailView({super.key});

  String _formatDate(DateTime? dt) {
    if (dt == null) return '';
    final d = dt.toLocal();
    return '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  Future<void> _openArticle(BuildContext ctx, String? url) async {
    if (url == null || url.isEmpty) {
      Get.snackbar('Error', 'No URL available for this article',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    final uri = Uri.tryParse(url);
    if (uri == null) {
      Get.snackbar('Error', 'Invalid article URL', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    try {
      final launched = await launchUrl(uri, mode: LaunchMode.platformDefault);
      if (!launched) {
        Get.snackbar('Error', 'Could not open article', snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Failed to open article', snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    final article = Get.arguments as top.Article?;
    if (article == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Article')),
        body: const Center(child: Text('No article data')),
      );
    }

    final title = article.title ?? 'Untitled';
    final author = article.author;
    final source = article.source?.name ?? '';
    final date = _formatDate(article.publishedAt);
    final description = article.description;
    final content = article.content;
    final imageUrl = article.urlToImage;

    return Scaffold(
      appBar: AppBar(
        title: Text(source.isNotEmpty ? source : 'Article'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (imageUrl != null && imageUrl.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        imageUrl,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: double.infinity,
                          height: 200,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.broken_image, size: 48, color: Colors.grey),
                        ),
                        loadingBuilder: (_, child, progress) {
                          if (progress == null) return child;
                          return Container(
                            width: double.infinity,
                            height: 200,
                            color: Colors.grey.shade200,
                            child: const Center(child: CircularProgressIndicator()),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 12),
                  Text(title, style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (author != null) Text(author, style: Theme.of(context).textTheme.bodySmall),
                      if (author != null && date.isNotEmpty) const SizedBox(width: 8),
                      if (date.isNotEmpty) Text(date, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // if (description != null)
                  //   Text(description, style: Theme.of(context).textTheme.bodyMedium),
                  // if (description != null) const SizedBox(height: 12),
                  if (content != null)
                    Text(content, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 18),
                ],
              ),
              Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _openArticle(context, article.url),
                          icon: const Icon(Icons.open_in_browser),
                          label: const Text('Open in browser'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        onPressed: () {
                          // lightweight share/favorite placeholder
                          Get.snackbar('Info', 'Bookmark not implemented', snackPosition: SnackPosition.BOTTOM);
                        },
                        icon: const Icon(Icons.bookmark_border),
                      )
                    ],
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
// ...existing code...