// CloudStorage
// CloudStorage.swift
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

/// A property wrapper type that reflects a value from `NSUbiquitousKeyValueStore` and invalidates a view on a change in value in that ubiquitous user default.
@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, macCatalyst 16.0, *)
@propertyWrapper
public struct CloudStorage<Value>: DynamicProperty, Sendable {

    // MARK: - Initializers

    /// Creates a property that can read and write to a string ubiquitous user default.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value if a string value is not specified for the given key.
    ///   - key: The key to read and write the value to in the ubiquitous user defaults store.
    ///   - store: The ubiquitous user defaults store to read and write to. A value of `nil` will use the ubiquitous user default store from the environment.
    public init(
        wrappedValue: Value,
        _ key: String,
        store: NSUbiquitousKeyValueStore? = nil
    ) where Value == String {
        self.init(
            key: key,
            providedStore: store,
            wrappedValue: wrappedValue,
            local: AppStorage(wrappedValue: wrappedValue, key)
        ) { store, key, fallback in
            guard store.dictionaryRepresentation.keys.contains(key) else {
                return fallback
            }
            return store.string(forKey: key) ?? fallback
        } setter: { newValue, store, key in
            store.set(newValue, forKey: key)
        }
    }

    /// Creates a property that can read and write to an integer ubiquitous user default, transforming that to `RawRepresentable` data type.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value if an integer value is not specified for the given key.
    ///   - key: The key to read and write the value to in the ubiquitous user defaults store.
    ///   - store: The ubiquitous user defaults store to read and write to. A value of `nil` will use the ubiquitous user default store from the environment.
    public init(
        wrappedValue: Value,
        _ key: String,
        store: NSUbiquitousKeyValueStore? = nil
    ) where Value: RawRepresentable, Value.RawValue == Int {
        self.init(
            key: key,
            providedStore: store,
            wrappedValue: wrappedValue,
            local: AppStorage(wrappedValue: wrappedValue, key)
        ) { store, key, fallback in
            guard store.dictionaryRepresentation.keys.contains(key) else {
                return fallback
            }
            let integer = Int(store.longLong(forKey: key))
            return Value(rawValue: integer) ?? fallback
        } setter: { newValue, store, key in
            store.set(newValue.rawValue, forKey: key)
        }
    }

    /// Creates a property that can read and write to an integer ubiquitous user default.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value if an integer value is not specified for the given key.
    ///   - key: The key to read and write the value to in the ubiquitous user defaults store.
    ///   - store: The ubiquitous user defaults store to read and write to. A value of `nil` will use the ubiquitous user default store from the environment.
    public init(
        wrappedValue: Value,
        _ key: String,
        store: NSUbiquitousKeyValueStore? = nil
    ) where Value == Int {
        self.init(
            key: key,
            providedStore: store,
            wrappedValue: wrappedValue,
            local: AppStorage(wrappedValue: wrappedValue, key)
        ) { store, key, fallback in
            guard store.dictionaryRepresentation.keys.contains(key) else {
                return fallback
            }
            return Int(store.longLong(forKey: key))
        } setter: { newValue, store, key in
            let val = Int64(newValue)
            store.set(val, forKey: key)
        }
    }

    /// Creates a property that can read and write to a string ubiquitous user default, transforming that to `RawRepresentable` data type.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value if a string value is not specified for the given key.
    ///   - key: The key to read and write the value to in the ubiquitous user defaults store.
    ///   - store: The ubiquitous user defaults store to read and write to. A value of `nil` will use the ubiquitous user default store from the environment.
    public init(
        wrappedValue: Value,
        _ key: String,
        store: NSUbiquitousKeyValueStore? = nil
    ) where Value: RawRepresentable, Value.RawValue == String {
        self.init(
            key: key,
            providedStore: store,
            wrappedValue: wrappedValue,
            local: AppStorage(wrappedValue: wrappedValue, key)
        ) { store, key, fallback in
            guard store.dictionaryRepresentation.keys.contains(key) else {
                return fallback
            }
            let str = store.string(forKey: key) ?? fallback.rawValue
            return Value(rawValue: str) ?? fallback
        } setter: { newValue, store, key in
            store.set(newValue.rawValue, forKey: key)
        }
    }

    /// Creates a property that can read and write to a url ubiquitous user default.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value if a url value is not specified for the given key.
    ///   - key: The key to read and write the value to in the ubiquitous user defaults store.
    ///   - store: The ubiquitous user defaults store to read and write to. A value of `nil` will use the ubiquitous user default store from the environment.
    public init(
        wrappedValue: Value,
        _ key: String,
        store: NSUbiquitousKeyValueStore? = nil
    ) where Value == URL {
        self.init(
            key: key,
            providedStore: store,
            wrappedValue: wrappedValue,
            local: AppStorage(wrappedValue: wrappedValue, key)
        ) { store, key, fallback in
            guard store.dictionaryRepresentation.keys.contains(key) else {
                return fallback
            }
            guard let str = store.string(forKey: key) else {
                return fallback
            }
            return URL(string: str) ?? fallback
        } setter: { newValue, store, key in
            store.set(newValue.absoluteString, forKey: key)
        }
    }

    /// Creates a property that can read and write to a double ubiquitous user default.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value if a double value is not specified for the given key.
    ///   - key: The key to read and write the value to in the ubiquitous user defaults store.
    ///   - store: The ubiquitous user defaults store to read and write to. A value of `nil` will use the ubiquitous user default store from the environment.
    public init(
        wrappedValue: Value,
        _ key: String,
        store: NSUbiquitousKeyValueStore? = nil
    ) where Value == Double {
        self.init(
            key: key,
            providedStore: store,
            wrappedValue: wrappedValue,
            local: AppStorage(wrappedValue: wrappedValue, key)
        ) { store, key, fallback in
            guard store.dictionaryRepresentation.keys.contains(key) else {
                return fallback
            }
            return store.double(forKey: key)
        } setter: { newValue, store, key in
            store.set(newValue, forKey: key)
        }
    }

    /// Creates a property that can read and write to a boolean ubiquitous user default.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value if a boolean value is not specified for the given key.
    ///   - key: The key to read and write the value to in the ubiquitous user defaults store.
    ///   - store: The ubiquitous user defaults store to read and write to. A value of `nil` will use the ubiquitous user default store from the environment.
    public init(
        wrappedValue: Value,
        _ key: String,
        store: NSUbiquitousKeyValueStore? = nil
    ) where Value == Bool {
        self.init(
            key: key,
            providedStore: store,
            wrappedValue: wrappedValue,
            local: AppStorage(wrappedValue: wrappedValue, key)
        ) { store, key, fallback in
            guard store.dictionaryRepresentation.keys.contains(key) else {
                return fallback
            }
            return store.bool(forKey: key)
        } setter: { newValue, store, key in
            store.set(newValue, forKey: key)
        }
    }

    /// Creates a property that can read and write an Optional integer ubiquitous user default.
    ///
    /// - Parameters:
    ///   - key: The key to read and write the value to in the ubiquitous user defaults store.
    ///   - store: The ubiquitous user defaults store to read and write to. A value of `nil` will use the ubiquitous user default store from the environment.
    public init(
        _ key: String,
        store: NSUbiquitousKeyValueStore? = nil
    ) where Value == Int? {
        self.init(
            key: key,
            providedStore: store,
            wrappedValue: nil,
            local: AppStorage(key)
        ) { store, key, fallback in
            guard store.dictionaryRepresentation.keys.contains(key) else {
                return fallback
            }
            return Int(store.longLong(forKey: key))
        } setter: { newValue, store, key in
            if let newValue {
                store.set(newValue, forKey: key)
            } else {
                store.removeObject(forKey: key)
            }
        }
    }

    /// Creates a property that can read and write an Optional string ubiquitous user default.
    ///
    /// - Parameters:
    ///   - key: The key to read and write the value to in the ubiquitous user defaults store.
    ///   - store: The ubiquitous user defaults store to read and write to. A value of `nil` will use the ubiquitous user default store from the environment.
    public init(
        _ key: String,
        store: NSUbiquitousKeyValueStore? = nil
    ) where Value == String? {
        self.init(
            key: key,
            providedStore: store,
            wrappedValue: nil,
            local: AppStorage(key)
        ) { store, key, fallback in
            guard store.dictionaryRepresentation.keys.contains(key) else {
                return fallback
            }
            return store.string(forKey: key)
        } setter: { newValue, store, key in
            if let newValue {
                store.set(newValue, forKey: key)
            } else {
                store.removeObject(forKey: key)
            }
        }
    }

    /// Creates a property that can read and write an Optional double ubiquitous user default.
    ///
    /// - Parameters:
    ///   - key: The key to read and write the value to in the ubiquitous user defaults store.
    ///   - store: The ubiquitous user defaults store to read and write to. A value of `nil` will use the ubiquitous user default store from the environment.
    public init(
        _ key: String,
        store: NSUbiquitousKeyValueStore? = nil
    ) where Value == Double? {
        self.init(
            key: key,
            providedStore: store,
            wrappedValue: nil,
            local: AppStorage(key)
        ) { store, key, fallback in
            guard store.dictionaryRepresentation.keys.contains(key) else {
                return fallback
            }
            return store.double(forKey: key)
        } setter: { newValue, store, key in
            if let newValue {
                store.set(newValue, forKey: key)
            } else {
                store.removeObject(forKey: key)
            }
        }
    }

    /// Creates a property that can save and restore an Optional integer, transforming it to an Optional `RawRepresentable` data type.
    ///
    /// Defaults to `nil` if there is no restored value.
    ///
    /// A common usage is with enumerations:
    ///
    /// ```swift
    /// enum MyEnum: Int {
    ///     case a
    ///     case b
    ///     case c
    /// }
    /// struct MyView: View {
    ///     @CloudStorage("MyEnumValue") private var value: MyEnum?
    ///     var body: some View { ... }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - key: The key to read and write the value to in the ubiquitous user defaults store.
    ///   - store: The ubiquitous user defaults store to read and write to. A value of `nil` will use the ubiquitous user default store from the environment.
    public init<R>(
        _ key: String,
        store: NSUbiquitousKeyValueStore? = nil
    ) where Value == R?, R: RawRepresentable, R.RawValue == Int {
        self.init(
            key: key,
            providedStore: store,
            wrappedValue: nil,
            local: AppStorage(key)
        ) { store, key, fallback in
            guard store.dictionaryRepresentation.keys.contains(key) else {
                return fallback
            }
            let val = Int(store.longLong(forKey: key))
            return R(rawValue: val)
        } setter: { newValue, store, key in
            if let newValue {
                store.set(newValue.rawValue, forKey: key)
            } else {
                store.removeObject(forKey: key)
            }
        }
    }

    /// Creates a property that can save and restore an Optional string, transforming it to an Optional `RawRepresentable` data type.
    ///
    /// Defaults to `nil` if there is no restored value.
    ///
    /// A common usage is with enumerations:
    ///
    /// ```swift
    /// enum MyEnum: String {
    ///     case a
    ///     case b
    ///     case c
    /// }
    /// struct MyView: View {
    ///     @CloudStorage("MyEnumValue") private var value: MyEnum?
    ///     var body: some View { ... }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - key: The key to read and write the value to in the ubiquitous user defaults store.
    ///   - store: The ubiquitous user defaults store to read and write to. A value of `nil` will use the ubiquitous user default store from the environment.
    public init<R>(
        _ key: String,
        store: NSUbiquitousKeyValueStore? = nil
    ) where Value == R?, R: RawRepresentable, R.RawValue == String {
        self.init(
            key: key,
            providedStore: store,
            wrappedValue: nil,
            local: AppStorage(key)
        ) { store, key, fallback in
            guard store.dictionaryRepresentation.keys.contains(key) else {
                return fallback
            }
            guard let val = store.string(forKey: key) else {
                return fallback
            }
            return R(rawValue: val)
        } setter: { newValue, store, key in
            if let newValue {
                store.set(newValue.rawValue, forKey: key)
            } else {
                store.removeObject(forKey: key)
            }
        }
    }

    /// Creates a property that can read and write an Optional boolean ubiquitous user default.
    ///
    /// - Parameters:
    ///   - key: The key to read and write the value to in the ubiquitous user defaults store.
    ///   - store: The ubiquitous user defaults store to read and write to. A value of `nil` will use the ubiquitous user default store from the environment.
    public init(
        _ key: String,
        store: NSUbiquitousKeyValueStore? = nil
    ) where Value == Bool? {
        self.init(
            key: key,
            providedStore: store,
            wrappedValue: nil,
            local: AppStorage(key)
        ) { store, key, fallback in
            guard store.dictionaryRepresentation.keys.contains(key) else {
                return fallback
            }
            return store.bool(forKey: key)
        } setter: { newValue, store, key in
            if let newValue {
                store.set(newValue, forKey: key)
            } else {
                store.removeObject(forKey: key)
            }
        }
    }

    public init(
        _ key: String,
        store: NSUbiquitousKeyValueStore? = nil
    ) where Value == URL? {
        self.init(
            key: key,
            providedStore: store,
            wrappedValue: nil,
            local: AppStorage(key)
        ) { store, key, fallback in
            guard store.dictionaryRepresentation.keys.contains(key) else {
                return fallback
            }
            guard let str = store.string(forKey: key) else {
                return fallback
            }
            return URL(string: str) ?? fallback
        } setter: { newValue, store, key in
            if let newValue {
                store.set(newValue.absoluteString, forKey: key)
            } else {
                store.removeObject(forKey: key)
            }
        }
    }

    // MARK: - PropertyWrapper

    public var wrappedValue: Value {
        get {
            cloudStorageEnabled ? _wrapped : local
        }
        nonmutating set {
            if cloudStorageEnabled {
                setter(newValue, store, key)
                if mirrorCloudStorageInAppStorage {
                    local = newValue
                }
            } else {
                local = newValue
            }
        }
    }

    public var projectedValue: Binding<Value> {
        .init {
            wrappedValue
        } set: { newValue in
            wrappedValue = newValue
        }
    }

    // MARK: - DynamicProperty

    public mutating func update() {
        _wrapped = getter(store, key, fallback)
    }

    // MARK: - Private

    private init(
        key: String,
        providedStore: NSUbiquitousKeyValueStore?,
        wrappedValue: Value,
        local: AppStorage<Value>,
        getter: @escaping (NSUbiquitousKeyValueStore, String, Value) -> Value,
        setter: @escaping (Value, NSUbiquitousKeyValueStore, String) -> Void
    ) {
        self.key = key
        self.providedStore = providedStore
        self.getter = getter
        self.setter = setter
        _local = local
        fallback = wrappedValue
        _wrapped = wrappedValue
        start()
    }

    private let key: String
    private let providedStore: NSUbiquitousKeyValueStore?
    private let getter: (NSUbiquitousKeyValueStore, String, Value) -> Value
    private let setter: (Value, NSUbiquitousKeyValueStore, String) -> Void
    private let fallback: Value
    private var _wrapped: Value {
        didSet {
            setter(_wrapped, store, key)
        }
    }

    @AppStorage
    private var local: Value

    @CloudStorageEnabled
    private var cloudStorageEnabled: Bool

    @StateObject
    private var adapter = Adapter()

    @Environment(\.defaultCloudStorage)
    private var defaultStore: NSUbiquitousKeyValueStore

    @Environment(\.mirrorCloudStorageInAppStorage)
    private var mirrorCloudStorageInAppStorage: Bool

    private var store: NSUbiquitousKeyValueStore {
        providedStore ?? defaultStore
    }

    private func start() {
        adapter.start()
    }
}
