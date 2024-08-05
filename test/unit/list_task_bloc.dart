
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_cgi/domain/enitites/task.dart';
import 'package:todo_cgi/domain/repositories/task_repository.dart';
import 'package:todo_cgi/presentation/blocs/list_task_bloc/bloc/list_task_bloc.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late TaskListBloc taskListBloc;
  late MockTaskRepository mockRepository;

  setUp(() {
    mockRepository = MockTaskRepository();
    taskListBloc = TaskListBloc(mockRepository);
  });

  test('initial state is correct', () {
    expect(taskListBloc.state, TaskListState(tasks: []));
  });

  group('LoadTasks', () {
    final List<Task> tTasks = [
      Task(id: '1', title: 'Task 1'),
      Task(id: '2', title: 'Task 2'),
    ];

    test('emits new state with tasks when repository returns tasks', () async {
      when(mockRepository.getTasks()).thenAnswer((_) async => tTasks);

      expectLater(
        taskListBloc.stream,
        emits(TaskListState(tasks: tTasks)),
      );

      taskListBloc.add(LoadTasks());
    });
  });
}