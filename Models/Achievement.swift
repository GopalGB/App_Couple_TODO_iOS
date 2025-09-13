//
//  Achievement.swift
//  TogetherList
//

import Foundation

struct Achievement: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let icon: String
    let unlockedDate: Date
}