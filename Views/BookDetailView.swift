import SwiftUI

struct BookDetailView: View {
    let book: Book
    @ObservedObject var webrequest: WebRequest
    @State private var isEditing = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(book.title)
                .font(.title)
                .bold()
                .foregroundColor(AppTheme.primary)
            
            VStack(alignment: .leading, spacing: 12) {
                DetailRow(label: "Author", value: book.author)
                DetailRow(label: "ISBN", value: book.isbn)
                DetailRow(label: "Published Year", value: String(book.publishedYear))
                DetailRow(label: "Available Copies", value: String(book.noOfAvailableCopies))
            }
            
            Spacer()
        }
        .padding()
        .background(AppTheme.background)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Books")
                    }
                    .foregroundColor(AppTheme.secondary)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    isEditing = true
                }
                .foregroundColor(AppTheme.secondary)
            }
        }
        .toolbarBackground(AppTheme.background, for: .navigationBar)
        .sheet(isPresented: $isEditing) {
            EditBookView(book: book, webrequest: webrequest, isPresented: $isEditing)
        }
    }
} 