//
//  TodoModel.swift
//  TodoApp2
//
//  Created by sarah leventon on 2025-01-17.
//

import Foundation

struct Todo: Codable, Identifiable {
    let id: String?
    let title: String
    var isCompleted: Bool
}
