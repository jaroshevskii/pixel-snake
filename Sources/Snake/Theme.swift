//
// Snake
//

import Raylib

struct Theme {
  var fieldBackgroundColor: Color
  var fieldColor: Color

  var snakeHeadColor: Color
  var snakeTailColor: Color

  var fruitColor: Color

  var textColor: Color
}

extension Theme {
  static let light = Theme(
    fieldBackgroundColor: Color(r: 193, g: 193, b: 210, a: 255),
    fieldColor: Color(r: 230, g: 230, b: 236, a: 255),
    snakeHeadColor: Color(r: 83, g: 83, b: 115, a: 255),  // ???
    snakeTailColor: Color(r: 166, g: 166, b: 191, a: 255),  // ???
    fruitColor: Color(r: 14, g: 14, b: 18, a: 255),
    textColor: Color(r: 14, g: 14, b: 18, a: 255)
  )
  static let dark = Theme(
    fieldBackgroundColor: Color(r: 26, g: 26, b: 36, a: 255),
    fieldColor: Color(r: 14, g: 14, b: 18, a: 255),
    snakeHeadColor: Color(r: 166, g: 166, b: 191, a: 255),
    snakeTailColor: Color(r: 83, g: 83, b: 115, a: 255),
    fruitColor: Color(r: 230, g: 230, b: 236, a: 255),
    textColor: Color(r: 230, g: 230, b: 236, a: 255)
  )
  static let classic = Theme(
    fieldBackgroundColor: .lightGray,
    fieldColor: .white,
    snakeHeadColor: .darkGreen,
    snakeTailColor: .green,
    fruitColor: .red,
    textColor: .black
  )
}
