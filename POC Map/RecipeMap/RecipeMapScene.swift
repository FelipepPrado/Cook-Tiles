
import SwiftUI
import SpriteKit

final class MapScene: SKScene {

    let tileSize = CGSize(width: 155, height: 155)

    var recipes: [Recipe] = []

    var recipeTiles: [RecipeTile] = []

    var onRecipeTapped: ((Recipe) -> Void)?

    let xDistance: CGFloat = 85.25
    let yDistance: CGFloat = 54.25

    let mapCamera = SKCameraNode()

    var previousTouchPosition: CGPoint?
    
    // Identifica se o usuário está arrastando o mapa
    var isDragging = false

    override func didMove(to view: SKView) {

        backgroundColor = .systemMint

        anchorPoint = CGPoint(x: 0.5, y: 0.5)

        createCamera()
    }

    // MARK: - Camera

    func createCamera() {

        mapCamera.position = CGPoint(x: 0, y: 0)

        addChild(mapCamera)

        camera = mapCamera
    }

    // MARK: - Map

    func createMap(numberOfTiles: Int) {

        let side = Int(
            Double(numberOfTiles).squareRoot()
        )

        let center = side / 2

        var positions: [
            (
                point: CGPoint,
                row: Int,
                col: Int
            )
        ] = []

        for row in 0..<side {

            for column in 0..<side {

                let rowFromCenter = row - center
                let columnFromCenter = column - center

                let x =
                    CGFloat(
                        columnFromCenter - rowFromCenter
                    ) * xDistance

                let y =
                    CGFloat(
                        -columnFromCenter - rowFromCenter
                    ) * yDistance

                positions.append(
                    (
                        point: CGPoint(
                            x: x,
                            y: y
                        ),
                        row: rowFromCenter,
                        col: columnFromCenter
                    )
                )
            }
        }

        // Ordena para manter a sobreposição correta
        positions.sort {

            if $0.point.y == $1.point.y {
                return $0.point.x < $1.point.x
            }

            return $0.point.y > $1.point.y
        }

        // Garante que não acumularemos tiles
        // se o mapa for recriado
        recipeTiles.removeAll()

        var recipeIndex = 0

        for position in positions {

            // Tile central
            if position.row == 0 &&
                position.col == 0 {

                let castle = SKSpriteNode(
                    imageNamed: "tileTest"
                )

                castle.size = tileSize
                castle.position = position.point

                addChild(castle)

                continue
            }

            guard recipeIndex < recipes.count else {
                continue
            }

            let recipe = recipes[recipeIndex]
            
            let imageName =
                "tile_\(recipeIndex + 1)"

            let tile = SKSpriteNode(
                imageNamed: imageName
            )

            tile.size = tileSize
            tile.position = position.point

            // Pode continuar existindo.
            // É útil para debug.
            tile.name =
                "recipe_\(recipeIndex)"

            addChild(tile)

            let recipeTile = RecipeTile(
                recipe: recipe,
                tile: tile
            )

            recipeTiles.append(recipeTile)

            recipeIndex += 1
        }
    }
    
    func reloadMap() {

        // Remove os tiles antigos,
        // mas mantém a câmera
        children
            .filter { $0 !== mapCamera }
            .forEach {
                $0.removeFromParent()
            }

        recipeTiles.removeAll()

        createMap(
            numberOfTiles: recipes.isEmpty
                ? 9
                : recipes.count + 1
        )
    }
    
    func recipeTile(at point: CGPoint) -> RecipeTile? {

        //Tamanhos ficos da parte superior
        let topWidth: CGFloat = 155
        let topHeight: CGFloat = 97.15

        let halfWidth = topWidth / 2
        let halfHeight = topHeight / 2

        let yOffset =
            (tileSize.height - topHeight) / 2

        var selectedTile: RecipeTile?
        var smallestDistance = CGFloat.infinity

        for recipeTile in recipeTiles {

            let tilePosition =
                recipeTile.tile.position

            // Centro da FACE SUPERIOR,
            // não do sprite inteiro
            let hitCenter = CGPoint(
                x: tilePosition.x,
                y: tilePosition.y + yOffset
            )

            let deltaX =
                abs(point.x - hitCenter.x)

            let deltaY =
                abs(point.y - hitCenter.y)

            let distance =
                deltaX / halfWidth
                +
                deltaY / halfHeight

            if distance <= 1,
               distance < smallestDistance {

                smallestDistance = distance
                selectedTile = recipeTile
            }
        }

        return selectedTile
    }

    // MARK: - Touch

    override func touchesBegan(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {

        guard let touch = touches.first else {
            return
        }

        previousTouchPosition =
            touch.location(in: view)

        // Todo toque começa sendo considerado
        // um possível clique
        isDragging = false
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

        let currentTouchPosition =
            touch.location(in: view)

        let movementX =
            currentTouchPosition.x
            - previousTouchPosition.x

        let movementY =
            currentTouchPosition.y
            - previousTouchPosition.y

        // Se o dedo realmente se moveu,
        // consideramos um drag
        if abs(movementX) > 2 ||
            abs(movementY) > 2 {

            isDragging = true
        }

        // Move a câmera
        mapCamera.position.x -= movementX
        mapCamera.position.y += movementY

        // Limites da câmera
        let minX: CGFloat = -4 * xDistance
        let maxX: CGFloat = 4 * xDistance

        let minY: CGFloat = -4 * yDistance
        let maxY: CGFloat = 4 * yDistance

        mapCamera.position.x = min(
            max(
                mapCamera.position.x,
                minX
            ),
            maxX
        )

        mapCamera.position.y = min(
            max(
                mapCamera.position.y,
                minY
            ),
            maxY
        )

        self.previousTouchPosition =
            currentTouchPosition
    }

    override func touchesEnded(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {

        defer {
            previousTouchPosition = nil
            isDragging = false
        }

        guard !isDragging else {
            return
        }

        guard let touch = touches.first else {
            return
        }

        let location = touch.location(in: self)

        guard let recipeTile = recipeTile(
            at: location
        ) else {
            return
        }

        print("Recipe clicada:", recipeTile.recipe.name)
        print(recipeTile.tile.position)

        onRecipeTapped?(
            recipeTile.recipe
        )
    }

    override func touchesCancelled(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {

        // Caso o sistema cancele o toque,
        // também limpamos o estado
        previousTouchPosition = nil
        isDragging = false
    }
}
