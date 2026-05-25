import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/todo_bloc.dart';
import 'views/todo_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Pure BLoC Todo',
      theme: ThemeData(primarySwatch: Colors.blue),
      // Bọc BlocProvider ở ngoài cùng để mọi màn hình bên trong đều lấy được dữ liệu
      home: BlocProvider(
        create: (context) => TodoBloc(),
        child: const TodoScreen(),
      ),
    );
  }
}