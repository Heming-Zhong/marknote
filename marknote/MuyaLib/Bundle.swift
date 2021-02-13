//
//  Bundle.swift
//  iEdit
//
//  Created by 钟赫明 on 2020/9/28.
//

import Foundation
private class BundleFinder {}

extension Foundation.Bundle {
    /// Returns the resource bundle associated with the current Swift module.
    static var module: Bundle = {
        let bundleName = "Monaco"

        let candidates = [
            // Bundle should be present here when the package is linked into an App.
            Bundle.main.resourceURL,

            // Bundle should be present here when the package is linked into a framework.
            Bundle(for: BundleFinder.self).resourceURL,

            // For command-line tools.
            Bundle.main.bundleURL,
        ]

        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }
        fatalError("unable to find bundle named CodeMirror-SwiftUI_CodeMirror-SwiftUI")
    }()
}

extension Bundle {
    static func MonacoBundle() throws -> Bundle {
        let bundle = Bundle.module
        guard let bundlePath = bundle.resourceURL?.appendingPathComponent("Monaco", isDirectory: false).appendingPathExtension("bundle") else {
            throw NSError(domain: "com.Monaco-SwiftUI", code: 404, userInfo: [NSLocalizedDescriptionKey: "Missing resource bundle"])
        }
        let mpath = Bundle.main.url(forResource: "Monaco", withExtension: "bundle")
        let cpath = Bundle.main.url(forResource: "CodeMirrorView", withExtension: "bundle")
        guard let Monacobundle = Bundle(url: mpath!) else {
            throw NSError(domain: "com.Monaco-SwiftUI", code: 404, userInfo: [NSLocalizedDescriptionKey: "Missing resource bundle"])
        }
        return Monacobundle
    }
}
