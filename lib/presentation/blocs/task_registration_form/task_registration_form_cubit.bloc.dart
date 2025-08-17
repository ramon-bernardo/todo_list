import 'package:bloc/bloc.dart' show Cubit;
import 'package:reactive_forms/reactive_forms.dart';

import 'package:todo_list/domain/entities/task.dart';
import 'package:todo_list/domain/entities/task_type.dart';

final class TaskRegistrationFormCubit extends Cubit<FormGroup> {
  TaskRegistrationFormCubit()
    : super(
        FormGroup({
          'id': FormControl<int>(),
          'title': FormControl<String>(
            validators: [Validators.required, Validators.maxLength(50)],
          ),
          'description': FormControl<String>(
            validators: [Validators.maxLength(200)],
          ),
          'status': FormControl<TaskStatus>(
            value: TaskStatus.pending,
            validators: [Validators.required],
          ),
        }),
      );

  FormControl<int> get idControl => state.control('id') as FormControl<int>;
  FormControl<String> get titleControl =>
      state.control('title') as FormControl<String>;
  FormControl<String> get descriptionControl =>
      state.control('description') as FormControl<String>;
  FormControl<TaskStatus> get statusControl =>
      state.control('status') as FormControl<TaskStatus>;

  bool get saved => idControl.value != null;

  void reset() {
    state.reset(value: {'status': TaskStatus.pending});
  }

  Task getModel() {
    return Task(
      id: idControl.value,
      title: titleControl.value!,
      status: statusControl.value!,
      description: descriptionControl.value,
    );
  }
}
