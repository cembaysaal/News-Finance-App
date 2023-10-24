import Foundation

class ArticleService {

    static let shared = ArticleService()

    private let url = "https://newsapi.org/v2/top-headlines"
    private let country = "US"
    private let apiKey = "e5033b0065e2427c843617d696beef16"
    private var cachedArticles: [Article]?

    private var fullURL: String {
        return "\(url)?country=\(country)&apiKey=\(apiKey)"
    }

    private init() {}

    func fetchArticles(completion: @escaping ([Article]?) -> Void) {
        if let cached = cachedArticles {
            completion(cached)
            return
        }
        
        guard let url = URL(string: fullURL) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            let articleResponse = try? JSONDecoder().decode(ArticleResponse.self, from: data)
            self.cachedArticles = articleResponse?.articles
            completion(articleResponse?.articles)
        }.resume()
    }
}
