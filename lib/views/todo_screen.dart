import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';
import '../bloc/todo_state.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Todo App (Pure BLoC)', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      
      // Lắng nghe dữ liệu bằng BlocBuilder
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state.todos.isEmpty) {
            return const Center(
              child: Text('Chưa có công việc nào. Thêm ngay nhé!', 
                style: TextStyle(fontSize: 16, color: Colors.grey)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.todos.length,
            itemBuilder: (context, index) {
              final todo = state.todos[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  // Đổi màu và gạch ngang chữ nếu đã xong
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                      color: todo.isCompleted ? Colors.grey : Colors.black87,
                    ),
                  ),
                  // Nút Tick
                  leading: Checkbox(
                    value: todo.isCompleted,
                    activeColor: Colors.blue,
                    onChanged: (_) {
                      context.read<TodoBloc>().add(ToggleTodo(todo.id));
                    },
                  ),
                  // Nút Xóa
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    onPressed: () {
                      context.read<TodoBloc>().add(DeleteTodo(todo.id));
                    },
                  ),
                ),
              );
            },
          );
        },
      ),

      // Nút hiển thị bảng nhập (Bottom Sheet)
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  // Bảng Bottom Sheet gọn gàng để nhập tên công việc
  void _showAddTodoSheet(BuildContext context) {
    final textController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20, right: 20, top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Thêm công việc', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: textController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Bạn cần làm gì?',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    if (textController.text.trim().isNotEmpty) {
                      // Bắn Event thêm công việc
                      context.read<TodoBloc>().add(AddTodo(textController.text.trim()));
                      Navigator.pop(context); // Đóng bảng
                    }
                  },
                  child: const Text('Lưu lại', style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}