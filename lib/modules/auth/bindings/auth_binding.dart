import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Use permanent binding to prevent disposal issues
    Get.put<AuthController>(
      AuthController(),
      permanent: true, // This prevents early disposal
    );
  }
}
