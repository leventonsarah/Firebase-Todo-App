//
//  AddTodoView.swift
//  TodoApp2
//
//  Created by sarah leventon on 2025-01-17.
//

import SwiftUI

struct AddTodoView: View {
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var isCompleted = false
    @State private var showAlert = false
    let firestoreService: FirestoreService
    let onSave: () -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Details")) {
                    TextField("Title", text: $title)
                }
            }
            .navigationTitle("Add Todo")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if title.trimmingCharacters(in: .whitespaces).isEmpty {
                            showAlert = true
                        } else {
                            saveTodo()
                        }
                    }
                }
            }
            .alert("Error", isPresented: $showAlert, actions: {
                Button("OK", role: .cancel) {}
            }, message: {
                Text("Todo title cannot be empty.")
            })
        }
    }

    private func saveTodo() {
        let newTodo = Todo(id: nil, title: title, isCompleted: isCompleted)
        firestoreService.addTodo(newTodo) { error in
            if let error = error {
                print("Error adding todo: \(error.localizedDescription)")
                return
            }
            onSave()
        }
    }
}
