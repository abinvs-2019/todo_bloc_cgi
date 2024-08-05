part of 'delete_task_bloc.dart';



class DeleteTaskState {
  final bool isDeleting;
  final bool isDeleted;
  final String? error;

  DeleteTaskState({this.isDeleting = false, this.isDeleted = false, this.error});
}
