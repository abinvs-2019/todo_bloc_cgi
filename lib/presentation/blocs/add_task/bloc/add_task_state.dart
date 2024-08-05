part of 'add_task_bloc.dart';

class AddTaskState {
  final bool isAdding;
  final bool isAdded;
  final String? error;

  AddTaskState({this.isAdding = false, this.isAdded = false, this.error});
}