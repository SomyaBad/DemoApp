

import Foundation

class HomeViewModel {
    var trendingMovies: [Movie] = []
    var nowPlayingMovies: [Movie] = []
    var popularMovies: [Movie] = []
    var topRatedMovies: [Movie] = []
    
    let apiKey = "c77a451f55684047265eed8393fe387d"
    let baseURL = "https://api.themoviedb.org/3"
    
    var onUpdate: (() -> Void)?

    enum MovieCategory {
        case trending(timeWindow: String)
        case nowPlaying
        case popular
        case topRated

        var path: String {
            switch self {
            case .trending(let timeWindow):
                return "/trending/movie/\(timeWindow)"
            case .nowPlaying:
                return "/movie/now_playing"
            case .popular:
                return "/movie/popular"
            case .topRated:
                return "/movie/top_rated"
            }
        }
    }

    func fetchMovies(for category: MovieCategory, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let urlString = "\(baseURL)\(category.path)?api_key=\(apiKey)"
        print("URL: \(urlString)")  
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "invalidURL", code: -1000, userInfo: nil)))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else {
                let error = NSError(domain: "dataNilError", code: -1001, userInfo: nil)
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            do {
                let response = try JSONDecoder().decode(MovieResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(response.results))
                }
            } catch let decodingError {
                print("Decoding Error: \(decodingError)")  // Debug statement to print the decoding error
                print("Response Data: \(String(data: data, encoding: .utf8) ?? "No data")")  // Print the raw data for inspection
                DispatchQueue.main.async {
                    completion(.failure(decodingError))
                }
            }
        }
        task.resume()
    }


    func fetchAllMovies() {
        let group = DispatchGroup()

        group.enter()
        fetchMovies(for: .trending(timeWindow: "day")) { result in
            switch result {
            case .success(let movies):
                self.trendingMovies = movies
            case .failure(let error):
                print("Error fetching trending movies: \(error)")
            }
            group.leave()
        }

        group.enter()
        fetchMovies(for: .nowPlaying) { result in
            switch result {
            case .success(let movies):
                self.nowPlayingMovies = movies
            case .failure(let error):
                print("Error fetching now playing movies: \(error)")
            }
            group.leave()
        }

        group.enter()
        fetchMovies(for: .popular) { result in
            switch result {
            case .success(let movies):
                self.popularMovies = movies
            case .failure(let error):
                print("Error fetching popular movies: \(error)")
            }
            group.leave()
        }

        group.enter()
        fetchMovies(for: .topRated) { result in
            switch result {
            case .success(let movies):
                self.topRatedMovies = movies
            case .failure(let error):
                print("Error fetching top rated movies: \(error)")
            }
            group.leave()
        }

        group.notify(queue: .main) {
            self.onUpdate?()
        }
    }
}

struct MovieResponse: Codable {
    let results: [Movie]
}
