
import UIKit

import UIKit

struct UserDefaultsKeys {
    static let playlist = "playlist"
}

class CreatePlaylistViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textfield: UITextField!
    static var playlist: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
    }
    
    func setupTextField() {
        textfield.delegate = self
    }
    
    private func savePlaylist() {
        UserDefaults.standard.set(CreatePlaylistViewController.playlist, forKey: UserDefaultsKeys.playlist)
    }
    
    @IBAction func okbtnclick(_ sender: Any) {
        if let text = textfield.text, !text.isEmpty {
            CreatePlaylistViewController.playlist.append(text)
        }
        savePlaylist()
        self.dismiss(animated: true)
    }
    
    @IBAction func cancelbtnclick(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    // UITextFieldDelegate method to limit the text input to 10 characters
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= 20
    }
}
