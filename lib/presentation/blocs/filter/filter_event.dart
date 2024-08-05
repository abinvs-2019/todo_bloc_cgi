part of 'filter_bloc.dart';


enum TaskFilter { all, completed, pending }

class FilterTasksEvent {
  final TaskFilter filter;

  FilterTasksEvent(this.filter);
}