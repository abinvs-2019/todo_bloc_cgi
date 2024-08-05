import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_cgi/domain/enitites/task.dart';
import 'package:todo_cgi/domain/repositories/task_repository.dart';
import 'package:todo_cgi/presentation/blocs/update_task_bloc/bloc/update_task_bloc.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late UpdateTaskBloc updateTaskBloc;
  late MockTaskRepository mockRepository;

  setUp(() {
    mockRepository = MockTaskRepository();
    updateTaskBloc = UpdateTaskBloc(mockRepository);
  });

  test('initial state is correct', () {
    expect(updateTaskBloc.state, UpdateTaskState());
  });

  group('UpdateTaskEvent', () {
    final task = Task(id: '1', title: 'Test Task', isCompleted: false);

    test('emits [updating, updated] when task is updated successfully', () async {
      when(mockRepository.updateTask(task)).thenAnswer((_) async {});

      expectLater(
        updateTaskBloc.stream,
        emitsInOrder([
          UpdateTaskState(isUpdating: true),
          UpdateTaskState(isUpdated: true),
        ]),
      );

      updateTaskBloc.add(UpdateTaskEvent(task));
    });

    test('emits [updating, error] when task update fails', () async {
      when(mockRepository.updateTask(task)).thenThrow(Exception('Failed to update task'));

      expectLater(
        updateTaskBloc.stream,
        emitsInOrder([
          UpdateTaskState(isUpdating: true),
          predicate<UpdateTaskState>((state) => state.error != null),
        ]),
      );

      updateTaskBloc.add(UpdateTaskEvent(task));
    });
  });
}