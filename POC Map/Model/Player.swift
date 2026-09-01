import SwiftData

@Model
final class Player {
    var coin: Int
    var banner: String
    
    init(coin: Int, banner: String) {
        self.coin = coin
        self.banner = banner
    }
}
