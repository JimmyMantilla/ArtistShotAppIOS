

import SwiftUI

struct TagItemView: View {
    let tag: String

    var body: some View {
        Text(tag)
            .font(.caption)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.gray.opacity(0.2))
            .foregroundColor(.black)
            .cornerRadius(12)
    }
}
