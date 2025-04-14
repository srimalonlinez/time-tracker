import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../dialogs/delete_dialog.dart';
import '../models/project.dart';
import '../models/task.dart';
import '../providers/project_task_provider.dart';

class ProjectTaskManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectTaskProvider>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(''), // Will be set dynamically based on tab
          bottom: TabBar(
            tabs: [
              Tab(text: 'MANAGE PROJECTS'),
              Tab(text: 'MANAGE TASKS'),
            ],
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.yellow[700],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Manage Projects
            ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: projectProvider.projects.length,
              itemBuilder: (context, index) {
                final project = projectProvider.projects[index];
                return ListTile(
                  title: Text(project.name),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final confirm = await showDeleteDialog(context, 'project');
                      if (confirm == true) {
                        projectProvider.deleteProject(project.id);
                      }
                    },
                  ),
                );
              },
            ),
            // Tab 2: Manage Tasks
            ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: projectProvider.tasks.length,
              itemBuilder: (context, index) {
                final task = projectProvider.tasks[index];
                return ListTile(
                  title: Text(task.name),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final confirm = await showDeleteDialog(context, 'task');
                      if (confirm == true) {
                        projectProvider.deleteTask(task.id);
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final tabIndex = DefaultTabController.of(context)!.index;
            _showAddDialog(context, tabIndex == 0 ? 'Project' : 'Task');
          },
          child: Icon(Icons.add),
          tooltip: 'Add Project or Task',
        ),
      ),
    );
  }

  void _showAddDialog(BuildContext context, String type) {
    final projectProvider = Provider.of<ProjectTaskProvider>(context, listen: false);
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add $type'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: '$type Name',
              border: UnderlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  if (type == 'Project') {
                    projectProvider.addProject(controller.text);
                  } else {
                    projectProvider.addTask(controller.text);
                  }
                  Navigator.pop(context);
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}