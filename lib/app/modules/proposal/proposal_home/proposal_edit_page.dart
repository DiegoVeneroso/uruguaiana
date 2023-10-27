import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:validatorless/validatorless.dart';
import '../../../core/colors/services/theme_service.dart';
import '../../../core/ui/app_state.dart';
import '../../../core/ui/widgets/custom_appbar.dart';
import '../../../core/ui/widgets/custom_button.dart';
import '../../../core/ui/widgets/custom_textformfield.dart';
import 'proposal_controller.dart';

class ProposalEditPage extends StatefulWidget {
  const ProposalEditPage({Key? key}) : super(key: key);

  @override
  State<ProposalEditPage> createState() => _ProposalAddPageState();
}

class _ProposalAddPageState
    extends AppState<ProposalEditPage, ProposalController> {
  final _formKey = GlobalKey<FormState>();
  final _titleEC = TextEditingController(text: Get.parameters['title']);

  @override
  void dispose() {
    _titleEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      appBar: CustomAppbar(
        actionsList: [
          IconButton(
            onPressed: ThemeService().switchTheme,
            icon: const Icon(Icons.contrast),
            color: Get.theme.colorScheme.onBackground,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Alterar pilar',
                      style: Get.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Get.theme.colorScheme.surface,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomTextformfield(
                    label: 'Título',
                    controller: _titleEC,
                    validator: Validatorless.required('Titulo é obrigatório'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: CustomButton(
                      color: Get.theme.colorScheme.primaryContainer,
                      width: double.infinity,
                      label: 'ATUALIZAR',
                      onPressed: () {
                        final formValid =
                            _formKey.currentState?.validate() ?? false;
                        if (formValid) {
                          controller.proposalUpdate({
                            'idProposal': Get.parameters['id_proposal_base'],
                            'title': _titleEC.text.toUpperCase(),
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
