import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eu_faco_parte/app/core/ui/widgets/custom_button.dart';
import 'package:video_compress/video_compress.dart';

class CustomProgressDialog extends StatefulWidget {
  const CustomProgressDialog({super.key});

  @override
  State<CustomProgressDialog> createState() => _CustomProgressDialogState();
}

class _CustomProgressDialogState extends State<CustomProgressDialog> {
  late Subscription subscription;
  double? progress;

  @override
  void initState() {
    super.initState();

    subscription = VideoCompress.compressProgress$
        .subscribe((progress) => setState(() => this.progress = progress));
  }

  @override
  void dispose() {
    subscription.unsubscribe();
    VideoCompress.cancelCompression();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final value = progress == null ? progress : progress! / 100;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Text(
            'COMPACTANDO',
            style: TextStyle(
              fontSize: 20,
              color: Get.theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          'AGUARDE...',
          style: TextStyle(
              fontSize: 16,
              color: Get.theme.colorScheme.primary,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 24,
        ),
        LinearProgressIndicator(
          value: value,
          minHeight: 12,
        ),
        const SizedBox(
          height: 16,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              onPressed: () => Get.back(),
              label: 'VOLTAR',
              height: 40,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomButton(
              onPressed: () => VideoCompress.cancelCompression(),
              label: 'CANCELAR',
              height: 40,
            ),
          ],
        )
      ],
    );
  }
}
