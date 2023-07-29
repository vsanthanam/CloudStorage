// CloudStorage
// CloudStorageEnabled.swift
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

import SwiftUI

/// A property wrapper that determines whether cloud storage is enabled for the user.
@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, macCatalyst 16.0, *)
@propertyWrapper
public struct CloudStorageEnabled: DynamicProperty {

    // MARK: - Initializers

    public init() {
        let key = (Bundle.main.bundleIdentifier ?? "com.cloudstorage") + ".shouldusecloud"
        _cloudEnabled = AppStorage(wrappedValue: false, key, store: .standard)
    }

    // MARK: - Property Wrapper

    public var wrappedValue: Bool {
        cloudEnabled
    }

    public var projectedValue: Binding<Bool> {
        $cloudEnabled
    }

    // MARK: - Private

    @AppStorage
    private var cloudEnabled: Bool

}
