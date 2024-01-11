import 'package:get/get.dart';
import 'package:eu_faco_parte/app/repository/auth_repository.dart';
import 'package:eu_faco_parte/app/repository/proposal_repositories.dart';
import './proposal_controller.dart';

class ProposalBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(ProposalController(
      repository: ProposalRepository(),
      authRepository: AuthRepository(),
    ));
  }
}
