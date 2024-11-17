import SwiftUI

class WebRequest: ObservableObject {
    @Published var books: [Book] = []
    
    func fetchBooks() {
        guard let url = URL(string:
        "http://localhost:8080/api/books/allBooks") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                let books = try JSONDecoder().decode([Book].self, from: data)
                DispatchQueue.main.async {
                    self?.books = books
                }
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func addBook(title: String, author: String, isbn: String,
                publishedYear: Int, noOfAvailableCopies: Int) {
        guard let url = URL(string: "http://localhost:8080/api/books/addBook") else { return }
        
        let book = CreateBookRequest(
            title: title,
            author: author,
            isbn: isbn,
            publishedYear: publishedYear,
            noOfAvailableCopies: noOfAvailableCopies
        )
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(book)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                
                DispatchQueue.main.async {
                    self?.fetchBooks()
                }
            }
            task.resume()
        } catch {
            print("Encoding error: \(error)")
        }
    }
    
    
    func editBook(id: Int, title: String?, author: String?, isbn: String?,
                 publishedYear: Int?, noOfAvailableCopies: Int?) {
        guard let url = URL(string: "http://localhost:8080/api/books/updateBook/\(id)") else {
            print("Invalid URL")
            return
        }
        
        var bodyDict: [String: Any] = [:]
        
        if let title = title { bodyDict["title"] = title }
        if let author = author { bodyDict["author"] = author }
        if let isbn = isbn { bodyDict["isbn"] = isbn }
        if let publishedYear = publishedYear { bodyDict["publishedYear"] = publishedYear }
        if let noOfAvailableCopies = noOfAvailableCopies { bodyDict["noOfAvailableCopies"] = noOfAvailableCopies }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: bodyDict)
            request.httpBody = jsonData
            
            print("\nRequest URL: \(url)")
            print("Request Method: \(request.httpMethod ?? "")")
            print("Request Headers: \(request.allHTTPHeaderFields ?? [:])")
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("Request Body: \(jsonString)")
            }
            
            let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                if let error = error {
                    print("Network Error: \(error)")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("Status Code: \(httpResponse.statusCode)")
                }
                
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    print("Response: \(responseString)")
                }
                
                DispatchQueue.main.async {
                    self?.fetchBooks()
                }
            }
            task.resume()
        } catch {
            print("JSON Serialization error: \(error)")
        }
    }
    
    func deleteBook(id: Int) {
        guard let url = URL(string: "http://localhost:8080/api/books/deleteBook/\(id)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            DispatchQueue.main.async {
                self?.fetchBooks()
            }
        }
        task.resume()
    }
} 
