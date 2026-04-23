# Repository Guidelines

## Project Structure & Module Organization

This repository contains a Flutter mobile app and supporting product docs.

- `app/`: Flutter application for Android and iOS
- `app/lib/`: source code
  - `core/`: app-wide routing, theme, utilities, errors
  - `data/`: database, parsers, services, repositories
  - `domain/`: entities, value objects, use cases
  - `features/`: feature-first UI and logic (`bookshelf/`, `reader/`, `settings/`, etc.)
- `app/test/`: widget and future unit tests
- `docs/`: planning, UI specs, technical design, and task breakdowns

Keep new code inside the existing `feature-first + layered` structure. Avoid dumping feature logic into `core/`.

## Build, Test, and Development Commands

Run commands from `app/` unless noted otherwise.

- `flutter pub get`: install dependencies
- `flutter run`: run locally on a simulator or device
- `flutter analyze`: run static analysis with repo lint rules
- `flutter test`: run widget tests
- `dart run build_runner build --delete-conflicting-outputs`: regenerate Drift code

Example:

```bash
cd app
flutter analyze
flutter test
```

## Coding Style & Naming Conventions

- Follow `app/analysis_options.yaml`
- Use 2-space Dart indentation and package imports (`package:pocketread/...`)
- Types: `PascalCase`
- variables, methods, files, directories: `snake_case`
- Prefer `final` locals and explicit return types
- Avoid `print`; use structured logging later if needed

Keep widgets small and feature-local. Put reusable app-wide styling in `core/theme/`.

## Testing Guidelines

Use Flutter’s `flutter_test` package. Add tests in `app/test/` and name them `*_test.dart`.

- Widget tests should cover visible page shell states and critical flows
- Update tests when UI text or navigation changes
- Run `flutter test` before every commit touching `app/lib/`

## Commit & Pull Request Guidelines

Follow the existing Conventional Commits style seen in history:

- `feat(app): initialize flutter mobile project skeleton`
- `docs: add execution plan and technical design`
- `chore: reset repository to current local project`

PRs should include:

- short summary of changes
- affected paths/modules
- test results (`flutter analyze`, `flutter test`)
- screenshots for UI changes
- linked issue or task ID when applicable

## Security & Configuration Tips

Do not commit secrets, local machine config, or generated build artifacts. Keep platform-specific local files ignored. Review `app/.gitignore` before adding new tooling outputs.
