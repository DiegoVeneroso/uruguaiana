import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uruguaiana/app/modules/about/about_controller.dart';
import 'package:uruguaiana/app/modules/news/news_controller.dart';
import 'package:validatorless/validatorless.dart';
import '../../core/colors/services/theme_service.dart';
import '../../core/ui/app_state.dart';
import '../../core/ui/widgets/custom_appbar.dart';
import '../../core/ui/widgets/custom_button.dart';
import '../../core/ui/widgets/custom_picker.dart';
import '../../core/ui/widgets/custom_textformfield.dart';
import 'package:auto_size_text/auto_size_text.dart';

class AboutEditPage extends StatefulWidget {
  const AboutEditPage({Key? key}) : super(key: key);

  @override
  State<AboutEditPage> createState() => _AboutAddPageState();
}

class _AboutAddPageState extends AppState<AboutEditPage, AboutController> {
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
                    'ALTERAR NOTÍCIA',
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
                  validator: Validatorless.required('Titulo é obrigatório'),
                  maxlines: 2,
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextformfield(
                  label: 'Descrição',
                  controller: _descriptionEC,
                  validator: Validatorless.required('Descrição é obrigatória'),
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
                    onPressed: () {
                      final formValid =
                          _formKey.currentState?.validate() ?? false;
                      if (formValid) {
                        controller.aboutUpdate({
                          'idNews': Get.parameters['idNews'],
                          'title': _titleEC.text,
                          'url_image': _pickedKey.currentState?.imageFile?.path,
                          'description': _descriptionEC.text,
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






// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:uruguaiana/app/modules/about/about_controller.dart';
// import 'package:validatorless/validatorless.dart';
// import '../../core/colors/services/theme_service.dart';
// import '../../core/ui/app_state.dart';
// import '../../core/ui/widgets/custom_appbar.dart';
// import '../../core/ui/widgets/custom_button.dart';
// import '../../core/ui/widgets/custom_textformfield.dart';
// import 'package:auto_size_text/auto_size_text.dart';

// class AboutEditPage extends StatefulWidget {
//   const AboutEditPage({Key? key}) : super(key: key);

//   @override
//   State<AboutEditPage> createState() => _AboutAddPageState();
// }

// class _AboutAddPageState extends AppState<AboutEditPage, AboutController> {
//   final _formKey = GlobalKey<FormState>();
//   final _titleEC = TextEditingController(text: Get.parameters['title']);
//   final _descriptionEC =
//       TextEditingController(text: Get.parameters['description']);

//   @override
//   void dispose() {
//     _titleEC.dispose();
//     _descriptionEC.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: context.theme.colorScheme.background,
//       appBar: CustomAppbar(
//         actionsList: [
//           IconButton(
//             onPressed: ThemeService().switchTheme,
//             icon: const Icon(Icons.contrast),
//             color: Get.theme.colorScheme.onBackground,
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: IntrinsicHeight(
//           child: Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Center(
//                     child: AutoSizeText(
//                       minFontSize: 10,
//                       'Atualizar notícia',
//                       style: Get.textTheme.titleLarge?.copyWith(
//                         fontWeight: FontWeight.bold,
//                         color: Get.theme.colorScheme.surface,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   controller.imageFile == null
//                       ? Center(
//                           child: Container(
//                             width: double.infinity,
//                             height: 250,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               image: DecorationImage(
//                                 image: NetworkImage(
//                                     Get.parameters['urlImage'].toString()),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                         )
//                       : Center(
//                           child: Container(
//                             width: double.infinity,
//                             height: 250,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               image: DecorationImage(
//                                 image: FileImage(
//                                   File(controller.imageFile!.path),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       IconButton(
//                         onPressed: () async {
//                           Map<Permission, PermissionStatus> statuses = await [
//                             Permission.storage,
//                             Permission.camera,
//                           ].request();
//                           if (statuses[Permission.storage]!.isGranted &&
//                               statuses[Permission.camera]!.isGranted) {
//                             await controller.pickImageFileFromGalery();
//                             setState(() {
//                               controller.imageFile;
//                             });
//                           } else {
//                             print('Permissão negada!');
//                           }
//                         },
//                         icon: Icon(
//                           Icons.image_outlined,
//                           color: Get.theme.colorScheme.surface,
//                           size: 30,
//                         ),
//                       ),
//                       const SizedBox(
//                         width: 10,
//                       ),
//                       IconButton(
//                         onPressed: () async {
//                           Map<Permission, PermissionStatus> statuses = await [
//                             Permission.storage,
//                             Permission.camera,
//                           ].request();
//                           if (statuses[Permission.storage]!.isGranted &&
//                               statuses[Permission.camera]!.isGranted) {
//                             await controller.captureImageFileFromCamera();
//                             setState(() {
//                               controller.imageFile;
//                             });
//                           } else {
//                             print('Permissão negada!');
//                           }
//                         },
//                         icon: Icon(
//                           Icons.camera_alt_outlined,
//                           color: Get.theme.colorScheme.surface,
//                           size: 30,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   CustomTextformfield(
//                     label: 'Título',
//                     controller: _titleEC,
//                     validator: Validatorless.required('Titulo é obrigatório'),
//                     maxlines: 2,
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   CustomTextformfield(
//                     label: 'Descrição',
//                     controller: _descriptionEC,
//                     validator:
//                         Validatorless.required('Descrição é obrigatória'),
//                     maxlines: 10,
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   Center(
//                     child: CustomButton(
//                       color: Get.theme.colorScheme.primaryContainer,
//                       width: double.infinity,
//                       label: 'ATUALIZAR',
//                       onPressed: () {
//                         final formValid =
//                             _formKey.currentState?.validate() ?? false;
//                         if (formValid) {
//                           controller.aboutUpdate({
//                             'idAbout': Get.parameters['idAbout'],
//                             'title': _titleEC.text,
//                             'url_image': controller.imageFile == null
//                                 ? ''
//                                 : controller.imageFile!.path,
//                             'description': _descriptionEC.text,
//                           });
//                         }
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
