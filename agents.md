# Agents Guide — Recipes

This document gives AI coding agents the context needed to work effectively in this codebase.

## Project purpose and summary

**Recipes** is an offline-first iOS application to be used as a personal cooking recipe book.

## UI Design in Figma
https://www.figma.com/design/Pmt3Jutavs9rPe8MJaNtLA/Recipes?node-id=0-1 

Figma is the reference for visual design when a task involves UI appearance or layout. Do not change UI solely to match Figma unless the task concerns that UI.

## Architecture

- The project consists of several modules
- Modules in the "Feature" folder are representing features consisting of one or more screens user interacts with  
- SwiftUI is used for UI
- New asynchronous code should use Swift structured concurrency (async/await, Task, actors) by default.
- Do not introduce Combine, GCD, callbacks, or other concurrency mechanisms for new code unless required by an existing API or explicitly requested by the task.
- Do not migrate existing code to structured concurrency unless it is necessary for the task.
- Dependencies are provided using manual dependency injection. Object graphs are assembled explicitly at composition roots. Do not introduce a DI framework or service locator unless explicitly requested.

## Purely educational parts of the project

- folder "Лекции" - contains some lecturer notes and must not be modified by agents

## Testing

- The project uses **Swift Testing** (`@Test`, `#expect`) throughout — not XCTest, except for legacy snapshot tests.
- User-visible feature behavior and user flows must be covered by acceptance tests. Purely visual changes that do not affect behavior do not require new acceptance tests.
- Acceptance tests should describe behavior in domain/user terminology and must not expose implementation details such as ViewModels, repositories, loaders, SwiftUI views, or networking clients.
- Use DSL objects such as Feature, User, and Server to translate implementation details into user/domain concepts.
- Existing acceptance tests are executable specifications and must not be modified unless the task explicitly requires changing the specified behavior.
- If an existing acceptance test conflicts with the requested behavior, do not modify it silently. Ask the task owner for clarification.
- Agents may add DSL vocabulary required by new acceptance tests, but must not change the semantics or public API of existing DSL objects without explicit approval from the task owner for that change.

## Git
- Branches created by agents must be prefixed with "dev/ai"
- New branches connected with GitHub issues must be named `dev/ai/issue-N`, where N is the issue number.
- Agents must not commit into branches not prefixed with "dev/ai" unless it is explicitly stated in task

## Task processing rules and code style
- If the task names an existing type, function, module, or API, search the project for it before creating anything new.
- If an exact match is not found, look for obvious existing equivalents.
- Do not create a new similarly named abstraction merely because the name from the task was not found. If multiple plausible equivalents exist and the choice affects the design, ask for clarification.
- Naming for screens and views should start with the name of the entity they are related to (RecipeEdit, not EditRecipe)  
- Keep changes scoped to the task. Do not refactor, rename, reformat, or migrate unrelated code unless required to complete the task.

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

After making changes, agents must run the narrowest relevant test scheme.
- Changes in RecipeList → run RecipeList
- Changes in RecipeEdit or RecipeDetail → run RecipeEdit
- App-level/integration changes → run recipes

Run broader test suites only when the change affects multiple modules or shared infrastructure.
**Notes:**
- `swift build` without flags builds for macOS and fails on UIKit imports — always use `xcodebuild`
- The workspace file is at `Recipes.xcworkspace` in the project root

## Handling ambiguity

- Do not guess when a task is ambiguous in a way that can materially affect behavior, architecture, or public APIs.
- First inspect the existing codebase, tests, and established patterns for an answer.
- Prefer existing project conventions over introducing a new pattern.
- If multiple materially different solutions remain plausible after inspecting the codebase, ask the task owner for clarification before implementing.
- Do not ask for clarification when the ambiguity can be resolved safely from existing code or tests.
