import 'package:flutter/material.dart';

class ActionLogModel extends InheritedWidget {
  final List<String> actionLog;

  const ActionLogModel({
    Key? key,
    required Widget child,
    required this.actionLog,
  }) : super(key: key, child: child);

  static ActionLogModel? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ActionLogModel>();
  }

  @override
  bool updateShouldNotify(covariant ActionLogModel oldWidget) {
    return actionLog != oldWidget.actionLog;
  }

  void addActionLog(String s) {}
}