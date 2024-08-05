import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../domain/enitites/task.dart';
import '../../../../domain/repositories/task_repository.dart';

part 'update_task_event.dart';
part 'update_task_state.dart';



class UpdateTaskBloc extends Bloc<UpdateTaskEvent, UpdateTaskState> {
  final TaskRepository _repository;

  UpdateTaskBloc(this._repository) : super(UpdateTaskState()) {
    on<UpdateTaskEvent>(_onUpdateTask);
  }

  Future<void> _onUpdateTask(UpdateTaskEvent event, Emitter<UpdateTaskState> emit) async {
    emit(UpdateTaskState(isUpdating: true));
    try {
      await _repository.updateTask(event.task);
      emit(UpdateTaskState(isUpdated: true));
    } catch (e) {
      emit(UpdateTaskState(error: e.toString()));
    }
  }
}
