import Foundation

class APICaller {
    
    enum APIError: Error {
        case failedToGetData
    }
    
    static let shared = APICaller()

    func getUpcomingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {

        guard let url = URL(string: "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.API_KEY)&language=tr") else {return}

        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
                completion(.success(results.results))

            } catch {
                completion(.failure(APIError.failedToGetData))
            }

        }
        task.resume()

    }

    func getPopular(completion: @escaping (Result<[Movie], Error>) -> Void) {

        guard let url = URL(string: "\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.API_KEY)&language=tr") else {return}

        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
                completion(.success(results.results))

            } catch {
                completion(.failure(APIError.failedToGetData))
            }

        }
        task.resume()

    }
    
    func getTopRated(completion: @escaping (Result<[Movie], Error>) -> Void) {

        guard let url = URL(string: "\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.API_KEY)&language=tr") else {return}

        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
                completion(.success(results.results))

            } catch {
                completion(.failure(APIError.failedToGetData))
            }

        }
        task.resume()

    }

    func getDiscoverMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {

        guard let url = URL(string: "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.API_KEY)&include_adult=false&include_video=false&language=tr&page=1&sort_by=popularity.desc&with_watch_monetization_types=flatrate") else {return}

        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)

                completion(.success(results.results))

            } catch {
                completion(.failure(APIError.failedToGetData))
            }

        }
        task.resume()

    }

    func search(with query: String, completion: @escaping (Result<[Movie], Error>) -> Void) {

        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}

        guard let url = URL(string: "\(Constants.baseURL)/3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)&language=tr") else {return}

        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)

                completion(.success(results.results))

            } catch {
                completion(.failure(APIError.failedToGetData))
            }

        }
        task.resume()

    }
}

