//
// Snake
//

import Raylib

class Field {
  let squareSize: Int32
  let columnsCount: Int32
  let rowsCount: Int32

  let render: RenderTexture2D
  let renderDrawPosition: Point2D

  var backgroundColor: Color
  var color: Color

  init(
    squareSize: Int32, windowWidth: Int32, windowHeight: Int32, backgroundColor: Color, color: Color
  ) {
    self.squareSize = squareSize
    columnsCount = windowWidth / squareSize - 1
    rowsCount = windowHeight / squareSize - 1

    render = Raylib.loadRenderTexture(columnsCount * squareSize, rowsCount * squareSize)

    self.backgroundColor = backgroundColor
    self.color = color

    Raylib.beginTextureMode(render)
    Raylib.clearBackground(backgroundColor)
    // Draw notebook cells
    for x in 0..<columnsCount {
      for y in 0..<rowsCount {
        Raylib.drawRectangle(
          x * squareSize + 1, y * squareSize + 1,
          squareSize - 2, squareSize - 2,
          color
        )
      }
    }
    Raylib.endTextureMode()

    renderDrawPosition = Point2D(
      x: (windowWidth - render.texture.width) / 2,
      y: (windowHeight - render.texture.height) / 2
    )
  }

  deinit {
    Raylib.unloadRenderTexture(render)
  }
}
