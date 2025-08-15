//
//  StorageType.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/14/25.
//



enum StorageType: String, Codable {
    case refrigerated = "Soğukta"
    case frozen = "Dondurucuda"
    case dryPlace = "Kuru Yerde"
    case roomTemperature = "Oda Sıcaklığında"
    case cellar = "Kiler/Mahzende"
}