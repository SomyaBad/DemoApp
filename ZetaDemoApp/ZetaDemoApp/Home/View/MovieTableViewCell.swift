

import UIKit
protocol MovieProtocol:AnyObject {
    func viewAllClick(movie:[Movie],title:String)
    func todayClick(movie:[Movie])
    func thisWeekClick(movie:[Movie])
    func didLongPressTitle(in cell: MovieCollectionViewCell)
}

class MovieTableViewCell: UITableViewCell,MovieCollectionViewCellDelegate {

    @IBOutlet weak var mainview: UIView!
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var todayAndThisweekView: UIView!
    @IBOutlet weak var allbtn: UIButton!
    @IBOutlet weak var titlelbl: UILabel!
    
    weak var delegate:MovieProtocol?
    
    
    var movies: [Movie]? {
        didSet {
            collectionview.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell() {
        allbtn.layer.cornerRadius = allbtn.frame.height/2
        collectionview.delegate = self
        collectionview.dataSource = self
        mainview.layer.cornerRadius = 10
        todayAndThisweekView.layer.cornerRadius = 10
        collectionview.register(UINib(nibName:Strings.movieCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: Strings.movieCollectionViewCell)
    }
    
    @IBAction func thisWeekBtnClick(_ sender: Any) {
        self.delegate?.todayClick(movie: self.movies ?? [])
    }
    
    @IBAction func todayBtnClick(_ sender: Any) {
        self.delegate?.thisWeekClick(movie: self.movies ?? [])
    }
    
    @IBAction func clickToAllBtn(_ sender: Any) {
        self.delegate?.viewAllClick(movie: self.movies ?? [], title: self.titlelbl.text ?? "")
    }
    
    func didLongPressTitle(in cell: MovieCollectionViewCell) {
            self.delegate?.didLongPressTitle(in: cell)
        }
}

extension MovieTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Strings.movieCollectionViewCell, for: indexPath) as! MovieCollectionViewCell
        cell.delegate = self
        if let movieData = movies?[indexPath.row] {
            cell.bindData(data: movieData)
        }
        todayAndThisweekView.isHidden = (titlelbl.text == Strings.trending) ? false : true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width / 3) - 10
        return CGSize(width: width, height: 250)
    }
}
