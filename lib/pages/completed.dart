import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/provider/todo_provider.dart';

class CompletedTodoPage extends ConsumerWidget {
  const CompletedTodoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Todo> todos = ref.watch(todoProvider);
    List<Todo> completedTodos =
        todos.where((todo) => todo.completed == true).toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Complted Todos"),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: completedTodos.length+1,
          itemBuilder: (context, index) {
            return index == completedTodos.length
                ? completedTodos.isEmpty
                    ? Container()
                    : Center(
                        child: TextButton(
                          child: const Text("Active Todos"),
                          onPressed: () => Navigator.pop(context),
                        ),
                      )
                : Slidable(
                    startActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) => ref
                              .watch(todoProvider.notifier)
                              .removeTodo(index),
                          icon: Icons.delete,
                          backgroundColor: Colors.red,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                        )
                      ],
                    ),
                    child:
                        ListTile(title: Text(completedTodos[index].content)));
          }), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
