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
