import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskFormDialog extends StatefulWidget {
  final Task? initial;
  final Future<void> Function(Task task) onSubmit;

  const TaskFormDialog({super.key, this.initial, required this.onSubmit});

  @override
  State<TaskFormDialog> createState() => TaskFormDialogState();
}

class TaskFormDialogState extends State<TaskFormDialog> {
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late TaskStatus status;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.initial?.title ?? '');
    descriptionController = TextEditingController(text: widget.initial?.description ?? '');
    status = widget.initial?.status ?? TaskStatus.OPEN;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setDialogState) => AlertDialog(
        title: Text(widget.initial == null ? 'Nueva Tarea' : 'Editar Tarea'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration:
                  const InputDecoration(labelText: 'Título', prefixIcon: Icon(Icons.title_outlined)),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                  labelText: 'Descripción', prefixIcon: Icon(Icons.description_outlined)),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.flag_outlined, size: 20),
                const SizedBox(width: 8),
                const Text('Estado'),
                const Spacer(),
                DropdownButton<TaskStatus>(
                  value: status,
                  onChanged: (value) => setDialogState(() => status = value!),
                  items: TaskStatus.values.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status.displayName),
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              final String title = titleController.text.trim();
              final String description = descriptionController.text.trim();

              if (title.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: Colors.black),
                        SizedBox(width: 8),
                        Expanded(child: Text('El título es obligatorio')),
                      ],
                    ),
                  ),
                );
                return;
              }

              final task = Task(
                id: widget.initial?.id ?? 0,
                title: title,
                description: description.isEmpty ? 'Sin descripción' : description,
                status: status,
                userId: 1,
              );

              await widget.onSubmit(task);

              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}