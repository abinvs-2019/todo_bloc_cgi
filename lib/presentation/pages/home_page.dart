import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_cgi/presentation/blocs/filter/filter_bloc.dart';

import '../../domain/enitites/task.dart';
import '../blocs/add_task/bloc/add_task_bloc.dart';
import '../blocs/delete_task_bloc/bloc/delete_task_bloc.dart';
import '../blocs/list_task_bloc/bloc/list_task_bloc.dart';
import '../blocs/update_task_bloc/bloc/update_task_bloc.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
        actions: [
          PopupMenuButton<TaskFilter>(
            onSelected: (filter) {
              context.read<FilterTasksBloc>().add(FilterTasksEvent(filter));
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<TaskFilter>>[
              const PopupMenuItem<TaskFilter>(
                value: TaskFilter.all,
                child: Text('All'),
              ),
              const PopupMenuItem<TaskFilter>(
                value: TaskFilter.completed,
                child: Text('Completed'),
              ),
              const PopupMenuItem<TaskFilter>(
                value: TaskFilter.pending,
                child: Text('Pending'),
              ),
            ],
          ),
        ],
      ),
      body: BlocListener<AddTaskBloc, AddTaskState>(
        listener: (context, state) {
          if (state.isAdded) {
            context.read<TaskListBloc>().add(LoadTasks());
          }
        },
        child: BlocListener<UpdateTaskBloc, UpdateTaskState>(
          listener: (context, state) {
            if (state.isUpdated) {
              context.read<TaskListBloc>().add(LoadTasks());
            }
          },
          child: BlocListener<DeleteTaskBloc, DeleteTaskState>(
            listener: (context, state) {
              if (state.isDeleted) {
                context.read<TaskListBloc>().add(LoadTasks());
              }
            },
            child: BlocBuilder<TaskListBloc, TaskListState>(
              builder: (context, taskListState) {
                return BlocBuilder<FilterTasksBloc, FilterTasksState>(
                  builder: (context, filterState) {
                    final filteredTasks = _getFilteredTasks(taskListState.tasks, filterState.filter);
                    return ListView.builder(
                      itemCount: filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = filteredTasks[index];
                        return ListTile(
                          title: Text(task.title),
                          leading: Checkbox(
                            value: task.isCompleted,
                            onChanged: (_) {
                              context.read<UpdateTaskBloc>().add(
                                UpdateTaskEvent(task.copyWith(isCompleted: !task.isCompleted)),
                              );
                            },
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              context.read<DeleteTaskBloc>().add(DeleteTaskEvent(task.id));
                            },
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  List<Task> _getFilteredTasks(List<Task> tasks, TaskFilter filter) {
    switch (filter) {
      case TaskFilter.completed:
        return tasks.where((task) => task.isCompleted).toList();
      case TaskFilter.pending:
        return tasks.where((task) => !task.isCompleted).toList();
      default:
        return tasks;
    }
  }

  void _showAddTaskDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext _context) {
        return AlertDialog(
          title: Text('Add a new task'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: "Enter task title"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(_context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  context.read<AddTaskBloc>().add(AddTaskEvent(controller.text));
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}