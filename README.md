# Pterodactyl App

## Overview

Pterodactyl App is a mobile application developed using **Flutter** to enable seamless management of Pterodactyl-hosted servers from mobile devices. Since there is no official mobile application for Pterodactyl, this project was created to fill the gap and provide a user-friendly, open-source solution.

## Features

- **User Authentication**: Secure login using API keys from Pterodactyl.
- **Multi-Account Support**: Manage multiple Pterodactyl panel installations in one app.
- **Real-Time Console Access**: Send commands and view live console output.
- **File Management**: Navigate, edit, and delete files directly (excluding FTP operations).
- **Syntax-Highlighting File Editor**: Supports XML, JSON, YAML, and more.
- **Server Control**: Start, stop, and restart servers remotely.
- **Resource Monitoring**: View CPU and memory usage in real time.
- **Database Management**: View database credentials.
- **Dark Mode & Multi-Language Support**: Customizable themes and language settings.

## Technologies Used

- **Flutter & Dart** for cross-platform development.
- **GetX** for state management and navigation.
- **WebSockets** for real-time updates.
- **SQLite** for local storage.
- **Dartactyl API** for integration with Pterodactyl servers.
- Various Flutter libraries for UI enhancements and backend operations.

## Installation

### Prerequisites

- Install **Flutter** ([flutter.dev](https://flutter.dev/docs/get-started/install))
- Install **Android Studio** or **Visual Studio Code**
- Install **Git** ([git-scm.com](https://git-scm.com/downloads))

### Steps

1. Clone the repository:
   ```bash
   git clone https://github.com/educatalan02/pterodactyl_app.git
   ```
2. Navigate to the project directory and install dependencies:
   ```bash
   cd pterodactyl_app
   flutter pub get
   ```
3. Run the application:
   ```bash
   flutter run
   ```

## Documentation

For full details on features, implementation, and usage, refer to the **original documentation**: [Full Documentation]([docs](https://github.com/educatalan02/pterodactyl_app/tree/main/docs/documentation.md)

## Contribution

This project is open-source, and contributions are welcome! Feel free to submit pull requests or open issues.

## License

MIT License

