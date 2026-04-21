# Flow

> ⚠️ Библиотека находится в начальной стадии разработки. API может меняться.

`Flow` — лёгкая обёртка над async/throws-операцией, позволяющая выстраивать цепочки преобразований в функциональном стиле.

## Идея

`Flow<Value>` хранит одну асинхронную операцию и предоставляет набор операторов для её композиции. Операция не запускается до явного вызова `run()` или `callAsFunction()`.

## Установка

### Swift Package Manager

```swift
.package(path: "../Shared/Flow")
```

```swift
.product(name: "Flow", package: "Flow")
```

## Использование

### Создание

```swift
let flow = Flow {
    try await networkClient.fetchRecipes()
}
```

### Запуск

```swift
let recipes = try await flow.run()
// или эквивалентно:
let recipes = try await flow()
```

### Операторы

**`map`** — преобразует результат:

```swift
let titles: Flow<[String]> = flow.map { recipes in
    recipes.map(\.title)
}
```

**`fallback`** — при ошибке выполняет резервную операцию:

```swift
let resilient = flow.fallback {
    try await cache.loadRecipes()
}
```

**`onSuccess`** — побочное действие при успехе, не меняет значение:

```swift
let tracked = flow.onSuccess { recipes in
    await cache.save(recipes)
}
```

**`onError`** — побочное действие при ошибке, пробрасывает ошибку дальше:

```swift
let logged = flow.onError { error in
    await logger.log(error)
}
```

### Пример цепочки

```swift
let flow = Flow { try await networkClient.fetchRecipes() }
    .fallback { try await cache.loadRecipes() }
    .onSuccess { await cache.save($0) }
    .onError { await logger.log($0) }
    .map { $0.map(RecipeListItem.init) }

let items = try await flow()
```
