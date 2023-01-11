import 'package:commons_flutter/utils/dependency_injector.dart';
import 'package:flutter/material.dart';

abstract class DependencyInjectorState<TWidget extends StatefulWidget,
    TBind extends Object> extends State<TWidget> {
  final TBind _scope = DependencyInjector.get<TBind>();

  TBind get controller => _scope;

  @override
  void dispose() {
    DependencyInjector.dispose<TBind>();
    super.dispose();
  }
}
