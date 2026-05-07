import SwiftUI

// MARK: - Bölge Grupları
struct CityRegion {
    let name: String
    let sfSymbol: String
    let cities: [String]
}

struct CityConstants2 {
    static let regions: [CityRegion] = [
        CityRegion(name: "Marmara",          sfSymbol: "water.waves",          cities: ["Balıkesir","Bilecik","Bursa","Çanakkale","Edirne","İstanbul","Kırklareli","Kocaeli","Sakarya","Tekirdağ","Yalova"]),
        CityRegion(name: "Ege",              sfSymbol: "sun.horizon",           cities: ["Afyonkarahisar","Aydın","Denizli","İzmir","Kütahya","Manisa","Muğla","Uşak"]),
        CityRegion(name: "Akdeniz",          sfSymbol: "leaf",                  cities: ["Adana","Antalya","Burdur","Hatay","Isparta","Kahramanmaraş","Kilis","Mersin","Osmaniye"]),
        CityRegion(name: "İç Anadolu",       sfSymbol: "mountain.2",            cities: ["Aksaray","Ankara","Çankırı","Eskişehir","Karaman","Kayseri","Kırıkkale","Kırşehir","Konya","Nevşehir","Niğde","Sivas","Yozgat"]),
        CityRegion(name: "Karadeniz",        sfSymbol: "cloud.rain",            cities: ["Amasya","Artvin","Bartın","Bayburt","Bolu","Çorum","Düzce","Giresun","Gümüşhane","Kastamonu","Ordu","Rize","Samsun","Sinop","Tokat","Trabzon","Zonguldak"]),
        CityRegion(name: "Doğu Anadolu",     sfSymbol: "snowflake",             cities: ["Ağrı","Ardahan","Bingöl","Bitlis","Elazığ","Erzincan","Erzurum","Hakkari","Iğdır","Kars","Malatya","Muş","Tunceli","Van"]),
        CityRegion(name: "Güneydoğu Anadolu",sfSymbol: "sun.max",              cities: ["Adıyaman","Batman","Diyarbakır","Gaziantep","Karabük","Mardin","Siirt","Şanlıurfa","Şırnak"])
    ]
}

// MARK: - City Picker Sheet
struct CityPickerSheet: View {
    @Binding var selectedCity: String
    @Binding var isPresented: Bool

    @State private var searchText: String = ""
    @State private var selectedRegion: String? = nil
    @State private var pressedCity: String? = nil
    @FocusState private var searchFocused: Bool

    private var filteredRegions: [CityRegion] {
        let regions = CityConstants2.regions
        if searchText.isEmpty && selectedRegion == nil {
            return regions
        }
        return regions.compactMap { region in
            var cities = region.cities
            if let sel = selectedRegion, region.name != sel { return nil }
            if !searchText.isEmpty {
                cities = cities.filter { $0.localizedCaseInsensitiveContains(searchText) }
            }
            guard !cities.isEmpty else { return nil }
            return CityRegion(name: region.name, sfSymbol: region.sfSymbol, cities: cities)
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.Colors.background.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Arama Çubuğu
                    searchBar
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        .padding(.bottom, 12)

                    // Bölge Filtresi
                    regionFilterBar
                        .padding(.bottom, 12)

                    // Şehir Listesi
                    ScrollView {
                        LazyVStack(spacing: 16, pinnedViews: [.sectionHeaders]) {
                            ForEach(filteredRegions, id: \.name) { region in
                                Section {
                                    cityGrid(for: region)
                                        .padding(.horizontal, 16)
                                } header: {
                                    regionHeader(region)
                                }
                            }
                        }
                        .padding(.bottom, 32)
                    }
                }
            }
            .navigationTitle("Şehir Seç")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Kapat") { isPresented = false }
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(AppTheme.Colors.primary)
                }
            }
        }
    }

    // MARK: - Arama Çubuğu
    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(searchFocused ? AppTheme.Colors.primary : .secondary)
                .animation(.easeInOut(duration: 0.2), value: searchFocused)

            TextField("Şehir ara...", text: $searchText)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .focused($searchFocused)
                .autocorrectionDisabled()

            if !searchText.isEmpty {
                Button { withAnimation(.spring(response: 0.3)) { searchText = "" } } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                        .font(.system(size: 16))
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background {
            RoundedRectangle(cornerRadius: 14)
                .fill(AppTheme.Colors.surfaceLowest)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(searchFocused ? AppTheme.Colors.primary.opacity(0.4) : Color.clear, lineWidth: 1.5)
                )
        }
        .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
        .animation(.easeInOut(duration: 0.25), value: searchFocused)
    }

    // MARK: - Bölge Filtresi
    private var regionFilterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                // Tümü butonu
                regionFilterChip(name: "Tümü", sfSymbol: "map", isSelected: selectedRegion == nil) {
                    withAnimation(.spring(response: 0.3)) { selectedRegion = nil }
                }
                ForEach(CityConstants2.regions, id: \.name) { region in
                    regionFilterChip(name: region.name, sfSymbol: region.sfSymbol, isSelected: selectedRegion == region.name) {
                        withAnimation(.spring(response: 0.3)) {
                            selectedRegion = selectedRegion == region.name ? nil : region.name
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private func regionFilterChip(name: String, sfSymbol: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 5) {
                Image(systemName: sfSymbol)
                    .font(.system(size: 12, weight: .semibold))
                Text(name).font(.system(size: 13, weight: .semibold, design: .rounded))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background {
                Capsule()
                    .fill(isSelected ? AppTheme.Colors.primary : AppTheme.Colors.surfaceLowest)
            }
            .foregroundColor(isSelected ? .white : AppTheme.Colors.primary)
            .shadow(color: isSelected ? AppTheme.Colors.primary.opacity(0.3) : .black.opacity(0.04), radius: 5, y: 2)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Bölge Başlığı
    private func regionHeader(_ region: CityRegion) -> some View {
        HStack(spacing: 8) {
            Image(systemName: region.sfSymbol)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(AppTheme.Colors.primary)
            Text(region.name)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(AppTheme.Colors.primary)
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial)
    }

    // MARK: - Şehir Izgarası
    private func cityGrid(for region: CityRegion) -> some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
        return LazyVGrid(columns: columns, spacing: 10) {
            ForEach(region.cities, id: \.self) { city in
                cityCell(city)
            }
        }
    }

    private func cityCell(_ city: String) -> some View {
        let isSelected = city == selectedCity
        return Button {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            withAnimation(.spring(response: 0.3, dampingFraction: 0.65)) {
                selectedCity = city
                pressedCity = city
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                isPresented = false
            }
        } label: {
            VStack(spacing: 4) {
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .transition(.scale.combined(with: .opacity))
                }
                Text(city)
                    .font(.system(size: 13, weight: isSelected ? .bold : .medium, design: .rounded))
                    .foregroundColor(isSelected ? .white : AppTheme.Colors.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected
                          ? AnyShapeStyle(LinearGradient(colors: [AppTheme.Colors.primary, AppTheme.Colors.primary.opacity(0.75)], startPoint: .topLeading, endPoint: .bottomTrailing))
                          : AnyShapeStyle(AppTheme.Colors.surfaceLowest))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? AppTheme.Colors.primary : AppTheme.Colors.primary.opacity(0.12), lineWidth: isSelected ? 0 : 1)
                    )
            }
            .shadow(color: isSelected ? AppTheme.Colors.primary.opacity(0.35) : .black.opacity(0.04), radius: isSelected ? 8 : 3, y: isSelected ? 3 : 1)
            .scaleEffect(pressedCity == city ? 1.06 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
        }
        .buttonStyle(.plain)
    }
}
