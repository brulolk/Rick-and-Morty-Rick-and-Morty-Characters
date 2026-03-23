# Rick and Morty Characters App

iOS application built with SwiftUI that consumes the Rick and Morty API to display a list of characters with search, filtering, pagination, and details.

---

## 🚀 How to Run

### Requirements

* Xcode 15+
* iOS 16+

### Steps

1. Open the project in Xcode
2. Select a simulator or device
3. Run the app (`⌘ + R`)

---

## 🏗️ Architecture

The project follows the **MVVM (Model-View-ViewModel)** pattern.

**Why MVVM?**

* Clear separation between UI and business logic
* Easy to test ViewModels
* Works naturally with SwiftUI

Structure:

* **View**: SwiftUI screens
* **ViewModel**: State + business logic
* **Model**: API response structures
* **Service/Network**: Data fetching and abstraction

---

## 💉 Dependency Injection

Dependency Injection is done via **protocols + constructor injection**.

* Protocols define contracts (`Service`, `NetworkClient`)
* Concrete implementations are injected into ViewModels and Services

Example:

```swift id="d82k1a"
init(service: RickAndMortyServiceProtocol? = nil) {
    self.service = service ?? RickAndMortyService()
}
```

**Why?**

* Improves testability
* Reduces coupling
* Allows easy mocking

---

## 🧪 Tests

Tests focus on **core logic**:

* Service layer (API response + error handling)
* ViewModel behavior (state changes)

Mocks are used to simulate network and service responses.

---

## 📊 Observability

Basic logging is implemented in the network layer:

* Status codes
* Network errors
* Decoding errors

---

## 🔐 Security

* Uses `URLSession` with HTTPS
* No sensitive data stored
* Error handling is abstracted via `APIError`

---

## 🔄 Improvements

* Add image caching
* Improve loading states
* Add retry mechanism in the network layer
* Handle `tooManyRequests` by allowing users to retry after a cooldown period
* Increase test coverage
* Introduce Coordinator and Factory patterns to improve separation of concerns

---

## 📦 API

https://rickandmortyapi.com

---

## 👨‍💻 Author
Bruno Vinicius
