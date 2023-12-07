## Changelog

### Version 0.4.0 *(2023-12-7)*
Improvements
- Added `partnerConsentStatus` APIs.
- Removed `CBCConsentAdapter` and `CBCConsentAdapterDelegate` from the public API; these are Swift-only protocols now.

### Version 0.3.0 *(2023-10-9)*
Improvements
- Added support for setting the console output level of SDK logs.
- Added support for custom logging handlers.
- Updated `userAgent(completion:)` method to call its handler on failure paths, passing a `nil` value.
- Added support for observing changes to `PublisherMetadata` properties via new `PublisherMetadataObserver` protocol.
- Propagated Chartboost app ID to modules on initialization via `ModuleInitializationConfiguration.chartboostAppID`.

### Version 0.2.0 *(2023-9-7)*
Improvements:
- Refactor the synchronous `userAgent` variable in `AnalyticsEnvironment` and `AttributionEnvironment` as an asynchronous function.

### Version 0.1.0 *(2023-8-15)*
First public alpha.
