import 'package:get/get.dart';
import 'package:flutter/material.dart';
import './about_controller.dart';

class AboutPage extends GetView<AboutController> {
    
    const AboutPage({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: const Text('AboutPage'),),
            body: Container(),
        );
    }
}