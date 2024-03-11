import 'package:eu_faco_parte/app/repository/Finance_repositories.dart';
import 'package:get/get.dart';
import 'package:eu_faco_parte/app/repository/auth_repository.dart';

import 'finance_controller.dart';

class FinanceBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(FinanceController(
      repository: FinanceRepository(),
      authRepository: AuthRepository(),
    ));
  }
}
