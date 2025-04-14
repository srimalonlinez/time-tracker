import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../dialogs/delete_dialog.dart';
import '../models/project.dart';
import '../models/task.dart';
import '../models/time_entry.dart';
import '../providers/project_task_provider.dart';
import '../providers/time_entry_provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectTaskProvider>(context);
    final entryProvider = Provider.of<TimeEntryProvider>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Time Tracking'),
          actions: [
            // Add a temporary button to clear time entries
            IconButton(
              icon: Icon(Icons.clear_all),
              onPressed: () async {
                await entryProvider.clearEntries();
              },
              tooltip: 'Clear All Time Entries',
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: 'ALL ENTRIES'),
              Tab(text: 'GROUPED BY PROJECTS'),
            ],
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black54,
            indicatorColor: Colors.yellow[700],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.teal,
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.folder),
                title: Text('Projects'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/manage');
                },
              ),
              ListTile(
                leading: Icon(Icons.list),
                title: Text('Tasks'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/manage');
                },
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: All Entries
            entryProvider.entries.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.hourglass_empty,
                          size: 60,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No time entries yet!',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          'Tap the + button to add your first entry.',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: entryProvider.entries.length,
                    itemBuilder: (context, index) {
                      final entry = entryProvider.entries[index];
                      final project = projectProvider.projects.firstWhere(
                        (p) => p.id == entry.projectId,
                        orElse: () => Project(id: '', name: 'Unknown'),
                      );
                      final task = projectProvider.tasks.firstWhere(
                        (t) => t.id == entry.taskId,
                        orElse: () => Task(id: '', name: 'Unknown', projectId: ''),
                      );
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          title: Text(
                            '${project.name} - ${task.name}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('TOTAL TIME: ${entry.totalTime} hours'),
                              Text(
                                'Date: ${DateFormat('MMM d, yyyy').format(entry.date)}',
                              ),
                              Text('Note: ${entry.notes}'),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              final confirm = await showDeleteDialog(context, 'entry');
                              if (confirm == true) {
                                entryProvider.deleteTimeEntry(entry.id);
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
            // Tab 2: Grouped by Projects
            entryProvider.entries.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.hourglass_empty,
                          size: 60,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No time entries yet!',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          'Tap the + button to add your first entry.',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: projectProvider.projects.length,
                    itemBuilder: (context, index) {
                      final project = projectProvider.projects[index];
                      final projectEntries = entryProvider.entries
                          .where((e) => e.projectId == project.id)
                          .toList();
                      if (projectEntries.isEmpty) return SizedBox.shrink();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              project.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          ...projectEntries.map((entry) {
                            final task = projectProvider.tasks.firstWhere(
                              (t) => t.id == entry.taskId,
                              orElse: () => Task(id: '', name: 'Unknown', projectId: ''),
                            );
                            return Card(
                              margin: EdgeInsets.only(bottom: 4),
                              child: ListTile(
                                title: Text(
                                  ' - ${task.name}: ${entry.totalTime} hours (${DateFormat('MMM d, yyyy').format(entry.date)})',
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      );
                    },
                  ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/add_entry');
          },
          child: Icon(Icons.add),
          tooltip: 'Add Time Entry',
        ),
      ),
    );
  }
}