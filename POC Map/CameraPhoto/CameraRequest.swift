import Foundation
import SwiftUI


struct CameraRequest: Hashable {
    let id = UUID()
    let onPhoto: (Data) -> Void

    static func == (
        lhs: CameraRequest,
        rhs: CameraRequest
    ) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
