import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_cgi/domain/repositories/task_repository.dart';
import 'package:todo_cgi/domain/repositories/task_repository_impl.dart';


import 'presentation/blocs/add_task/bloc/add_task_bloc.dart';
import 'presentation/blocs/delete_task_bloc/bloc/delete_task_bloc.dart';
import 'presentation/blocs/filter/filter_bloc.dart';
import 'presentation/blocs/list_task_bloc/bloc/list_task_bloc.dart';
import 'presentation/blocs/update_task_bloc/bloc/update_task_bloc.dart';
import 'presentation/pages/home_page.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo CGi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RepositoryProvider<TaskRepository>(
        create: (context) => TaskRepositoryImpl(),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => TaskListBloc(
                RepositoryProvider.of<TaskRepository>(context),
              )..add(LoadTasks()),
            ),
            BlocProvider(
              create: (context) => AddTaskBloc(
                RepositoryProvider.of<TaskRepository>(context),
              ),
            ),
            BlocProvider(
              create: (context) => UpdateTaskBloc(
                RepositoryProvider.of<TaskRepository>(context),
              ),
            ),
            BlocProvider(
              create: (context) => DeleteTaskBloc(
                RepositoryProvider.of<TaskRepository>(context),
              ),
            ),
            BlocProvider(
              create: (context) => FilterTasksBloc(),
            ),
          ],
          child: HomePage(),
        ),
      ),
    );
  }
}
