import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class DrawerItem extends Equatable {
  final IconData icon;
  final String title;
  final String route;
  final bool useGo;

  const DrawerItem({
    required this.icon,
    required this.title,
    required this.route,
    this.useGo = false,
  });

  @override
  List<Object?> get props => [icon, title, route, useGo];
}

const drawerItems = [
  DrawerItem(icon: Icons.home, title: 'Tela Inicial', route: '/profile'),
  DrawerItem(
    icon: Icons.book,
    title: 'Cursos e Matérias',
    route: '/info-cursos',
  ),
  DrawerItem(
    icon: Icons.school_outlined,
    title: 'Docentes',
    route: '/docentes',
  ),
];
