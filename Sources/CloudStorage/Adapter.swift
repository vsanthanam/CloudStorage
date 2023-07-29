// CloudStorage
// Adapter.swift
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
import Foundation

@MainActor
final class Adapter: ObservableObject, Sendable {

    // MARK: - Initializers

    init() {}

    // MARK: - API

    func start() {
        subscription = NotificationCenter.default
            .publisher(for: NSUbiquitousKeyValueStore.didChangeExternallyNotification)
            .map { notif -> Notification? in notif }
            .subscribe(on: DispatchQueue.main)
            .assign(to: \.notification, on: self)
    }

    func stop() {
        subscription = nil
    }

    @Published
    var notification: Notification?

    // MARK: - Private

    @AutoCancel
    private var subscription: Cancellable?

}

@propertyWrapper
final class AutoCancel {

    init(wrappedValue: Cancellable?) {
        self.wrappedValue = wrappedValue
    }

    var wrappedValue: Cancellable? {
        didSet {
            oldValue?.cancel()
        }
    }

    deinit {
        wrappedValue?.cancel()
    }

}
