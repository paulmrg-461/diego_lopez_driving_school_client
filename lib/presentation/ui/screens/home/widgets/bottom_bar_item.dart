import 'package:flutter/material.dart';
import 'package:diego_lopez_driving_school_client/presentation/ui/screens/home/tabs/tabs.dart';

class BottomBarItem {
  final String label;
  final IconData icon;
  final Widget widget;

  const BottomBarItem({
    required this.label,
    required this.icon,
    required this.widget,
  });

  NavigationDestination get navigationDestination =>
      NavigationDestination(icon: Icon(icon), label: label);
}

const List<BottomBarItem> bottombarListAdmin = [
  BottomBarItem(
    label: 'Reportes',
    icon: Icons.list_alt_rounded,
    widget: ReportsTab(),
  ),
  BottomBarItem(
    label: 'Historial',
    icon: Icons.history_rounded,
    widget: HistoryReportsTab(),
  ),
  BottomBarItem(
    label: 'Operadores',
    icon: Icons.engineering_outlined,
    widget: OperatorsTab(),
  ),
  BottomBarItem(
    label: 'Perfil',
    icon: Icons.person_outline_rounded,
    widget: ProfileTab(),
  ),
];

const List<BottomBarItem> bottombarList = [
  BottomBarItem(
    label: 'Reportes',
    icon: Icons.list_alt_rounded,
    widget: ReportsTab(),
  ),
  BottomBarItem(
    label: 'Historial',
    icon: Icons.history_rounded,
    widget: HistoryReportsTab(),
  ),
  BottomBarItem(
    label: 'Perfil',
    icon: Icons.person_outline_rounded,
    widget: ProfileTab(),
  ),
];
