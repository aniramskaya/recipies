# Agents Guide — Recipies

This document gives AI coding agents the context needed to work effectively in this codebase.

## Project purpose and summary

**Recipies** is an offline-first iOS application to be used as a personal cooking recipe book.

## UI Design in Figma
https://www.figma.com/design/Pmt3Jutavs9rPe8MJaNtLA/Recipes?node-id=0-1 

## Architecture

- the project consists of several modules
- modules in the "Feature" folder are representing features consisting of one ore more screens user interacts with  
- SwiftUI is used for UI
- Swift 6 and structured concurrency are primarily used unless something else is explicitly stated in the task
- manual Dependency Injection together with composition are considered to be the architectural style
- Agents should not predict the future development of the project and should not try to design for the future unless it is explicitly stated in the task.

## Purely educational parts of the project

- folder "Лекции" - contains some lecturer notes and shoud be not modified by agents

## Testing

- The project uses **Swift Testing** (`@Test`, `#expect`) throughout — not XCTest, except for legacy snapshot tests. Tests follow strict TDD: Red → Green → Refactor. Coverage is measured by user scenarios, not lines
- UI reatures (aka screens and screen sequences) should be covered with acceptance tests
- Acceptance tests should use human intuitive terminology like Feature, Server, User and so on to provide readers clear understanding how feature works
- DSL objects and functions should be used to adapt technical feature terminology to acceptance tests terminology
- Agents should not modify acceptance tests unless it is explicitly stated in the task
- DSL objects can be modified by agents while implementing a feature with explicit confirmation from the task owner

## Git
- Agents must create git branches with prefix "dev/ai"
- Agents cannot commiе into branches not prefixed with "dev/ai" unless it is explicitly stated in task
- Branches connected with Github issues should be named as "issue-N" where N is the number of the issue

## Task processing rules and code style
- If task given by agent user contains names for certan types to create, agent should use them without changes
- Naming for screens and views should start with the name of the entity they are related to (RecipeEdit, not EditRecipe)  

## Build & Test

Tests are run via `xcodebuild` through the workspace:

xcodebuild test
  -workspace Recipes.xcworkspace
  -scheme <SchemeName>
  -destination 'platform=iOS Simulator,name=iPhone 17'

**Schemes:**
- `RecipeList` — tests for the RecipeList feature
- `RecipeEdit` — tests for RecipeEdit and RecipeDetail features (both live in the RecipeEdit package)
- `recipes` — integration/app-level tests

**Notes:**
- `swift build` without flags builds for macOS and fails on UIKit imports — always use `xcodebuild`
- The workspace file is at `Recipes.xcworkspace` in the project root
