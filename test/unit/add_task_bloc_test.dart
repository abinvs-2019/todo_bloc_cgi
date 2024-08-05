import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_cgi/domain/enitites/task.dart';
import 'package:todo_cgi/domain/repositories/task_repository.dart';
import 'package:todo_cgi/presentation/blocs/add_task/bloc/add_task_bloc.dart';
import 'package:todo_cgi/presentation/blocs/list_task_bloc/bloc/list_task_bloc.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late AddTaskBloc addTaskBloc;
  late MockTaskRepository mockRepository;

  setUp(() {
    mockRepository = MockTaskRepository();
    addTaskBloc = AddTaskBloc(mockRepository);
  });

  test('initial state is correct', () {
    expect(addTaskBloc.state, AddTaskState());
  });

  group('AddTaskEvent', () {
    var task = Task(id: "100", title: "Test", isCompleted: false);
    test('emits [adding, added] when task is added successfully', () async {
      when(mockRepository.addTask(task)).thenAnswer((_) async {});

      expectLater(
        addTaskBloc.stream,
        emitsInOrder([
          AddTaskState(isAdding: true),
          AddTaskState(isAdded: true),
        ]),
      );

      addTaskBloc.add(AddTaskEvent('New Task'));
    });

    test('emits [adding, error] when task addition fails', () async {
      when(mockRepository.addTask(task))
          .thenThrow(Exception('Failed to add task'));

      expectLater(
        addTaskBloc.stream,
        emitsInOrder([
          AddTaskState(isAdding: true),
          predicate<AddTaskState>((state) => state.error != null),
        ]),
      );

      addTaskBloc.add(AddTaskEvent('New Task'));
    });
  });
}
