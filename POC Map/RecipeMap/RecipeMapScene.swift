
import SwiftUI
import SpriteKit

//final class MapScene: SKScene {
//
//    override func didMove(to view: SKView) {
//
//        backgroundColor = .systemMint
//        anchorPoint = CGPoint(x: 0.5, y: 0.5)
//
//        let tileSize = CGSize(width: 100, height: 100)
//
//        // Castle
//        let castle = SKSpriteNode(imageNamed: "tileTest")
//        castle.size = tileSize
//        castle.position = CGPoint(x: 0, y: 0)
//
//        // Direita
//        let tileRight = SKSpriteNode(imageNamed: "tile2")
//        tileRight.size = tileSize
//        tileRight.position = CGPoint(x: 55, y: -35)
//
//        // Esquerda
//        let tileLeft = SKSpriteNode(imageNamed: "tile2")
//        tileLeft.size = tileSize
//        tileLeft.position = CGPoint(x: -55, y: 35)
//        
//        let tileTop = SKSpriteNode(imageNamed: "tile2")
//        tileTop.size = tileSize
//        tileTop.position = CGPoint(x: 55, y: 35)
//        
//        let tileBottom = SKSpriteNode(imageNamed: "tile2")
//        tileBottom.size = tileSize
//        tileBottom.position = CGPoint(x: -55, y: -35)
//        
//        let tileTopLeft = SKSpriteNode(imageNamed: "tile2")
//        tileTopLeft.size = tileSize
//        tileTopLeft.position = CGPoint(x: 0, y: 70)
//        
//        let tileTopRight = SKSpriteNode(imageNamed: "tile2")
//        tileTopRight.size = tileSize
//        tileTopRight.position = CGPoint(x: 110, y: 0)
//        
//        let tileBottomLeft = SKSpriteNode(imageNamed: "tile2")
//        tileBottomLeft.size = tileSize
//        tileBottomLeft.position = CGPoint(x: -110, y: 0)
//        
//        let tileBottomRight = SKSpriteNode(imageNamed: "tile2")
//        tileBottomRight.size = tileSize
//        tileBottomRight.position = CGPoint(x: 0, y: -70)
//
//        addChild(tileTopLeft)
//        
//        addChild(tileTop)
//        
//        addChild(tileTopRight)
//        
//        addChild(tileLeft)
//        
//        addChild(castle)
//        
//        addChild(tileRight)
//        
//        addChild(tileBottomLeft)
//        
//        addChild(tileBottom)
//        
//        addChild(tileBottomRight)
//        
//    }
//}

final class MapScene: SKScene {

    let tileSize = CGSize(width: 155, height: 155)

    var recipes: [Recipe] = []
    //precisa ordenar isso aqui de alguma forma para ficar filtrado
    var recipeTiles: [RecipeTile] = []
    
    let xDistance: CGFloat = 85.25
    let yDistance: CGFloat = 54.25

    // Câmera do mapa
    let mapCamera = SKCameraNode()

    // Guarda onde o dedo estava
    var previousTouchPosition: CGPoint?

    override func didMove(to view: SKView) {
        
        backgroundColor = .systemMint
        anchorPoint = CGPoint(x: 0.5, y: 0.5)

        createMap(numberOfTiles: recipes.count == 0 ? 9 : recipes.count)
        createCamera()
    }

    // MARK: - Camera

    func createCamera() {

        mapCamera.position = CGPoint(x: 0, y: 0)

        addChild(mapCamera)

        camera = mapCamera
    }

    // MARK: - Map

//    func createMap(numberOfTiles: Int) {
//
//        let side = Int(Double(numberOfTiles).squareRoot())
//        let center = side / 2
//
//        var positions: [CGPoint] = []
//
//        for row in 0..<side {
//
//            for column in 0..<side {
//
//                let rowFromCenter = row - center
//                let columnFromCenter = column - center
//
//                let x = CGFloat(columnFromCenter - rowFromCenter) * xDistance
//
//                let y = CGFloat(-columnFromCenter - rowFromCenter) * yDistance
//
//                positions.append(
//                    CGPoint(x: x, y: y)
//                )
//            }
//        }
//
//        positions.sort {
//
//            if $0.y == $1.y {
//                return $0.x < $1.x
//            }
//
//            return $0.y > $1.y
//        }
//        
//
//        for position in positions {
//
//            let imageName: String
//
//            if position == .zero {
//                imageName = "tileTest"
//            } else {
//                imageName = "tile2"
//                
//            }
//
//            let tile = SKSpriteNode(imageNamed: imageName)
//
//            tile.size = tileSize
//            tile.position = position
//
//            addChild(tile)
//        }
//    }
    func createMap(numberOfTiles: Int) {

        let side = Int(Double(numberOfTiles).squareRoot())
        let center = side / 2

        var positions: [(point: CGPoint, row: Int, col: Int)] = []

        for row in 0..<side {
            for column in 0..<side {

                let rowFromCenter = row - center
                let columnFromCenter = column - center

                let x = CGFloat(columnFromCenter - rowFromCenter) * xDistance
                let y = CGFloat(-columnFromCenter - rowFromCenter) * yDistance

                positions.append((
                    point: CGPoint(x: x, y: y),
                    row: rowFromCenter,
                    col: columnFromCenter
                ))
            }
        }

        // Ordena pra manter a sobreposição correta
        positions.sort {
            if $0.point.y == $1.point.y {
                return $0.point.x < $1.point.x
            }
            return $0.point.y > $1.point.y
        }

        var recipeIndex = 0

        for position in positions {

            // Tile central
            if position.row == 0 && position.col == 0 {
                let castle = SKSpriteNode(imageNamed: "tileTest")
                castle.size = tileSize
                castle.position = position.point
                addChild(castle)
                continue
            }
            guard recipeIndex < recipes.count else { continue }
            let recipe = recipes[recipeIndex]
            // Atribui a imagem numerada (tile_1, tile_2, ... tile_24)
            let imageName = "tile_\(recipeIndex + 1)"
            let tile = SKSpriteNode(imageNamed: imageName)
            tile.size = tileSize
            tile.position = position.point
            tile.name = "recipe_\(recipeIndex)"

            addChild(tile)
            let recipeTile = RecipeTile(recipe: recipe, tile: tile)
            recipeTiles.append(recipeTile)

            recipeIndex += 1
        }
    }

    // MARK: - Touch

    override func touchesBegan(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {

        guard let touch = touches.first else {
            return
        }

        previousTouchPosition = touch.location(in: view)
    }

    override func touchesMoved(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {

        guard
            let touch = touches.first,
            let previousTouchPosition
        else {
            return
        }

        let currentTouchPosition = touch.location(in: view)

        let movementX =
            currentTouchPosition.x - previousTouchPosition.x

        let movementY =
            currentTouchPosition.y - previousTouchPosition.y

        // Move a câmera
        mapCamera.position.x -= movementX
        mapCamera.position.y += movementY

        // Limites da câmera
        let minX: CGFloat = -4*xDistance
        let maxX: CGFloat = 4*xDistance

        let minY: CGFloat = -4*yDistance
        let maxY: CGFloat = 4*yDistance

        // Impede a câmera de ultrapassar os limites
        mapCamera.position.x = min(
            max(mapCamera.position.x, minX),
            maxX
        )

        mapCamera.position.y = min(
            max(mapCamera.position.y, minY),
            maxY
        )

        self.previousTouchPosition = currentTouchPosition
    }

    override func touchesEnded(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {

        previousTouchPosition = nil
    }
}
