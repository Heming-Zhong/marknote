//
//  naviView.swift
//  marknote
//
//  Created by 钟赫明 on 2021/3/13.
//

import SwiftUI

extension View {
    func navigationContent() -> some View {
        NavigationView{
            self
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct naviView: View {
    
    var body: some View {
        HStack(spacing: 0){
            List {
                Text("item1")
                Text("item2")
            }
            .toolbar(content: {
                Text("tool")
            })
            Divider()
            Text("detail")
                .navigationContent()
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct naviView_Previews: PreviewProvider {
    static var previews: some View {
        naviView()
    }
}
