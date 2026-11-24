# Laboratory Activity 9: Student Records Management with Cloud Firestore

**Student Name:** Alvin Legarbes  
**Project:** legarbes_navigation_app  
**Repository:** [LabAct9](https://github.com/GodlyMori/LabAct9.git)

---

## Activity Overview
A Firebase-enabled Flutter application implementing a Student Records Management module with Cloud Firestore. The module supports full CRUD operations (Create, Read, Update, Delete) synchronized in real-time, secured with Firestore Security Rules, and backed by Firebase Anonymous Authentication.

---

## Testing Table

| Test | Expected Result | Pass/Fail |
| :--- | :--- | :--- |
| **Open Student Records.** | Form and record list appear. | **Pass** |
| **Submit empty fields.** | Validation prevents saving. | **Pass** |
| **Add a valid record.** | Record appears in the list and Firestore. | **Pass** |
| **Edit an existing record.** | Selected values fill the form. | **Pass** |
| **Save an update.** | Existing document changes. | **Pass** |
| **Cancel editing.** | Form returns to Add Student mode. | **Pass** |
| **Cancel deletion.** | Record remains. | **Pass** |
| **Confirm deletion.** | Record is removed. | **Pass** |
| **Leave and reopen the page.** | Saved records load again. | **Pass** |

---

## Guide Questions & Answers

### 1. What is the difference between a collection and a document?
In Cloud Firestore, a **collection** is a container or group of documents, functioning like a table or directory that cannot hold raw data fields directly. A **document** is the individual unit of storage containing specific data fields organized as key-value pairs. While documents can host subcollections to create hierarchical data structures, collections strictly hold documents.

### 2. Why do Update and Delete need the document ID?
Cloud Firestore uniquely identifies and addresses each individual record within a collection by its **document ID**. The Update and Delete operations require this identifier to know precisely which document to mutate or remove without modifying or affecting other records. Without a specific document ID, Firestore cannot determine the target path in the collection hierarchy.

### 3. What does `snapshots()` provide to the application?
The `snapshots()` method provides a continuous, real-time asynchronous `Stream` of query snapshots representing the live state of a collection or document. Whenever a document is added, updated, or deleted in Firestore, the stream automatically broadcasts the new data to client listeners. This allows UI widgets such as `StreamBuilder` to immediately rebuild and reflect database changes without requiring manual refresh.

### 4. How does input validation prevent incomplete records?
Input validation enforces rules at both the client interface and database levels before data persistence occurs. In the Flutter UI, `formKey.currentState!.validate()` ensures that fields are non-empty and within character limits before sending a request. Simultaneously, Firestore security rules validate incoming payloads using conditions like `hasAll(['name', 'course'])` and string length checks, rejecting any incomplete or malformed requests at the server level.

### 5. How does this Firestore application differ from storing records in a Dart list?
Storing records in a local Dart list only keeps data in memory during runtime, meaning all changes are lost as soon as the application is closed or reloaded. In contrast, Cloud Firestore stores records permanently in the cloud, preserving data across app restarts, device reboots, and multiple sessions. Furthermore, Firestore enables multi-device synchronization, real-time live streams, and strict security rules that local lists cannot provide.

---

## Features Implemented
* **Firebase Anonymous Authentication**: Transparently authenticates the user upon application launch to secure user-scoped database operations.
* **Real-Time Cloud Firestore Sync**: Reads live student records from `users/{userId}/students`.
* **Form Validation**: Validates inputs with clear error messages.
* **Confirmation Dialogs**: Confirms before deleting student records to prevent accidental deletions.
* **Material 3 UI**: Matches modern UI theming and integrates seamlessly into the Dashboard.
