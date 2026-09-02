import SwiftUI

struct TestComponent: View {
    var body: some View {
        
        VStack {
            Rectangle()
                .fill(Color.purple)
        }
    }
}

#Preview {
    TestComponent()
}
