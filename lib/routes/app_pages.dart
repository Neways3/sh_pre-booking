import 'package:get/get.dart';
import 'package:sh_m/modules/auth/views/forgot_password_view.dart';
import 'package:sh_m/modules/auth/views/reset_password_view.dart';
import 'package:sh_m/modules/personal_info/bindings/document_binding.dart';
import 'package:sh_m/modules/personal_info/bindings/personal_info_binding.dart';
import 'package:sh_m/modules/personal_info/views/documents_screen.dart';
import 'package:sh_m/modules/personal_info/views/personal_info_screen.dart';
import 'package:sh_m/modules/splash_screen/presentation/splash_screen.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/register_view.dart';
import '../modules/auth/views/otp_verification_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import 'app_routes.dart';

class AppPages {
  static const INITIAL = AppRoutes.LOGIN;

  static final routes = [
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => LoginView(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 250),
    ),
    GetPage(
      name: AppRoutes.REGISTER,
      page: () => RegisterView(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.OTP_VERIFICATION,
      page: () => OtpVerificationView(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 250),
    ),
    GetPage(
      name: AppRoutes.PERSONAL_INFO,
      page: () => PersonalInfoScreen(),
      binding: PersonalInfoBinding(),
    ),
    GetPage(
      name: AppRoutes.DOCUMENTS,
      page: () => DocumentsScreen(),
      binding: DocumentBinding(),
    ),
    GetPage(
      name: AppRoutes.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.RESET_PASSWORD,
      page: () => const ResetPasswordView(),
      binding: AuthBinding(),
    ),
    GetPage(name: AppRoutes.SPLASH_SCREEN, page: () => const SplashScreen()),
  ];
}
