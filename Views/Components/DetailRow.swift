import SwiftUI

struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(AppTheme.lightGray)
            Text(value)
                .font(.body)
                .foregroundColor(AppTheme.primary)
        }
    }
} 