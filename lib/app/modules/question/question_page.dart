import 'package:get/get.dart';
import 'package:flutter/material.dart';
import './question_controller.dart';

class QuestionPage extends GetView<QuestionController> {
    
    const QuestionPage({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: const Text('QuestionPage'),),
            body: Container(),
        );
    }
}