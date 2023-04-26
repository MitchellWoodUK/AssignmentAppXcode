//
//  Project.swift
//  AssignmentApp
//
//  Created by Mitchell Wood (Student) on 26/04/2023.
//

import Foundation

struct Project : Codable, Identifiable{
    let id: Int
    let name: String
    let description: String
    let start_date: String
    let end_date: String
    let user_id: Int
    
}
