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

  var tail = [Point2D]()

  var movement: Movement
  var speed: Float

  var headColor: Color
  var tailColor: Color

  var isDeath = false

  init(headPosition: Point2D, movement: Movement, speed: Float, headColor: Color, tailColor: Color)
  {
    self.headPreviousPosition = headPosition
    self.rawHeadPosition = Vector2(x: Float(headPosition.x), y: Float(headPosition.y))
    self.movement = movement
    self.speed = speed
    self.headColor = headColor
    self.tailColor = tailColor
  }

  mutating func move(deltaTime: Float) {
    // Move head
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

    // Move tail
    if headPosition != headPreviousPosition {
      tail.append(headPreviousPosition)
      tail.removeFirst()
    }

    for tailItem in tail {
      if headPosition == tailItem { isDeath = true }
    }
  }
}
