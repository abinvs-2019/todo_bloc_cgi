import 'package:flutter_test/flutter_test.dart';
import 'package:todo_cgi/presentation/blocs/filter/filter_bloc.dart';

void main() {
  late FilterTasksBloc filterTasksBloc;

  setUp(() {
    filterTasksBloc = FilterTasksBloc();
  });

  test('initial state is correct', () {
    expect(filterTasksBloc.state, FilterTasksState(filter: TaskFilter.all));
  });

  group('FilterTasksEvent', () {
    test('emits new state with updated filter', () async {
      expectLater(
        filterTasksBloc.stream,
        emitsInOrder([
          FilterTasksState(filter: TaskFilter.completed),
          FilterTasksState(filter: TaskFilter.pending),
        ]),
      );

      filterTasksBloc.add(FilterTasksEvent(TaskFilter.completed));
      filterTasksBloc.add(FilterTasksEvent(TaskFilter.pending));
    });
  });
}