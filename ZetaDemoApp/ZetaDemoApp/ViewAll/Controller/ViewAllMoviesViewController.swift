

import UIKit

class ViewAllMoviesViewController: UIViewController, MovieCollectionViewCellDelegate, AddPlayListProtocol {
    
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var movies: [Movie]?
    var header = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCell()
    }
    
    func setupCell() {
        titlelbl.text = header
        self.navigationController?.navigationBar.isHidden = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName:Strings.movieCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: Strings.movieCollectionViewCell)
    }
    
    func didLongPressTitle(in cell: MovieCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell),
              let movie = movies?[indexPath.row] else { return }
        presentBottomSheet(for: movie)
    }
    
    private func presentBottomSheet(for movie: Movie) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let bottomSheetVC = storyboard.instantiateViewController(withIdentifier: "AddPlayListViewController") as? AddPlayListViewController {
            //  bottomSheetVC.movie = movie // Pass the selected movie to the bottom sheet
            if let sheet = bottomSheetVC.sheetPresentationController {
                sheet.detents = [.medium()]
            }
            bottomSheetVC.delegate =  self
            present(bottomSheetVC, animated: true, completion: nil)
        }
    }
    
    func enterPlayList() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let bottomSheetVC = storyboard.instantiateViewController(withIdentifier: "CreatePlaylistViewController") as? CreatePlaylistViewController {
            if let sheet = bottomSheetVC.sheetPresentationController {
                sheet.detents = [.large()]
            }
            present(bottomSheetVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension ViewAllMoviesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Strings.movieCollectionViewCell, for: indexPath) as! MovieCollectionViewCell
        cell.delegate = self
        if let movieData = movies?[indexPath.row] {
            cell.bindData(data: movieData)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width / 3) - 10
        return CGSize(width: width, height: 250)
    }
}
