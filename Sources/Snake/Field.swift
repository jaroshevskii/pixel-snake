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

  init(windowWidth: Int32, windowHeight: Int32) {
    squareSize = 20
    columnsCount = windowWidth / squareSize - 1
    rowsCount = windowHeight / squareSize - 1

    render = Raylib.loadRenderTexture(columnsCount * squareSize, rowsCount * squareSize)

    Raylib.beginTextureMode(render)
    Raylib.clearBackground(
      Color(r: 26, g: 26, b: 36, a: 255)  // Dark themme
    )
    // Draw notebook cells
    for x in 0..<columnsCount {
      for y in 0..<rowsCount {
        Raylib.drawRectangle(
          x * squareSize + 1, y * squareSize + 1,
          squareSize - 2, squareSize - 2,
          Color(r: 14, g: 14, b: 18, a: 255)  // Dark themme
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
