# Project Description

This repository contains a demo project built using SwiftUI, connected to the Rick and Morty API. The project adheres closely to the principles of Clean Architecture, with a focus on SOLID principles.

## Features

- **SwiftUI Implementation**: The user interface is built entirely using SwiftUI, Apple's modern framework for building user interfaces across all Apple platforms.

- **Integration with Rick and Morty API**: The project fetches data from the [Rick and Morty API](https://rickandmortyapi.com/) to populate its content. This includes character information, locations, and episodes.

- **Display of characters from the Rick and Morty universe.**

- **Characters are presented in a grid layout with columns.**

- **SwiftData**: Data Persistance

- **Pagination is implemented automatically**, allowing for seamless browsing through the characters.

- **View detail from this character**

- **Clean Architecture**: The project follows the Clean Architecture principles, separating concerns into layers such as Presentation, Domain, and Data layers. This ensures modularity, maintainability, and testability of the codebase.

- **SOLID Principles**: The codebase adheres to the SOLID principles (Single Responsibility, Open/Closed, Liskov Substitution, Interface Segregation, Dependency Inversion), promoting code that is easy to understand, maintain, and extend.

- **Unit Testing**: Implemented to test data source

## Structure

The project is organized into several modules:

- **Presentation Layer**: Contains SwiftUI views, view models, and UI-related logic.
  
- **Domain Layer**: Defines business logic and entities that are independent of any specific UI framework or data source.

- **Data Layer**: Handles data retrieval and storage, including networking with the Rick and Morty API.

## NO Third-party libraries

## Getting Started

To run the project locally, follow these steps:

1. Clone this repository to your local machine.
2. Open the project in Xcode.
3. Build and run the project on your desired iOS or macOS device/simulator.

## Requirements

- iOS 17

## Contributing

Contributions to this project are welcome! If you find any bugs or have suggestions for improvements, please feel free to open an issue or submit a pull request.

## License

This project is licensed under the [MIT License](LICENSE). Feel free to use and modify the code as needed.

## Acknowledgements

- The project was inspired by the creativity of the creators of Rick and Morty.
- Thanks to the community for providing feedback and suggestions for improvement.

