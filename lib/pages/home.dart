import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/pages/add.dart';
import 'package:todo_app/pages/completed.dart';
import 'package:todo_app/provider/todo_provider.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Todo> todos = ref.watch(todoProvider);
    List<Todo> activeTodos =
        todos.where((todo) => todo.completed == false).toList();
    List<Todo> completedTodos =
        todos.where((todo) => todo.completed == true).toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Todo app"),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: activeTodos.length + 1,
          itemBuilder: (context, index) {
            return index == activeTodos.length
                ? completedTodos.isEmpty
                    ? Container()
                    : Center(
                        child: TextButton(
                          child: const Text("Completed Todos"),
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CompletedTodoPage())),
                        ),
                      )
                : Slidable(
                    startActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) => ref
                              .watch(todoProvider.notifier)
                              .removeTodo(activeTodos[index].todoId),
                          icon: Icons.delete,
                          backgroundColor: Colors.red,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                        )
                      ],
                    ),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) => ref
                              .watch(todoProvider.notifier)
                              .completeTodo(activeTodos[index].todoId),
                          icon: Icons.check,
                          backgroundColor: Colors.green,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                        )
                      ],
                    ),
                    child: ListTile(title: Text(activeTodos[index].content)));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const AddTodo()));
        },
        tooltip: 'Add Todo',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
