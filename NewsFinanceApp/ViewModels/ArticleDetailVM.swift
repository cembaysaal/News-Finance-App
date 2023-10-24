import Foundation

class ArticleDetailVM {
    private var article: Article
    private var rates: [Currency: Double]

    init(article: Article, eurRate: Double?, tryRate: Double?, gelRate: Double?) {
        self.article = article
        self.rates = [:]
        
        if let eurRate = eurRate {
            rates[.EUR] = eurRate
        }
        
        if let tryRate = tryRate {
            rates[.TRY] = tryRate
        }
        
        if let gelRate = gelRate {
            rates[.GEL] = gelRate
        }
    }

    var articleTitle: String {
        return article.title ?? ""
    }

    var articleDescription: String {
        return article.description ?? ""
    }

    var imageUrl: URL? {
        return URL(string: article.urlToImage ?? "")
    }

    var eurRateText: String {
        return "EUR: \(rates[.EUR] ?? 0.0)"
    }

    var tryRateText: String {
        return "TRY: \(rates[.TRY] ?? 0.0)"
    }

    var gelRateText: String {
        return "GEL: \(rates[.GEL] ?? 0.0)"
    }
}
