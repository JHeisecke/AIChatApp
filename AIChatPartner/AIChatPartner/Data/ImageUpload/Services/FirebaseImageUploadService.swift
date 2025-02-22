//
//  FirebaseImageUploadService.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-02-19.
//

import SwiftUI
import FirebaseStorage

protocol ImageUploadService {
    func uploadImage(image: UIImage, path: String) async throws -> URL
}

struct FirebaseImageUploadService {
    func uploadImage(image: UIImage, path: String) async throws -> URL {
        guard let data = image.jpegData(compressionQuality: 1) else {
            throw ImageUploadError.imageCompressionError
        }

        try await saveImageToFirebase(data: data, path: path)
        return try await imageReference(path: path).downloadURL()
    }

    private func imageReference(path: String) -> StorageReference {
        let name = "\(path).jpg"
        return Storage.storage().reference(withPath: name)
    }

    @discardableResult
    private func saveImageToFirebase(data: Data, path: String) async throws -> URL {
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"

        let returnedMeta = try await imageReference(path: path).putDataAsync(data, metadata: meta)

        guard let returnedPath = returnedMeta.path, let url = URL(string: returnedPath) else {
            throw ImageUploadError.badImagePath
        }

        return url
    }

    enum ImageUploadError: LocalizedError {
        case imageCompressionError
        case badImagePath
    }
}
