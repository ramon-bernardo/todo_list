import 'package:flutter/material.dart';

import 'package:todo_list/presentation/widgets/button.dart';

final class SaveButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool disabled;

  const SaveButton({
    super.key,
    this.text = 'Salvar',
    required this.onPressed,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Button(
      text: text,
      onPressed: onPressed,
      icon: Icons.save,
      iconColor: Colors.white,
      textColor: Colors.white,
      backgroundColor: const Color(0xFF1B5E20),
      disabled: disabled,
    );
  }
}
