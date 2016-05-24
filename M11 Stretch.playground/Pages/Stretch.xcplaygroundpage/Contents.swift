//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


protocol Vehicle {
    
    get {
    var speed: Double
    var isMoving: Bool
    }
    
    func startMoving()
    if  isMoving == true {
    print ("This vehicle is moving")
    } else { return }
    
    
    func stopMoving()
    if isMoving == false {
    print ("This vehicle is stopped")
    } else { return }
    
}


class Truck: Vehicle {
    
    let speed: Double
    let isMoving: Bool
    
    init(speed: Double, isMoving: Bool) {
        self.speed = speed
        self.isMoving = isMoving
    }

}

class Lawnmower: Vehicle {
    
    let speed: Double
    let isMoving: Bool
    
    init(speed: Double, isMoving: Bool) {
        self.speed = speed
        self.isMoving = isMoving
    }
}


let truck = Truck(speed: 60.0, isMoving: true)
let lawnmower = Lawnmower(speed: 0.0, isMoving: false)

print(Truck)

