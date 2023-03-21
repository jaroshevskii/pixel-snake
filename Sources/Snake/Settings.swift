//
// Snake
//

import Raylib

struct Settings {
  var isVsync: Bool
  var windowWidth: Int32
  var windowHeight: Int32

  var theme: Theme
}

extension Settings {
  static let `default` = Settings(
    isVsync: true,
    windowWidth: 640,
    windowHeight: 360,
    theme: .light
  )
}