// CloudStorage
// Environment.swift
//
// MIT License
//
// Copyright (c) 2021 Varun Santhanam
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the  Software), to deal
//
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED  AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation
import SwiftUI

extension EnvironmentValues {

    /// The default cloud storage used by the ``CloudStorage`` property wrapper.
    ///
    /// You can change this value using the ``SwiftUI/View/defaultCloudStorage(_:)`` modifier.
    public var defaultCloudStorage: NSUbiquitousKeyValueStore {
        get { self[DefaultCloudStorageEnvironmentKey.self] }
        set { self[DefaultCloudStorageEnvironmentKey.self] = newValue }
    }

    /// Whether or not cloud storage of descending views should be mirrored in the local user defaults
    ///
    /// You can change this value using the ``SwiftUI/View/mirrorCloudStorageInAppStorage(_:)`` modifier.
    var mirrorCloudStorageInAppStorage: Bool {
        get { self[MirrorCloudStorageInAppStorageEnvironmentKey.self] }
        set { self[MirrorCloudStorageInAppStorageEnvironmentKey.self] = newValue }
    }

}

private struct DefaultCloudStorageEnvironmentKey: EnvironmentKey {

    // MARK: - EnvironmentKey

    typealias Value = NSUbiquitousKeyValueStore

    static let defaultValue: Value = .default

}

private struct MirrorCloudStorageInAppStorageEnvironmentKey: EnvironmentKey {

    // MARK: - EnvironmentKey

    typealias Value = Bool

    static let defaultValue: Bool = false

}
