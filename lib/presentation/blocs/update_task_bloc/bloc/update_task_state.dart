part of 'update_task_bloc.dart';

class UpdateTaskState {
  final bool isUpdating;
  final bool isUpdated;
  final String? error;

  UpdateTaskState({this.isUpdating = false, this.isUpdated = false, this.error});
}