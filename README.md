# Staring Round Up

**Minimum Deployment Target:** 15.0 *(can be adjusted to lower versions by swapping out the networking layer)*

Staring Round Up is a simple UIKit app powered by the Starling API, RxSwift, and Swift Concurrency. It facilitates rounding up transactions and adding them to a savings goal.

## Getting Started
Refer to the authentication section for initial setup details.

### Authentication
Implementing a fully functioning authentication flow is beyond the scope of this project. A dummy authentication flow is included in the app – if the token expires, the user is presented with a simulated login screen. However, the actual OAuth flow is not implemented.

To proceed, users need to manually add their `authToken` and `user agent` to the app. Modify the `userAgentHolder` and `authTokenHolderValid` variables within the `KeychainClient`. Note that this manual approach is for demo purposes, and in a production environment, a more secure method should be employed.

A `SessionManager` class is provided, handling storage and retrieval of sensitive data through its dependency `KeychainManager`. The `KeychainManager` is stubbed with a test value for this demo.

Note:
If you would like me to implement this properly, please let me know.

### Architecture
The app adheres to a basic modular MVVM pattern, consisting of four screens: login, transaction feed, savings goal list, and create savings goal. It features a tree-like drill-down navigation structure.

#### Navigation
Possible navigation destinations are modeled by routes in the view model. This approach allows precise domain modeling by keeping all potential destinations in one place, enumerated as cases that must be handled appropriately.

While the coordinator pattern was considered for navigation extraction, it was deemed overkill for an app of this size. However, its usage could be beneficial if the app were to expand significantly. I'd consider using it if iwas to rewrite the project.

### UI
The app utilizes reusable color systems, font systems, and UI components.

- UI components can be found in the `views` directory.
- Systems can be found under `Common`.

### Testing
All the main feature view models are tested, although not fully covered due to time constraints. Additional test cases can be added upon request. Dependencies such as `APIClient` and `RoundUpClient` have also been tested.

### Improvements and Todos
- Add support for switching between user accounts.
- Enhance test coverage with additional test cases.
- Implement a database for persistent data, allowing the app to function offline.
- Inline with the above, introduce a repository layer between the `APIClient` and the view model.
- Enable dynamic date changes within the app to round up transactions for differnet weeks.
