
import SwiftUI
import SpriteKit

final class MapScene: SKScene {

    let tileSize = CGSize(
        width: 155,
        height: 155
    )

    var recipes: [Recipe] = []

    var recipeTiles: [RecipeTile] = []

    var onRecipeTapped: ((Recipe) -> Void)?

    let xDistance: CGFloat = 85.25
    let yDistance: CGFloat = 54.25

    let mapCamera = SKCameraNode()

    var previousTouchPosition: CGPoint?

    var isDragging = false

    override func didMove(to view: SKView) {

        backgroundColor = .systemMint

        anchorPoint = CGPoint(
            x: 0.5,
            y: 0.5
        )

        createCamera()
    }

    // MARK: - Camera

    func createCamera() {

        mapCamera.position = .zero

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

                let rowFromCenter =
                    row - center

                let columnFromCenter =
                    column - center

                let x =
                    CGFloat(
                        columnFromCenter
                        - rowFromCenter
                    )
                    * xDistance

                let y =
                    CGFloat(
                        -columnFromCenter
                        - rowFromCenter
                    )
                    * yDistance

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

        // Mantém a sobreposição isométrica
        positions.sort {

            if $0.point.y == $1.point.y {
                return $0.point.x < $1.point.x
            }

            return $0.point.y > $1.point.y
        }

        recipeTiles.removeAll()

        var recipeIndex = 0

        for position in positions {

            // Castelo central
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

            let recipe =
                recipes[recipeIndex]

            let imageName =
                "tile_\(recipeIndex + 1)"

            let tile = SKSpriteNode(
                imageNamed: "tile2"
            )

            tile.size = tileSize

            tile.position =
                position.point

            tile.name =
                "recipe_\(recipeIndex)"

            addChild(tile)

            // MUDOU:
            // agora guardamos a coordenada
            // lógica do tile.
            let recipeTile = RecipeTile(
                recipe: recipe,
                tile: tile,
                row: position.row,
                col: position.col
            )

            recipeTiles.append(
                recipeTile
            )

            recipeIndex += 1
        }

        // NOVO:
        // depois que todos existem,
        // calculamos os estados.
        refreshTileStates()
    }

    func reloadMap() {

        children
            .filter {
                $0 !== mapCamera
            }
            .forEach {
                $0.removeFromParent()
            }

        recipeTiles.removeAll()

        createMap(
            numberOfTiles:
                recipes.isEmpty
                ? 9
                : recipes.count + 1
        )
    }

    // MARK: - Adjacency

    func adjacentTiles(
        to recipeTile: RecipeTile
    ) -> [RecipeTile] {

        recipeTiles.filter { otherTile in

            let rowDifference =
                abs(
                    otherTile.row
                    - recipeTile.row
                )

            let colDifference =
                abs(
                    otherTile.col
                    - recipeTile.col
                )

            return
                rowDifference
                + colDifference
                == 1
        }
    }

    // MARK: - Status

    func calculatedStatus(
        for recipeTile: RecipeTile
    ) -> RecipeStatus {

        // Se já está desbloqueada,
        // ela continua desbloqueada.
        if recipeTile.recipe.status == .unlocked {
            return .unlocked
        }

        let neighbors =
            adjacentTiles(
                to: recipeTile
            )

        let hasUnlockedNeighbor =
            neighbors.contains { neighbor in
                neighbor.recipe.status
                    == .unlocked
            }

        if hasUnlockedNeighbor {
            return .locked
        }

        return .unavailable
    }

    /// Recalcula todos os estados e,
    /// em seguida, atualiza os visuais.
    func refreshTileStates() {

        // Primeiro calculamos os estados.
        for recipeTile in recipeTiles {

            let newStatus =
                calculatedStatus(
                    for: recipeTile
                )

            recipeTile.recipe.status =
                newStatus
        }

        // Depois atualizamos os visuais.
        for recipeTile in recipeTiles {

            updateVisual(
                for: recipeTile
            )
        }
    }

    // MARK: - Tile Visual

    func updateVisual(
        for recipeTile: RecipeTile
    ) {

        switch recipeTile.recipe.status {

        case .unlocked:

            recipeTile.tile.alpha = 1

            recipeTile.tile.colorBlendFactor = 0

        case .locked:

            recipeTile.tile.alpha = 0.7

            recipeTile.tile.color = .gray

            recipeTile.tile.colorBlendFactor = 0.25

        case .unavailable:

            recipeTile.tile.alpha = 0.3

            recipeTile.tile.color = .gray

            recipeTile.tile.colorBlendFactor = 0.65
        }
    }

    // MARK: - Hit Test

    func recipeTile(
        at point: CGPoint
    ) -> RecipeTile? {

        let topWidth: CGFloat = 155
        let topHeight: CGFloat = 97.15

        let halfWidth =
            topWidth / 2

        let halfHeight =
            topHeight / 2

        let yOffset =
            (
                tileSize.height
                - topHeight
            ) / 2

        var selectedTile: RecipeTile?

        var smallestDistance =
            CGFloat.infinity

        for recipeTile in recipeTiles {

            let tilePosition =
                recipeTile.tile.position

            let hitCenter = CGPoint(
                x: tilePosition.x,
                y: tilePosition.y
                    + yOffset
            )

            let deltaX =
                abs(
                    point.x
                    - hitCenter.x
                )

            let deltaY =
                abs(
                    point.y
                    - hitCenter.y
                )

            let distance =
                deltaX / halfWidth
                +
                deltaY / halfHeight

            if distance <= 1,
               distance < smallestDistance {

                smallestDistance =
                    distance

                selectedTile =
                    recipeTile
            }
        }

        return selectedTile
    }

    // MARK: - Touch

    override func touchesBegan(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {

        guard let touch =
            touches.first
        else {
            return
        }

        previousTouchPosition =
            touch.location(in: view)

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

        if abs(movementX) > 2 ||
            abs(movementY) > 2 {

            isDragging = true
        }

        mapCamera.position.x -=
            movementX

        mapCamera.position.y +=
            movementY

        let minX: CGFloat =
            -4 * xDistance

        let maxX: CGFloat =
            4 * xDistance

        let minY: CGFloat =
            -4 * yDistance

        let maxY: CGFloat =
            4 * yDistance

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

        guard let touch =
            touches.first
        else {
            return
        }

        let location =
            touch.location(in: self)

        guard let recipeTile =
            recipeTile(
                at: location
            )
        else {
            return
        }

        print(
            "Recipe:",
            recipeTile.recipe.name
        )

        print(
            "Status:",
            recipeTile.recipe.status
        )

        print(
            "Position:",
            recipeTile.row,
            recipeTile.col
        )

        onRecipeTapped?(
            recipeTile.recipe
        )
    }

    override func touchesCancelled(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {

        previousTouchPosition = nil
        isDragging = false
    }
}
