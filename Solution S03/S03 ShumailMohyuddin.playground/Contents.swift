// Solution S03
// Shumail Mohyuddin

import UIKit

enum CookieType: Int {
    case oreo, choclate, butter, caramel, strawberry
}

struct Cookie {
    var type: CookieType
    var cookieCrust: Bool
    
    init(type: CookieType, cookieCrust: Bool) {
        self.type = type
        self.cookieCrust = cookieCrust
    }
}

struct Order {
    var cookie: Cookie
    var customer: String
    var delivery:  Bool
}

protocol deliveryManProtocol {
    var name: String {get}
    func deliver(order: Order)
}

class CookieBaker: deliveryManProtocol {
    var name: String
    var orders = [Order] ()
    var delegate: deliveryManProtocol?
    
    init(name: String, orders: [Order]) {
        self.name = name
        self.orders = orders
    }
    
    func process(order: Order) {
        print("Baking a \(order.cookie.type) Cookie for \(order.customer)")
        
        if(!order.delivery) {
            deliver(order: order)
            return
        }
        if let delegate = delegate {
            print("DeliveryPanda will deliver this cookie \(order.cookie.type) to \(order.customer)")
            delegate.deliver(order: order)
        }
    }
    
    func processAll()  {
        for order in self.orders {
            self.process(order: order)
        }
    }
    
    func deliver(order: Order) {
        print("Hi \(order.customer) your order for \(order.cookie.type) is Ready!")

    }
}

class CookieDeliveryman: deliveryManProtocol {
    var name: String
    
    init(name: String) {
        self.name = name
    }
    func deliver(order: Order)  {
        print("Hello \(order.customer) * I have brought \(order.cookie.type) for you")
    }
}

let cookie1 = Cookie(type: CookieType.butter, cookieCrust: false)
let cookie2 = Cookie(type: CookieType.choclate, cookieCrust: false)
let cookie3 = Cookie(type: CookieType.oreo, cookieCrust: true)
let cookie4 = Cookie(type: CookieType.strawberry, cookieCrust: false)
let cookie5 = Cookie(type: CookieType.caramel, cookieCrust: true)

let myOrders =  [   Order(cookie: cookie1, customer: "Shumail", delivery: false),
                    Order(cookie: cookie2, customer: "John ", delivery: true),
                    Order(cookie: cookie3, customer: "Doe", delivery: false),
                    Order(cookie: cookie4, customer: "Mike", delivery: true),
                    Order(cookie: cookie5, customer: "Ani", delivery: false),
    ]

let myCookieBaker = CookieBaker(name: "Bakerman", orders: myOrders)
myCookieBaker.delegate = CookieDeliveryman(name: "DeliveryPanda")
myCookieBaker.processAll()
