import SwiftUI

struct ContentView: View {
    @StateObject var webrequest = WebRequest()
    @State private var showingAddBook = false
    @State private var showingSearchBar = false
    @State private var searchText = ""
    
    var filteredBooks: [Book] {
        if searchText.isEmpty {
            return webrequest.books
        } else {
            return webrequest.books.filter { book in
                book.title.localizedCaseInsensitiveContains(searchText) ||
                book.author.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                if showingSearchBar {
                    SearchBar(text: $searchText)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color.white)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
                
                List {
                    ForEach(filteredBooks, id: \.self) { book in
                        NavigationLink(destination: BookDetailView(book: book, webrequest: webrequest)) {
                            HStack {
                                Image(systemName: "book.closed.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(AppTheme.secondary)
                                    .padding(.trailing, 5)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(book.title)
                                        .bold()
                                        .font(.system(size: 17))
                                        .foregroundColor(AppTheme.primary)
                                    Text(book.author)
                                        .font(.system(size: 16))
                                        .foregroundColor(AppTheme.lightGray)
                                }
                                .padding(.vertical, 4)
                                
                                Spacer()
                            }
                        }
                        .listRowBackground(Color.white)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                webrequest.deleteBook(id: book.id)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .scrollContentBackground(.hidden)
            }
            .background(Color.clear)
            .navigationTitle("Books")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 16) {
                        Button {
                            withAnimation(.spring(duration: 0.3)) {
                                showingSearchBar.toggle()
                                if !showingSearchBar {
                                    searchText = ""
                                }
                            }
                        } label: {
                            Image(systemName: showingSearchBar ? "xmark.circle.fill" : "magnifyingglass")
                                .foregroundColor(AppTheme.secondary)
                        }
                        
                        if !showingSearchBar {
                            Button {
                                showingAddBook = true
                            } label: {
                                Image(systemName: "plus")
                                    .foregroundColor(AppTheme.secondary)
                            }
                        }
                    }
                }
            }
            .safeAreaInset(edge: .top, spacing: 0) {
                Color.clear.frame(height: 20)
            }
            .sheet(isPresented: $showingAddBook) {
                AddBookView(webrequest: webrequest)
            }
            .onAppear {
                webrequest.fetchBooks()
            }
        }
    }
}

#Preview {
    SplashScreen()
} 