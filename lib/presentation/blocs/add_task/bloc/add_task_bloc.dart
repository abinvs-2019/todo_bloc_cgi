import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../domain/enitites/task.dart';
import '../../../../domain/repositories/task_repository.dart';

part 'add_task_event.dart';
part 'add_task_state.dart';



class AddTaskBloc extends Bloc<AddTaskEvent, AddTaskState> {
  final TaskRepository _repository;

  AddTaskBloc(this._repository) : super(AddTaskState()) {
    on<AddTaskEvent>(_onAddTask);
  }

  Future<void> _onAddTask(AddTaskEvent event, Emitter<AddTaskState> emit) async {
    emit(AddTaskState(isAdding: true));
    try {
      final task = Task(id: DateTime.now().toString(), title: event.title);
      await _repository.addTask(task);
      emit(AddTaskState(isAdded: true));
    } catch (e) {
      emit(AddTaskState(error: e.toString()));
    }
  }
}