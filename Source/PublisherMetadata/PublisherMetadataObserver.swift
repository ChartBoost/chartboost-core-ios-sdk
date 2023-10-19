// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// An observer that gets notified when the value of any publisher metadata field changes.
@objc(CBCPublisherMetadataObserver)
public protocol PublisherMetadataObserver: AnyObject {

    /// Called every time a setter method of ``PublisherMetadata`` gets called in order to notify
    /// of a publisher metadata field change.
    /// - parameter property: A constant that identifies the field that changed.
    /// Note that in order to access the new value for that field you'll have to go through the Core environment.
    func onChange(_ property: PublisherMetadata.Property)
}
