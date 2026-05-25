import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/todo.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(const TodoState()) {
    
    // 1. Xử lý Thêm công việc
    on<AddTodo>((event, emit) {
      final newTodo = Todo(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // ID ngẫu nhiên
        title: event.title,
      );
      // Dùng dấu spread (...) để bung mảng cũ ra và nhét cái mới vào cuối
      emit(TodoState(todos: [...state.todos, newTodo]));
    });

    // 2. Xử lý Đánh dấu Hoàn thành / Chưa hoàn thành
    on<ToggleTodo>((event, emit) {
      final updatedTodos = state.todos.map((todo) {
        return todo.id == event.id
            ? todo.copyWith(isCompleted: !todo.isCompleted)
            : todo;
      }).toList();
      emit(TodoState(todos: updatedTodos));
    });

    // 3. Xử lý Xóa công việc
    on<DeleteTodo>((event, emit) {
      final filteredTodos = state.todos.where((t) => t.id != event.id).toList();
      emit(TodoState(todos: filteredTodos));
    });
  }
}