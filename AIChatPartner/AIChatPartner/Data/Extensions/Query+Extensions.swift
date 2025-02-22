//
//  Query+Extensions.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-02-22.
//

import Foundation
import FirebaseFirestore

extension Query {
    func getDocuments<T: Decodable>(as type: T.Type) async throws -> [T] {
        let snapshot = try await self.getDocuments()
        return try snapshot.documents.map { try $0.data(as: T.self) }
    }
}
