//
//  DrawerView.swift
//  marknote
//
//  Created by 钟赫明 on 2021/5/12.
//

import Foundation
import SwiftUI

extension MainView {
    var Drawer: some View {
        NavigationView {
            sidebar
        }
        .accessibility(hidden: (offset == CGFloat(-320)))
        .frame(width: CGFloat(320), height: .infinity)
        .offset(x: offset)
        .animation(.default)
        .ignoresSafeArea(.all)
        .shadow(radius: 0.9)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
