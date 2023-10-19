## Changelog

### Version 0.3.0
- Added support for setting the console output level of SDK logs.
- Added support for custom logging handlers.
- Updated `userAgent(completion:)` method to call its handler on failure paths, passing a `nil` value.
- Added support for observing changes to `PublisherMetadata` properties via new `PublisherMetadataObserver` protocol.
- Propagated Chartboost app ID to modules on initialization via `ModuleInitializationConfiguration.chartboostAppID`.

### Version 0.2.0
Refactor the synchronous `userAgent` variable in `AnalyticsEnvironment` and `AttributionEnvironment` as an asynchronous function.

### Version 0.1.0
First public alpha.
