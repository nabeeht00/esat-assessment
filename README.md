🧑‍💼 User Management System

ASP.NET Core Web API + Flutter Mobile Application

This repository contains both the backend Web API (Clean Architecture) and the Flutter mobile application in a single solution.
The API manages users, roles, authentication etc., while the Flutter app provides a mobile UI for accessing these services.

📁 Project Structure
Root Folder
│
├── UserManagement.API               # Entry point for ASP.NET Core Web API
├── UserManagement.Application       # Application layer (CQRS, DTOs, Services)
├── UserManagement.Domain            # Entities, Interfaces, Business rules
├── UserManagement.Infrastructure    # EF Core, DB Context, Repositories
│
└── user_management                  # Flutter App (Frontend)


Frontend Setup – Flutter App
🔧 Prerequisites

Flutter SDK (Stable channel recommended)
Android Studio / VS Code
Dart 3+

Go to Flutter project:
🔗 Configure API Base URL in Flutter

You must update the API base URL before running the app:

📍 user_management/lib/core/config/app_config.dart
class AppConfig {
  static const String baseUrl = "http://YOUR_LOCALHOST_OR_SERVER_URL/api";
}
