import SwiftUI

/// Centers each row of whole ingredients while preserving each component's ideal size.
struct IngredientFlowLayout: Layout {
    var horizontalSpacing: CGFloat = 10
    var verticalSpacing: CGFloat = 10

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        arrangement(width: proposal.width, subviews: subviews).size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrangement(width: bounds.width, subviews: subviews)
        for (index, subview) in subviews.enumerated() {
            subview.place(
                at: CGPoint(x: bounds.minX + result.origins[index].x,
                            y: bounds.minY + result.origins[index].y),
                anchor: .topLeading,
                proposal: .unspecified
            )
        }
    }

    private func arrangement(width: CGFloat?, subviews: Subviews) -> (size: CGSize, origins: [CGPoint]) {
        let availableWidth = width.flatMap { $0.isFinite ? max(0, $0) : nil }
        var origins: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var contentWidth: CGFloat = 0
        var rowStart = 0
        var rows: [(range: Range<Int>, width: CGFloat)] = []

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x > 0, let availableWidth, x + size.width > availableWidth {
                rows.append((rowStart..<origins.count, x - horizontalSpacing))
                rowStart = origins.count
                x = 0
                y += rowHeight + verticalSpacing
                rowHeight = 0
            }
            origins.append(CGPoint(x: x, y: y))
            contentWidth = max(contentWidth, x + size.width)
            rowHeight = max(rowHeight, size.height)
            x += size.width + horizontalSpacing
        }

        if rowStart < origins.count {
            rows.append((rowStart..<origins.count, x - horizontalSpacing))
        }
        let layoutWidth = availableWidth ?? contentWidth
        for row in rows {
            let offset = (layoutWidth - row.width) / 2
            for index in row.range {
                origins[index].x += offset
            }
        }

        return (CGSize(width: layoutWidth, height: y + rowHeight), origins)
    }
}
