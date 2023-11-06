import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Compactando o video...',
            style: TextStyle(fontSize: 20),
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
          ElevatedButton(
            onPressed: () => VideoCompress.cancelCompression(),
            child: Text(
              'Cancelar',
              style: TextStyle(color: Get.theme.colorScheme.onPrimaryContainer),
            ),
          )
        ],
      ),
    );
  }
}
