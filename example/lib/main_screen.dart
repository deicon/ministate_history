import 'package:example/home_page.dart';
import 'package:example/main.dart';
import 'package:example/todo/widget/todo_lists_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("State Management Testbed"),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.countertops),
              ),
              Tab(
                icon: Icon(Icons.countertops),
              )
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            Center(child: MyHomePage(title: "Counter Sample")),
            Center(child: TodoListsPage()),
          ],
        ),
      ),
    );
  }
}
