import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/time_entry.dart';
import '../providers/project_task_provider.dart';
import '../providers/time_entry_provider.dart';

class AddTimeEntryScreen extends StatefulWidget {
  @override
  _AddTimeEntryScreenState createState() => _AddTimeEntryScreenState();
}

class _AddTimeEntryScreenState extends State<AddTimeEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _projectId;
  String? _taskId;
  double _totalTime = 0.0;
  DateTime _date = DateTime.now();
  String _notes = '';

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectTaskProvider>(context);
    final timeEntryProvider = Provider.of<TimeEntryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Time Entry'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Project Dropdown
              Text('Project', style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButton<String>(
                value: _projectId,
                hint: Text('Select Project'),
                isExpanded: true,
                items: projectProvider.projects.map((project) {
                  return DropdownMenuItem<String>(
                    value: project.id,
                    child: Text(project.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _projectId = value;
                    _taskId = null; // Reset task when project changes
                  });
                },
              ),
              SizedBox(height: 16),
              // Task Dropdown
              Text('Task', style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButton<String>(
                value: _taskId,
                hint: Text('Select Task'),
                isExpanded: true,
                items: projectProvider.tasks
                    .where((task) =>
                        _projectId == null || task.projectId == _projectId)
                    .map((task) {
                  return DropdownMenuItem<String>(
                    value: task.id,
                    child: Text(task.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _taskId = value;
                  });
                },
              ),
              SizedBox(height: 16),
              // Date Picker
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Date: ${DateFormat('yyyy-MM-dd').format(_date)}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _date,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _date = pickedDate;
                        });
                      }
                    },
                    child: Text('Select Date', style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Total Time
              Text('TOTAL TIME (in hours)', style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter hours',
                ),
                onChanged: (value) {
                  _totalTime = double.tryParse(value) ?? 0.0;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter total time';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Notes
              Text('Note', style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Enter notes',
                ),
                onChanged: (value) {
                  _notes = value;
                },
              ),
              SizedBox(height: 16),
              // Save Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() && _projectId != null && _taskId != null) {
                    timeEntryProvider.addTimeEntry(
                      _projectId!,
                      _taskId!,
                      _totalTime,
                      _date,
                      _notes,
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text('SAVE TIME ENTRY'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Updated from primary
                  foregroundColor: Colors.white, // Updated from onPrimary
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}