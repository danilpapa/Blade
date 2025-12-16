import Blade


class User {
    
    public var name: String
    private var age: Int
    
    public init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
    public func getName() -> String {
        self.name
    }
    
    private func getAge() -> Int {
        self.age
    }
}

public protocol IUser {
    var name: String {
        get
        set
    }
    func getName() -> String
}

public extension User: IUser {
}

