import UIKit

class ArticleCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    func configure(with article: Article) {
        titleLabel.text = article.title
        descriptionLabel.text = article.description
        loadImage(from: article.urlToImage)
    }

    private func loadImage(from urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            imageView.image = nil 
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                return
            }
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
        }
        task.resume()
    }
}
