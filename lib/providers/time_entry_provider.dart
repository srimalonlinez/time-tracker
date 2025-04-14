import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/time_entry.dart';

class TimeEntryProvider with ChangeNotifier {
  List<TimeEntry> _entries = [];

  List<TimeEntry> get entries => _entries;

  TimeEntryProvider() {
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final String? entriesString = prefs.getString('timeEntries');
    if (entriesString != null) {
      final List<dynamic> entriesJson = jsonDecode(entriesString);
      _entries = entriesJson.map((json) => TimeEntry.fromJson(json)).toList();
    }
    notifyListeners();
  }

  Future<void> addTimeEntry(String projectId, String taskId, double totalTime, DateTime date, String notes) async {
    final newEntry = TimeEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      projectId: projectId,
      taskId: taskId,
      totalTime: totalTime,
      date: date,
      notes: notes,
    );
    _entries.add(newEntry);
    await _saveEntries();
    notifyListeners();
  }

  Future<void> deleteTimeEntry(String id) async {
    _entries.removeWhere((entry) => entry.id == id);
    await _saveEntries();
    notifyListeners();
  }

  // Add this method to clear all time entries
  Future<void> clearEntries() async {
    _entries.clear();
    await _saveEntries();
    notifyListeners();
  }

  Future<void> _saveEntries() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('timeEntries', jsonEncode(_entries.map((e) => e.toJson()).toList()));
  }
}