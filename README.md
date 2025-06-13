# 📝 NotesApp

A simple iOS note-taking app built using UIKit and CoreData. Notes can be pinned, unpinned, edited, deleted, and shared. It features a clean user interface and supports searching notes by title or content.

---

## 🚀 Features

- 📌 Pin & unpin notes
- 🗑️ Swipe to delete
- 📤 Share notes via iOS share sheet
- 🔍 Search notes (title and content)
- 🧠 Notes are split into **title** (first line) and **content** (rest of the text)
- 📅 Shows formatted creation time/date
- 📂 Data is persisted using CoreData

---
## 📸 Demo Video

📽️ [Watch the demo](demo.mp4)

---
## 🧱 Architecture

- **MVC (Model-View-Controller)** pattern
- **Core Data** for local persistence
- Custom `UITableViewCell` for note display
- Navigation via `UINavigationController`
- UISearchBar for real-time filtering

---
## 🛠 How to Run
1. Clone this repo
2. Open `NotesApp.xcodeproj` in Xcode
3. Build & run on iPhone Simulator or device
 
---
## 🧰 Tech Stack

- 💻 Language: Swift 5.8
- 📱 UI Framework: UIKit
- 💾 Persistence: CoreData
- 🛠 IDE: Xcode 15
- 📱 Platform: iOS 15+

---
## 📁 Project Structure
NotesApp/
├── Controllers/                 # View controllers (VC logic)
│   ├── NotesTableViewController.swift
│   └── NoteViewController.swift
│
├── Models/                      # Data models and persistence
│   ├── NotesApp.xcdatamodeld    # Core Data schema
│   └── CoreData/                # Core Data manager
│       └── CoreDataManager.swift
│
├── Views/                       # UI components (xibs, cells)
│   ├── NotesTableViewCell.xib
│   └── NotesTableViewCell.swift
│
├── Assets.xcassets              # Image and color assets
├── Info.plist                   # App configuration
├── AppDelegate.swift            # App lifecycle
├── SceneDelegate.swift          # Scene lifecycle
├── Base.lproj/                  # Storyboards or localized resources
├── NotesApp.xcodeproj           # Xcode project file
└── README.md                    # Project documentation
