# Trains

Trains is an iOS app for searching train routes and viewing carrier information. The app allows users to choose cities and stations, browse route results, apply filters, and open detailed carrier information.

## Features

- City selection
- Station selection
- Route search
- Carrier results screen
- Carrier details screen
- Search filters
- Error screens for network and server issues
- Settings screen
- Stories interface
- Loading placeholders and shimmer effects

## Tech Stack

- Swift
- SwiftUI
- Combine
- async/await
- OpenAPI-based API description

## Installation

1. Clone the repository:
   `git clone https://github.com/maximgv3/Trains.git`

2. Open the project:
   `open Trains.xcodeproj`

3. Run the app in Xcode.

## Screenshots

<p align="left">
  <img src="https://github.com/user-attachments/assets/4409879b-ba71-4e8c-823c-1ca971d058a5" width="125" />
  <img src="https://github.com/user-attachments/assets/66fe13b5-0f64-4d9e-a194-f8bed5b1cf6f" width="125" />
  <img src="https://github.com/user-attachments/assets/b9b80d94-076c-4253-a214-346c33799736" width="125" />
  <img src="https://github.com/user-attachments/assets/0e79d55b-73b0-488c-b422-582b3ac63465" width="125" />
  <img src="https://github.com/user-attachments/assets/00a366e0-4880-4c04-bc81-d4f8552e2cd6" width="125" />
  <img src="https://github.com/user-attachments/assets/95bbcf12-03ad-4c88-9cca-f1a2f1b2b124" width="125" />
</p>

## Architecture

The project is divided into several feature modules:

- **Main screen** — route entry point
- **City selection** — choosing departure and destination cities
- **Station selection** — choosing stations
- **Carrier results** — route and carrier search results
- **Carrier info** — detailed carrier information
- **Stories** — promotional / informational stories UI
- **Services** — networking, search, stations, schedules, and carrier data

The app is built with **SwiftUI** and uses **Combine** and **async/await** in the presentation and networking layers.

## Result

This project demonstrates building a multi-screen SwiftUI application with routing logic, modular structure, network services, filters, loading states, and error handling.
