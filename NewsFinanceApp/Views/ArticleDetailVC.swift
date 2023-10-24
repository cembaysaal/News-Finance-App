import UIKit

class ArticleDetailVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var eurRateLabel: UILabel!
    @IBOutlet weak var tryRateLabel: UILabel!
    @IBOutlet weak var gelRateLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var financeLabel: UILabel!
    
    // MARK: - Variables
    var viewModel: ArticleDetailVM!

    // MARK: - Initializers
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(viewModel: ArticleDetailVM) {
        super.init(nibName: "ArticleDetailVC", bundle: nil)
        self.viewModel = viewModel
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        hideUIElements()
        
        self.title = "News Detail"
        startLoading()
        fetchData()
    }

    func fetchData() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) { [weak self] in
            DispatchQueue.main.async {
                self?.setupUI()
            }
        }
    }
    
    func hideUIElements() {
        titleLabel.isHidden = true
        descriptionLabel.isHidden = true
        eurRateLabel.isHidden = true
        tryRateLabel.isHidden = true
        gelRateLabel.isHidden = true
        articleImageView.isHidden = true
        financeLabel.isHidden = true
    }

    func startLoading() {
        activityIndicator?.startAnimating()
        view.isUserInteractionEnabled = false
    }

    func stopLoading() {
        activityIndicator.stopAnimating()
        view.isUserInteractionEnabled = true
    }

    // MARK: - UI Setup
    func setupUI() {
        titleLabel.isHidden = false
        descriptionLabel.isHidden = false
        eurRateLabel.isHidden = false
        tryRateLabel.isHidden = false
        gelRateLabel.isHidden = false
        articleImageView.isHidden = false
        financeLabel.isHidden = false

        titleLabel.text = viewModel.articleTitle
        descriptionLabel.text = viewModel.articleDescription
        eurRateLabel.text = viewModel.eurRateText
        tryRateLabel.text = viewModel.tryRateText
        gelRateLabel.text = viewModel.gelRateText
        
        fetchImage(from: viewModel.imageUrl)
    }

    private func fetchImage(from url: URL?) {
        guard let url = url else {
            stopLoading()
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            if let error = error {
                print("Failed to load image: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.stopLoading()
                }
                return
            }

            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.articleImageView.image = image
                    self?.stopLoading()
                }
            }
        }
        task.resume()
    }
}
