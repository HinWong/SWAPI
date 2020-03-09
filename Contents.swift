import UIKit

// var str = "Hello, playground"

//MARK: - Model

struct Person: Codable {
    let name: String
    let films: [URL]
}

struct Film: Codable {
    let title: String
    let opening_crawl : String
    let release_date : String
}

//MARK: - Controller

class SwapiService {
    private static let baseURL = URL(string: "https://swapi.co/api")
    private static let personEndpoint = "person"
    private static let filmEndpoint = "film"
    private static let personQueryItemName = "person"
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        // 1 - Prepare URL
        guard let baseURL = baseURL else {return completion(nil)}
        let personURL = baseURL.appendingPathComponent("people/\(id)")
        print(personURL)
        
        // 2 - Contact server
        URLSession.shared.dataTask(with: personURL) { (data, _, error) in
            
            // 3 - Handle errors
            if let error = error {
                print(error, error.localizedDescription)
                return completion(nil)
            }
            
            // 4 - Check for data
            guard let data = data else { return completion(nil) }
            
            // 5 - Decode Person from JSON
            do {
                let person = try JSONDecoder().decode(Person.self, from: data)
                return completion(person)
            } catch {
                print(error, error.localizedDescription)
                return completion(nil)
            }
            
        }.resume()
    }
    
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
        // 1 - Contact server
//        guard let baseURL = baseURL else { return completion(nil) }
//        let filmURL = baseURL.appendingPathComponent("films/\(url)")
//        print(filmURL)
        // 2 - Handle errors
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            
            // 3 - Check for data
            guard let data = data else { return completion(nil) }
            
            // 4 - Decode Film from JSON
            do {
                let film = try JSONDecoder().decode(Film.self, from: data)
                return completion(film)
            } catch {
                print(error, error.localizedDescription)
                return completion(nil)
            }
        }.resume()
        
    }
    
}

func fetchFilm(url: URL) {
    SwapiService.fetchFilm(url: url) { film in
        if let film = film {
            print(film.title)
        }
    }
}

SwapiService.fetchPerson(id: 10) { person in
    if let person = person {
        print(person)
        for film in person.films {
            fetchFilm(url: film)
        }
    }
}



