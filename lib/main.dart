import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:p02_newsie_news_app/app/controllers/on_start_controller.dart';
import 'package:p02_newsie_news_app/core/theme.dart';

import 'app/routes/app_pages.dart';

main() async {
  await GetStorage.init();
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: CustomTheme.lightTheme(),
      darkTheme: CustomTheme.darkTheme(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      initialBinding: BindingsBuilder(() {
        // Lazy put or put is fine. Using Get.put here so instance is available immediately.
        Get.put(OnStartController());
      }),
      onReady: () => {
        if (Get.find<OnStartController>().isFirstLaunch()) {
          Get.offNamed(Routes.ONBOARDING)
        } else {
          Get.offNamed(Routes.HOME)
        }
      },
    ),
  );
}

// [00:02.87] Hey, it's me
// [00:07.07] Things have been weird
// [00:09.33] 눈이 가 자꾸 왜 이래? (Whoa)
// [00:13.40] 조절이 안돼 이제 (no), 왜 혼자서만 이래? 복잡해져
// [00:22.03] Then let me just make it simple
// [00:25.30] Oh, you're all I think about, yeah
// [00:27.52] I love to get your attention, babe
// [00:29.63] Yeah, yeah, what I need is only you, bebe
// [00:31.74] 너도너도 그렇다고 말해줘
// [00:33.85] 애써애써 숨기지는 말아줘
// [00:36.02] I love to feel the attraction, babe
// [00:38.17] Yeah, yeah, what I need is only you, bebe
// [00:40.19] 자꾸 애써 숨기려고 하지 마
// [00:42.66] Just say what's right now
// [00:44.09] I know you love me back, 말하지 않아도
// [00:48.17] Oh, I know you love me back, 티내지 않아도
// [00:52.35] Maybe you don't love me back
// [00:54.68] 떨리는 이 느낌 feel so high (so high, so high), just let me tell you
// [01:02.04] 나에게만 only, 달콤하게 holy
// [01:06.32] 달아오른 두 볼이 show it to you
// [01:10.52] 기다려져 call me, 확실히 난 fallin'
// [01:14.88] 차오르는 웃음이 번져가잖아, yeah
// [01:19.28] 태연하게 가려준 햇빛
// [01:20.94] 하나하나 왠지 묻고 싶어
// [01:23.36] 궁금한 게 없는 것 같아
// [01:25.35] Do you want, want, want me too?
// [01:27.94] 매일 길을 잃어, what if you go away, away, away?
// [01:35.10] Ooh-ooh, ooh, ooh
// [01:36.16] I love to get your attention, babe
// [01:38.11] Yeah, yeah, what I need is only you, bebe
// [01:40.47] 너도너도 그렇다고 말해줘
// [01:42.33] 애써애써 숨기지는 말아줘
// [01:44.68] I love to feel the attraction, babe
// [01:46.71] Yeah, yeah, what I need is only you, bebe
// [01:48.84] 자꾸 애써 숨기려고 하지 마
// [01:51.12] Just say what's right now
// [01:52.61] I know you love me back, 말하지 않아도
// [01:56.66] Oh, I know you love me back, 티내지 않아도
// [02:01.16] Maybe you don't love me back (love me back)
// [02:03.25] 떨리는 이 느낌 feel so high (so high, so high), just let me tell you
// [02:10.61] Waiting for your call (your call)
// [02:12.67] 매일 밤 생각나 (생각나)
// [02:14.72] I just wanna fall (fall in) in love, oh
// [02:19.40] 우연인 척 또 눈을 마주쳐, 그럼 뭐 어때? Hi, you, hi, you
// [02:27.03] I know you love me back (ah), 말하지 않아도 (않아도)
// [02:30.93] Oh, I know you love me back, 티내지 않아도 (않아도)
// [02:35.27] Maybe you don't love me back (love me back)
// [02:37.79] 떨리는 이 느낌 feel so high (so high, so high), just let me tell you
// [02:45.00] 나에게만 only (only), 달콤하게 holy
// [02:49.11] 달아오른 두 볼이 show it to you
// [02:53.52] 기다려져 call me (call me), 확실히 난 fallin' (fallin')
// [02:57.42] 차오르는 웃음이 (웃음이), 번져가잖아, yeah
// [03:02.60] 
