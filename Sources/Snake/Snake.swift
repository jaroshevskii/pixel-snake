//
// Snake
//

import Foundation
import Raylib

struct Snake {
  private(set) var headPreviousPosition: Point2D
  private(set) var rawHeadPosition: Vector2 {
    willSet {
      headPreviousPosition = headPosition
    }
  }

  var headPosition: Point2D {
    get {
      Point2D(x: Int32(roundf(rawHeadPosition.x)), y: Int32(roundf(rawHeadPosition.y)))
    }
    set(newHeadPosition) {
      rawHeadPosition = Vector2(x: Float(newHeadPosition.x), y: Float(newHeadPosition.y))
    }
  }

  var headColor = Color(r: 166, g: 166, b: 191, a: 255)  // Dark themme

  var movement: Movement
  var speed: Float

  var tail = [Point2D]()
  var tailColor = Color(r: 83, g: 83, b: 115, a: 255)  // Dark themme

  init(headPosition: Point2D, movement: Movement, speed: Float) {
    self.headPreviousPosition = headPosition
    self.rawHeadPosition = Vector2(x: Float(headPosition.x), y: Float(headPosition.y))
    self.movement = movement
    self.speed = speed
  }

  mutating func move(deltaTime: Float) {
    switch movement {
    case .up:
      rawHeadPosition.y -= speed * deltaTime
    case .down:
      rawHeadPosition.y += speed * deltaTime
    case .left:
      rawHeadPosition.x -= speed * deltaTime
    case .right:
      rawHeadPosition.x += speed * deltaTime
    }
  }
}
