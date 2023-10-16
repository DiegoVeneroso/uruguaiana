import 'package:flutter/material.dart';
import 'package:gridview_menu/gridview_menu.dart';
import 'package:uruguaiana/app/modules/home/home_page.dart';

import '../../core/ui/widgets/menu_grid_widget.dart';

class AdminPage extends StatefulWidget {
  final Color color = const Color.fromRGBO(70, 103, 48, 1);

  const AdminPage({super.key});

  @override
  _MenuHomeScreenState createState() => _MenuHomeScreenState();
}

class _MenuHomeScreenState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    List<MenuItem> menuItem = <MenuItem>[
      MenuItem(
        icon: Icons.admin_panel_settings_outlined,
        color: widget.color,
        title: 'Planejamento',
        subtitle: 'Administrativo',
        child: HomePage(),
        disabled: false,
      ),
      MenuItem(
        icon: Icons.monetization_on,
        color: widget.color,
        title: 'Financeiro',
        subtitle: 'Administrativo',
        child: HomePage(),
        disabled: false,
      ),
      MenuItem(
        icon: Icons.newspaper_outlined,
        color: widget.color,
        title: 'Material',
        subtitle: 'Administrativo',
        child: HomePage(),
        disabled: false,
      ),
      MenuItem(
        icon: Icons.person,
        color: widget.color,
        title: 'Recursos Humanos',
        subtitle: 'Administrativo',
        child: HomePage(),
        disabled: false,
      ),
    ];
    return MenuGridWidget(
      menuItem: menuItem,
    );
  }
}
