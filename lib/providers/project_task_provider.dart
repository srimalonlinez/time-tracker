import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/project.dart';
import '../models/task.dart';

class ProjectTaskProvider with ChangeNotifier {
  List<Project> _projects = [];
  List<Task> _tasks = [];

  List<Project> get projects => _projects;
  List<Task> get tasks => _tasks;

  ProjectTaskProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? projectsString = prefs.getString('projects');
    final String? tasksString = prefs.getString('tasks');
    if (projectsString != null) {
      final List<dynamic> projectsJson = jsonDecode(projectsString);
      _projects = projectsJson.map((json) => Project.fromJson(json)).toList();
    }
    if (tasksString != null) {
      final List<dynamic> tasksJson = jsonDecode(tasksString);
      _tasks = tasksJson.map((json) => Task.fromJson(json)).toList();
    }
    if (_projects.isEmpty) {
      _projects.addAll([
        Project(id: '1', name: 'Project Mahinda'),
        Project(id: '2', name: 'Project Gotabhaya'),
        Project(id: '3', name: 'Project Namal'),
      ]);
      _saveProjects();
    }
    if (_tasks.isEmpty) {
      _tasks.addAll([
        Task(id: '1', name: 'Task A', projectId: '3'), // Associated with Project Namal
        Task(id: '2', name: 'Task B', projectId: '3'), // Associated with Project Namal
        Task(id: '3', name: 'Task C', projectId: '1'), // Associated with Project Mahinda
        Task(id: '4', name: 'Task 1', projectId: '1'), // Associated with Project Mahinda
        Task(id: '5', name: 'Task 2', projectId: '1'), // Associated with Project Mahinda
      ]);
      _saveTasks();
    }
    notifyListeners();
  }

  Future<void> _saveProjects() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('projects', jsonEncode(_projects.map((p) => p.toJson()).toList()));
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tasks', jsonEncode(_tasks.map((t) => t.toJson()).toList()));
  }

  void addProject(String name) {
    final newProject = Project(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
    );
    _projects.add(newProject);
    _saveProjects();
    notifyListeners();
  }

  void addTask(String name) {
    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
    );
    _tasks.add(newTask);
    _saveTasks();
    notifyListeners();
  }

  void deleteProject(String id) {
    _projects.removeWhere((project) => project.id == id);
    _tasks.removeWhere((task) => task.projectId == id);
    _saveProjects();
    _saveTasks();
    notifyListeners();
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    _saveTasks();
    notifyListeners();
  }
}