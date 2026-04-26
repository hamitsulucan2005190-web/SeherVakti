//
//  AddJournalView.swift
//  SeherVakti
//
//  Created by Hamit Sulucan on 22.04.2026.
//

import SwiftUI
import SwiftData

struct AddJournalView: View {
    
    // 1. Veritabanına kaydetmek için ortam değişkeni
       @Environment(\.modelContext) private var modelContext
       // 2. Ekrandan çıkmak / popup'ı kapatmak için ortam değişkeni
       @Environment(\.dismiss) private var dismiss
       
       // Kullanıcının yazdığı metni tutan değişken
       @State private var journalText: String = ""
    var body: some View {
        NavigationStack{
            ZStack{
             AppTheme.Colors.background.ignoresSafeArea()

             VStack(alignment: .leading , spacing :20){
                Text("Bugün neye şükrediyorsun?")
                     .font(.system(size: 24, weight: .bold,design: .rounded))
                    .foregroundColor(AppTheme.Colors.primary)

                     // Şık Metin Giriş Alanı (TextEditor)
                    TextEditor(text: $journalText)
                        .padding()
                        .background(Color.white)
                 
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                 
                        .overlay(
                                                  RoundedRectangle(cornerRadius: 16)
                                                      .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                                              )
                                              .frame(minHeight: 250) // Geniş ve rahat bir yazı alanı
                 
                 Spacer()
                 // Kaydet Butonu
                                     Button(action: saveEntry) {
                                         Text("Deftere Kaydet")
                                             .font(.system(size: 18, weight: .bold, design: .rounded))
                                             .foregroundColor(.white)
                                             .frame(maxWidth: .infinity)
                                             .padding(.vertical, 16)
                                             // Yazı boşsa butonu gri, doluysa yeşil yapıyoruz
                                             .background(journalText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.secondary.opacity(0.5) : AppTheme.Colors.primary)
                                             .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.mainCard))
                                     }
                 // Boş metin kaydedilmesini engelle
                                  .disabled(journalText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                              }
                              .padding()
                              .padding(.top, 20)
                          }
                          .navigationBarTitleDisplayMode(.inline)
                          .toolbar {
                              // Sol üste iptal butonu eklendi
                              ToolbarItem(placement: .navigationBarLeading) {
                                  Button("İptal") {
                                      dismiss()
                                  }
                 
                    
                
             }

                
            }
        }
    }

    // Kaydet butonuna basıldığında çalışan fonksiyon
        private func saveEntry() {
            // 1. Yeni bir obje (satır) oluştur
            let newEntry = JournalEntry(content: journalText)
            
            // 2. Veritabanına ekle
            modelContext.insert(newEntry)
            
            // 3. Ekranı kapatıp listeye geri dön
            dismiss()
        }
}


#Preview {
    AddJournalView()
}
