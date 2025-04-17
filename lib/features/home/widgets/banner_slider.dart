import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

class BannerModel {
  final String imageUrl;
  final String? linkUrl;
  final String? title;
  final String? subtitle;

  BannerModel({
    required this.imageUrl,
    this.linkUrl,
    this.title,
    this.subtitle,
  });
}

class BannerSlider extends StatefulWidget {
  final List<BannerModel> banners;
  final double height;
  final Duration autoPlayInterval;
  final bool showIndicator;
  final Function(int)? onPageChanged;

  const BannerSlider({
    Key? key,
    required this.banners,
    this.height = 200.0,
    this.autoPlayInterval = const Duration(seconds: 3),
    this.showIndicator = true,
    this.onPageChanged,
  }) : super(key: key);

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    if (widget.autoPlayInterval.inMilliseconds > 0 &&
        widget.banners.length > 1) {
      _timer = Timer.periodic(widget.autoPlayInterval, (timer) {
        if (!mounted) return;

        final nextPage = (_currentPage + 1) % widget.banners.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) {
      return SizedBox(
        height: widget.height,
        child: const Center(child: Text('No banners available')),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.banners.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
              if (widget.onPageChanged != null) {
                widget.onPageChanged!(index);
              }
            },
            itemBuilder: (context, index) {
              final banner = widget.banners[index];
              return GestureDetector(
                onTap: () async {
                  if (banner.linkUrl != null && banner.linkUrl!.isNotEmpty) {
                    final Uri uri = Uri.parse(banner.linkUrl!);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: Colors.grey.shade200),
                  child: Stack(
                    children: [
                      // Banner Image
                      Positioned.fill(
                        child: Image.network(
                          banner.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(
                                Icons.image_not_supported,
                                color: Colors.grey.shade400,
                                size: 50,
                              ),
                            );
                          },
                        ),
                      ),

                      // Gradient overlay for text readability
                      if (banner.title != null || banner.subtitle != null)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.7),
                                ],
                                stops: const [0.6, 1.0],
                              ),
                            ),
                          ),
                        ),

                      // Banner Text
                      if (banner.title != null || banner.subtitle != null)
                        Positioned(
                          bottom: 16,
                          left: 16,
                          right: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (banner.title != null)
                                Text(
                                  banner.title!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              if (banner.subtitle != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    banner.subtitle!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Indicator
        if (widget.showIndicator && widget.banners.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.banners.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _currentPage == index ? 16.0 : 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    color:
                        _currentPage == index
                            ? Theme.of(context).primaryColor
                            : Colors.grey.withOpacity(0.4),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
