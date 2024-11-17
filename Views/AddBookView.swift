import SwiftUI

struct AddBookView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var webrequest: WebRequest
    
    @State private var title = ""
    @State private var author = ""
    @State private var isbn = ""
    @State private var publishedYear = ""
    @State private var copies = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title", text: $title)
                        .foregroundColor(AppTheme.primary)
                    TextField("Author", text: $author)
                        .foregroundColor(AppTheme.primary)
                    TextField("ISBN", text: $isbn)
                        .foregroundColor(AppTheme.primary)
                    TextField("Published Year", text: $publishedYear)
                        .keyboardType(.numberPad)
                        .foregroundColor(AppTheme.primary)
                    TextField("Available Copies", text: $copies)
                        .keyboardType(.numberPad)
                        .foregroundColor(AppTheme.primary)
                }
                .listRowBackground(AppTheme.background)
            }
            .scrollContentBackground(.hidden)
            .background(Color.white)
            .navigationTitle("Add New Book")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(AppTheme.secondary),
                trailing: Button("Save") {
                    if let year = Int(publishedYear),
                       let availableCopies = Int(copies) {
                        webrequest.addBook(
                            title: title,
                            author: author,
                            isbn: isbn,
                            publishedYear: year,
                            noOfAvailableCopies: availableCopies
                        )
                        dismiss()
                    }
                }
                .disabled(title.isEmpty || author.isEmpty || isbn.isEmpty ||
                         publishedYear.isEmpty || copies.isEmpty)
                .foregroundColor(title.isEmpty || author.isEmpty || isbn.isEmpty ||
                               publishedYear.isEmpty || copies.isEmpty ?
                               AppTheme.lightGray : AppTheme.secondary)
            )
        }
    }
} 