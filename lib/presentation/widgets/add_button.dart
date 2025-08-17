import 'package:flutter/material.dart';

import 'package:todo_list/presentation/widgets/button.dart';

final class AddButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool disabled;

  const AddButton({
    super.key,
    this.text = 'Adicionar',
    required this.onPressed,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Button(
      text: text,
      onPressed: onPressed,
      icon: Icons.add,
      iconColor: const Color(0xFF424242),
      textColor: const Color(0xFF424242),
      backgroundColor: null,
      disabled: disabled,
    );
  }
}
