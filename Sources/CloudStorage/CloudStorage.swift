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

import Combine
import SwiftUI

@propertyWrapper
public struct CloudStorage<T>: DynamicProperty {

    // MARK: - Initializers

    public init(wrappedValue: T, _ key: String) where T == Bool {
        self.init { adapter in
            guard adapter.containsValue(forKey: key) else {
                return wrappedValue
            }
            return adapter.bool(forKey: key)
        } set: { newValue, adapter in
            adapter.set(newValue, forKey: key)
        }
    }

    public init(wrappedValue: T, _ key: String) where T == String {
        self.init { adapter in
            adapter.string(forKey: key) ?? wrappedValue
        } set: { newValue, adapter in
            adapter.set(newValue, forKey: key)
        }
    }

    public init(wrappedValue: T, _ key: String) where T: RawRepresentable, T.RawValue == String {
        self.init { adapter in
            guard adapter.containsValue(forKey: key),
                  let raw = adapter.string(forKey: key),
                  let value = T(rawValue: raw) else {
                return wrappedValue
            }
            return value
        } set: { newValue, adapter in
            adapter.set(newValue.rawValue, forKey: key)
        }
    }

    public init(wrappedValue: T, _ key: String) where T == Int {
        self.init { adapter in
            guard adapter.containsValue(forKey: key) else {
                return wrappedValue
            }
            return adapter.int(forKey: key)
        } set: { newValue, adapter in
            adapter.set(newValue, forKey: key)
        }
    }

    public init(wrappedValue: T, _ key: String) where T: RawRepresentable, T.RawValue == Int {
        self.init { adapter in
            guard adapter.containsValue(forKey: key),
                  let val = T(rawValue: adapter.int(forKey: key)) else {
                return wrappedValue
            }
            return val
        } set: { newValue, adapter in
            adapter.set(newValue.rawValue, forKey: key)
        }
    }

    public init(wrappedValue: Double, _ key: String) where T == Double {
        self.init { adapter in
            guard adapter.containsValue(forKey: key) else {
                return wrappedValue
            }
            return adapter.double(forKey: key)
        } set: { newValue, adapter in
            adapter.set(newValue, forKey: key)
        }
    }

    public init(wrappedValue: T, _ key: String) where T: RawRepresentable, T.RawValue == Double {
        self.init { adapter in
            guard adapter.containsValue(forKey: key),
                  let val = T(rawValue: adapter.double(forKey: key)) else {
                return wrappedValue
            }
            return val
        } set: { newValue, adapter in
            adapter.set(newValue.rawValue, forKey: key)
        }
    }

    public init(wrappedValue: T, _ key: String) where T == Data {
        self.init { adapter in
            adapter.data(forKey: key) ?? wrappedValue
        } set: { newValue, adapter in
            adapter.set(newValue, forKey: key)
        }
    }

    public init(_ key: String) where T == String? {
        self.init { adapter in
            adapter.string(forKey: key)
        } set: { newValue, adapter in
            adapter.set(newValue, forKey: key)
        }
    }

    public init<R>(_ key: String) where T == R?, R: RawRepresentable, R.RawValue == String {
        self.init { adapter in
            guard let raw = adapter.string(forKey: key),
                  let val = R(rawValue: raw) else {
                return nil
            }
            return val
        } set: { newValue, adapter in
            adapter.set(newValue?.rawValue, forKey: key)
        }
    }

    public init(_ key: String) where T == Int? {
        self.init { adapter in
            guard adapter.containsValue(forKey: key) else {
                return nil
            }
            return adapter.int(forKey: key)
        } set: { newValue, adapter in
            guard let newValue = newValue else {
                adapter.removeValue(forKey: key)
                return
            }
            adapter.set(newValue, forKey: key)
        }
    }

    public init<R>(_ key: String) where T == R?, R: RawRepresentable, R.RawValue == Int {
        self.init { adapter in
            guard adapter.containsValue(forKey: key),
                  let val = R(rawValue: adapter.int(forKey: key)) else {
                return nil
            }
            return val
        } set: { newValue, adapter in
            guard let newValue = newValue else {
                adapter.removeValue(forKey: key)
                return
            }
            adapter.set(newValue.rawValue, forKey: key)
        }
    }

    public init(_ key: String) where T == Double? {
        self.init { adapter in
            guard adapter.containsValue(forKey: key) else {
                return nil
            }
            return adapter.double(forKey: key)
        } set: { newValue, adapter in
            guard let newValue = newValue else {
                adapter.removeValue(forKey: key)
                return
            }
            adapter.set(newValue, forKey: key)
        }
    }

    public init<R>(_ key: String) where T == R?, R: RawRepresentable, R.RawValue == Double {
        self.init { adapter in
            guard adapter.containsValue(forKey: key),
                  let val = R(rawValue: adapter.double(forKey: key)) else {
                return nil
            }
            return val
        } set: { newValue, adapter in
            guard let newValue = newValue else {
                adapter.removeValue(forKey: key)
                return
            }
            adapter.set(newValue.rawValue, forKey: key)
        }
    }

    public init(_ key: String) where T == Data? {
        self.init { adapter in
            adapter.data(forKey: key)
        } set: { newValue, adapter in
            adapter.set(newValue, forKey: key)
        }
    }

    // MARK: - PropertyWrapper

    public var wrappedValue: T {
        get {
            getter(adapter)
        }
        nonmutating set {
            setter(newValue, adapter)
        }
    }

    public var projectedValue: Binding<T> {
        .init {
            wrappedValue
        } set: { newValue in
            wrappedValue = newValue
        }
    }

    // MARK: - Private

    private init(get: @escaping (Adapter) -> T,
                 set: @escaping (T, Adapter) -> Void) {
        getter = get
        setter = set
    }

    private let getter: (Adapter) -> T
    private let setter: (T, Adapter) -> Void

    @ObservedObject
    private var adapter = Adapter()

    @MainActor
    private final class Adapter: ObservableObject {

        init() {
            observe()
        }

        func containsValue(forKey key: String) -> Bool {
            defaults.dictionaryRepresentation.keys.contains(key)
        }

        func removeValue(forKey key: String) {
            defaults.removeObject(forKey: key)
        }

        func set(_ value: Bool, forKey key: String) {
            defaults.set(value, forKey: key)
            objectWillChange.send()
        }

        func bool(forKey key: String) -> Bool {
            defaults.bool(forKey: key)
        }

        func set(_ value: String?, forKey key: String) {
            defaults.set(value, forKey: key)
            objectWillChange.send()
        }

        func string(forKey key: String) -> String? {
            defaults.string(forKey: key)
        }

        func set(_ int: Int, forKey key: String) {
            let val = Int64(int)
            defaults.set(val, forKey: key)
            objectWillChange.send()
        }

        func int(forKey key: String) -> Int {
            Int(defaults.longLong(forKey: key))
        }

        func set(_ double: Double, forKey key: String) {
            defaults.set(double, forKey: key)
            objectWillChange.send()
        }

        func double(forKey key: String) -> Double {
            defaults.double(forKey: key)
        }

        func set(_ data: Data?, forKey key: String) {
            defaults.set(data, forKey: key)
            objectWillChange.send()
        }

        func data(forKey key: String) -> Data? {
            defaults.data(forKey: key)
        }

        private let defaults = NSUbiquitousKeyValueStore.default

        private var subscription: Cancellable?

        private func observe() {
            objectWillChange.send()
            subscription = NotificationCenter.default.publisher(for: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: defaults)
                .receive(on: DispatchQueue.main)
                .sink { _ in
                    self.objectWillChange.send()
                }
        }

        deinit {
            subscription?.cancel()
        }
    }

}
