# Query Stack

A simple yet powerful state management that makes fetching, caching, synchronizing and updating state in your Flutter applications a breeze.

# Inspired by React Query

This package is inspired by the [TanStack Query](https://tanstack.com/query/v5/docs/react/overview).

## Features

* Integrated dependency injection system.
* Easy to use.
* Promotes SOLID design patterns and Clean Architecture.
* Promotes DRY pattern and the creation of domain plugins (i.e.: once an authentication plugin is created, it's highly reusable in other apps).

## Usage

Query Stack has only 3 parts: dependency injection, stream builders and future builders.

# Dependency Injection

Dependency injection in Query Stack works by creating environments.

You can create a `DebugEnvironment` with api keys or remote urls pointing to development resources and a `ProductionEnvironment` for real usage,
pointing to real servers and api keys.

You can also create different classes that inherit `Environment` for flavours.

Usually, you will write an abstract `BaseEnvironment` that registers all common dependencies and only specialize in differences in your concrete
`DebugEnvironment` and `ProductionEnvironment`.

Here is what a real-world environment looks like:

```dart
import 'package:flutter/foundation.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:query_stack/query_stack.dart';
import 'package:query_stack_firebase_authentication/query_stack_firebase_authentication.dart';

import 'authentication/db_authentication_service.dart';
import 'companies/companies_service.dart';
import 'firebase_options.dart';

// This class is abstract because it contains common registrations
// between debug and production environments
@immutable
abstract class BaseEnvironment extends Environment {
  const BaseEnvironment();

  // This will be overriden by my concrete classes because
  // each environment will point to a different server url
  String get serverBaseUrl => throw UnimplementedException();

  // This method will be called when your app run
  //
  // Here you will configure what class will return when someone asks
  // for a specific type (that's called service locator)
  //
  // Since you have a `get` argument, you can inject other services into
  // the services you are registering (because one depends on another, that's
  // called dependency inversion principle)
  //
  // Just be careful about circular dependencies!
  @override
  void registerDependencies(RegisterDependenciesDelegate when, PlatformInfo platformInfo) {
    // This `AuthenticationService` is a Query Stack plugin provided by the
    // query_stack_firebase_authentication_service
    //
    // You can create plugins that are common for all your apps and reuse them
    when<AuthenticationService>(
      // Since I'm persisting my authenticated user in a database, I can inherit the
      // `AuthenticationService` and specialize it
      (get) => DBAuthenticationService(
        appleRedirectUrl: platformInfo.nativePlatform.when(
          onAndroid: () => "use this url on android",
          onWeb: () => "use this url on web",
          orElse: () => null,
        ),
        appleServiceId: "apple sign in service id",
        googleClientId: platformInfo.nativePlatform.when(
          onAndroid: () => "use this google client id on android",
          oniOS: () => "use this google client id on ios",
          onWeb: () => "use this google client id on web",
          orElse: () => throw UnsupportedError("${platformInfo.nativePlatform} is not supported"),
        ),
      ),
    );

    // This is a service of my app that uses the `AuthenticationService` to get the
    // authenticated user id
    //
    // Notice how I request `<AuthenticationService>` but registered a `DBAuthenticationService`
    // above. That will work because `CompaniesService` knows how to handle `AuthenticationService`
    // and inheriting that class won't change its behavior in this context (that's called Open-closed
    // principal and Liskov substitution principal)
    when<CompaniesService>(
      (get) => CompaniesService(
        authenticationService: get<AuthenticationService>(),
        // Since my service will call some remote API,
        // I need to know which server to use, and that base
        // url is different between debug and production environments
        serverBaseURL: serverBaseURL,
      ),
    );
  }

  // Each service registered inherits `BaseService` that has a
  // `void initialize()` and a `Future<void> initializeAsync()`.
  // You can override any of those methods if your service needs
  // an initialization (you can override none, one or both of them,
  // initializeAsync will be awaited, so if your initialization has
  // async methods, that's your guy)
  //
  // Just after this method, all services `initialize` and `initializeAsync`
  // will be called (if you didn't override them, they will be empty and
  // will have no effect)
  @override
  Future<void> initializeAsync(GetDelegate get) async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    FirebaseAnalytics.instance.logAppOpen().ignore();
  }
}

// Since my development and production environment are the same, I need only
// to change specific settings (in my case, point to a local or remote API
// server, depending on the environment)
@immutable
class DevelopmentEnvironment extends BaseEnvironment {
  const DevelopmentEnvironment();

  @override
  String get serverBaseUrl => "http://localhost:8888";
}

@immutable
class ProductionEnvironment extends BaseEnvironment {
  const ProductionEnvironment();

  @override
  String get serverBaseUrl => "https://my-real-api-server.com";  
}

```

That being done, just use your environment on your main:

```dart
Future<void> main() async {
  await Environment.use(
    kDebugMode 
      ? const DevelopmentEnvironment() 
      : const ProductionEnvironment(),
  );

  runApp(const MainApp());
}
```

Here, I decide which environment to use based on `kDebugMode`, which is a Flutter const that tells me
if I'm in debug or release mode.

You can choose your environment however you want, including using Flutter Flavors.

# Stream Builders

Stream builders are basically a `StreamBuilder` with some easy-to-use features.

A real-world example would be changing which home widget is displayed depending
on the currently authenticated user. For instance, set the `MaterialApp.home`
property to:

```dart
return AuthenticationQuery(
  loginConfiguration: BaseLoginConfiguration(
    header: const AppHeader(),
    privacyPolicyText: "Política de Privacidade",
    privacyPolicyURL: "https://meucronogramacapilar.code.art.br/Privacy.html",
    termsOfUseText: "Termos de Uso",
    termsOfUseURL: "https://meucronogramacapilar.code.art.br/Terms.html",
    signInWithAppleText: "Entrar com Apple",
    signInWithGoogleText: "Entrar com Google",
    footerTextColor: Colors.white,
    progressIndicatorColor: Colors.white,
    backgroundColor: theme.primaryColor,
    onDebug: () => Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => DriftDbViewer(Database.instance)),
    ),
  ),
  builder: (_, principal) => Text(
    principal == null 
      ? "Not authenticated"
      : "${principal!.displayName} authenticated"
  ),
);
```

This `AuthenticationQuery` is a widget of the `query_stack_firebase_authentication`
that will provide a LoginPage for your app automatically.

Its source code is:

```dart
class AuthenticationQuery extends StatelessWidget {
  const AuthenticationQuery({required this.loginConfiguration, required this.builder, super.key});

  final BaseLoginConfiguration loginConfiguration;
  final Widget Function(BuildContext context, Principal principal) builder;

  @override
  Widget build(BuildContext context) {
    return QueryStreamBuilder<Principal>(
      stream: AuthenticationService.current.currentPrincipalStream,
      emptyBuilder: (_) => BaseLoginPage(loginConfiguration: loginConfiguration),
      waitingBuilder: (_) => WaitingPage(header: loginConfiguration.header),
      errorBuilder: (_, __) => BaseLoginPage(loginConfiguration: loginConfiguration),
      initialData: AuthenticationService.current.currentPrincipalStream.hasValue ? AuthenticationService.current.currentPrincipalStream.value : null,
      onError: _onError,
      dataBuilder: builder,
    );
  }

  void _onError(BuildContext context, Object error) {
    showOkAlertDialog(
      context: context,
      title: "Erro inesperado",
      message: error.toString(),
    );
  }
}
```

The magic is done by the `QueryStreamBuilder<Principal>`.

The QueryStreamBuilder will listen to a stream (in this case, the `AuthenticationService` `currentPrincipalStream` that will change from `null` (no user authenticated to an instance of `Principal` (representing the authenticated user))).

Whenever the stream changes, some builder is called:

* `emptyBuilder` will be called whenever the stream content is null or an empty
`Iterator` (empty list, map or set).
* `waitingBuilder` will be called whenever the stream is in a waiting state (the 
first time it initializes)
* `errorBuilder` will be called whenever the stream has an error on it
* `dataBuilder` will be called when the stream has a valid value.

In this case, `empty` means no user authenticated (so we will build a `BaseLoginPage`),
`data` means an authenticated user `so we will build whatever the app wants, passing the
currently authenticated user.

In other words: is a `StreamBuilder` where you don't have to deal with empty values, waiting for states and exceptions by yourself.

# Future Builders

Future builders are special `FutureBuilders` that handle some neat things automatically
for you.

For example, let's assume you need to build a different page, depending on the user
having some settings configurated or not (in my example, the authenticated user has
to configure some company stuff before entering the app, so, I'm using a remote api
to check if the user already has some company configurated or if he needs to set up
that now).

For that purpose, I can use the `QueryFutureBuilder<bool>` to ask my server if it
has some company setup or not (which I call first access). Or I can wrap this in a
specialized widget made for this purpose:

```dart
// By using a custom widget instead of a generic `QueryFutureBuilder<T>,`
// I don't need to manually handle query keys and I can have access
// to a typed specialized version of this data using
// `FirstAccessQuery.of(context)`
@immutable
class FirstAccessQuery extends StatelessWidget {
  const FirstAccessQuery({required this.builder, super.key});

  // This builder will be called with the response of my query
  final Widget Function(BuildContext context, bool firstAccessComplete) builder;

  // Each query must have a key, so I can access them later to
  // make it refresh (for instance: after setuping my first company
  // I can trigger a refetch on this widget manually)
  static final String queryKey = "${FirstAccessQuery}";

  // I just wrap a `QueryFutureBuilder<Response>` so I don't
  // repeat myself in the future and keep all things related
  // in a single place
  @override
  Widget build(BuildContext context) {
    return QueryFutureBuilder<bool>(
      queryKey: queryKey,
      // This is the method that will call my local database or
      // remote API and return me a `true` if this user has any
      // company registered or `false` if don't and I need to
      // do this now
      future: () => CompaniesService.current.getFirstAccessIsComplete(),
      dataBuilder: builder,
    );
  }

  // Some generic `maybeOf` and `of` of `InheritedModels` (those are
  // a special case of `InheritedWidget`s)
  static Query<bool>? maybeOf(BuildContext context) {
    return InheritedModel.inheritFrom<Query<bool>>(context, aspect: queryKey);
  }

  static Query<bool> of(BuildContext context) {
    final result = maybeOf(context);

    assert(result != null, "Unable to find an instance of FirstAccessQuery in the widget tree");

    return result!;
  }
}
```

So, I can now decide what to do based on whatever the user was previously setup:

```dart
...
return FirstAccessQuery(
  builder: (context, hasFirstAccess) {
    if(hasFirstAccess) {
      return const HomePage();
    }

    return const SetupCompanyPage();
  },
);
...
```

On `SetupCompanyPage()`, I can trigger a refresh by calling:

```dart
...
  final query = FirstAccessQuery.of(context);

  await query.refreshFn();
...
```

This will make the `FirstAccessQuery()` widget to reexecute the `future`
function, calling my API again.

Also, `QueryFutureBuilder<T>` can also reexecute its feature when:

* A navigation pops into the page where the `QueryFutureBuilder<T>` is in,
if it is stale (stale is a duration after the execution of the future where
the automatic refetch is not done. If you set this for 5 minutes, then all
the automatic refetchs will only hit your API after 5 minutes since the last
successful response)
* You configure an automatic refetch timer using `refetchInterval`
* Your app was in the background and now returns to the foreground

Also, `QueryFutureBuilder<T>` will attempt to reexecute the future n times (
configurated by the `maxAttempts` property) before yielding an error.

`QueryFutureBuilder<T>` will only set a waiting state (building a `waitingBuilder`,
so you can show, for example, spinning progress while the data is being fetched) if
`keepPreviousDate` is `false`, otherwise, nothing will change until the fetch
is done when the `dataBuilder` will be executed with the new data and your screen
will refresh.

For simple values (such as the default Flutter counter sample), you can define
a mutable service that has some internal `_count` variable that is handled by
functions and those functions triggers a stream:

```dart
class CounterService extends BaseService {
  CounterService(this.initialValue);

  static CounterService get current => Environment.get<CounterService>();

  final int? initialValue;

  // Use the package `rxDart` for this `BehaviorSubject`:
  final _streamController = BehaviorSubject<int>(initialValue ?? 0); 

  Stream<int> get counterStream => _streamController.stream;

  void addToCounter() {
    final currentValue = _streamController.value;

    _streamController.add(currentValue + 1);
  }
}
```

And use the `QueryStreamBuilder`:

```dart
...
return QueryStreamBuilder<int>(
      stream: CounterService.current.counterStream,
      initialData: 1,
      dataBuilder: (context, value) => Text("Counter: ${value}"),
    )
...
```

This way, your counter value is immutable outside your service (which is the
major problem with Provider).