## Changelog

### Version 1.1.0 *(2025-10-02)*
- Bug fixes and improvements.

### Version 1.0.0 *(2024-08-01)*
Improvements:
- Initialization now takes an `SDKConfiguration` object and an optional `ModuleObserver`.
- Renamed `ConsentKeys` and `ConsentValues` and changed them to a list of constants instead of an enum for ease of use.
- Added `userDefaultsIABStrings` for IAB defaults to `ConsentAdapter`.
- See the [documentation](https://docs.chartboost.com/en/mediation/integrate/core/ios/get-started/) for more information.

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
