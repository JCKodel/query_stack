# Query Stack

A simple yet powerful state management that makes fetching, caching, synchronizing and updating state in your Flutter applications a breeze.

# Inspired by React Query

This package is inspired by the [TanStack Query](https://tanstack.com/query/v5/docs/react/overview).

## Features

* Integrated dependency injection system.
* Easy to use.
* Promotes SOLID design patterns and Clean Architecture.
* Promotes DRY pattern and the creation of domain plugins (i.e.: once an authentication plugin is created, it's highly reusable in other apps).

# Important software architecture and principles information

If you are already familiar with SOLID, Clean Architecture, DRY, repository pattern, CQRS and TDD, you can [skip this section](#get-started).

## What is Clean architecture?

Clean architecture is a software architecture following [Uncle Bob’s principles](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html). The key idea is to use the dependency inversion principle to place boundaries between high-level components and low-level components. This creates a “plug-in architecture” that keeps the system flexible and maintainable.

## What is SOLID?

SOLID is a set of principles for software design that can help developers build more robust, maintainable, and extensible software systems. Here is a brief overview of each of the SOLID principles:

**S**: Single Responsibility Principle (SRP): By ensuring that a class has only one responsibility, it becomes easier to understand, test, and maintain the code. Changes can be made to a specific part of the code without affecting other parts of the system.

**O**: Open/Closed Principle (OCP): This principle promotes code reuse and reduces the risk of introducing new bugs when modifying existing code. By making modules open for extension but closed for modification, new functionality can be added without breaking existing code, so you can reuse those classes in other projects (and the more you use, the more you refine it, tune it and make it performant).

**L**: Liskov Substitution Principle (LSP): By ensuring that objects of a superclass can be replaced with objects of its subclass, the code becomes more flexible and extensible. This allows for polymorphic behaviour and simplifies code reuse.

**I**: Interface Segregation Principle (ISP): By separating interfaces into smaller, more specific ones, it becomes easier to develop, maintain, and test code. Clients can implement only the interfaces that they need, which promotes loose coupling and reduces the impact of changes.

**D**: Dependency Inversion Principle (DIP): By depending on abstractions rather than concrete implementations, the code becomes more modular and flexible. Changes in low-level modules do not affect high-level modules, and different implementations of the same interface can be used interchangeably.

By following these SOLID principles, developers can create code that is easier to understand, maintain, and extend over time. These principles help to reduce the risk of bugs, promote code reuse, and make the codebase more flexible and adaptable to change.

## DRY

The DRY (Don't Repeat Yourself) principle is a software development principle that states that a piece of code should not be repeated throughout a program. Instead, the code should be abstracted into a single, reusable component.

The DRY principle is based on the idea that code duplication can lead to inconsistencies, errors, and higher maintenance costs. If a change needs to be made, it may need to be made in multiple places, increasing the likelihood of introducing errors and making the code more difficult to maintain.

By applying the DRY principle, developers can improve the quality of their code and reduce its complexity. Reusing code also helps to reduce the amount of time and effort required to develop new features or fix bugs.

In practice, applying the DRY principle can involve creating reusable functions, classes, and libraries, and avoiding copy-pasting code. Instead of repeating the same code in multiple places, a developer can extract the code into a separate function or class and call it from multiple places as needed. This helps to reduce code redundancy and makes the codebase more modular and maintainable.

One of the goals of this package is to promote the creation of plugins. For instance, many apps need to authenticate the user using, for example, Google Sign In, Sign In With Apple and Firebase Authentication (especially because they are all free to use, with no costs whatsoever). One person can create a domain + repositories classes for authentication and anyone using query_stack can simply register those classes, add some needed configuration and voila, authentication is implemented.

## TDD

Test-driven development (TDD) is a software development process in which developers write automated tests before writing the code to implement the feature or functionality being tested. TDD involves a continuous cycle of writing a failing test, writing the code to pass the test, and then refactoring the code to improve its quality.

The advantages of using TDD in software development include:

Improved code quality: By writing tests first, developers are forced to think carefully about the design of their code and ensure that it is structured in a way that is testable and maintainable.

Faster feedback loop: TDD provides rapid feedback on whether the code is working as expected or not. This allows developers to catch and fix issues early in the development process, reducing the risk of bugs and other problems later on.

Reduced debugging time: Since TDD helps to catch and fix issues early on, it can significantly reduce the amount of time spent debugging code.

Better code coverage: TDD encourages developers to write comprehensive tests, which helps to ensure that all parts of the code are covered and that edge cases are taken into account.

Easier maintenance: TDD can make it easier to maintain code over time, as changes and updates can be made with confidence that the tests will catch any issues that arise.

Improved collaboration: TDD promotes collaboration between developers and testers, as both parties can work together to create and maintain a suite of tests that ensure the code is working as intended.

Overall, TDD helps to improve the quality and reliability of software, reduces the risk of bugs and other issues, and can lead to a more efficient and collaborative development process.

## Repository pattern

The repository pattern is a design pattern that provides a way to abstract the data access layer in a software application. It provides a layer of separation between the application logic and the underlying data store by providing a set of abstractions for reading and writing data.

The main advantage of using the repository pattern is that it helps to decouple the application from the data access layer, making it easier to change the data storage mechanism without affecting the application logic. This also makes the application more modular and easier to test, as the application can be tested independently of the data access layer.

Some other advantages of using the repository pattern include:

Improved maintainability: Since the repository pattern provides a clear separation between the application logic and the data access layer, it makes it easier to modify or refactor either layer without affecting the other.

Simplified testing: The repository pattern makes it easier to write unit tests for the application logic, as the data access layer can be mocked or replaced with a test implementation.

Increased flexibility: By using the repository pattern, the application can support multiple data storage mechanisms, such as relational databases, NoSQL databases, or in-memory data stores.

Improved code quality: The repository pattern promotes the use of well-defined interfaces for data access, which can help to improve the overall quality and consistency of the codebase.

Easier code reuse: By separating the data access logic from the application logic, the repository pattern makes it easier to reuse code across different parts of the application or across different applications.

In summary, the repository pattern provides a way to abstract the data access layer in a software application, which makes the application more modular, easier to test, and more flexible. It can also help to improve the maintainability, quality, and reusability of the codebase.

## CQRS

CQRS (Command Query Responsibility Segregation) is an architectural pattern that separates an application into two parts: one part for handling commands that change the state of the system, and another part for handling queries that retrieve data from the system. The advantages of using CQRS in software development include:

Improved scalability: By separating the read and write operations, CQRS allows each part of the system to scale independently based on its specific needs. This can help to improve performance and reduce bottlenecks.

Improved performance: Since read and write operations are handled separately, each part of the system can be optimized for its specific use case, which can improve overall performance.

Improved data consistency: CQRS makes it easier to enforce data consistency by using different models for reads and writes. This helps to reduce the risk of data inconsistencies and other errors.

Improved flexibility: CQRS provides a way to use different storage mechanisms and data structures for reads and writes, which can increase the flexibility of the system and make it easier to adapt to changing requirements.

Improved testability: CQRS makes it easier to write automated tests for the system, as each part of the system can be tested independently.

Improved maintainability: By separating the read and write operations, CQRS makes it easier to modify or refactor different parts of the system without affecting the other.

Improved collaboration: CQRS can improve collaboration between developers and business stakeholders, as it provides a clear separation between the application logic and the data access layer.

In summary, CQRS can help to improve scalability, performance, data consistency, flexibility, testability, maintainability, and collaboration in a software system. It is particularly useful in systems with complex data access requirements or high levels of concurrency.

# Get started

Using QueryStack is very simple. All you need to do is to create an `Environment`. An `Environment` is a class that handles the dependency injection and the initialization of your app. You can have many environments, such as `DevelopmentEnvironment`, with settings suitable for a development environment (for example: using local APIs or different URLs of remote APIs pointing to your development server and so on), `ProductionEnvironment` then can inherit `DevelopmentEnvironment` and change some settings (such as URLs, API keys, etc.), you can have some `HomologationDevelopment` or `TestDevelopment`, whatever environments you need.

## Creating an Environment

To create an environment, all you need to do is to create a class that inherits `Environment` and then implement two methods: `registerDependencies`, where you will set what object will be created when you ask for a specific class, along with its arguments.

For development/production environments, these registrations often have different arguments (let's say, for example, the URL of your app's API, where you point to a local development server during development and the production remote server during production).

For test environments, these registrations will return mocked objects instead of real repositories (because repositories fetches data from real data sources, it is not very suitable for tests). Since we are using dependency injection, we can get our repositories interfaces and easily implement mocks using, for example, the [mockito package](https://pub.dev/packages/mockito).

Using authentication as an example, your `DevelopmentEnvironment` should be something like this:

```dart
@immutable
class DevelopmentEnvironment extends Environment {
  const DevelopmentEnvironment();

  @override
  void registerDependencies(RegisterDependenciesDelegate when) {
    // IAuthenticationRepository is an interface: a blue-print 
    // for classes that will implement authentication.
    // In this environment, whenever the app requests that blue-
    // print, we will return a concrete `FirebaserAuthenticationRepository`
    // instance, with these settings.
    when<IAuthenticationRepository>(
      (use) => FirebaseAuthenticationRepository(
        appleRedirectUrl: "required setting",
        appleServiceId: "required setting",
        googleClientId: "required setting",
        platformInfo: platformInfo,
      ),
    );

    // The same here for analytics.
    when<IAnalyticsRepository>(
      (use) => const FirebaseAnalyticsRepository(),
    );

    // I can use repositories for native plugins as well,
    // in this example, I use the DeviceInfoPlus package
    // to get device information
    when<IDeviceInfoRepository>(
      (use) => DeviceInfoRepository(
        platformInfo: platformInfo,
      ),
    );

    // And even some neat local databases (a good local database
    // is SQLite with Drift, that works with web and has automatic
    // isolate support).
    //
    // Notice that Database, in this case, is always concrete, since
    // you don't really need to create an interface for a class that
    // is app-specific and hence will never be reutilized.
    when<Database>(
      (use) => Database(),
    );

    // And here we have an example of a class that provides some
    // neat Global Unique Identifiers, think of this as a private
    // library of utilities that you can share amongst many apps.
    when<GuidCombFeature>(
      (use) => const GuidCombFeature(),
    );

    // And here we have a reusable "feature" for our authentication.
    // Notice how we pass all dependencies used by this domain
    // by using the `use` method:
    when<AuthenticationFeature>(
      (use) => AuthenticationFeature(
        authenticationRepository: use<IAuthenticationRepository>(),
        principalRepository: use<IPrincipalRepository>(),
        analyticsRepository: use<IAnalyticsRepository>(),
        deviceInfoRepository: use<IDeviceInfoRepository>(),
      ),
    );
  }

  // This method is called by the `EnvironmentProvider` as soon the
  // `registerDependencies` method finishes its job.
  @override
  Future<void> initializeAsync(UseDelegate use) async {
    // Here is the place to initialize some stuff, such as Firebase...
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    await Future.wait(
      [
        // ...and your app-specific database, with data migrations and other
        // interesting stuff that needs to be initialized
        use<Database>().initializeAsync(),
      ],
    );
  }
}
```

This class is suitable for a production environment because it does not contain any class or configuration that must be different among these environments, but, let's imagine you need to provide an API URL and key for each environment, you could:

```dart
@immutable
class DevelopmentEnvironment extends Environment {
  const DevelopmentEnvironment();

  String get apiURL => "http://localhost/dev-api";
  String get apiKey => "some-dev-key";

  @override
  void registerDependencies(RegisterDependenciesDelegate when) {
    when<IMyApi>(
      (use) => SomeHttpConcreteClass(
        apiURL: apiURL,
        apiKey: apiKey,
      ),
    );
  }
}
```

So, for your production environment, all you need to do is to override those settings:

```dart
@immutable
class ProductionEnvironment extends DevelopmentEnvironment {
  const ProductionEnvironment();

  @override
  String get apiURL => "http://remote-server/production-api";

  @override
  String get apiKey => "some-production-key";
}
```

If you need to change dependency registrations or even initialization, you could override those methods in `ProductionEnvironment` and re-register your dependencies (they will be overwritten) or, even better, create a `BaseEnvironment` abstract class that does all the common job, then create two inherited classes (development and production) that will handle the remaining differences (remember the "O" from SOLID).

## Initializing your environment

With your environment ready, all you need to do is to add two things in your app:

### EnvironmentProvider

This is how a QueryStack main is:

```dart
void main() {
  runApp(
    const EnvironmentProvider(
      environment: kDebugMode ? DevelopmentEnvironment() : ProductionEnvironment(),
      child: App(),
    ),
  );
}
```

You just need to wrap your App inside an `EnvironmentProvider`, pass the desired environment class and...

### Very important step!!!

...add the environment route observer to your app.

```dart
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // You can use this to get your environment when needed:
    final environment = EnvironmentProvider.of(context);

    return MaterialApp( // Or CupertinoApp
      navigatorObservers: [environment.routeObserver],
      ...
    );
}
```

This is important because the queries will refetch themselves, if they need when a widget is re-rendered after a navigation pop (i.e.: you are showing some page with data, then navigates to another page, then navigate back... that page will refetch the data, if stale, so the user can always see the latest data automatically).

# Queries

A query is any method that returns some data for your application. It can be sync or async (`Query<T>` will require a `FutureOr<T>`, i.e.: you can return `T` or `Future<T>`). You can really use any method you like, but the query builder will provide you with a `use` argument, where you can grab instances of those classes you registered on the `registerDependencies`.

If those classes have any global state in them (for instance, the currently authenticated user), you can create a method that returns that (and that is the whole "state management" thing). The only difference between other state managements is that those states are not reactive: they are refetched (meaning: this query method will be reexecuted) when a mutation with the same key occurs (so we know that data is dirty and need to be rebuilt), or when you change that query key by hand.

So, imagine our `AuthenticationFeature` class has a `getCurrentPrincipal()` method that returns the currently authenticated user (which we call principal in an entity class named `Principal` that has the name, avatar, email and id of such user):

```dart
return MaterialApp(
  navigatorObservers: [environment.routeObserver],
  // Our query will use our `Principal` class that contains
  // our user information
  home: QueryBuilder<Principal>(
    // This is the query key. A mutation that mutates the same key
    // will invalidate this query and it will rerun the method
    // in the `queryFn` property below
    queryKey: QueryKey(const ["authentication"]),
    // This is our data fetcher, the method responsible to get us
    // the currently authenticated user
    queryFn: (use) => use<AuthenticationFeature>().getCurrentPrincipal(),
    // Whenever this query changes (it can be the first time, after a mutation,
    // after a specified period, after a navigation, after the app comes to 
    // foreground, etc.)
    builder: (context, query) {
      // Which is the state of our query?
      switch (query.status) {
        // It's an error? We will render a red screen of death
        // (or whatever you want to represent an error state)
        case QueryStatus.error:
          return ErrorWidget(query.error!);
        // It's empty? (i.e.: the query returned null or an empty
        // List or Map?) We will render some neat "this is empty"
        // piece of UI. 
        // In this case, Empty means Principal is null, which means
        // there is no user authenticated, so, we render the
        // LoginPage
        case QueryStatus.empty:
          return const LoginPage();
        // Now we have data, so let's use that data.
        // In this case, the data is the currently authenticated user,
        // which we don't use anywhere for now (we just need to know
        // someone is authenticated)
        case QueryStatus.success:
          return const HomePage();
        // The other cases are `QueryStatus.idle` (we didn't run yet)
        // and `QueryStatus.loading` (we are loading), so, in both
        // cases, we show a progress indicator:
        default:
          return const Scaffold(body: Center(child: CircularProgressIndicator.adaptive()));
      }
    },
  ),
  ```

  Now, you can configure that query in many ways: such as refetch it n times per second, or how many time should pass before that query is considered as stale (meaning: it is old data and we should refresh it as soon as possible or, if is not stale, we don't even refetch it, saving a precious roundtrip to the server!)

  # Mutations

  There are two ways of mutating some query: by using the method `mutate` in the current `Environment` (which can be retrieved by `EnvironmentProvider.of(context)`) or by using a `MutationBuilder`:

  ```dart
  class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // This will be rebuilt depending on the mutation state:
        child: MutationBuilder<Principal>(
          // This mutation will invalidate all `QueryBuilder` that
          // have a key starting with `"authentication"`
          queryKey: QueryKey(const ["authentication"]),
          onError: (Object ex) async {
            // This is a good place to invoke some dialogs showing some
            // error that occurred in the authentication process
          },
          builder: (context, mutation) {
            // Here you have the same kind of state in the mutation.status:
            // MutationStatus.idle: the mutation never run (initial status)
            // MutationStatus.mutating: the mutation method is running
            // MutationStatus.error: an error ocurred
            // MutationStatus.success: the mutation was successful
            
            // There are some neat shortcuts so you can render your UI
            // accordingly, for example: to disable an authentication
            // button, you could:
            return TextButton(
              onPressed: mutation.isBusy 
                        ? null 
                        : mutation.mutate(
                          (use) => use<AuthenticationFeature>().signInWithGoogle(),
                        )
            );

            // The `mutation.mutate` method will trigger a mutation rebuild.

...
```

# Query keys

The query keys are unique identifiers for each query. They are a `List<Object>`, so you can create a key with all your entities' attributes, such as the examples below.

/!\ Important: your key will be converted to `String`, so it is important that all objects inside your keys can be safely converted to `String`.

Key examples:

1) `["movies"]` - For a list of all movies in an app
2) `["movies", { "genre": 2 }]` - For a list of all movies filtered by genre with id 2
3) `["movies", 345]` - A single movie with id 345

When mutated, this will happen:

1) All 3 queries will be mark as stale (so they will be refreshed as soon as they are rendered), and the `["movies"]` query will receive the result of the mutation (optimistic update - the UI will be re-rendered using that new data and the new data from the `queryFn` will be fetched when possible).
2) Only the lists that are showing movies of genre 2 will be updated.
3) Only the queries that are showing the movie with id 345 will be updated. If you need to update more queries (for example, the `["movies]`, so all data in your app will reflect the movie #345 changes, you can force the update by using the `mutation.invalidateQueryKey(["mutation"])`, which will invalidate all queries that have a key that begins with `"authentication"`. If you want to update only the movies list, you can set the key to specific: `mutation.invalidateQueryKey(["mutation"], isSpecific: true)`.