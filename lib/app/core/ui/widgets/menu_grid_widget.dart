import 'package:flutter/material.dart';
import 'package:gridview_menu/gridview_menu.dart';
import 'package:uruguaiana/app/core/ui/widgets/custom_appbar.dart';

class MenuGridWidget extends StatefulWidget {
  final List<MenuItem>? menuItem;
  const MenuGridWidget({Key? key, @required this.menuItem}) : super(key: key);

  @override
  _MenuGridWidgetState createState() => _MenuGridWidgetState();
}

class _MenuGridWidgetState extends State<MenuGridWidget> {
  final bool _showList = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        titulo: 'Realtime',
      ),
      body: MobileSidebar(
        breakPoint: 3000,
        items: widget.menuItem!,
        showList: _showList,
      ),
    );
  }
}
