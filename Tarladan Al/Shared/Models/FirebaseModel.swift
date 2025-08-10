//
//  FirebaseModel.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/10/25.
//

protocol FirebaseModel: Codable, Identifiable {
    var id: String? { get set }
}
