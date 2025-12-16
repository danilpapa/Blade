# BladeMacro

макрос, который автоматически генерирует **протокол** из публичных свойств и методов класса и делает класс **соответствующим этому протоколу** через `extension`. 

---

## Использование

Добавьте атрибут `@Blade` к вашему классу:

```swift
@Blade
public final class WebSocketManager {
    public var connectedUsers: Int = 0
    public var messages: [Message] = []

    public func connect() {}
    public func disconnect() {}
}
```

---

## Что генерирует макрос

После компиляции автоматически создаются:

1. **Протокол с публичными членами класса**:

```swift
public protocol IWebSocketManager {
    var connectedUsers: Int { get set }
    var messages: [Message] { get set }

    func connect()
    func disconnect()
}

extension WebSocketManager: IWebSocketManager {}
```

---

## Установка

```
dependencies: [
    .package(
        url: "https://github.com/danilpapa/Blade.git",
        from: "0.1.0"
    )
]

targets: [
    .target(
        name: "App",
        dependencies: [
            .product(name: "Blade", package: "Blade")
        ]
    ),
    .testTarget(
        name: "AppTests",
        dependencies: ["App"]
    ),
]
```
