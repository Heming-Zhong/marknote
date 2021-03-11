//
//  settings.swift
//  marknote
//
//  Created by 钟赫明 on 2021/3/10.
//

import Foundation
import SwiftUI

// MARK: - 图床类型
enum PicHostType: String {
    case gitee = "gitee"
    case github = "github"
    case smms = "smms"
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
    var body: some View {
        List {
            GroupBox(label: Text("图床配置"), content: {
                VStack {
                    HStack {
                        Text("用户名: ")
                        TextField("", text: .init(
                            get: {""},
                            set: { print($0) }
                        ),
                        onCommit: {
                            
                        })
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    HStack {
                        Text("仓库名: ")
                        TextField("", text: .init(
                            get: {""},
                            set: { print($0) }
                        ),
                        onCommit: {
                            
                        })
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    HStack {
                        Text("分支: ")
                        TextField("", text: .init(
                            get: {""},
                            set: { print($0) }
                        ),
                        onCommit: {
                            
                        })
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    HStack {
                        Text("Token: ")
                        SecureField("", text: .init(
                            get: {""},
                            set: { print($0) }
                        ),
                        onCommit: {
                            
                        })
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    HStack {
                        Text("图床类型: ")
                        TextField("", text: .init(
                            get: {""},
                            set: { print($0) }
                        ),
                        onCommit: {
                            
                        })
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
            })
            GroupBox(label: Text("编辑器设置"), content: {
                VStack {
                    HStack {
                        Text("主题设置")
                    }
                    HStack {
                        Text("字体大小")
                    }
                    HStack {
                        Text("字体类型")
                    }
                    HStack {
                        Text("")
                    }
                }
            })
        }

    }
    
}
