//
//  ShadowCover.swift
//  marknote
//
//  Created by 钟赫明 on 2021/5/12.
//

import Foundation
import SwiftUI

extension MainView {
    var ShadowCover: some View {
        Rectangle()
            .opacity(0.001)
            .ignoresSafeArea(.all)
            .edgesIgnoringSafeArea(.all)
            .tappable {
                withAnimation {
                    if offset == CGFloat(-320) {
                        offset = CGFloat(0)
                    }
                    else {
                        offset = CGFloat(-320)
                    }
                }
            }
    }
}
