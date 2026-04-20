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
