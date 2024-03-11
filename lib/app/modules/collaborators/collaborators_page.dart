import 'package:get/get.dart';
import 'package:flutter/material.dart';
import './collaborators_controller.dart';

class CollaboratorsPage extends GetView<CollaboratorsController> {
    
    const CollaboratorsPage({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: const Text('CollaboratorsPage'),),
            body: Container(),
        );
    }
}