import UIKit

class ArticlesVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var eurRateLabel: UILabel!
    @IBOutlet weak var tryRateLabel: UILabel!
    @IBOutlet weak var gelRateLabel: UILabel!

    // MARK: - Variables
    private var viewModel = ArticleListVM()

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "News"
        setupCollectionView()
        fetchArticlesAndRates()
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ArticleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ArticleCellIdentifier")
        
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 10
            layout.minimumLineSpacing = 10
            layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 10)
        }
    }

    private func fetchArticlesAndRates() {
        viewModel.fetchArticles { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }

        viewModel.fetchExchangeRates { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.eurRateLabel.text = self.viewModel.eurRateText
                self.tryRateLabel.text = self.viewModel.tryRateText
                self.gelRateLabel.text = self.viewModel.gelRateText
            }
        }
    }

    // MARK: - Collection View Delegate & Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfArticles()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCellIdentifier", for: indexPath) as? ArticleCollectionViewCell else { return UICollectionViewCell()}

        let article = viewModel.article(at: indexPath.row)
        cell.configure(with: article)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewModel = viewModel.detailViewModel(for: indexPath.row)
        let detailsVC = ArticleDetailVC(viewModel: detailViewModel)
        self.navigationController?.pushViewController(detailsVC, animated: false)
        detailsVC.startLoading()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            detailsVC.stopLoading()
            detailsVC.setupUI()
        }
    }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 30) / 2
        return CGSize(width: width, height: 300)
    }

}
