import 'package:get/get.dart';
import 'package:flutter/material.dart';
import './activities_controller.dart';

class ActivitiesPage extends GetView<ActivitiesController> {
    
    const ActivitiesPage({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: const Text('ActivitiesPage'),),
            body: Container(),
        );
    }
}