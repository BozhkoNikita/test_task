import 'package:flutter/material.dart';

import '../../domain/entities/task.dart';
import 'colors.dart';
import 'constants.dart';

typedef TaskSaveCallback = void Function(String);

class AppBottomSheet {
  static void showSheet({
    required BuildContext context,
    required TaskSaveCallback onSave,
    Task? task,
  }) {
    final _controller = TextEditingController(text: task?.title ?? '');
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: AppColors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppRadius.normal),
                topRight: Radius.circular(AppRadius.normal),
              ),
            ),
            padding: const EdgeInsets.all(AppDimens.normal),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  maxLines: 20,
                  minLines: 1,
                  cursorColor: AppColors.accent,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'New to-do',
                  ),
                  controller: _controller,
                ),
                const SizedBox(height: AppDimens.small),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      primary: AppColors.accent,
                    ),
                    onPressed: () {
                      if (_controller.text.isNotEmpty) onSave(_controller.text);
                      Navigator.pop(context);
                    },
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
