//
//  BarcodeProduct.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/19/25.
//
import Foundation

struct BarcodeProduct: Codable {
    var id : String
    var barcode : String
    var name : String
    var description : String
    var brand : String
    var image : Data?
}
