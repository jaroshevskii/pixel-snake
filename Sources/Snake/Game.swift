//
// Snake
//

import Raylib

class Game {
  // 16:9
  // private let windowWidth: Int32 = 640
  // private let windowHeight: Int32 = 360

  // 16:10
  // private let windowWidth: Int32 = 640
  // private let windowHeight: Int32 = 400

  // 21:9
  private let windowWidth: Int32 = 840
  private let windowHeight: Int32 = 360

  private let fieldSquareSize: Int32 = 20
  private let fieldWidth: Int32
  private let fieldHeight: Int32
  private let fieldRender: RenderTexture2D
  private let fieldPositionDraw: Vector2

  struct Position2D {
    var x: Int32, y: Int32
  }

  struct SnakeHead {
    var position: Vector2
    var positionOnField: Position2D {
      Position2D(x: Int32(position.x), y: Int32(position.y))
    }

    enum Movement {
      case up, down, left, right

      var isVertical: Bool { self == .up || self == .down }
      var isHorizontal: Bool { self == .left || self == .right }
    }

    var movement: Movement
    let speed: Float
  }

  private var snakeHead = SnakeHead(position: Vector2(x: 3, y: 3), movement: .right, speed: 12.5)
  private var snakeTail = [Position2D]()

  private var fruitPosition: Position2D

  private var isPause = false
  private var isDeath = false

  init() {
    Raylib.setConfigFlags(.vsyncHint)
    Raylib.initWindow(windowWidth, windowHeight, "Snake")

    fieldWidth = windowWidth / fieldSquareSize
    fieldHeight = windowHeight / fieldSquareSize

    fieldRender = Raylib.loadRenderTexture(
      fieldWidth * fieldSquareSize, fieldHeight * fieldSquareSize)

    Raylib.beginTextureMode(fieldRender)
    Raylib.clearBackground(
      // .lightGray
      // Color(r: 193, g: 193, b: 210, a: 255) // Light theme
      Color(r: 26, g: 26, b: 36, a: 255)  // Dark themme
    )

    for positionX in 0..<fieldWidth {
      for positionY in 0..<fieldHeight {
        // Notebook cells.
        Raylib.drawRectangle(
          positionX * fieldSquareSize + 1, positionY * fieldSquareSize + 1, fieldSquareSize - 2,
          fieldSquareSize - 2,
          // .white
          // Color(r: 230, g: 230, b: 236, a: 255)  // Light themme
          Color(r: 14, g: 14, b: 18, a: 255)  // Dark themme
        )

        // Chess board.
        // if (positionX + positionY) % 2 == 0 {
        //   Raylib.drawRectangle(
        //     positionX * fieldSquareSize, positionY * fieldSquareSize, fieldSquareSize,
        //     fieldSquareSize,
        //     // .white
        //     // Color(r: 230, g: 230, b: 236, a: 255) // Light themme
        //     Color(r: 14, g: 14, b: 18, a: 255)  // Dark themme
        //   )
        // }
      }
    }

    Raylib.endTextureMode()

    fieldPositionDraw = Vector2(
      x: (Float(windowWidth) - Float(fieldRender.texture.width)) / 2,
      y: (Float(windowHeight) - Float(fieldRender.texture.height)) / 2
    )

    fruitPosition = Position2D(
      x: fieldWidth - Int32(snakeHead.position.x),
      y: fieldHeight - Int32(snakeHead.position.y)
    )
  }

  private func input() {
    if Raylib.isKeyPressed(.up) && snakeHead.movement.isHorizontal {
      snakeHead.movement = .up
    } else if Raylib.isKeyPressed(.down) && snakeHead.movement.isHorizontal {
      snakeHead.movement = .down
    } else if Raylib.isKeyPressed(.left) && snakeHead.movement.isVertical {
      snakeHead.movement = .left
    } else if Raylib.isKeyPressed(.right) && snakeHead.movement.isVertical {
      snakeHead.movement = .right
    }

    if Raylib.isKeyPressed(.letterP) || Raylib.isKeyPressed(.enter) {
      isPause.toggle()
    }
    if Raylib.isKeyPressed(.letterR) || Raylib.isKeyPressed(.enter) {
      snakeHead = SnakeHead(position: Vector2(x: 3, y: 3), movement: .right, speed: 12.5)
      snakeTail.removeAll()
      isPause = false
      isDeath = false
    }
  }

  private func update(deltaTime: Float) {
    if isPause || isDeath {
      return
    }

    let previousPosition = snakeHead.positionOnField

    switch snakeHead.movement {
    case .up:
      snakeHead.position.y -= snakeHead.speed * deltaTime
    case .down:
      snakeHead.position.y += snakeHead.speed * deltaTime
    case .left:
      snakeHead.position.x -= snakeHead.speed * deltaTime
    case .right:
      snakeHead.position.x += snakeHead.speed * deltaTime
    }

    for snakeTailItem in snakeTail {
      if snakeHead.positionOnField.x == snakeTailItem.x
        && snakeHead.positionOnField.y == snakeTailItem.y
      {
        isDeath = true
      }
    }

    if snakeHead.positionOnField.x != previousPosition.x
      || snakeHead.positionOnField.y != previousPosition.y
    {
      snakeTail.append(previousPosition)
      snakeTail.removeFirst()
    }

    if snakeHead.positionOnField.x < 0 {
      snakeHead.position.x = Float(fieldWidth - 1)
    } else if snakeHead.positionOnField.x >= fieldWidth {
      snakeHead.position.x = 0.0
    }
    if snakeHead.positionOnField.y < 0 {
      snakeHead.position.y = Float(fieldHeight) - 1
    } else if snakeHead.positionOnField.y >= fieldHeight {
      snakeHead.position.y = 0.0
    }

    if Int32(snakeHead.position.x) == fruitPosition.x
      && Int32(snakeHead.position.y) == fruitPosition.y
    {
      snakeTail.append(previousPosition)

      fruitPosition = Position2D(
        x: Int32.random(in: 0..<fieldWidth),
        y: Int32.random(in: 0..<fieldHeight)
      )
    }
  }

  private func render() {
    Raylib.beginDrawing()
    Raylib.clearBackground(.white)

    // Draw field.
    Raylib.drawTextureV(fieldRender.texture, fieldPositionDraw, .white)

    // Draw snake tail.
    for snakeTailItem in snakeTail {
      Raylib.drawRectangleRec(
        Rectangle(
          x: Float(snakeTailItem.x) * Float(fieldSquareSize) + fieldPositionDraw.x,
          y: Float(snakeTailItem.y) * Float(fieldSquareSize) + fieldPositionDraw.y,
          width: Float(fieldSquareSize),
          height: Float(fieldSquareSize)
        ),
        // .purple
        Color(r: 83, g: 83, b: 115, a: 255)  // Dark themme
      )
    }
    // Draw snake head.
    Raylib.drawRectangleRec(
      Rectangle(
        x: Float(snakeHead.positionOnField.x) * Float(fieldSquareSize) + fieldPositionDraw.x,
        y: Float(snakeHead.positionOnField.y) * Float(fieldSquareSize) + fieldPositionDraw.y,
        width: Float(fieldSquareSize),
        height: Float(fieldSquareSize)
      ),
      // .darkPurple
      Color(r: 166, g: 166, b: 191, a: 255)  // Dark themme
    )
    // Draw fruit.
    Raylib.drawRectangleRec(
      Rectangle(
        x: Float(fruitPosition.x) * Float(fieldSquareSize) + fieldPositionDraw.x,
        y: Float(fruitPosition.y) * Float(fieldSquareSize) + fieldPositionDraw.y,
        width: Float(fieldSquareSize), height: Float(fieldSquareSize)
      ),
      // .red
      // Color(r: 14, g: 14, b: 18, a: 255)  // Light themme
      Color(r: 230, g: 230, b: 236, a: 255)  // Dark themme
    )

    if isPause || isDeath {
      Raylib.drawRectangleRec(
        Rectangle(x: 0, y: 0, width: Float(windowWidth), height: Float(windowHeight)),
        // Color(r: 0, g: 0, b: 0, a: 128)
        Color(r: 255, g: 255, b: 255, a: 128)
        // Color(r: 230, g: 41, b: 55, a: 128)
        // Color(r: 0, g: 121, b: 241, a: 128)
      )

      let text = isPause ? "Pause" : "Death"
      let fontSize: Int32 = 30
      let positionDraw = Position2D(
        x: (windowWidth - Raylib.measureText(text, fontSize)) / 2, y: (windowHeight - fontSize) / 2)

      // Draw text.
      Raylib.drawText(text, positionDraw.x, positionDraw.y, fontSize, .black)
    }

    Raylib.drawFPS(8, 8)
    Raylib.drawText(
      """
      Snake head:
          Position on field: \(snakeHead.positionOnField.x), \(snakeHead.positionOnField.y)
          Speed: \(snakeHead.speed)

      Snake tail:
          Count: \(snakeTail.count)
      """, 8, 36, 10,
      // .black
      // Color(r: 14, g: 14, b: 18, a: 255)  // Light themme
      Color(r: 230, g: 230, b: 236, a: 255)  // Dark themme
    )

    Raylib.endDrawing()
  }

  func run() {
    while !Raylib.windowShouldClose {
      input()
      update(deltaTime: Raylib.getFrameTime())
      render()
    }
  }

  deinit {
    Raylib.closeWindow()
  }
}
