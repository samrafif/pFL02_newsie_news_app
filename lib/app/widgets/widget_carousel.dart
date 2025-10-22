// ...existing code...

import 'package:flutter/material.dart';

class WidgetCarousel extends StatefulWidget {
  final List<Widget> children;
  final double height;
  final double? itemWidth;
  final EdgeInsets padding;
  final double itemSpacing;
  final bool enableInfiniteScroll;
  final bool autoPlay;
  final Duration autoPlayDuration;
  final Curve autoPlayCurve;

  const WidgetCarousel({
    super.key,
    required this.children,
    this.height = 200,
    this.itemWidth,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.itemSpacing = 12,
    this.enableInfiniteScroll = true,
    this.autoPlay = false,
    this.autoPlayDuration = const Duration(seconds: 3),
    this.autoPlayCurve = Curves.easeInOut,
  });

  @override
  State<WidgetCarousel> createState() => _WidgetCarouselState();
}

class _WidgetCarouselState extends State<WidgetCarousel> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.enableInfiniteScroll ? 1000 : 0;
    _pageController = PageController(
      initialPage: _currentPage,
      viewportFraction: widget.itemWidth != null ? 0.85 : 1.0,
    );

    if (widget.autoPlay && widget.children.isNotEmpty) {
      _startAutoPlay();
    }
  }

  void _startAutoPlay() {
    Future.delayed(widget.autoPlayDuration, () {
      if (mounted && widget.autoPlay) {
        final nextPage = _currentPage + 1;
        _pageController
            .animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: widget.autoPlayCurve,
        )
            .then((_) {
          if (mounted) {
            setState(() {
              _currentPage = nextPage;
            });
            _startAutoPlay();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.children.isEmpty) {
      return SizedBox(height: widget.height);
    }

    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: widget.enableInfiniteScroll ? null : widget.children.length,
            itemBuilder: (context, index) {
              final itemIndex = index % widget.children.length;
              return Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? widget.padding.left : widget.itemSpacing / 2,
                  right: widget.itemSpacing / 2,
                ),
                child: widget.children[itemIndex],
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        _buildIndicator(),
      ],
    );
  }

  Widget _buildIndicator() {
    final displayIndex = _currentPage % widget.children.length;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.children.length,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: index == displayIndex ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: index == displayIndex
                ? Theme.of(context).primaryColor
                : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
