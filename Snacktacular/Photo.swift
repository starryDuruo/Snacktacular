//
//  Photo.swift
//  Snacktacular
//
//  Created by Wang Sige on 3/27/26.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class Photo: Identifiable, Codable {
    @DocumentID var id: String?
    var imageURLString = ""
    var description = ""
    var reviewer: String = Auth.auth().currentUser?.email ?? ""
    var postedOn = Date()
    
    init(id: String? = nil, imageURLString: String = "", description: String = (Auth.auth().currentUser?.email ?? ""), reviewer: String = "", postedOn: Date = Date()) {
        self.id = id
        self.imageURLString = imageURLString
        self.description = description
        self.reviewer = reviewer
        self.postedOn = postedOn
    }
}

extension Photo {
    static var preview: Photo {
        let newPhoto = Photo(
            id: "1",
            imageURLString: "https://i.redd.it/hqcim9ti0u861.jpg",
            description: "my favorite meme",
            reviewer: "me",
            postedOn: Date()
        )
        return newPhoto
    }
}
