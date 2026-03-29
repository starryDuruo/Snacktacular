//
//  PhotoViewModel.swift
//  Snacktacular
//
//  Created by Wang Sige on 3/27/26.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import SwiftUI
import FirebaseFirestore

class PhotoViewModel {
    
    static func saveImage(spot: Spot, photo: Photo, data: Data) async {
        guard let id = spot.id else {
            print("😡 ERROR: Should never have been called without a valid spot.id")
            return
        }
        let storage = Storage.storage().reference()
        let metadata = StorageMetadata()
        if photo.id == nil {
            photo.id = UUID().uuidString  //create filename for the photo
        }
        metadata.contentType = "image/jpeg"//allow image to be viewed in the browser from Firestore console
        let path = "\(id)/\(photo.id ?? "n/a")"
        
        do {
            let storageref = storage.child(path)
            let returnedMetaData = try await storageref.putDataAsync(data, metadata: metadata)
            print("Saved \(returnedMetaData)")
            guard let url = try? await storageref.downloadURL() else {
                print("😡 ERROR: Could not get downloadURL")
                return
            }
            photo.imageURLString = url.absoluteString
            print("photo.imageURLString: \(photo.imageURLString)")
            
            let db = Firestore.firestore()
            do {
                try db.collection("spots").document(id).collection("photos").document(photo.id ?? "n/a").setData(from: photo)
            } catch {
                print("😡 ERROR: Could not update data in spots/\(id)/photos/\(photo.id ?? "n/a"). \(error.localizedDescription)")
            }
        } catch {
            print("😡 ERROR saving photo to Storage \(error.localizedDescription)")
        }
    }
}
