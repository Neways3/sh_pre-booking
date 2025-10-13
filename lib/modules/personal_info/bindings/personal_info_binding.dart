import 'package:get/get.dart';
import 'package:sh_m/modules/personal_info/controllers/document_controller.dart';
import 'package:sh_m/modules/personal_info/controllers/personal_info_controller.dart';

class PersonalInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<PersonalInfoController>(PersonalInfoController());
    Get.put<DocumentController>(DocumentController());
  }
}
