import 'package:flutter/material.dart';
import 'package:todo_app/data/hive_data_store.dart';
import 'package:todo_app/models/hive_task.dart';
import 'package:todo_app/pages/home/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';


Future<void> main() async {
  // init db before runapp
  await Hive.initFlutter();

  // register hive adapter
  Hive.registerAdapter<hiveTask>(hiveTaskAdapter());

  // open a box
  var box = await Hive.openBox<hiveTask>(HiveDataStore.boxName);

  runApp(BaseWidget(child: const MyApp()));
}

class BaseWidget extends InheritedWidget {
  BaseWidget({Key? key, required this.child}) : super(key: key, child: child);
  final HiveDataStore dataStore = HiveDataStore();
  final Widget child;

  static BaseWidget of(BuildContext context) {
    final base = context.dependOnInheritedWidgetOfExactType<BaseWidget>();
    if (base != null) {
      return base;
    } else {
      throw StateError("Could not find ancestor widget of type BaseWidget");
    }
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      theme: ThemeData(primaryColor: Color(0xFF5039bd)),
      home: const MyHomePage(),
    );
  }
}
