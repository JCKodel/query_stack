## 1.0.0-dev.1

* Initial release

## 1.0.0-dev.2

* Fixed README.md

## 1.0.0-dev.3

* Fixed bugs in `refetch`

## 1.0.0-dev.4

* Added `singleLetterName` to all `PlatformInfo` enums to facilitate safer serialization.
* Added `StackTrace` info in errors

## 1.0.0-dev.5

* Fix project availability for Windows, Linux, MacOS, iOS, Android and Web.

## 1.0.0-dev.6

* Added `PlatformInfo` into `registerDependencies` so dependencies can be injected based on the current platform.

## 1.0.0-dev.7

* Added `T when<T>()` on any enum of `PlatformInfo`

## 1.0.0-dev.8

* Fix `isStale` when fetching is retried

## 1.0.0-dev.9

* Fix `isError` when fetching is retried

## 1.0.0-dev.10

* BREAKING CHANGE: now `QueryBuilder` and `MutationBuilder` methods `onSuccess`, `onError` and `onSettled` will receive the `Query<T>` or `Mutation<T>` instead of a `T` for success and `Object` for error.

## 1.0.0-dev.11

* Better initialization rendering.

## 1.0.0-dev.12

* Avoiding QueryBuilder rebuild when popping modal routes.

## 1.0.0-dev.13

* Added `setCachedData<T>` on mutation, so it is now possible to invalidate the current query key for different return types.
* Improvements in log

## 1.0.0-dev.14

* Prevent refetch if `QueryBuilder` isn't in the top of navigation stack
