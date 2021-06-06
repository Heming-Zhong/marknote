//
//  PrimaryView.swift
//  marknote
//
//  Created by 钟赫明 on 2021/5/12.
//

import Foundation
import SwiftUI

extension MainView {
    
    // The primary part of the App UI
    var Primary: some View {
        NavigationView {
            Editor
        }
        .ignoresSafeArea(.all)
        .frame(height: .infinity)
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
}
