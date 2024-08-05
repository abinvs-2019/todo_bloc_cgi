import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_cgi/domain/repositories/task_repository.dart';
import 'package:todo_cgi/presentation/blocs/delete_task_bloc/bloc/delete_task_bloc.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late DeleteTaskBloc deleteTaskBloc;
  late MockTaskRepository mockRepository;

  setUp(() {
    mockRepository = MockTaskRepository();
    deleteTaskBloc = DeleteTaskBloc(mockRepository);
  });

  test('initial state is correct', () {
    expect(deleteTaskBloc.state, DeleteTaskState());
  });

  group('DeleteTaskEvent', () {
    test('emits [deleting, deleted] when task is deleted successfully', () async {
      when(mockRepository.deleteTask("0")).thenAnswer((_) async {});

      expectLater(
        deleteTaskBloc.stream,
        emitsInOrder([
          DeleteTaskState(isDeleting: true),
          DeleteTaskState(isDeleted: true),
        ]),
      );

      deleteTaskBloc.add(DeleteTaskEvent('1'));
    });

    test('emits [deleting, error] when task deletion fails', () async {
      when(mockRepository.deleteTask("0")).thenThrow(Exception('Failed to delete task'));

      expectLater(
        deleteTaskBloc.stream,
        emitsInOrder([
          DeleteTaskState(isDeleting: true),
          predicate<DeleteTaskState>((state) => state.error != null),
        ]),
      );

      deleteTaskBloc.add(DeleteTaskEvent('1'));
    });
  });
}