// ...existing code...
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p02_newsie_news_app/app/routes/app_pages.dart';
import 'package:p02_newsie_news_app/app/widgets/article_tile.dart';
import 'package:p02_newsie_news_app/app/widgets/breaking_news_card.dart';
import 'package:p02_newsie_news_app/app/widgets/widget_carousel.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  Widget _buildChips(HomeController c) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Obx(() => Row(
            children: List.generate(c.tabs.length, (i) {
              final selected = i == c.currentIndex.value;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: ChoiceChip(
                  label: Text(
                    c.tabs[i],
                    style: Get.theme.textTheme.bodyLarge?.copyWith(
                      color: selected ? Colors.white : Colors.black.withAlpha(140),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  showCheckmark: false,
                  selected: selected,
                  onSelected: (_) => c.changeTab(i),
                  backgroundColor: Colors.transparent,
                  selectedColor: Colors.grey.shade800,
                  elevation: 0,
                  side: BorderSide.none,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                ),
              );
            }),
          )),
    );
  }

  Widget _buildPage(HomeController c, String title, IconData icon, int index) {
    // Wrap in Obx so the list updates when controller.articles changes
    return Obx(() {
      if (c.isLoading.value && (c.articles.isEmpty)) {
        return const Center(child: CircularProgressIndicator());
      }

      if (c.error.value != null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Failed to load articles.'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  await c.loadTopHeadlines();
                },
                child: const Text('Try Again'),
              ),
            ],
          ),
        );
      }

      if (c.articles.isEmpty) {
        return const Center(child: Text('No articles available.'));
      }

      return RefreshIndicator(
        onRefresh: () async {
          await c.loadTopHeadlines(); // Assuming fetchArticles is a method in HomeController to refresh articles
        },
        child: ListView.builder(
          itemCount: c.articles.length,
          itemBuilder: (ctx, i) {
            final article = c.articles[i];
            if (index == 0 && i == 0) {
              return WidgetCarousel(
                autoPlay: true,
                itemWidth: 200,
                height: 250,
                children: [
                  BreakingNewsCard(article: c.articles[0], onTap: controller.openArticleDetails),
                  BreakingNewsCard(article: c.articles[1], onTap: controller.openArticleDetails),
                  BreakingNewsCard(article: c.articles[2], onTap: controller.openArticleDetails),
                ],
              );
            }
            return ArticleTile(article: article, onTap: controller.openArticleDetails);
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.put(HomeController());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('NEWSie', style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.w700, fontSize: 20))
      ),
      floatingActionButton: FloatingSearchBar(
        onBookmarkPressed: () {
          // Show not implemented snackbar
          Get.snackbar(
            'Not Implemented',
            'Bookmark feature is not implemented yet, due to [DEVELOPER BURNOUT, CONNECTION INSTABILITY, & SITUATION VOLATILITY], please wait for the next minor version. Also like thanks for cooking for us (to all ustaz), like actually super thanks am super grateful (sooper heartfelt thank you), will implement later when have time... sometime',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 10),
            );
        },
        onSubmitted: (value) => {
          Get.toNamed(Routes.SEARCH, parameters: {'query': value})
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
        children: [
          _buildChips(c),
          Expanded(
            child: TabBarView(
              controller: c.tabController,
              children: List.generate(
                c.tabs.length,
                (i) => _buildPage(c, c.tabs[i], Icons.article, i),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FloatingSearchBar extends StatefulWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onBookmarkPressed;
  final TextEditingController? controller;

  const FloatingSearchBar({
    super.key,
    this.hintText = 'Search...',
    this.onChanged,
    this.onSubmitted,
    this.onBookmarkPressed,
    this.controller,
  });

  @override
  State<FloatingSearchBar> createState() => _FloatingSearchBarState();
}

class _FloatingSearchBarState extends State<FloatingSearchBar> {
  late TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
    _hasText = _controller.text.isNotEmpty;
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 56,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 16),
          IconButton(
            onPressed: () {
              widget.onSubmitted?.call(_controller.text);
            },
            icon: const Icon(Icons.search, color: Colors.grey)),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
              decoration: InputDecoration(
                hintText: widget.hintText,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                //contentPadding: const EdgeInsets.symmetric(horizontal: 1),
                suffixIcon: _hasText
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          _controller.clear();
                          widget.onChanged?.call('');
                        },
                      )
                    : null,
              ),
            ),
          ),
          Container(
            height: 40,
            width: 1,
            color: Colors.grey.shade300,
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: widget.onBookmarkPressed,
            tooltip: 'Bookmarks',
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}
