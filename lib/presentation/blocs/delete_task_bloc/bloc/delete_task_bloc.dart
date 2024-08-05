import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../domain/repositories/task_repository.dart';

part 'delete_task_event.dart';
part 'delete_task_state.dart';


class DeleteTaskBloc extends Bloc<DeleteTaskEvent, DeleteTaskState> {
  final TaskRepository _repository;

  DeleteTaskBloc(this._repository) : super(DeleteTaskState()) {
    on<DeleteTaskEvent>(_onDeleteTask);
  }

  Future<void> _onDeleteTask(DeleteTaskEvent event, Emitter<DeleteTaskState> emit) async {
    emit(DeleteTaskState(isDeleting: true));
    try {
      await _repository.deleteTask(event.id);
      emit(DeleteTaskState(isDeleted: true));
    } catch (e) {
      emit(DeleteTaskState(error: e.toString()));
    }
  }
}