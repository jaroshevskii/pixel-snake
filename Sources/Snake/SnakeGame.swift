//
// Snake
//

import Raylib

@main
class Game {
  private var field: Field
  private var snake: Snake
  private var fruit: Fruit

  private var isPause = false

  private var textColor: Color

  init(settings: Settings) {
    if settings.isVsync {
      Raylib.setConfigFlags(.vsyncHint)
    }
    Raylib.initWindow(settings.windowWidth, settings.windowHeight, "Snake")

    field = Field(
      squareSize: 20,
      windowWidth: settings.windowWidth, windowHeight: settings.windowHeight,
      backgroundColor: settings.theme.fieldBackgroundColor,
      color: settings.theme.fieldColor
    )
    snake = Snake(
      headPosition: Point2D(x: field.columnsCount / 4, y: field.rowsCount / 2),
      movement: .right,
      speed: 15.0,
      headColor: settings.theme.snakeHeadColor,
      tailColor: settings.theme.snakeTailColor
    )
    fruit = Fruit(
      position: Point2D(
        x: field.columnsCount - 1 - snake.headPosition.x, y: snake.headPosition.y
      ),
      color: settings.theme.fruitColor
    )

    textColor = settings.theme.textColor
  }

  deinit {
    Raylib.closeWindow()
  }

  private func input() {
    if Raylib.isKeyPressed(.letterP) {
      isPause.toggle()
    }

    if isPause { return }

    if Raylib.isKeyPressed(.up) && snake.movement.isHorizontal {
      snake.movement = .up
    } else if Raylib.isKeyPressed(.down) && snake.movement.isHorizontal {
      snake.movement = .down
    } else if Raylib.isKeyPressed(.left) && snake.movement.isVertical {
      snake.movement = .left
    } else if Raylib.isKeyPressed(.right) && snake.movement.isVertical {
      snake.movement = .right
    }
  }

  private func update(deltaTime: Float) {
    if isPause { return }

    snake.move(deltaTime: deltaTime)

    if snake.headPosition.x < 0 {
      snake.headPosition.x = field.columnsCount - 1
    } else if snake.headPosition.x >= field.columnsCount {
      snake.headPosition.x = 0
    }
    if snake.headPosition.y < 0 {
      snake.headPosition.y = field.rowsCount - 1
    } else if snake.headPosition.y >= field.rowsCount {
      snake.headPosition.y = 0
    }

    if snake.headPosition == fruit.position {
      snake.tail.append(snake.headPreviousPosition)
      fruit.position = Point2D(
        x: Int32.random(in: 0..<field.columnsCount), y: Int32.random(in: 0..<field.rowsCount)
      )
    }
  }

  private func draw() {
    Raylib.beginDrawing()
    Raylib.clearBackground(field.backgroundColor)

    // MARK: Field

    Raylib.drawTexture(
      // Texture
      field.render.texture,
      // Position
      field.renderDrawPosition.x, field.renderDrawPosition.y,
      // Color
      .white
    )

    // MARK: Snake

    // Draw snake tail
    for tailItem in snake.tail {
      Raylib.drawRectangleRec(
        Rectangle(
          x: Float(field.renderDrawPosition.x + tailItem.x * field.squareSize),
          y: Float(field.renderDrawPosition.y + tailItem.y * field.squareSize),
          width: Float(field.squareSize),
          height: Float(field.squareSize)
        ),
        snake.tailColor
      )
    }

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

    // MARK: Fruit

    Raylib.drawRectangleRec(
      Rectangle(
        x: Float(field.renderDrawPosition.x + fruit.position.x * field.squareSize),
        y: Float(field.renderDrawPosition.y + fruit.position.y * field.squareSize),
        width: Float(field.squareSize),
        height: Float(field.squareSize)
      ),
      fruit.color
    )

    // MARK: UI

    Raylib.drawFPS(
      // Position x
      field.renderDrawPosition.x + 8,
      // Postion y
      field.renderDrawPosition.y + 8
    )
    // Raylib.drawText(
    //   // Text
    //   """
    //   Field:
    //       Columns count: \(field.columnsCount)
    //       Rows count: \(field.rowsCount)

    //   Snake head position:
    //       X: \(snake.headPosition.x)
    //       Y: \(snake.headPosition.y)

    //   Fruit position:
    //       X: \(fruit.position.x)
    //       Y: \(fruit.position.y)
    //   """,
    //   // Position x
    //   field.renderDrawPosition.x + 8,
    //   // Position y
    //   field.renderDrawPosition.y + 20 + 8 + 8,
    //   // Font height
    //   10,
    //   // Color
    //   textColor
    // )

    let text = "[ Pixel Snake ]"
    let textFontSize: Int32 = 40
    let drawPosition = Point2D(
      x: (640 - Raylib.measureText(text, textFontSize)) / 2,
      y: (360 - textFontSize) / 2
    )
    Raylib.drawText(text, drawPosition.x, drawPosition.y, textFontSize, textColor)

    let descripion = "[ Press any key to play ]"
    let descriptionFontSize: Int32 = 10
    let descriptionDrawPosition = Point2D(
      x: (640 - Raylib.measureText(descripion, descriptionFontSize)) / 2,
      y: 360 / 2 + (360 / 4 - descriptionFontSize) / 2
    )
    Raylib.drawText(
      descripion, descriptionDrawPosition.x, descriptionDrawPosition.y, descriptionFontSize,
      textColor)

    // text = "[  Play  |  Exit  ]"
    // fontSize = 20
    // drawPosition = Point2D(
    //   x: (840 - Raylib.measureText(text, fontSize)) / 2,
    //   y: (360 - fontSize) / 2 + 128
    // )
    // Raylib.drawText(text, drawPosition.x, drawPosition.y, fontSize, textColor)

    Raylib.endDrawing()
  }

  func run() {
    while !Raylib.windowShouldClose {
      input()
      update(deltaTime: Raylib.getFrameTime())
      draw()
    }
  }

  static func main() {
    let snakeGame = Game(settings: .default)
    snakeGame.run()
  }
}
