// ...existing code...

import 'package:flutter/material.dart';
import 'package:p02_newsie_news_app/app/data/top_headlines_response.dart' as top;

class BreakingNewsCard extends StatelessWidget {
  final top.Article article;
  final onTap;

  const BreakingNewsCard({super.key, required this.article, this.onTap});

  String _formatDate(DateTime? dt) {
    if (dt == null) return '';
    final d = dt.toLocal();
    return '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = article.urlToImage;
    final title = article.title ?? 'Untitled';
    final source = article.source?.name ?? '';
    final date = _formatDate(article.publishedAt);

    return GestureDetector(
      onTap: onTap != null ? () {
            onTap!(article);
          } :
          () {
            if (article.url != null) print('Open article: ${article.url}');
          },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: SizedBox(
          height: 180,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (imageUrl != null && imageUrl.isNotEmpty)
                Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, st) =>
                      Container(color: Colors.grey.shade300),
                  loadingBuilder: (ctx, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: Colors.grey.shade300,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                )
              else
                Container(color: Colors.grey.shade300),
              // dark gradient for readability
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.black.withOpacity(0.2),
                      Colors.transparent
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
              // content
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (source.isNotEmpty || date.isNotEmpty)
                      Row(
                        children: [
                          if (source.isNotEmpty)
                            Text(
                              source,
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 12),
                            ),
                          if (source.isNotEmpty && date.isNotEmpty)
                            const SizedBox(width: 8),
                          if (date.isNotEmpty)
                            Text(
                              date,
                              style: const TextStyle(
                                  color: Colors.white54, fontSize: 12),
                            ),
                        ],
                      ),
                    const SizedBox(height: 6),
                    Text(
                      title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
