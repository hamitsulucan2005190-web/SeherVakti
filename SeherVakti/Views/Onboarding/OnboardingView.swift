//
//  OnboardingView.swift
//  SeherVakti
//
//  Created by Hamit Sulucan on 26.04.2026.
//

import SwiftUI

struct OnboardingView: View {
    // Kullanıcının onboarding ekranını görüp görmediğini hafızaya kaydederiz (Varsayılan: false)
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    // Kullanıcının şu an kaçıncı adımda (sayfada) olduğunu takip ederiz
       @State private var currentStep: Int = 1
    
    
    var body: some View {
        TabView(selection:$currentStep){
            // hoşgeldin ekranı
            WelcomeStepView(currentStep: $currentStep)
                            .tag(1)
            // İsim Alma Ekranı
                       NameInputStepView(currentStep: $currentStep)
                           .tag(2)

             // bildirim ekranı 
              NotificationStepView(currentStep: $currentStep)
              .tag(3)              
            // konum ekranı 
            _LocationStepView(currentStep: $currentStep)
            .tag(4)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .ignoresSafeArea()
        }
        
    }


#Preview {
    OnboardingView()
}
