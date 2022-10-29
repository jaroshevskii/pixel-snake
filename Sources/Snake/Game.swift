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
  // private let fieldTexture: Texture2D
  private let fieldPositionDraw: Vector2

  struct Position2D {
    var x: Int32, y: Int32
  }

  struct SnakeHead {
    var position: Vector2

    enum Movement {
      case up, down, left, right
    }

    var movement: Movement
    var previousPosition: Position2D {
      var position = Position2D(x: Int32(position.x), y: Int32(position.y))
      switch movement {
      case .up:
        position.y += 1
      case .down:
        position.y -= 1
      case .left:
        position.x += 1
      case .right:
        position.x -= 1
      }
      return position
    }
    let speed: Float32
  }

  private var snakeHead = SnakeHead(position: Vector2(x: 3, y: 3), movement: .right, speed: 12.5)
  private var snakeTail = [Position2D]()

  private var fruitPosition: Position2D
  // Position2D(x: Int32.random(in: 0...fieldWidth), y: Int32.random(in: 0...fieldHeight))

  private var isPause = false

  init() {
    Raylib.setConfigFlags(.vsyncHint)
    Raylib.initWindow(windowWidth, windowHeight, "Snake")
    // Raylib.setWindowPosition(364, 364)
    // Raylib.setExitKey(.letterQ)

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
          // Color(r: 230, g: 230, b: 236, a: 255) // Light themme
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

    // fieldTexture = fieldRender.texture
    fieldPositionDraw = Vector2(
      x: (Float(windowWidth) - Float(fieldRender.texture.width)) / 2,
      y: (Float(windowHeight) - Float(fieldRender.texture.height)) / 2
    )

    fruitPosition = Position2D(
      x: fieldWidth - Int32(snakeHead.position.x),
      y: fieldHeight - Int32(snakeHead.position.y)
    )

    // MARK: TODO
    // snakeTail.append(Position2D(x: Int32(snakeHead.position.x), y: Int32(snakeHead.position.y)))
  }

  private func input() {
    switch Raylib.getKeyPressed() {
    case .up:
      snakeHead.movement = .up
    case .down:
      snakeHead.movement = .down
    case .left:
      snakeHead.movement = .left
    case .right:
      snakeHead.movement = .right
    // case .letterP:
    //   isPause.toggle()
    // case .letterR:
    //   snakeHead = SnakeHead(position: Vector2(x: 3, y: 3), movement: .right, speed: 5)
    //   snakeTail = [Position2D(x: Int32(snakeHead.position.x), y: Int32(snakeHead.position.y))]
    default: break
    }

    // if snakeHead.movement == .up || snakeHead.movement == .down {
    //   if Raylib.isKeyPressed(.left) {
    //     snakeHead.movement = .left
    //   }
    //   if Raylib.isKeyPressed(.right) {
    //     snakeHead.movement = .right
    //   }
    // }
    // if snakeHead.movement == .left || snakeHead.movement == .right {
    //   if Raylib.isKeyPressed(.up) {
    //     snakeHead.movement = .up
    //   }
    //   if Raylib.isKeyPressed(.down) {
    //     snakeHead.movement = .down
    //   }
    // }

    if Raylib.isKeyPressed(.letterP) || Raylib.isKeyPressed(.enter) {
      isPause.toggle()
    }
    if Raylib.isKeyPressed(.letterR) || Raylib.isKeyPressed(.enter) {
      snakeHead = SnakeHead(position: Vector2(x: 3, y: 3), movement: .right, speed: 12.5)
      // snakeTail = [Position2D(x: Int32(snakeHead.position.x), y: Int32(snakeHead.position.y))]
      snakeTail.removeAll()
      isPause = false
    }
  }

  private func update(deltaTime: Float) {
    if isPause { return }

    // let x = Int32(snakeHead.position.x)
    // let y = Int32(snakeHead.position.y)
    // if x < 0 || x >= fieldWidth || y < 0 || y >= fieldHeight {
    //   isPause = true
    // }

    if snakeHead.position.x < 0 {
      snakeHead.position.x = Float(fieldWidth)
    } else if snakeHead.position.x >= Float(fieldWidth) {
      snakeHead.position.x = Float(fieldWidth)
    }
    if snakeHead.position.y < 0 {
      snakeHead.position.y = Float(fieldHeight) - 1
    } else if snakeHead.position.y > Float(fieldHeight) {
      snakeHead.position.y = 0
    }

    let previousPosition = Position2D(
      x: Int32(snakeHead.position.x), y: Int32(snakeHead.position.y))

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

    if Int32(snakeHead.position.x) != previousPosition.x
      || Int32(snakeHead.position.y) != previousPosition.y
    {
      snakeTail.append(snakeHead.previousPosition)
      // snakeTail.append(Position2D(x: Int32(snakeHead.position.x), y: Int32(snakeHead.position.y)))
      snakeTail.removeFirst()
    }

    if Int32(snakeHead.position.x) == fruitPosition.x
      && Int32(snakeHead.position.y) == fruitPosition.y
    {
      snakeTail.append(Position2D(x: Int32(snakeHead.position.x), y: Int32(snakeHead.position.y)))

      fruitPosition = Position2D(
        x: Int32.random(in: 0..<fieldWidth),
        y: Int32.random(in: 0..<fieldHeight)
      )
    }

    // for tailItem in snakeTail
    // where snakeTail.count > 4 && tailItem.x != snakeTail.first?.x && tailItem.y != snakeTail.first?.y
    // {
    //   if Int32(snakeHead.position.x) == tailItem.x && Int32(snakeHead.position.y) == tailItem.y {
    //     isPause = true
    //   }
    // }
  }

  private func render() {
    // Raylib.beginTextureMode(fieldRender)
    // Raylib.clearBackground(.black)

    // // Raylib.drawTextureV(fieldTexture, Vector2(), .white)
    // // Raylib.drawTexture(fieldTexture, 0, 0, .blue)
    // Raylib.drawRectangle(1, 1, 30, 30, .white)
    // // Draw snake head.
    // Raylib.drawRectangle(
    //   snakeHead.position.x * fieldSquareSize, snakeHead.position.y * fieldSquareSize,
    //   fieldSquareSize, fieldSquareSize, .magenta)

    // Raylib.endTextureMode()

    Raylib.beginDrawing()
    Raylib.clearBackground(.white)

    // Raylib.drawRectangleGradientH(0, 0, windowWidth, windowHeight, .magenta, .black)
    // Raylib.drawCircleGradient(windowWidth / 2, windowHeight / 2, Float(windowWidth), .black, .magenta)

    // Raylib.drawRectangleLines(
    //   Int32(fieldPositionDraw.x - 1), Int32(fieldPositionDraw.y - 1),
    //   fieldWidth * fieldSquareSize + 2,
    //   fieldHeight * fieldSquareSize + 2, .lightGray)

    // Draw field border.
    // Raylib.drawRectangleLines(
    //   Int32(fieldPositionDraw.x - 1), Int32(fieldPositionDraw.y - 1),
    //   fieldWidth * fieldSquareSize + 2,
    //   fieldHeight * fieldSquareSize + 2, .lightGray)
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
        x: Float(Int32(snakeHead.position.x)) * Float(fieldSquareSize) + fieldPositionDraw.x,
        y: Float(Int32(snakeHead.position.y)) * Float(fieldSquareSize) + fieldPositionDraw.y,
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

    if isPause {
      Raylib.drawRectangleRec(
        Rectangle(x: 0, y: 0, width: Float(windowWidth), height: Float(windowHeight)),
        // Color(r: 0, g: 0, b: 0, a: 128)
        Color(r: 255, g: 255, b: 255, a: 128)
        // Color(r: 230, g: 41, b: 55, a: 128)
        // Color(r: 0, g: 121, b: 241, a: 128)
      )

      let text = "Pause"
      let fontSize: Int32 = 30
      let positionDraw = Position2D(
        x: (windowWidth - Raylib.measureText(text, fontSize)) / 2, y: (windowHeight - fontSize) / 2)

      // Draw shadow.
      // Raylib.drawTex230, 230, 236t(text, positionDraw.x + 1, positionDraw.y + 1, fontSize, .black)
      // Draw text.
      Raylib.drawText(text, positionDraw.x, positionDraw.y, fontSize, .black)
    }

    Raylib.drawFPS(8, 8)
    Raylib.drawText(
      """
      Snake head:
          Position: \(Int32(snakeHead.position.x)), \(Int32(snakeHead.position.y))
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
