

import UIKit

protocol AddPlayListProtocol:AnyObject{
    func enterPlayList()
}

class AddPlayListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    weak var delegate:AddPlayListProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadPlaylist()
        updateTableViewHeight()
       
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Strings.playListTableViewCell, bundle: nil), forCellReuseIdentifier: Strings.playListTableViewCell)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
    }
    
    func updateTableViewHeight() {
        tableView.layoutIfNeeded()
        let contentHeight = tableView.contentSize.height
        tableViewHeightConstraint.constant = min(contentHeight, 250)
    }
    
    private func loadPlaylist() {
        if let savedPlaylist = UserDefaults.standard.stringArray(forKey: UserDefaultsKeys.playlist) {
            CreatePlaylistViewController.playlist = savedPlaylist
        }
    }
    
    @IBAction func addPlayListClick(_ sender: Any) {
        self.dismiss(animated: true)
        self.delegate?.enterPlayList()
    }
    
    
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension AddPlayListViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CreatePlaylistViewController.playlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier:  Strings.playListTableViewCell, for: indexPath) as! PlayListTableViewCell
        cell.playlistNamelbl.text = CreatePlaylistViewController.playlist[indexPath.row]
        return cell
    }
}
