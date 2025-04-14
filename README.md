# ⏱️ Time Tracker

Time Tracker is a **Flutter-based mobile application** designed to help users track time spent on various **projects** and **tasks**. The app features project/task management, detailed time entry logging, and data persistence via **SharedPreferences**. With a **clean teal and yellow interface**, the app offers a simple, user-friendly experience.

---

## 📱 Features

### ✅ Project & Task Management
- Add, view, and delete **projects** (e.g., Project Alpha, Project Beta, Project Gamma).
- Add, view, and delete **tasks** associated with each project.

### ⏰ Time Entry Tracking
- Log time with details: project, task, total time (hours), date, and notes.
- View all entries as a **flat list** or **grouped by project**.
- Delete entries with a confirmation dialog.

### 💾 Local Storage
- Persist data using `SharedPreferences`.
- Retains all user-added projects, tasks, and entries between sessions.

### 🖌️ User Interface
- Tabbed layout:  
  - `ALL ENTRIES`: View all logs.  
  - `GROUPED BY PROJECTS`: View entries grouped by projects.
- Drawer for navigating to **Project** and **Task** management screens.
- Dialogs for adding and deleting items.
- Teal app bars, yellow FABs, and minimalistic layout.

---

## 🧰 Dependencies

| Package             | Version    | Purpose                       |
|---------------------|------------|-------------------------------|
| `flutter`           | SDK        | Core framework                |
| `provider`          | ^6.0.0     | State management              |
| `shared_preferences`| ^2.0.0     | Local storage persistence     |
| `intl`              | ^0.17.0    | Date formatting               |

---

## 🚀 Setup Instructions

### 1. Clone the Repository

git clone https://github.com/srimalonlinez/time-tracker

cd time-tracker

### 2. Install Dependencies

flutter pub get

### 3. Run the App

For Web:
flutter run -d chrome

For Emulator or Device:
flutter run

📝 Usage Guide

➕ Add a Time Entry
Tap the yellow "+" FAB on the home screen.
Fill out the form:
Select a project & task
Choose a date
Input total time and notes
Tap Save.

⚙️ Manage Projects/Tasks
Open the drawer.
Navigate to Projects or Tasks.
Add new items or delete existing ones.

📄 View Time Entries
Switch tabs at the top:
ALL ENTRIES → View all logs
GROUPED BY PROJECTS → Organized by project

### Notes

The app initializes with default projects and tasks:
    Projects: Project Alpha, Beta, Gamma
    Tasks: Related to each project

All entries display essential details:
    Project / Task
    Total Time
    Date
    Notes

Data is stored locally and remains available across sessions.