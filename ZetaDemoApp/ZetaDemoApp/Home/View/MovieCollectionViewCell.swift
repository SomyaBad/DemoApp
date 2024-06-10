

import UIKit

protocol MovieCollectionViewCellDelegate: AnyObject {
    func didLongPressTitle(in cell: MovieCollectionViewCell)
}

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var yearlbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    weak var delegate: MovieCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 10
        setupLongPressGesture()
    }
    
    private func setupLongPressGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        titlelbl.isUserInteractionEnabled = true
        titlelbl.addGestureRecognizer(longPressGesture)
    }
    
    @objc private func handleLongPress() {
        delegate?.didLongPressTitle(in: self)
    }
    
    func bindData(data:Movie){
        titlelbl.text = data.title
        if let posterPath = data.posterPath {
            let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
            imageView.loadImage(from: imageUrl!)
        } else {
            imageView.image = UIImage(named: "placeholder")
        }
        if let releaseDateString = data.releaseDate,
           let year = DateUtils.getYear(from: releaseDateString) {
            yearlbl.text = year
        }
    }
}
