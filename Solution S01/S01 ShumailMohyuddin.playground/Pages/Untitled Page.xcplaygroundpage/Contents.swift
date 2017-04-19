//: Playground - noun: a place where people can play

import Foundation

class Cookie {
    let type: String
    let brand: String
    
    init(type: String, brand: String) {
        self.type = type
        self.brand = brand
    }
}

class CookieMonster {
    let name: String
    var cookies: [Cookie] = []
    
    init(name: String) {
        self.name = name
    }
    
    func takeCookie(cookieToTake: Cookie) {
        cookies.append(cookieToTake)
    }
    
    func eatCookies() {
        print("\(cookies.count) Cooookies!!!! Om")
        for _ in cookies {
            print("nom nom")
        }
        cookies.removeAll()
    }
}

let cookieMonsterInstance = CookieMonster(name: "Demon")

for i in 1...3 {
    var cookieInstance = Cookie(type: "Oreo-\(i)", brand: "M&M")
    cookieMonsterInstance.takeCookie(cookieToTake: cookieInstance)
}
dump(cookieMonsterInstance.cookies) // check cookes fed to cookieMonster
cookieMonsterInstance.eatCookies()
