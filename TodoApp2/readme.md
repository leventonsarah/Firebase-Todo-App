# Firestore todo app

## Description
This is a user-friendly todo app built using SwiftUI and Firestore. It allows users to create, update and delete todos and updates the database accordingly. 

## Features
### 1. View todos
The homepage displays all todos once they are added. From there, one can view the title and status of the todo, and swipe to delete it.
![view todos](ss/homepage.png)

### 2. Add todos
A sheet appears, allowing the user to enter the title of a todo. It will not be created unless a title is added.
![add todo](ss/addtodoview.png)
![error msg](ss/emptytodo.png)

### 3. Update status
By pressing on the checkmark or cross, the todo's status changes from completed to incomplete, and vice-versa.
![mark as completed](ss/complete.png)
![mark as incomplete](ss/incomplete.png)
The Firestore database is updated accordingly:
![updated database](ss/completed-db.png)

### 4. Delete todos
Swipe left on the todo to delete it.
![delete todo](ss/delete.png)
The todo is deleted from the database as well:
![deleted from db](ss/deleted.png)
