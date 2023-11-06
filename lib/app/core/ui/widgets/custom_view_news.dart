// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomViewNews extends StatefulWidget {
  Uri videoUri;
  CustomViewNews({
    Key? key,
    required this.videoUri,
  }) : super(key: key);

  @override
  State<CustomViewNews> createState() => _CustomPlayerVideoState();
}

class _CustomPlayerVideoState extends State<CustomViewNews> {
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
            height: 210,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: Get.theme.colorScheme.primary,
              ),
              borderRadius: BorderRadius.circular(20),
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
              ClipRRect(
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  // height: 230,
                  width: double.infinity,
                  child: CustomVideoPlayer(
                    customVideoPlayerController: _customVideoPlayerController,
                  ),
                ),
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
        // showDurationPlayed: false,
        // thumbnailWidget: Center(
        //   child: IconButton(
        //       onPressed: () {
        //         print('play');
        //       },
        //       icon: Icon(
        //         Icons.play_arrow,
        //         size: 40,
        //         color: Get.theme.colorScheme.onPrimaryContainer,
        //       )),
        // ),
        // showPlayButton: true,
        // showDurationRemaining: false,
        // showFullscreenButton: false,
        // showSeekButtons: false,
        // playButton: const Center(
        //   child: Text(
        //     'play',
        //     style: TextStyle(color: Colors.white, fontSize: 50),
        //   ),
        // ),
        controlBarAvailable: false,
        customAspectRatio: 16 / 9,
        // controlBarDecoration: const BoxDecoration(
        //   borderRadius: BorderRadius.all(
        //     Radius.circular(10),
        //   ),
        // ),
        settingsButtonAvailable: false,
      ),
      context: context,
      videoPlayerController: videoPlayerController,
    );
  }
}
