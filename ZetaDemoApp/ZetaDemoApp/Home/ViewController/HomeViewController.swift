import UIKit

import UIKit

class HomeViewController: UIViewController, MovieProtocol, AddPlayListProtocol {
     
    @IBOutlet weak var tableView: UITableView!
    let viewModel = HomeViewModel()
    var categoryList = [Strings.trending,Strings.nowPlaying,Strings.popular,Strings.toprated]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel.fetchAllMovies()
        setupTableView()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Strings.movieTableViewCell, bundle: nil), forCellReuseIdentifier: Strings.movieTableViewCell)
    }
    
    func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func viewAllClick(movie: [Movie],title:String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewAllMoviesVC = storyboard.instantiateViewController(withIdentifier: "ViewAllMoviesViewController") as? ViewAllMoviesViewController {
            viewAllMoviesVC.movies = movie
            viewAllMoviesVC.header = title
            navigationController?.pushViewController(viewAllMoviesVC, animated: true)
        }
    }
    
    func todayClick(movie: [Movie]) {
        
    }
    
    func thisWeekClick(movie: [Movie]) {
        
    }
    
    func didLongPressTitle(in cell: MovieCollectionViewCell) {
        guard let tableViewIndexPath = tableView.indexPathForRow(at: cell.superview?.convert(cell.frame.origin, to: tableView) ?? CGPoint()) else {
            return
        }
        let sectionMovies: [Movie]
        switch tableViewIndexPath.section {
        case 0:
            sectionMovies = viewModel.trendingMovies
        case 1:
            sectionMovies = viewModel.nowPlayingMovies
        case 2:
            sectionMovies = viewModel.popularMovies
        case 3:
            sectionMovies = viewModel.topRatedMovies
        default:
            return
        }
        if let collectionView = cell.superview as? UICollectionView,
           let collectionViewIndexPath = collectionView.indexPath(for: cell) {
            let movie = sectionMovies[collectionViewIndexPath.row]
            presentBottomSheet(for: movie)
        }
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
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return categoryList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Strings.movieTableViewCell, for: indexPath) as! MovieTableViewCell
        cell.delegate = self
        let movies: [Movie]
        switch indexPath.section {
        case 0:
            movies = viewModel.trendingMovies
        case 1:
            movies = viewModel.nowPlayingMovies
        case 2:
            movies = viewModel.popularMovies
        case 3:
            movies = viewModel.topRatedMovies
        default:
            fatalError("Unexpected section")
        }
        cell.movies = movies
        cell.titlelbl.text = categoryList[indexPath.section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 320
    }
    
    
}
