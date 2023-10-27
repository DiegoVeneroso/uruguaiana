import 'package:get/get.dart';
import 'package:uruguaiana/app/repository/auth_repository.dart';
import 'package:uruguaiana/app/repository/proposal_actions_repositories.dart';

import 'proposal_actions_controller.dart';

class ProposalActionsBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(ProposalActionsController(
      idProposalBase: Get.parameters['id_proposal_base'].toString(),
      repository: ProposalActionsRepository(),
      authRepository: AuthRepository(),
    ));
  }
}
