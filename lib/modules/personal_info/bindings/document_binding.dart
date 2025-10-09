import 'package:get/get.dart';
import 'package:sh_m/modules/personal_info/controllers/document_controller.dart';
import 'package:sh_m/modules/personal_info/controllers/personal_info_controller.dart';
import 'package:sh_m/modules/personal_info/services/document_service.dart';

class DocumentBinding extends Bindings {
  @override
  void dependencies() {
    // Use permanent binding to prevent disposal issues
    Get.put<DocumentController>(DocumentController());
  }
}
