import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:p02_newsie_news_app/app/controllers/on_start_controller.dart';
import 'package:p02_newsie_news_app/app/routes/app_pages.dart';
import 'package:p02_newsie_news_app/core/config.dart';

class OnboardingController extends GetxController {
  // current page index
  final page = 0.obs;

  // Predefined suggestions
  final suggestions = Config.topics;

  // Selected topics
  final RxList<String> selectedTopics = <String>[].obs;

  // Notifications toggle
  final RxBool notificationsEnabled = true.obs;

  // Text controller for custom topics
  final TextEditingController topicController = TextEditingController();

  // PageView controller
  late final PageController pageController;

  final box = GetStorage();

  // Optional external callback (if caller wants to receive results)
  void Function(List<String> topics, bool notifications)? onFinish;
  bool _onFinishSet = false;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  @override
  void onClose() {
    pageController.dispose();
    topicController.dispose();
    super.onClose();
  }

  /// Sets the optional callback only once
  void setOnFinish(void Function(List<String>, bool)? cb) {
    if (_onFinishSet) return;
    _onFinishSet = true;
    onFinish = cb;
  }

  void nextPage() {
    if (page.value < 2) {
      pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      finish();
    }
  }

  void previousPage() {
    if (page.value > 0) pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void skip() {
    finish();
  }

  void finish() {
    final topics = selectedTopics.isEmpty ? ['General'] : selectedTopics.toList();
    if (onFinish != null) {
      onFinish!(topics, notificationsEnabled.value);
    } else {
      // default: return result to previous route
      //Get.back(result: {'topics': topics, 'notifications': notificationsEnabled.value});
      //Get.find<OnStartController>().setFirstLaunchDone(); 
      // TODO: ^^ REMEMBER TO UNCOMMENT
      box.write('preferred_topics', topics);
      box.write('notifications_enabled', notificationsEnabled.value);

      Get.offNamed(Routes.HOME);
    }
  }

  void toggleSuggestion(String topic) {
    if (selectedTopics.contains(topic)) {
      selectedTopics.remove(topic);
    } else {
      selectedTopics.add(topic);
    }
  }

  void addCustomTopic(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return;
    if (!selectedTopics.contains(text)) selectedTopics.add(text);
    topicController.clear();
  }
}