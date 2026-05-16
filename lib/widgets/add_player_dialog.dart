import 'package:flutter/cupertino.dart';

import 'liquid_glass/liquid_glass_container.dart';

class AddPlayerDialog extends StatefulWidget {
  const AddPlayerDialog({super.key});

  @override
  State<AddPlayerDialog> createState() => _AddPlayerDialogState();
}

class _AddPlayerDialogState extends State<AddPlayerDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return CupertinoAlertDialog(
      title: Text(
        'Новый игрок',
        style: theme.textTheme.navTitleTextStyle.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: LiquidGlassContainer(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          borderRadius: BorderRadius.circular(12),
          blur: 12,
          child: CupertinoTextField(
            controller: _controller,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            placeholder: 'Введите имя',
            style: theme.textTheme.textStyle,
            placeholderStyle: theme.textTheme.textStyle.copyWith(
              color: isDark
                  ? CupertinoColors.systemGrey
                  : CupertinoColors.systemGrey2,
            ),
            decoration: null,
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                Navigator.of(context).pop(value.trim());
              }
            },
          ),
        ),
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            final name = _controller.text.trim();
            if (name.isNotEmpty) {
              Navigator.of(context).pop(name);
            }
          },
          child: const Text('Добавить'),
        ),
      ],
    );
  }
}
