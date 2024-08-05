import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_cgi/domain/enitites/task.dart';

import '../../../../domain/repositories/task_repository.dart';

part 'list_task_event.dart';
part 'list_task_state.dart';


class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  final TaskRepository _repository;

  TaskListBloc(this._repository) : super(TaskListState(tasks: [])) {
    on<LoadTasks>(_onLoadTasks);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskListState> emit) async {
    final tasks = await _repository.getTasks();
    emit(TaskListState(tasks: tasks));
  }
}