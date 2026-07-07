# Enrollment Management System (EMS) 📱

A real-time, role-based mobile application built with Flutter and Firebase, designed to streamline academic enrollments and manage student data dynamically.

This project was developed with a strict focus on software architecture patterns, global state management, and real-time database synchronization to ensure scalability and data integrity.

## ⚙️ Tech Stack

- **Framework:** Flutter (Dart)
- **Backend as a Service (BaaS):** Firebase Auth, Cloud Firestore
- **Architecture Pattern:** MVC (Model-View-Controller)
- **State Management:** `provider` (Global State), `StreamBuilder` (Reactive UI)

## 🏗️ Core Architecture & Features

### 1. Role-Based Access Control (RBAC)

Implemented a strict separation between Authentication (Identity) and Authorization (Business Logic). Users are classified into specific roles (e.g., Admin, Teacher, Student) using secure UID-binding to a protected Firestore collection.

### 2. Real-Time Synchronization via WebSockets

The presentation layer is fully decoupled from the database. By utilizing `StreamBuilder`, the UI subscribes to Firestore WebSockets. Any mutation in the cloud database triggers an isolated, real-time rebuild of the necessary widgets, eliminating the need for manual HTTP polling and reducing unnecessary render cycles.

### 3. Data Denormalization for Read Optimization

In the NoSQL environment (Cloud Firestore), the data models were specifically denormalized. By selectively duplicating critical referential data into the `Matricula` documents, the system entirely avoids the N+1 Query problem, minimizing read operations and optimizing operational costs.

## 🚀 Local Installation & Setup

> **Security Notice:** The API keys have been removed from this public repository to comply with standard DevOps security practices.

To run this project locally:

1. Clone the repository: `git clone <your_repo_url>`
2. Navigate to the project root and run `flutter pub get`
3. Locate the `lib/firebase_options.example.dart` file.
4. Duplicate the file and rename the copy to `lib/firebase_options.dart`.
5. Replace the placeholder strings with your own Firebase Project API keys.
6. Run the application: `flutter run`

## 🧠 Technical Debt & Future Iterations

In order to deliver a functional MVP within a strict 72-hour deadline, a _Passive Enrollment_ strategy was implemented utilizing plain-text email bindings rather than cryptographic UUIDs to relate offline students to their records.

**V2 Roadmap:**

- Migrate the enrollment logic to a secure Node.js backend using **Firebase Admin SDK** / Cloud Functions to handle identity creation securely without dropping the active Admin session.
- Implement robust local caching (SQLite integration) for offline functionality during network latency spikes.

---

_Developed by an undergraduate Computer Science researcher and Applied Informatics teaching assistant._
