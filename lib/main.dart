// Simple Todo App BLoC
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const TodoApp());
}

// Events
abstract class TodoEvent {}

class AddTodoEvent extends TodoEvent {
  final String todo;
  AddTodoEvent(this.todo);
}

class RemoveTodoEvent extends TodoEvent {
  final String todo;
  RemoveTodoEvent(this.todo);
}

// States
class TodoState {
  final List<String> todos;
  TodoState(this.todos);
}

// BLoC
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoState([])) {
    on<AddTodoEvent>((event, emit) {
      final updatedTodos = List<String>.from(state.todos)..add(event.todo);
      emit(TodoState(updatedTodos));
    });

    on<RemoveTodoEvent>((event, emit) {
      final updatedTodos = List<String>.from(state.todos)..remove(event.todo);
      emit(TodoState(updatedTodos));
    });
  }
}

// Usage in Widget
class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoBloc(),
      child: MaterialApp(
        home: TodoListScreen(),
      ),
    );
  }
}

class TodoListScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  TodoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Todo App')),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Enter todo',
              suffixIcon: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    context.read<TodoBloc>().add(
                          AddTodoEvent(_controller.text),
                        );
                    _controller.clear();
                  }
                },
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<TodoBloc, TodoState>(
              builder: (context, state) {
                return ListView.builder(
                  itemCount: state.todos.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(state.todos[index]),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          context.read<TodoBloc>().add(
                                RemoveTodoEvent(state.todos[index]),
                              );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
