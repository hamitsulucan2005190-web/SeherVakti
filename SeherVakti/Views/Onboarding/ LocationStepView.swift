//
//   LocationStepView.swift
//  SeherVakti
//
//  Created by Hamit Sulucan on 26.04.2026.
//

import SwiftUI
import MapKit

struct _LocationStepView: View {
    @Binding var currentStep: Int
        
        // Uygulama ayarlarında şehri tutmak için
        @AppStorage("userCity") private var userCity: String = ""
        
        // Onboarding'i tamamen bitirmek için kalıcı hafıza değiştiricisi
        @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
        // GPS servisi: @State ile bu View'a ait bir örnek oluşturuyoruz
    @State private var locationManager = LocationManager()
       // Harita kamera pozisyonu (Türkiye merkezli başlar)
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 39.9, longitude: 32.8),
            span: MKCoordinateSpan(latitudeDelta: 8, longitudeDelta: 8)
        )
    )
    // Manuel şehir seçici sheet kontrolü
    @State private var showCityPicker: Bool = false
    // Şehir onay kartı gösterilsin mi?
    @State private var showConfirmCard: Bool = false

        
    var body: some View {
        
        ZStack {
            // --- KATMAN 1: Harita (Tıklanabilir) ---
            MapReader { proxy in
                Map(position: $cameraPosition) {
                    // GPS konumu alındıysa haritaya pin koy
                    if let location = locationManager.lastLocation {
                        Annotation("Konumun", coordinate: location.coordinate) {
                            // Özel animasyonlu pin
                            ZStack {
                                Circle()
                                    .fill(AppTheme.Colors.primary.opacity(0.2))
                                    .frame(width: 44, height: 44)
                                    .scaleEffect(showConfirmCard ? 1.3 : 1.0)
                                    .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true),
                                               value: showConfirmCard)
                                Circle()
                                    .fill(AppTheme.Colors.primary)
                                    .frame(width: 20, height: 20)
                                Image(systemName: "moon.stars.fill")
                                    .font(.system(size: 10))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
                .mapStyle(.standard(elevation: .realistic))
                // Haritaya tıklayınca o noktanın şehrini bul
                .onTapGesture { position in
                    if let coordinate = proxy.convert(position, from: .local) {
                        print("📍 Haritaya tıklandı: \(coordinate.latitude), \(coordinate.longitude)")
                        handleMapTap(coordinate: coordinate)
                    }
                }
            }
            .ignoresSafeArea()
            // --- KATMAN 2: Üst gradient sis efekti ---
            VStack {
                LinearGradient(
                    colors: [AppTheme.Colors.background, .clear],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 160)
                Spacer()
                // Alt gradient
                LinearGradient(
                    colors: [.clear, AppTheme.Colors.background],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 280)
            }
            .ignoresSafeArea()
            // --- KATMAN 3: UI İçeriği ---
            VStack(spacing: 0) {
                // Üst navigasyon
                HStack {
                    Button {
                        withAnimation(.easeInOut) { currentStep -= 1 }
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(AppTheme.Colors.primary)
                            .padding(12)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    Spacer()
                    // Sayfa indikatörü
                    HStack(spacing: 8) {
                        Circle().fill(Color.gray.opacity(0.3)).frame(width: 6, height: 6)
                        Circle().fill(Color.gray.opacity(0.3)).frame(width: 6, height: 6)
                        Circle().fill(Color.gray.opacity(0.3)).frame(width: 6, height: 6)
                        Capsule().fill(AppTheme.Colors.tertiary).frame(width: 24, height: 4)
                    }
                    .padding(.trailing, 40)
                    Spacer()
                }
                .padding(.top, 60)
                .padding(.horizontal, 24)
                Spacer()
                // --- Alt Panel ---
                VStack(spacing: 16) {
                    // Şehir onay kartı (GPS başarıyla şehir bulduysa göster)
                    if showConfirmCard && !locationManager.resolvedCityName.isEmpty {
                        HStack(spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.green)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Konum Bulundu")
                                    .font(.system(size: 12, weight: .bold, design: .rounded))
                                    .foregroundColor(.secondary)
                                // Bulunan şehri büyük göster
                                Text(locationManager.resolvedCityName)
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundColor(AppTheme.Colors.primary)
                            }
                            Spacer()
                            // Onayla butonu
                            Button("Onayla") {
                                userCity = locationManager.resolvedCityName
                                completeOnboarding()
                            }
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(AppTheme.Colors.primary)
                            .clipShape(Capsule())
                        }
                        .padding(16)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    // Başlık
                    VStack(spacing: 6) {
                        Text("Bulunduğun şehri\nöğrenelim")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(AppTheme.Colors.primary)
                            .multilineTextAlignment(.center)
                        if let error = locationManager.errorMessage {
                            Text(error)
                                .font(.system(size: 13, design: .rounded))
                                .foregroundColor(.orange)
                        } else {
                            Text("Doğru namaz vakitleri için konumuna ihtiyacımız var")
                                .font(.system(size: 14, design: .rounded))
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                    // GPS Butonu
                    Button {
                        locationManager.requestLocation()
                    } label: {
                        HStack(spacing: 10) {
                            // Yükleniyor animasyonu veya ikon
                            if locationManager.isLoading {
                                ProgressView()
                                    .progressViewStyle(.circular)
                                    .tint(.white)
                                    .scaleEffect(0.85)
                            } else {
                                Image(systemName: "location.fill")
                                    .font(.system(size: 14))
                            }
                            Text(locationManager.isLoading ? "Konum Alınıyor..." : "Konumu Paylaş")
                        }
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(16)
                        .background(AppTheme.Colors.primary)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: AppTheme.Colors.primary.opacity(0.35), radius: 12, y: 5)
                    }
                    .disabled(locationManager.isLoading)
                    // Manuel Seç Butonu
                    Button {
                        showCityPicker = true
                    } label: {
                        Text("Manuel Seç")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(AppTheme.Colors.primary)
                            .frame(maxWidth: .infinity)
                            .padding(16)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(AppTheme.Colors.primary.opacity(0.2), lineWidth: 1)
                            )
                    }
                    Text("ADIM 4 / 4")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundColor(.secondary.opacity(0.5))
                        .padding(.bottom, 30)
                }
                .padding(.horizontal, 24)
            }
        }
        // GPS şehri bulduğunda haritayı oraya animasyonlu götür
        .onChange(of: locationManager.lastLocation) { _, newLocation in
            guard let loc = newLocation else { return }
            withAnimation(.easeInOut(duration: 1.2)) {
                cameraPosition = .region(
                    MKCoordinateRegion(
                        center: loc.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 1.5, longitudeDelta: 1.5)
                    )
                )
            }
        }
        // Şehir adı gelince onay kartını göster
        .onChange(of: locationManager.resolvedCityName) { _, city in
            if !city.isEmpty {
                withAnimation(.spring(response: 0.5)) {
                    showConfirmCard = true
                }
            }
        }
        // Manuel şehir seçici sheet
        .sheet(isPresented: $showCityPicker) {
            CityPickerSheet(selectedCity: $userCity, isPresented: $showCityPicker)
                .onDisappear {
                    // Kullanıcı bir şehir seçtiyse onboarding'i bitir
                    if !userCity.isEmpty {
                        completeOnboarding()
                    }
                }
        }
    }
    // Onboarding'i kapatır, ana ekrana geçiş başlar
    private func completeOnboarding() {
        withAnimation(.easeInOut) {
            hasSeenOnboarding = true
        }
    }
    // Haritaya tıklanınca çağrılır — koordinattan şehir bulur
private func handleMapTap(coordinate: CLLocationCoordinate2D) {
    let tappedLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    // Haritayı tıklanan noktaya animasyonlu götür
    withAnimation(.easeInOut(duration: 0.8)) {
        cameraPosition = .region(
            MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 1.5, longitudeDelta: 1.5)
            )
        )
    }
    // Pin'i güncelle
    locationManager.lastLocation = tappedLocation
    // Tıklanan noktanın şehrini bul (reverse geocode)
    let geocoder = CLGeocoder()
    Task {
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(tappedLocation)
            let city = placemarks.first?.locality
                ?? placemarks.first?.administrativeArea
                ?? "Bilinmiyor"
            print("📍 Haritadan seçilen şehir: \(city)")
            await MainActor.run {
                locationManager.resolvedCityName = city
                withAnimation(.spring(response: 0.5)) {
                    showConfirmCard = true
                }
            }
        } catch {
            print("📍 Harita geocode hatası: \(error.localizedDescription)")
        }
    }
}

}
#Preview {
    _LocationStepView(currentStep: .constant(4))
}
