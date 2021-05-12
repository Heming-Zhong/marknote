//
//  Data.swift
//  iEdit
//
//  Created by 钟赫明 on 2020/9/28.
//

import Foundation

extension Data {
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}
