import SwiftUI

struct EditBookView: View {
    let book: Book
    @ObservedObject var webrequest: WebRequest
    @Binding var isPresented: Bool
    
    @State private var title: String
    @State private var author: String
    @State private var isbn: String
    @State private var publishedYear: String
    @State private var copies: String
    
    @State private var titleChanged = false
    @State private var authorChanged = false
    @State private var isbnChanged = false
    @State private var yearChanged = false
    @State private var copiesChanged = false
    
    init(book: Book, webrequest: WebRequest, isPresented: Binding<Bool>) {
        self.book = book
        self.webrequest = webrequest
        self._isPresented = isPresented
        _title = State(initialValue: book.title)
        _author = State(initialValue: book.author)
        _isbn = State(initialValue: book.isbn)
        _publishedYear = State(initialValue: String(book.publishedYear))
        _copies = State(initialValue: String(book.noOfAvailableCopies))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title", text: $title)
                        .foregroundColor(AppTheme.primary)
                        .onChange(of: title) { _,_ in
                            titleChanged = true
                        }
                    
                    TextField("Author", text: $author)
                        .foregroundColor(AppTheme.primary)
                        .onChange(of: author) { _,_ in
                            authorChanged = true
                        }
                    
                    TextField("ISBN", text: $isbn)
                        .foregroundColor(AppTheme.primary)
                        .onChange(of: isbn) { _,_ in
                            isbnChanged = true
                        }
                    
                    TextField("Published Year", text: $publishedYear)
                        .foregroundColor(AppTheme.primary)
                        .onChange(of: publishedYear) { _,_ in
                            yearChanged = true
                        }
                        .keyboardType(.numberPad)
                    
                    TextField("Available Copies", text: $copies)
                        .foregroundColor(AppTheme.primary)
                        .onChange(of: copies) { _,_ in
                            copiesChanged = true
                        }
                        .keyboardType(.numberPad)
                }
                .listRowBackground(AppTheme.background)
            }
            .scrollContentBackground(.hidden)
            .background(Color.white)
            .navigationTitle("Edit Book")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    isPresented = false
                }
                .foregroundColor(AppTheme.secondary),
                trailing: Button("Save") {
                    webrequest.editBook(
                        id: book.id,
                        title: titleChanged ? title : nil,
                        author: authorChanged ? author : nil,
                        isbn: isbnChanged ? isbn : nil,
                        publishedYear: yearChanged ? Int(publishedYear) : nil,
                        noOfAvailableCopies: copiesChanged ? Int(copies) : nil
                    )
                    isPresented = false
                }
                .disabled(!titleChanged && !authorChanged && !isbnChanged &&
                         !yearChanged && !copiesChanged)
                .foregroundColor(!titleChanged && !authorChanged && !isbnChanged &&
                               !yearChanged && !copiesChanged ?
                               AppTheme.lightGray : AppTheme.secondary)
            )
        }
    }
} 