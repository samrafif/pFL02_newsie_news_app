// lib/features/onboarding/onboarding_binding.dart
// lib/features/onboarding/onboarding_controller.dart
// lib/features/onboarding/onboarding_view.dart

// The file below contains the *three* separated Dart files concatenated for convenience.
// Copy each section into the corresponding file in your project.

// ----------------------------- onboarding_binding.dart -----------------------------
// ---------------------------- onboarding_controller.dart ---------------------------
// ------------------------------ onboarding_view.dart ------------------------------

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p02_newsie_news_app/core/utils.dart';
import 'onboarding_controller.dart';

/// Usage:
/// Get.to(() => const OnboardingPage(), binding: OnboardingBinding());
/// or declare a named route and use the binding in GetPage.

class OnboardingView extends GetView<OnboardingController> {
  /// Optional callback if you want the results directly instead of Get.back result.
  final void Function(List<String> topics, bool notifications)? onFinish;

  const OnboardingView({super.key, this.onFinish});

  @override
  Widget build(BuildContext context) {
    // allow external callback to be set once
    controller.setOnFinish(onFinish);

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        actions: [
          TextButton(
            onPressed: controller.skip,
            child: const Text('Skip'),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: controller.pageController,
              onPageChanged: (i) => controller.page.value = i,
              children: [
                _pageWelcome(context),
                _pageTopicsInput(context),
                _pageFinalize(context),
              ],
            ),
          ),

          const SizedBox(height: 14),
          _buildDots(context),
          const SizedBox(height: 14),

          // Bottom action row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
            child: Row(
              children: [
                TextButton(
                  onPressed: controller.previousPage,
                  child: const Text(
                    'Back',
                    style: TextStyle(fontWeight: FontWeight.w900)  
                  ),
                ),
                const Spacer(),
                Obx(() => ElevatedButton(
                      onPressed: controller.nextPage,
                      child: Text(
                        controller.page.value == 2 ? 'Done' : 'Next',
                        style: TextStyle(fontWeight: FontWeight.w900)
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDots(BuildContext context) {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          3,
          (i) => AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(horizontal: 6),
            width: controller.page.value == i ? 18 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: controller.page.value == i ? Theme.of(context).colorScheme.primary : Colors.grey.shade400,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );
    });
  }

  Widget _pageWelcome(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Image(image: AssetImage('assets/onboarding_imgs/0.png'), height: 300),
          // const Icon(Icons.newspaper, size: 92),
          const SizedBox(height: 28),
          const Text(
            'Stay informed, your way',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          const Text(
            'Pick topics you care about and we will tailor the news feed to match your interests.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _pageTopicsInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          const Text('Choose topics you like', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Tap to select.'),

          const SizedBox(height: 18),

          // Suggestions as chips
            Obx(() => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.suggestions.map((topic) {
                final selected = controller.selectedTopics.contains(topic);
                return FilterChip(
                selected: selected,
                label: Text(capitalizeFirst(topic)),
                onSelected: (_) {
                  if (selected) {
                  controller.toggleSuggestion(topic);
                  } else if (controller.selectedTopics.length < 3) {
                  controller.toggleSuggestion(topic);
                  }
                  else {
                  // Show a snackbar or toast to inform user
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('You can select up to 3 topics only.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  }
                },
                selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                );
              }).toList(),
              )),

          const SizedBox(height: 18),

          // Selected topics list with removable chips
          Obx(() => controller.selectedTopics.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Selected', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: controller.selectedTopics.map((topic) {
                        return InputChip(
                          label: Text(capitalizeFirst(topic)),
                          onDeleted: () => controller.selectedTopics.remove(topic),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 18),
                  ],
                )
              : const SizedBox()),

          // Custom topic input
          // Row(
          //   children: [
          //     Expanded(
          //       child: TextField(
          //         controller: controller.topicController,
          //         textInputAction: TextInputAction.done,
          //         onSubmitted: controller.addCustomTopic,
          //         decoration: const InputDecoration(
          //           hintText: 'Add a custom topic (e.g. Climate, Startups)',
          //           border: OutlineInputBorder(),
          //           isDense: true,
          //         ),
          //       ),
          //     ),
          //     const SizedBox(width: 10),
          //     ElevatedButton(
          //       onPressed: () => controller.addCustomTopic(controller.topicController.text),
          //       child: const Text('Add'),
          //     ),
          //   ],
          // ),

          const Spacer(),

          const Text('Tip: You can change these anytime in Settings', style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _pageFinalize(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // const Icon(Icons.thumb_up_alt, size: 84),
          const Image(image: AssetImage('assets/onboarding_imgs/1.png'), height: 300),
          const SizedBox(height: 20),
          const Text('All set!', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          const Text('We will show you a curated feed based on the topics you selected.'),
          const SizedBox(height: 18),

          // Summary of selected topics
          Obx(() => controller.selectedTopics.isNotEmpty
              ? Column(
                  children: [
                    const Text('Your topics', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: controller.selectedTopics.map((t) => Chip(label: Text(capitalizeFirst(t)))).toList(),
                    ),
                    const SizedBox(height: 18),
                  ],
                )
              : const SizedBox()),

          // Notifications toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Enable breaking news notifications'),
              const SizedBox(width: 12),
              Obx(() => Switch(
                    value: controller.notificationsEnabled.value,
                    onChanged: (v) => controller.notificationsEnabled.value = v,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

// ------------------------------ end of files -------------------------------------
