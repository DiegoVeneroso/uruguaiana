// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomPlayerVideo extends StatefulWidget {
  Uri videoUri;
  CustomPlayerVideo({
    Key? key,
    required this.videoUri,
  }) : super(key: key);

  @override
  State<CustomPlayerVideo> createState() => _CustomPlayerVideoState();
}

class _CustomPlayerVideoState extends State<CustomPlayerVideo> {
  late CustomVideoPlayerController _customVideoPlayerController;

  late bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initializeVideoPlayer();
  }

  @override
  void dispose() {
    _customVideoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: Get.theme.colorScheme.primary,
              ),
              borderRadius: BorderRadius.circular(0),
              color: Get.theme.colorScheme.onPrimaryContainer,
            ),
            child: Center(
              child: CircularProgressIndicator(
                color: Get.theme.colorScheme.primary,
              ),
            ),
          )
        : Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomVideoPlayer(
                customVideoPlayerController: _customVideoPlayerController,
              ),
            ],
          );
  }

  void initializeVideoPlayer() {
    setState(() {
      isLoading = true;
    });
    VideoPlayerController videoPlayerController;
    if (widget.videoUri != null || widget.videoUri != '') {
      videoPlayerController = VideoPlayerController.networkUrl(widget.videoUri)
        ..initialize().then((value) {
          setState(() {
            isLoading = false;
          });
        });
    } else {
      return;
    }

    _customVideoPlayerController = CustomVideoPlayerController(
      customVideoPlayerSettings: const CustomVideoPlayerSettings(
          // thumbnailWidget: Text(
          //   'fundo',
          // ),
          // customAspectRatio: 1.0,
          // placeholderWidget: Text('placeholder'),
          ),
      context: context,
      videoPlayerController: videoPlayerController,
    );
  }
}
