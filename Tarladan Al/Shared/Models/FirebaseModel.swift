//
//  FirebaseModel.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/10/25.
//
import FirebaseFirestore

protocol FirebaseModel: Codable, Hashable , Identifiable {
    var id: String? { get set  }
}
