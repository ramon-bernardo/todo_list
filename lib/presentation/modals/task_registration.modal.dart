import 'package:flutter/material.dart';

import 'package:flutter_modular/flutter_modular.dart'
    show ModularWatchExtension;
import 'package:reactive_forms/reactive_forms.dart';

import 'package:todo_list/domain/entities/task_type.dart';
import 'package:todo_list/presentation/blocs/task/task_cubit.bloc.dart';
import 'package:todo_list/presentation/blocs/task_registration_form/task_registration_form_cubit.bloc.dart';
import 'package:todo_list/presentation/widgets/save_button.dart';

final class TaskRegistrationModal extends StatefulWidget {
  const TaskRegistrationModal({super.key});

  @override
  State<TaskRegistrationModal> createState() => _TaskRegistrationModalState();
}

final class _TaskRegistrationModalState extends State<TaskRegistrationModal> {
  var inSaveProgress = false;

  @override
  Widget build(BuildContext context) {
    final taskCubit = context.read<TaskCubit>();
    final taskRegistrationFormCubit = context.read<TaskRegistrationFormCubit>();

    final taskRegistrationForm = taskRegistrationFormCubit.state;

    Future<void> handleSaveRequested() async {
      if (taskRegistrationForm.invalid) {
        taskRegistrationForm.markAllAsTouched();
        return;
      }

      setState(() {
        inSaveProgress = true;
      });

      final task = taskRegistrationFormCubit.getModel();
      await taskCubit
          .save(task)
          .then((task) {
            // Add a loading service to block user input while saving...
            // ignore: use_build_context_synchronously
            if (Navigator.canPop(context)) {
              // Currently, just closes the dialog if it can be popped
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            }

            taskRegistrationFormCubit.reset();

            setState(() {
              inSaveProgress = false;
            });
          })
          .catchError((err) {
            setState(() {
              inSaveProgress = false;
            });
          });
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: ReactiveForm(
        formGroup: taskRegistrationForm,
        child: Column(
          spacing: 12,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  'Nova tarefa',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF424242),
                  ),
                ),
                ReactiveTextField(
                  formControl: taskRegistrationFormCubit.titleControl,
                  decoration: InputDecoration(labelText: 'Título'),
                  validationMessages: {
                    ValidationMessage.required: (error) => 'Obrigatório.',
                  },
                  minLines: 1,
                  maxLines: 1,
                  maxLength: 50,
                  style: const TextStyle(color: Color(0xFF424242)),
                ),
                ReactiveTextField(
                  formControl: taskRegistrationFormCubit.descriptionControl,
                  decoration: InputDecoration(labelText: 'Descrição'),
                  minLines: 1,
                  maxLines: 3,
                  maxLength: 200,
                  style: const TextStyle(color: Color(0xFF424242)),
                ),
                ReactiveDropdownField(
                  formControl: taskRegistrationFormCubit.statusControl,
                  decoration: InputDecoration(labelText: 'Status'),
                  items: TaskStatus.values
                      .map(
                        (status) => DropdownMenuItem(
                          value: status,
                          child: Text(
                            status.getDescription,
                            style: const TextStyle(color: Color(0xFF424242)),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
            ReactiveFormConsumer(
              builder: (context, formGroup, child) {
                return SaveButton(
                  disabled: inSaveProgress || !formGroup.dirty,
                  onPressed: handleSaveRequested,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
