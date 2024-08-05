import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'filter_event.dart';
part 'filter_state.dart';

class FilterTasksBloc extends Bloc<FilterTasksEvent, FilterTasksState> {
  FilterTasksBloc() : super(FilterTasksState()) {
    on<FilterTasksEvent>(_onFilterTasks);
  }

  void _onFilterTasks(FilterTasksEvent event, Emitter<FilterTasksState> emit) {
    emit(FilterTasksState(filter: event.filter));
  }
}