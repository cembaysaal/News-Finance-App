import Foundation

class ArticleListVM {
    private var articles: [Article] = []
    var rates: [Currency: Double] = [:]

    var eurRateText: String {
        return "EUR: \(rates[.EUR] ?? 0.0)"
    }

    var tryRateText: String {
        return "TRY: \(rates[.TRY] ?? 0.0)"
    }

    var gelRateText: String {
        return "GEL: \(rates[.GEL] ?? 0.0)"
    }

    func fetchArticles(completion: @escaping () -> Void) {
        ArticleService.shared.fetchArticles { [weak self] articles in
            self?.articles = articles ?? []
            completion()
        }
    }

    func fetchExchangeRates(completion: @escaping () -> Void) {
        ExchangeRateService.shared.fetchExchangeRates { [weak self] rates in
            self?.rates[.EUR] = rates?.conversionRates[Currency.EUR.displayName]
            self?.rates[.TRY] = rates?.conversionRates[Currency.TRY.displayName]
            self?.rates[.GEL] = rates?.conversionRates[Currency.GEL.displayName]
            completion()
        }
    }

    func numberOfArticles() -> Int {
        return articles.count
    }

    func article(at index: Int) -> Article {
        return articles[index]
    }

    func detailViewModel(for index: Int) -> ArticleDetailVM {
        let article = self.article(at: index)
        return ArticleDetailVM(
            article: article,
            eurRate: rates[.EUR],
            tryRate: rates[.TRY],
            gelRate: rates[.GEL]
        )
    }
}
