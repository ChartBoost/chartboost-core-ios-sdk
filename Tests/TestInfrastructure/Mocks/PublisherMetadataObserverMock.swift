// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK

class PublisherMetadataObserverMock: PublisherMetadataObserver {

    // MARK: - Call Counts and Return Values

    var onChangeCallCount = 0
    var onChangePropertyLastValue: PublisherMetadata.Property?

    // MARK: - PublisherMetadataObserver

    func onChange(_ property: PublisherMetadata.Property) {
        onChangeCallCount += 1
        onChangePropertyLastValue = property
    }
}
