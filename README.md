# Campus Lost & Found — Flutter App

Student Name: Zenebu Melaku
Student ID: UGR/6058/16
Section: 2

## Overview

A Flutter mobile application that allows campus students to report, browse, update, and delete lost and found items. The app performs full **CRUD (Create, Read, Update, Delete)** operations against a live public REST API hosted on [mockapi.io](https://mockapi.io).

---

## API

- **Base URL:** `https://6a083b81fa9b27c848fac459.mockapi.io/items`
- **Type:** Public REST API (mockapi.io)

| Operation      | Method   | Endpoint     |
| -------------- | -------- | ------------ |
| Read all items | `GET`    | `/items`     |
| Create item    | `POST`   | `/items`     |
| Update item    | `PUT`    | `/items/:id` |
| Delete item    | `DELETE` | `/items/:id` |

---

## Project Structure

```
lib/
├── main.dart                  # App entry point, Provider setup
├── models/
│   └── item_model.dart        # LostFoundItem data model
├── providers/
│   └── item_provider.dart     # State management (ChangeNotifier)
├── screens/
│   ├── home_screen.dart       # Main screen — list, search, filter
│   └── add_edit_item_screen.dart  # Create / Update form screen
├── services/
│   └── api_service.dart       # HTTP CRUD operations
└── widgets/
    ├── item_card.dart         # Individual item card widget
    └── status_badge.dart      # Reusable badge widget
```

---

## State Management

The app uses the **Provider** package for state management:

- `ItemProvider` extends `ChangeNotifier`
- Manages the list of items, loading state, error messages, search query, and filter selection
- All UI widgets listen to `ItemProvider` via `context.watch<ItemProvider>()`
- Mutations (add, edit, delete) call `notifyListeners()` to rebuild the UI

---

## Features

- **View** all lost & found items fetched from the live API
- **Search** items by title or location in real time
- **Filter** items by type (Lost / Found) or status (Active / Claimed)
- **Report** a new lost or found item via a form
- **Edit** any existing item
- **Delete** any item with a confirmation dialog
- **Error handling** with retry button when network fails
- **Loading indicator** while data is being fetched

---

## Screenshots

### Home Screen

![Home Screen](screenshots/home.png)

### Add Item Screen

![Add Item](screenshots/add.png)

### Edit Item Screen

![Edit Item](screenshots/edit.png)

### Delete Confirmation

![Delete](screenshots/delete.png)

---

## How to Run

1. **Clone the repository**

   ```bash
   git clone <your-repo-url>
   cd lost_found
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## Tech Stack

- **Framework:** Flutter (Dart)
- **State Management:** Provider
- **Networking:** http package
- **API:** mockapi.io (public REST API)
