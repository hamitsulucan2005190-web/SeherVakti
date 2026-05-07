//
//  LocationManager.swift
//  SeherVakti
//

import Foundation
import CoreLocation

// @Observable → View'lar değişiklikleri otomatik takip eder
// Delegate YOK — modern async/await API kullanıyoruz
@Observable
class LocationManager {

    // Son alınan ham konum koordinatı
    var lastLocation: CLLocation? = nil

    // Şehir adı
    var resolvedCityName: String = ""

    // Yükleniyor mu?
    var isLoading: Bool = false

    // Hata mesajı
    var errorMessage: String? = nil

    // CLLocationManager sadece izin istemek için
    @ObservationIgnored
    private let clManager = CLLocationManager()

    // MARK: - Public

    // Kullanıcı "Konumu Paylaş" butonuna basınca çalışır
    func requestLocation() {
        print("📍 requestLocation() çağrıldı")
        isLoading = true
        errorMessage = nil

        Task {
            // 1) İzin kontrolü — gerekirse popup göster ve bekle
            let authorized = await waitForAuthorization()

            guard authorized else {
                await MainActor.run {
                    self.isLoading = false
                    self.errorMessage = "Konum izni gerekli. Manuel seçebilirsin."
                }
                return
            }

            // 2) GPS konumu al (async stream — delegate gerektirmez!)
            do {
                print("📍 liveUpdates başlatılıyor...")
                for try await update in CLLocationUpdate.liveUpdates() {
                    // İlk geçerli konumu al ve dur
                    if let location = update.location {
                        print("📍 Konum alındı: \(location.coordinate.latitude), \(location.coordinate.longitude)")

                        await MainActor.run {
                            self.lastLocation = location
                        }

                        // Koordinattan şehir adını çöz
                        await self.reverseGeocode(location: location)
                        return // İlk konumu aldık, döngüden çık
                    }
                }
            } catch {
                print("📍 GPS HATASI: \(error.localizedDescription)")
                await MainActor.run {
                    self.isLoading = false
                    self.errorMessage = "Konum alınamadı. Manuel seçebilirsin."
                }
            }
        }
    }

    // MARK: - Private

    // İzin durumunu kontrol et, gerekirse popup göster ve cevabı bekle
    private func waitForAuthorization() async -> Bool {
        let status = clManager.authorizationStatus
        print("📍 İzin durumu: \(status.rawValue)")

        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            print("📍 İzin zaten var ✅")
            return true

        case .notDetermined:
            print("📍 İzin popup'ı gösteriliyor...")
            clManager.requestWhenInUseAuthorization()

            // Kullanıcının popup'a cevap vermesini bekle (max 60 sn)
            for _ in 0..<120 {
                try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 saniye
                let newStatus = clManager.authorizationStatus
                if newStatus != .notDetermined {
                    print("📍 Kullanıcı cevap verdi → \(newStatus.rawValue)")
                    return newStatus == .authorizedWhenInUse || newStatus == .authorizedAlways
                }
            }
            print("📍 Zaman aşımı!")
            return false

        case .denied, .restricted:
            print("📍 İzin reddedilmiş ❌")
            return false

        @unknown default:
            return false
        }
    }

    // Koordinat → Şehir adı
    private func reverseGeocode(location: CLLocation) async {
        print("📍 Reverse geocode başladı...")
        let geocoder = CLGeocoder()
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            let city = placemarks.first?.locality
                ?? placemarks.first?.administrativeArea
                ?? "Bilinmiyor"
            print("📍 Şehir bulundu: \(city)")

            await MainActor.run {
                resolvedCityName = city
                isLoading = false
            }
        } catch {
            print("📍 Geocode HATASI: \(error.localizedDescription)")
            await MainActor.run {
                errorMessage = "Şehir bulunamadı. Manuel seçebilirsin."
                isLoading = false
            }
        }
    }
}
