import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eu_faco_parte/app/core/ui/widgets/custom_picker.dart';
import 'package:eu_faco_parte/app/modules/proposal/proposal_actions/proposal_actions_controller.dart';
import 'package:validatorless/validatorless.dart';
import '../../../core/colors/services/theme_service.dart';
import '../../../core/ui/app_state.dart';
import '../../../core/ui/widgets/custom_appbar.dart';
import '../../../core/ui/widgets/custom_button.dart';
import '../../../core/ui/widgets/custom_textformfield.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ProposalActionsEditPage extends StatefulWidget {
  const ProposalActionsEditPage({Key? key}) : super(key: key);

  @override
  State<ProposalActionsEditPage> createState() =>
      _ProposalActionsEditPageState();
}

class _ProposalActionsEditPageState
    extends AppState<ProposalActionsEditPage, ProposalActionsController> {
  final _formKey = GlobalKey<FormState>();
  final _titleEC = TextEditingController(text: Get.parameters['title']);
  final _descriptionEC =
      TextEditingController(text: Get.parameters['description']);

  final _pickedKey = GlobalKey<CustomPickerState>();

  @override
  void initState() {
    _pickedKey.currentState?.setImageValidate('false');
    loadMidiaEditForm();
  }

  @override
  void dispose() {
    _titleEC.dispose();
    _descriptionEC.dispose();
    controller.imageFile = null;
    super.dispose();
  }

  Future<void> loadMidiaEditForm() async {
    var pathImageUrl = await controller
        .getImageXFileByUrl(Get.parameters['url_image'].toString());

    _pickedKey.currentState?.setImageFile(pathImageUrl);
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
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: AutoSizeText(
                    minFontSize: 10,
                    'ALTERAR AÇÃO',
                    style: Get.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Get.theme.colorScheme.surface,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: AutoSizeText(
                    minFontSize: 10,
                    Get.parameters['proposal_pilar_name'].toString(),
                    style: Get.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Get.theme.colorScheme.surface,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomPicker(
                  key: _pickedKey,
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextformfield(
                  label: 'Título',
                  controller: _titleEC,
                  validator: Validatorless.required('Título é obrigatório'),
                  maxlines: 2,
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextformfield(
                  label: 'Descrição',
                  controller: _descriptionEC,
                  validator: Validatorless.required('Descrição é obrigatório'),
                  maxlines: 10,
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: CustomButton(
                    color: Get.theme.colorScheme.primaryContainer,
                    width: double.infinity,
                    label: 'ALTERAR',
                    onPressed: () async {
                      final formValid =
                          _formKey.currentState?.validate() ?? false;

                      final pickerValid =
                          _pickedKey.currentState?.imageFile?.path != null
                              ? true
                              : false;

                      if (formValid & pickerValid) {
                        controller.proposalActionUpdate({
                          'title': _titleEC.text,
                          // 'url_image': controller.imageFile!.path,
                          'url_image': _pickedKey.currentState?.imageFile?.path,
                          'description': _descriptionEC.text,
                          'id_proposal_base':
                              Get.parameters['id_proposal_base'].toString(),
                          'id_proposal_action':
                              Get.parameters['id_proposal_action'].toString(),
                          'proposal_pilar_name':
                              Get.parameters['proposal_pilar_name'].toString(),
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
    );
  }
}
