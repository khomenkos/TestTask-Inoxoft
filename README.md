# TestTask (News App)

## Network & API
The app uses **[NewsAPI](https://newsapi.org/)** as its data source.

## Architecture: Clean Architecture + MVVM + Coordinators
Ensures excellent scalability and testability.
- **Clean Architecture & Dependency Injection**: The project is strictly divided into layers (Presentation, Domain, Data). All external dependencies (repositories, network services) are hidden behind protocols and injected via initializers (DI).
- **Programmatic UI**: The UI is implemented entirely in code using UIKit + SwiftUI.
- **Coordinator Pattern**: All navigation logic is extracted into `AppCoordinator`.

## Dependencies (Swift Package Manager)
1. **Alamofire**
2. **Realm Swift**
3. **Kingfisher**

## Setup Instructions
1. In the root directory, rename `Secrets.xcconfig.example` to `Secrets.xcconfig`.
2. Open `Secrets.xcconfig` and set your personal key:
   `API_KEY = YOUR_API_KEY_HERE`
