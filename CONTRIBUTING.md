# Contributing to Carto

Thank you for your interest in contributing! Carto is a project built with a focus on high-quality UX/UI and a maintainable, scalable architecture.

## How to Contribute
- **Fork the repository**: Create your own copy of the project.
- **Branching**: Create a new branch from `main` for your feature or fix.
- **Implementation**: Ensure your changes align with the project's architectural principles.
- **Commit**: Use clear, descriptive commit messages.
- **Pull Request**: Open a PR with a detailed description of your changes.

## Development Guidelines

To maintain the quality and consistency of the project, please follow these guidelines:

### 1. Architectural Consistency
- **Separation of Concerns**: Keep the UI (Screens/Widgets) strictly separated from business logic (Providers).
- **Unidirectional Data Flow**: Ensure all state updates follow the flow: UI → Provider → State Update → UI.
- **Models**: Define clear data structures for any new entities to facilitate communication between layers.

### 2. UX/UI & Design System
- **Visual Tokens**: Use the established system for spacing (8, 12, 16, 24, 32 px), typography, and colors to ensure consistency.
- **Reusability**: Before creating a new widget, check if an existing component can be reused or extended.
- **Feedback**: Ensure any new interactive elements provide clear visual feedback to the user.

### 3. State Management & Persistence
- **Providers**: Use `ChangeNotifier` and the `Provider` package for state management.
- **Data Continuity**: If adding new user-related features, integrate local persistence within the relevant Provider to maintain state between sessions.

## Issues & Bug Reports
- **Search First**: Check existing issues before opening a new one to avoid duplicates.
- **Detail**: Provide clear reproduction steps, environment details, and screenshots if the issue is related to the UI.

## Security
- If you find a security vulnerability, please follow our **Security Policy** and do not open a public issue.

Thank you for helping us build a better, cleaner shopping experience! :)