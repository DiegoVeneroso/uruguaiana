import 'package:get/get.dart';
import 'package:flutter/material.dart';
import './collaborate_controller.dart';

class CollaboratePage extends GetView<CollaborateController> {
    
    const CollaboratePage({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: const Text('CollaboratePage'),),
            body: Container(),
        );
    }
}