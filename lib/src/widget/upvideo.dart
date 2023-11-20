import 'package:flutter/material.dart';
import 'package:socialpoc/common/contants.dart';
import 'package:socialpoc/common/widget/buttonCommonWidget.dart';
import 'package:textfields/textfields.dart';
import 'addvideo/showvideo_screen.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'dart:io';

class UpLoadVideoScreen extends StatefulWidget {
  final String? videoPath;

  const UpLoadVideoScreen({Key? key, this.videoPath}) : super(key: key);

  @override
  State<UpLoadVideoScreen> createState() => _UpLoadVideoScreenState();
}

class _UpLoadVideoScreenState extends State<UpLoadVideoScreen> {
  late VideoPlayerController _videoController;
  late ChewieController _chewieController;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: colorBackground,
        body: SafeArea(
          child: Stack(
            children: [
              SafeArea(
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.height,
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Expanded(
                        child: VideoPlayerScreen(
                            videoPath: widget.videoPath ?? ''),
                      ),
                    ),
                  ],
                ),
              ),
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.height * 0.45,
                          decoration: BoxDecoration(
                            color: colorBackground2,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: colorText2.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 4,
                                offset: const Offset(
                                    0, 2), // changes the position of the shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(paddingDefault),
                                child: Column(
                                  children: [
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Caption',
                                        style: TextStyle(
                                          fontSize: textSizeMedium,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const Divider(thickness: 2),
                                    const MultiLineTextField(
                                      label: '',
                                      maxLines: 4,
                                      bordercolor: Colors.transparent,
                                    ),
                                    const Divider(thickness: 2),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: ButtonCommonWidget(
                                          buttonText: 'Đăng',
                                          onPressed: () {},
                                          fontColor: colorBackground,
                                          backgroundColor: colorBg,
                                        )),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                            child: ButtonCommonWidget(
                                          buttonText: 'Cancel',
                                          onPressed: () {},
                                          fontColor: colorText2,
                                          backgroundColor: colorBackground2,
                                        )),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(paddingDefault),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(80)),
                                  color: colorFillBox,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: const Text(
                                            'Time',
                                            style: TextStyle(
                                              fontSize: textSizeMedium,
                                              fontWeight: FontWeight.w600,
                                              color: colorBackground,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Text(
                                            DateTime.now().toString(),
                                            style: const TextStyle(
                                              fontSize: textSizeMedium,
                                              color: colorBackground,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

