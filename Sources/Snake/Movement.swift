//
// Swift
//

enum Movement {
  case up, down, left, right

  var isVertical: Bool {
    self == .up || self == .down
  }
  var isHorizontal: Bool {
    self == .left || self == .right
  }
}
