import Foundation

class ExchangeRateService {

    static let shared = ExchangeRateService()

    private let url = "https://v6.exchangerate-api.com/v6"
    private let apiKey = "YOURAPIKEY"
    private let currency = "USD"
    private var cachedExchangeRate: ExchangeRate?

    private var fullURL: String {
        return "\(url)/\(apiKey)/latest/\(currency)"
    }

    private init() {}

    func fetchExchangeRates(completion: @escaping (ExchangeRate?) -> Void) {
        if let cached = cachedExchangeRate {
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
            let exchangeRate = try? JSONDecoder().decode(ExchangeRate.self, from: data)
            self.cachedExchangeRate = exchangeRate
            completion(exchangeRate)
        }.resume()
    }
}
