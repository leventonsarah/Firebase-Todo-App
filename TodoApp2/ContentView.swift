//
//  ContentView.swift
//  TodoApp2
//
//  Created by sarah leventon on 2025-01-17.
//

import SwiftUI

struct ContentView: View {
    @State private var todos: [Todo] = []
    @State private var isAddingTodo = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    private let firestoreService = FirestoreService()

    var body: some View {
        NavigationView {
            List {
                ForEach(todos) { todo in
                    HStack {
                        Text(todo.title)
                        Spacer()
                        Button(action: {
                            toggleTodoCompletion(todo)
                        }) {
                            Text(todo.isCompleted ? "✓" : "✗")
                                .font(.title2)
                                .foregroundColor(todo.isCompleted ? .green : .red)
                                .padding(8)
                                .background(Circle().fill(todo.isCompleted ? Color.green.opacity(0.2) : Color.red.opacity(0.2)))
                        }
                    }
                }
                .onDelete(perform: deleteTodo)
            }
            .navigationTitle("Todos")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isAddingTodo = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .onAppear {
                loadTodos()
            }
            .sheet(isPresented: $isAddingTodo) {
                AddTodoView(firestoreService: firestoreService, onSave: {
                    isAddingTodo = false
                    loadTodos()
                })
            }
            .alert("Error", isPresented: $showAlert, actions: {
                Button("OK", role: .cancel) {}
            }, message: {
                Text(alertMessage)
            })
        }
    }

    private func loadTodos() {
        firestoreService.fetchTodos { fetchedTodos, error in
            DispatchQueue.main.async {
                if let error = error {
                    alertMessage = "Error fetching todos: \(error.localizedDescription)"
                    showAlert = true
                    return
                }
                withAnimation {
                    todos = fetchedTodos ?? []
                }
            }
        }
    }

    private func deleteTodo(at offsets: IndexSet) {
        offsets.forEach { index in
            let todo = todos[index]
            if let id = todo.id {
                firestoreService.deleteTodo(id) { error in
                    DispatchQueue.main.async {
                        if let error = error {
                            alertMessage = "Error deleting todo: \(error.localizedDescription)"
                            showAlert = true
                        } else {
                            withAnimation {
                                todos.remove(at: index)
                            }
                        }
                    }
                }
            } else {
                alertMessage = "Error: Todo ID not found."
                showAlert = true
            }
        }
    }

    private func toggleTodoCompletion(_ todo: Todo) {
        var updatedTodo = todo
        updatedTodo.isCompleted.toggle()
        firestoreService.updateTodo(updatedTodo) { error in
            if let error = error {
                alertMessage = "Error updating todo: \(error.localizedDescription)"
                showAlert = true
                return
            }
            loadTodos()
        }
    }
}

#Preview {
    ContentView()
}
