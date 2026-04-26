//
//  JournalView.swift
//  SeherVakti
//
//  Created by Hamit Sulucan on 21.04.2026.
//

import SwiftUI
import SwiftData

struct JournalView: View {
    // 1. Veritabanından notları Tarihe göre (en yeni en üstte) çeker
    @Query(sort: \JournalEntry.date, order: .reverse) 
    private var entries: [JournalEntry]
    
    // 2. Veri silme/ekleme işlemleri için veritabanı ortamı
    @Environment(\.modelContext) private var modelContext
    
    // 3. Ekleme ekranının açık/kapalı durumunu kontrol eder
    @State private var showingAddSheet = false
    
    // 4. Silme işlemi için düzenleme modunu kontrol eder
    @State private var isEditing = false
    
        var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.Colors.background.ignoresSafeArea()
                
                // Eğer hiç kayıt yoksa boş durumu göster, varsa listele
                if entries.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "book.closed")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary.opacity(0.3))
                        
                        Text("Henüz bir günlük kaydınız yok.\nBugün neye şükrediyorsun?")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                } else {
                    List {
                        ForEach(entries) { entry in
                            // Kart Tasarımı
                            VStack(alignment: .leading, spacing: 8) {
                                Text(entry.date, style: .date)
                                    .font(.caption)
                                    .foregroundColor(AppTheme.Colors.tertiary)
                                    .fontWeight(.bold)
                                
                                Text(entry.content)
                                    .font(.system(size: 16, design: .rounded))
                                    .foregroundColor(AppTheme.Colors.primary)
                                    .lineLimit(2) // yazıyı 2 satırla sınırlar
                                    .multilineTextAlignment(.leading)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(AppTheme.Colors.surfaceLowest)
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.mainCard))
                            .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
                            
                            // Liste görünümünü bozmamak için varsayılan iOS ayarlarını eziyoruz
                            .listRowInsets(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                        }
                        .onDelete(perform: deleteEntries) // 👈 Sola kaydırarak silme (ForEach üzerinde çalışır)
                    }
                    .listStyle(.plain) // 👈 Standart liste görünümünü gizleme (List üzerinde çalışır!)
                    .scrollContentBackground(.hidden)
                }
            } // 👈 ZStack Bitişi
            .navigationTitle("İyilik Defteri")
            .toolbar {
                // Sağ üste yeni not ekleme butonu
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddSheet = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(AppTheme.Colors.primary)
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddJournalView()
                    .presentationDetents([.large]) // Sayfanın tam ekran açılmasını sağlar
            }
        } // NavigationStack Bitişi
    } //  body Bitişi
    
    // Silme motoru (Fonksiyon olduğu için body dışında!)
    private func deleteEntries(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(entries[index])
        }
    }
} //  Struct Bitişi

#Preview {
    JournalView()
}
