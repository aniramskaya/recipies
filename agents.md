# Agents Guide — Recipies

This document gives AI coding agents the context needed to work effectively in this codebase.

## Project purpose and summary

**Recipies** is an educational iOS project which is intended to display different coding techniques and architectural solutions. It is evolving step-by step with tiny changes. Agents should not predict the future development of the project and should not try to design for the future unless it is explicitly stated in the task.

## Architecture

- the project consists of several modules
- modules in the "Feature" folder are representing features consisting of one ore more screens user interacts with  
- SwiftUI is used for UI
- Swift 6 and structured concurrency are primarily used unless something else is explicitly stated in the task
- manual Dependency Inversion together with composition are considered to be the architectural style

## Purely educational parts of the project

- folder "Лекции" - contains some lecturer notes and shoud be not modified by agents
- folders "CombineServices" and "CallbackServices" are to display different implementation possibilities and should not be considered as a working code

## Testing strategy

- The project uses **Swift Testing** (`@Test`, `#expect`) throughout — not XCTest, except for legacy snapshot tests. Tests follow strict TDD: Red → Green → Refactor. Coverage is measured by user scenarios, not lines
- UI reatures (aka screens and screen sequences) should be covered with acceptance tests
- Acceptance tests should use human intuitive terminology like Feature, Server, User and so on to provide readers clear understanding how feature works
- DSL objects and functions should be used to adapt technical feature terminology to acceptance tests terminology
- Agents should not modify acceptance tests unless it is explicitly stated in the task
- DSL object can be modified by agents while implementing a feature with explicit confirmation from the task owner

## Git
- Agents must create git branches with prefix "dev/ai"
- Agents cannot commiе into branches not prefixed with "dev/ai" unless it is explicitly stated in task
- Branches connected with Github issues should be named as "issue-N" where N is the number of the issue
