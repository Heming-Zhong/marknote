//
//  settings.swift
//  marknote
//
//  Created by 钟赫明 on 2021/3/10.
//

import Foundation
import SwiftUI

// MARK: - 图床类型
enum PicHostType: String, Equatable, CaseIterable {
    case gitee = "gitee"
    case github = "github"
    case smms = "smms"
    case local = "local"
}


// MARK: - 图片上传配置
struct uploadsetting {
    var user: String = ""
    var url: String = ""
    var type: PicHostType
    
    var owner: String = ""
    var repo: String = ""
    var path: String = ""
    var token: String = ""
    var branch: String = "master"
}

enum FontType: String {
    case consolas = "consolas"
}

// MARK: - 编辑器相关设置
struct editorsetting {
    var fontsize: Int = 22
    var font: FontType
    var theme: EditorTheme
}

struct SettingMenu: View {
    @ObservedObject var settings = Usersettings()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("图床配置")) {
                    List {
                        HStack {
                            Text("用户名: ")
                            Spacer()
                            TextField("username", text: $settings.user)
                        }
                        HStack {
                            Text("仓库名: ")
                            Spacer()
                            TextField("repo or host", text: $settings.repo)
                        }
                        HStack {
                            Text("分支: ")
                            Spacer()
                            TextField("branch", text: $settings.branch)
                        }
                        HStack {
                            Text("Token: ")
                            Spacer()
                            TextField("token or passwd", text: $settings.token)
                        }
                        HStack {
                            Picker(selection: $settings.type, label: Text("图床类型"), content: {
                                ForEach(0..<PicHostType.allCases.count) { i in
                                    Text(PicHostType.allCases[i].rawValue).tag(PicHostType.allCases[i].rawValue)
                                }
                            })
                        }
                    }
                }
                
                Section(header: Text("编辑器设置")) {
                    List {
                        HStack {
                            Text("主题设置")
                        }
                        HStack {
                            Text("字体大小")
    //                        Stepper(<#T##title: StringProtocol##StringProtocol#>, value: <#T##Binding<Strideable>#>)
                        }
                        HStack {
                            Text("字体类型")
                        }
                        HStack {
                            Text("")
                        }
                    }
                }
            }
            .navigationTitle("Preference")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())

    }
    
}
