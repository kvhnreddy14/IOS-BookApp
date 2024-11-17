import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppTheme.lightGray)
            
            TextField("Search by title or author", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .foregroundColor(AppTheme.primary)
                .focused($isFocused)
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(AppTheme.lightGray)
                }
            }
        }
        .onAppear {
            isFocused = true
        }
    }
} 