//
//  PrayerTimeService.swift
//  SeherVakti
//
//  Created by Hamit Sulucan on 27.04.2026.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class PrayerTimeService {
    static let shared = PrayerTimeService()
    private init() {}
    
    /// Belirli bir şehir için bugünün namaz vakitlerini getirir
    /// - Parameters:
    ///   - city: Kullanıcının seçtiği şehir
    ///   - country: Ülke (Varsayılan Türkiye)
    func fetchDailyTimings(city: String, country: String = "Turkey") async throws -> Timings {
        // Aladhan API URL (Method 13 = Diyanet İşleri Başkanlığı)
        let urlString = "https://api.aladhan.com/v1/timingsByCity?city=\(city)&country=\(country)&method=13"
        
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.noData
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(AladhanResponse.self, from: data)
            return decodedResponse.data.timings
        } catch {
            print("Decoding Error: \(error)")
            throw NetworkError.decodingError
        }
    }
}

