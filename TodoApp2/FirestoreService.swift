//
//  FirestoreService.swift
//  TodoApp2
//
//  Created by sarah leventon on 2025-01-17.
//

import FirebaseFirestore

class FirestoreService {
    private let db = Firestore.firestore()
    
    func addTodo(_ todo: Todo, completion: @escaping (Error?) -> Void) {
        do {
            let newTodo = Todo(
                        id: UUID().uuidString,
                        title: todo.title,
                        isCompleted: todo.isCompleted
                    )
            try db.collection("todos").document(newTodo.id!).setData(from: newTodo) { error in
                completion(error)
            }
        } catch let error {
            completion(error)
        }
    }
    
    func fetchTodos(completion: @escaping ([Todo]?, Error?) -> Void) {
        db.collection("todos").getDocuments { (snapshot, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            let todos = snapshot?.documents.compactMap { doc -> Todo? in
                try? doc.data(as: Todo.self)
            }
            completion(todos, nil)
        }
    }
    
    func updateTodo(_ todo: Todo, completion: @escaping (Error?) -> Void) {
        guard let id = todo.id else {
            completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "ID is missing"]))
            return
        }
        do {
            try db.collection("todos").document(id).setData(from: todo) { error in
                completion(error)
            }
        } catch let error {
            completion(error)
        }
    }
    
    func deleteTodo(_ id: String, completion: @escaping (Error?) -> Void) {
        db.collection("todos").document(id).delete { error in
            completion(error)
        }
    }
}
