// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_cgi/domain/enitites/task.dart';

import 'package:todo_cgi/main.dart';
import 'package:todo_cgi/presentation/blocs/add_task/bloc/add_task_bloc.dart';
import 'package:todo_cgi/presentation/blocs/delete_task_bloc/bloc/delete_task_bloc.dart';
import 'package:todo_cgi/presentation/blocs/filter/filter_bloc.dart';
import 'package:todo_cgi/presentation/blocs/list_task_bloc/bloc/list_task_bloc.dart';
import 'package:todo_cgi/presentation/blocs/update_task_bloc/bloc/update_task_bloc.dart';
import 'package:todo_cgi/presentation/pages/home_page.dart';

class MockTaskListBloc extends Mock implements TaskListBloc {}
class MockAddTaskBloc extends Mock implements AddTaskBloc {}
class MockUpdateTaskBloc extends Mock implements UpdateTaskBloc {}
class MockDeleteTaskBloc extends Mock implements DeleteTaskBloc {}
class MockFilterTasksBloc extends Mock implements FilterTasksBloc {}

void main() {
  late MockTaskListBloc mockTaskListBloc;
  late MockAddTaskBloc mockAddTaskBloc;
  late MockUpdateTaskBloc mockUpdateTaskBloc;
  late MockDeleteTaskBloc mockDeleteTaskBloc;
  late MockFilterTasksBloc mockFilterTasksBloc;

  setUp(() {
    mockTaskListBloc = MockTaskListBloc();
    mockAddTaskBloc = MockAddTaskBloc();
    mockUpdateTaskBloc = MockUpdateTaskBloc();
    mockDeleteTaskBloc = MockDeleteTaskBloc();
    mockFilterTasksBloc = MockFilterTasksBloc();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<TaskListBloc>.value(value: mockTaskListBloc),
          BlocProvider<AddTaskBloc>.value(value: mockAddTaskBloc),
          BlocProvider<UpdateTaskBloc>.value(value: mockUpdateTaskBloc),
          BlocProvider<DeleteTaskBloc>.value(value: mockDeleteTaskBloc),
          BlocProvider<FilterTasksBloc>.value(value: mockFilterTasksBloc),
        ],
        child: HomePage(),
      ),
    );
  }

  testWidgets('HomePage displays tasks', (WidgetTester tester) async {
    when(mockTaskListBloc.state).thenReturn(TaskListState(tasks: [
      Task(id: '1', title: 'Test Task 1'),
      Task(id: '2', title: 'Test Task 2'),
    ]));
    when(mockFilterTasksBloc.state).thenReturn(FilterTasksState(filter: TaskFilter.all));

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Test Task 1'), findsOneWidget);
    expect(find.text('Test Task 2'), findsOneWidget);
  });

  testWidgets('HomePage adds a new task', (WidgetTester tester) async {
    when(mockTaskListBloc.state).thenReturn(TaskListState(tasks: []));
    when(mockFilterTasksBloc.state).thenReturn(FilterTasksState(filter: TaskFilter.all));
    when(mockAddTaskBloc.state).thenReturn(AddTaskState());

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('Add a new task'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'New Task');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    verify(mockAddTaskBloc.add(AddTaskEvent('New Task'))).called(1);
  });

  testWidgets('HomePage toggles task completion', (WidgetTester tester) async {
    final task = Task(id: '1', title: 'Test Task', isCompleted: false);
    when(mockTaskListBloc.state).thenReturn(TaskListState(tasks: [task]));
    when(mockFilterTasksBloc.state).thenReturn(FilterTasksState(filter: TaskFilter.all));

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();

    verify(mockUpdateTaskBloc.add(UpdateTaskEvent(task.copyWith(isCompleted: true)))).called(1);
  });

  testWidgets('HomePage deletes a task', (WidgetTester tester) async {
    final task = Task(id: '1', title: 'Test Task');
    when(mockTaskListBloc.state).thenReturn(TaskListState(tasks: [task]));
    when(mockFilterTasksBloc.state).thenReturn(FilterTasksState(filter: TaskFilter.all));

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();

    verify(mockDeleteTaskBloc.add(DeleteTaskEvent('1'))).called(1);
  });

  testWidgets('HomePage filters', (WidgetTester tester) async {
    when(mockTaskListBloc.state).thenReturn(TaskListState(tasks: [
      Task(id: '1', title: 'Test Task 1', isCompleted: true),
      Task(id: '2', title: 'Test Task 2', isCompleted: false),
    ]));
    when(mockFilterTasksBloc.state).thenReturn(FilterTasksState(filter: TaskFilter.all));

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Completed'));
    await tester.pumpAndSettle();

    verify(mockFilterTasksBloc.add(FilterTasksEvent(TaskFilter.completed))).called(1);
  });
}
