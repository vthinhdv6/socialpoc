import 'package:flutter/material.dart';
import 'package:socialpoc/common/contants.dart';
import 'package:socialpoc/common/widget/buttonCommonWidget.dart';
import 'package:textfields/textfields.dart';

class UpLoadVideoScreen extends StatefulWidget {
  const UpLoadVideoScreen({super.key});

  @override
  State<UpLoadVideoScreen> createState() => _UpLoadVideoScreenState();
}

class _UpLoadVideoScreenState extends State<UpLoadVideoScreen> {
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
                      child: const Expanded(
                          child: Image(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            'https://th.bing.com/th/id/R.a2cc3437b7c9183512532abec0a205e2?rik=rL98WTgQ7bIjRw&pid=ImgRaw&r=0'),
                      )),
                    ),
                  ],
                ),
              ),
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height * 0.4),
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
                                offset: const Offset(0, 2), // changes the position of the shadow
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
                                          buttonText: 'Up load video',
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
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(80)),
                                  color: colorFillBox,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.2,
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
                                          padding: const EdgeInsets.symmetric(vertical: 8.0),
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
