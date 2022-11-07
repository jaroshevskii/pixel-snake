//
// Snake
//

import Raylib

class Game {
  // 21:9
  private let windowWidth: Int32 = 840
  private let windowHeight: Int32 = 360

  private var field: Field
  private var snake: Snake
  private var fruit: Fruit

  init() {
    Raylib.setConfigFlags(.vsyncHint)
    Raylib.initWindow(windowWidth, windowHeight, "Snake")

    field = Field(windowWidth: windowWidth, windowHeight: windowHeight)
    snake = Snake(
      headPosition: Point2D(x: field.columnsCount / 4, y: field.rowsCount / 2),
      movement: .right,
      speed: 15.0
    )
    fruit = Fruit(
      position: Point2D(
        x: field.columnsCount - snake.headPosition.x, y: snake.headPosition.y
      )
    )
  }

  deinit {
    Raylib.closeWindow()
  }

  private func input() {

  }

  private func update(deltaTime: Float) {

  }

  private func draw() {
    Raylib.beginDrawing()
    Raylib.clearBackground(
      Color(r: 26, g: 26, b: 36, a: 255)  // Dark themme
    )

    // Draw filed
    Raylib.drawTexture(
      field.render.texture, field.renderDrawPosition.x, field.renderDrawPosition.y, .white)

    // Draw snake head
    Raylib.drawRectangleRec(
      Rectangle(
        x: Float(field.renderDrawPosition.x + snake.headPosition.x * field.squareSize),
        y: Float(field.renderDrawPosition.y + snake.headPosition.y * field.squareSize),
        width: Float(field.squareSize),
        height: Float(field.squareSize)
      ),
      snake.headColor
    )

    // Draw snake tail
    for snakeTailItem in snake.tail {
      Raylib.drawRectangleRec(
        Rectangle(
          x: Float(field.renderDrawPosition.x + snakeTailItem.x * field.squareSize),
          y: Float(field.renderDrawPosition.y + snakeTailItem.y * field.squareSize),
          width: Float(field.squareSize),
          height: Float(field.squareSize)
        ),
        snake.tailColor
      )
    }

    // Draw fruit
    Raylib.drawRectangleRec(
      Rectangle(
        x: Float(field.renderDrawPosition.x + fruit.position.x * field.squareSize),
        y: Float(field.renderDrawPosition.y + fruit.position.y * field.squareSize),
        width: Float(field.squareSize),
        height: Float(field.squareSize)
      ),
      fruit.color
    )

    Raylib.drawFPS(field.renderDrawPosition.x + 8, field.renderDrawPosition.y + 8)
    Raylib.drawText(
      """
      Field:
          Columns count: \(field.columnsCount)
          Rows count: \(field.rowsCount)

      Snake head position:
          X: \(snake.headPosition.x)
          Y: \(snake.headPosition.y)

      Fruit position:
          X: \(fruit.position.x)
          Y: \(fruit.position.y)
      """,
      field.renderDrawPosition.x + 8,
      field.renderDrawPosition.y + 20 + 8 + 8,
      10,
      Color(r: 230, g: 230, b: 236, a: 255)  // Dark themme
    )

    Raylib.endDrawing()
  }

  func run() {
    while !Raylib.windowShouldClose {
      input()
      update(deltaTime: Raylib.getFrameTime())
      draw()
    }
  }
}
