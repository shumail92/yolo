// Solution S06
// Shumail Mohyuddin

import UIKit

protocol Eatable{
    var name: String {get}
    var calories: Int {get}
}

enum Salads: Eatable {
    case fruit, chicken, tuna
    var name: String {
        switch self {
        case .fruit:
            return "Fruit Salad"
        case .chicken:
            return "Chicken Salad"
        case .tuna:
            return "Tuna Salad"
        }
    }
    
    var calories: Int {
        switch self {
        case .chicken:
            return 100
        case .fruit:
            return 200
        case .tuna:
            return 300
        }
    }
}

enum FireHydrant: Eatable {
    case alpha, beta, gamma
    var name: String {
        switch self {
        case .alpha:
            return "Alpha Fire Hydrant"
        case .beta:
            return "Beta Fire Hydrant"
        case .gamma:
            return "Gamma Fire Hydrant"
        }
    }
    
    var calories: Int {
        switch self {
        case .alpha:
            return 400
        case .beta:
            return 500
        case .gamma:
            return 600
        }
    }
}

enum Cookie: Eatable {
    case oreo, chocolate, caramel
    var name: String {
        switch self {
        case .oreo:
            return "Oreo Cookie"
        case .chocolate:
            return "Chocolate Cookie"
        case .caramel:
            return "Caramel Cookie"
        }
    }
    
    var calories: Int {
        switch self {
        case .oreo:
            return 150
        case .chocolate:
            return 250
        case .caramel:
            return 350
        }
    }
}

struct Food{
    let type: Eatable
    init(type: Eatable) {
        self.type = type
    }
}

struct Stack<T> {
    private var items = [T]()
    mutating func push(_ item: T) {
        items.append(item)
    }
    
    mutating func pop() -> T? {
        if items.count > 0 {
            return items.removeLast()
        } else {
            return nil
        }
    }
}

class CookieMonster{
    let name : String
    var food = Stack<Food>()
    
    init(name: String){
        self.name = name
    }
    
    func takeFood(meal: Food){
        food.push(meal)
    }
    
    func eatFood(){
        var calories = 0
        while let foodElem = food.pop() {
            print("Yummy \(foodElem.type.name) of \(foodElem.type.calories) Calories")
            calories = calories + foodElem.type.calories
        }
        print("Total Calories: \(calories)")
    }
}

let myCookieMonster = CookieMonster(name: "Panda")
myCookieMonster.takeFood(meal: Food(type: Salads.chicken))
myCookieMonster.takeFood(meal: Food(type: FireHydrant.alpha))
myCookieMonster.takeFood(meal: Food(type: FireHydrant.beta))
myCookieMonster.takeFood(meal: Food(type: Cookie.oreo))
myCookieMonster.eatFood()