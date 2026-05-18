import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../controllers/editor_controller.dart';
import '../controllers/upload_controller.dart';
import '../controllers/story_editor_controller.dart';
import '../controllers/post_settings_controller.dart';
import '../views/home_screen.dart';
import '../views/upload_screen.dart';
import '../views/editor_screen.dart';
import '../views/settings_screen.dart';
import '../views/text_editor_screen.dart';
import '../views/color_picker_screen.dart';
import '../views/post_settings_screen.dart';

part 'routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.home;

  static final routes = [
    GetPage(
      name: Routes.home,
      page: () => const HomeScreen(),
      binding: BindingsBuilder(() => Get.lazyPut(() => HomeController())),
    ),
    GetPage(
      name: Routes.upload,
      page: () => const UploadScreen(),
      binding: BindingsBuilder(() => Get.lazyPut(() => UploadController())),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: Routes.editor,
      page: () => const EditorScreen(),
      binding: BindingsBuilder(() => Get.lazyPut(() => EditorController())),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: Routes.settings,
      page: () => const SettingsScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: Routes.textEditor,
      page: () => const TextEditorScreen(),
      binding:
          BindingsBuilder(() => Get.lazyPut(() => StoryEditorController())),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 250),
    ),
    GetPage(
      name: Routes.colorPicker,
      page: () => const ColorPickerScreen(),
      binding:
          BindingsBuilder(() => Get.lazyPut(() => StoryEditorController())),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: Routes.postSettings,
      page: () => const PostSettingsScreen(),
      binding: BindingsBuilder(
          () => Get.lazyPut(() => PostSettingsController())),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}
