//
// Snake
//

import Foundation
import Raylib

class GameOld {
  struct Point2D: Equatable {
    var x, y: Int32
  }

  enum Movement {
    case up, down, left, right

    var isVertical: Bool { self == .up || self == .down }
    var isHorizontal: Bool { self == .left || self == .right }
  }

  struct Snake {
    private(set) var headPreviousPosition: Point2D
    private(set) var rawHeadPosition: Vector2 {
      willSet {
        headPreviousPosition = headPosition
      }
    }

    var movement: Movement
    var speed: Float

    var headPosition: Point2D {
      get {
        Point2D(x: Int32(roundf(rawHeadPosition.x)), y: Int32(roundf(rawHeadPosition.y)))
      }
      set(newHeadPosition) {
        rawHeadPosition = Vector2(x: Float(newHeadPosition.x), y: Float(newHeadPosition.y))
      }
    }

    init(headPosition: Point2D, movement: Movement, speed: Float) {
      self.headPreviousPosition = headPosition
      self.rawHeadPosition = Vector2(x: Float(headPosition.x), y: Float(headPosition.y))
      self.movement = movement
      self.speed = speed
    }

    mutating func move(deltaTime: Float) {
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
    }
  }

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

  private var snake = Snake(headPosition: Point2D(x: 3, y: 3), movement: .right, speed: 12.5)
  private var snakeTail = [Point2D]()
  private var fruit: Point2D

  private var isPause = false
  private var isDeath = false

  init() {
    Raylib.setConfigFlags(.vsyncHint)
    // Raylib.setTargetFPS(15)
    Raylib.initWindow(windowWidth, windowHeight, "Snake")

    fieldWidth = windowWidth / fieldSquareSize - 1
    fieldHeight = windowHeight / fieldSquareSize - 1

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
    fruit = Point2D(
      x: fieldWidth - 1 - snake.headPosition.x, y: fieldHeight - 1 - snake.headPosition.y
    )
  }

  private func input() {
    if Raylib.isKeyPressed(.up) && snake.movement.isHorizontal {
      snake.movement = .up
    } else if Raylib.isKeyPressed(.down) && snake.movement.isHorizontal {
      snake.movement = .down
    } else if Raylib.isKeyPressed(.left) && snake.movement.isVertical {
      snake.movement = .left
    } else if Raylib.isKeyPressed(.right) && snake.movement.isVertical {
      snake.movement = .right
    }

    if Raylib.isKeyPressed(.letterP) {
      isPause.toggle()
    }
    if Raylib.isKeyPressed(.letterR) {
      snake = Snake(headPosition: Point2D(x: 3, y: 3), movement: .right, speed: 12.5)
      snakeTail.removeAll()
      isPause = false
      isDeath = false
    }
  }

  private func update(deltaTime: Float) {
    if isPause || isDeath {
      return
    }

    snake.move(deltaTime: deltaTime)

    for snakeTailItem in snakeTail {
      if snake.headPosition == snakeTailItem { isDeath = true }
    }

    if snake.headPosition != snake.headPreviousPosition {
      snakeTail.append(snake.headPreviousPosition)
      snakeTail.removeFirst()
    }

    if snake.headPosition.x < 0 {
      snake.headPosition.x = fieldWidth - 1
    } else if snake.headPosition.x >= fieldWidth {
      snake.headPosition.x = 0
    }
    if snake.headPosition.y < 0 {
      snake.headPosition.y = fieldHeight - 1
    } else if snake.headPosition.y >= fieldHeight {
      snake.headPosition.y = 0
    }

    if snake.headPosition == fruit {
      snakeTail.append(snake.headPreviousPosition)
      fruit = Point2D(x: Int32.random(in: 0..<fieldWidth), y: Int32.random(in: 0..<fieldHeight))
    }
  }

  private func draw() {
    Raylib.beginDrawing()
    Raylib.clearBackground(
      // .lightGray
      // Color(r: 193, g: 193, b: 210, a: 255) // Light theme
      Color(r: 26, g: 26, b: 36, a: 255)  // Dark themme
    )

    // Draw field.
    Raylib.drawTextureV(fieldRender.texture, fieldPositionDraw, .white)

    // Draw snake tail.
    for snakeTailItem in snakeTail {
      Raylib.drawRectangleRec(
        Rectangle(
          x: Float(snakeTailItem.x * fieldSquareSize) + fieldPositionDraw.x,
          y: Float(snakeTailItem.y * fieldSquareSize) + fieldPositionDraw.y,
          width: Float(fieldSquareSize),
          height: Float(fieldSquareSize)
        ),
        // .green  // Classic themme
        Color(r: 83, g: 83, b: 115, a: 255)  // Dark themme
      )
    }
    // Draw snake head.
    Raylib.drawRectangleRec(
      Rectangle(
        x: Float(snake.headPosition.x * fieldSquareSize) + fieldPositionDraw.x,
        y: Float(snake.headPosition.y * fieldSquareSize) + fieldPositionDraw.y,
        width: Float(fieldSquareSize),
        height: Float(fieldSquareSize)
      ),
      // .darkGreen  // Classic themme
      Color(r: 166, g: 166, b: 191, a: 255)  // Dark themme
    )

    // Draw fruit.
    Raylib.drawRectangleRec(
      Rectangle(
        x: Float(fruit.x * fieldSquareSize) + fieldPositionDraw.x,
        y: Float(fruit.y * fieldSquareSize) + fieldPositionDraw.y,
        width: Float(fieldSquareSize),
        height: Float(fieldSquareSize)
      ),
      // .red  // Classic theme
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
      let drawPosition = Point2D(
        x: (windowWidth - Raylib.measureText(text, fontSize)) / 2,
        y: (windowHeight - fontSize) / 2
      )

      // Draw text.
      Raylib.drawText(text, drawPosition.x, drawPosition.y, fontSize, .black)
    }

    Raylib.drawFPS(18, 18)
    Raylib.drawText(
      """
      Snake:
          Raw head position: \(snake.rawHeadPosition.x), \(snake.rawHeadPosition.y)
          Head position: \(snake.headPosition.x), \(snake.headPosition.y)
          Head previous position: \(snake.headPreviousPosition.x), \(snake.headPreviousPosition.y)
          Speed: \(snake.speed)

      Snake tail:
          Count: \(snakeTail.count)
      """, 18, 46, 10,
      // .black  // Classic themme
      // Color(r: 14, g: 14, b: 18, a: 255)  // Light themme
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

  deinit {
    Raylib.closeWindow()
  }
}
