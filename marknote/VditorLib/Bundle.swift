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
        let bundleName = "Editor"

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
        fatalError("unable to find bundle named Editor")
    }()
}

extension Bundle {
    static func EditorBundle() throws -> Bundle {
        let bundle = Bundle.module
        guard (bundle.resourceURL?.appendingPathComponent("Editor", isDirectory: false).appendingPathExtension("bundle")) != nil else {
            throw NSError(domain: "com.Editor", code: 404, userInfo: [NSLocalizedDescriptionKey: "Missing resource bundle"])
        }
        let mpath = Bundle.main.url(forResource: "Editor", withExtension: "bundle")
        guard let Monacobundle = Bundle(url: mpath!) else {
            throw NSError(domain: "com.Editor", code: 404, userInfo: [NSLocalizedDescriptionKey: "Missing resource bundle"])
        }
        return Monacobundle
    }
}
