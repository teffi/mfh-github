# GitHub Community
Take a peek at the GitHub Community and their repositories.


## Running instructions
Requirement: **Github Personal Access Token**. Please generate your own *fine-grained personal access tokens* 
 
**🚨IMPORTANT: To run the app in Xcode, open the the project and replace the token in `RootView.swift`**

```
    // RootView.swift
    let token = "your-token-here"
```

## Implementation overview

### Architecture
- MVVM + Router + Repository + APIService
- To keep things simple, I used direct constructor dependency injection pattern.
 
Note: For apps with more screens, I would use Swinject or something similar.

### API workflow
- The app uses Github's API response url attributes to identify the other endpoints.

**Note:** For apps with larger scope and different API designs, I would write the endpoint models. 

```
// Alternative approach. Something like this
struct UsersAPIEndpoint: EndpointProtocol {
  func path() -> String { baseUrlString + "/users" }
  func method() -> HTTPMethod { .get }
  func body() -> [String: Any] // or Encodable
}

class APIService {
  ...
  func sendRequest(endpoint: EndpointProtocol,...) { 
}

```

### State and Data
- Between `Combine` and `Async Await`, I decided to use `Async Await` for API calls.
- To illustrate `Combine` chaining capabilities, I used it on filter users feature.


### UI/UX
- To achieve a richer ui on the first screen, I used two endpoints retrieved both users list and each user's data.

  

## Comments
* I kept this app implementation direct and simple. 
* Future development – add envs, add color/image libraries, more ui components, factory or container dependency injection.




