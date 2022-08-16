//
//  ViewController.swift
//  AlertsCamera
//
//  Created by Dusan Orescanin on 17/08/2022.
//

import UIKit
import PhotosUI

class ViewController: UIViewController {

    
    @IBOutlet weak var containerIV: UIImageView!
    @IBOutlet weak var editingButton: UIButton!
    
    var libraryPicker: PHPickerViewController?
    var cameraPicker = UIImagePickerController()
    var canUserCamera = UIImagePickerController.isSourceTypeAvailable(.camera)
    var canEdit = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLibrary()
        setupCamera()
    }


    @IBAction func editingPressed(_ sender: Any) {
        //alertForEditing()
        AlertHelper.shared.alertForEditing(self) { editing in
            self.canEdit = editing
            self.setupCamera()
        }
    }
    @IBAction func takeAPicPressed(_ sender: Any) {
        //alertForPicture()
        AlertHelper.shared.alertForPicture(self, canUserCamera, cameraPicker, libraryPicker!)
    }
    
    
}

extension ViewController: PHPickerViewControllerDelegate {
    
    func setupLibrary() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        configuration.preferredAssetRepresentationMode = .automatic
        libraryPicker = PHPickerViewController(configuration: configuration)
        libraryPicker?.delegate = self
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        guard let first = results.first else { return }
        let newPhotoProvider = first.itemProvider
        guard newPhotoProvider.canLoadObject(ofClass: UIImage.self) else { return }
        newPhotoProvider.loadObject(ofClass: UIImage.self) { image, error in
            DispatchQueue.main.async {
                if let e = error {
                    print(e.localizedDescription)
                }
                guard let newImage = image as? UIImage else { return }
                self.containerIV.image = newImage
            }
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func setupCamera() {
        if canUserCamera {
            cameraPicker.delegate = self
            cameraPicker.sourceType = .camera
            cameraPicker.allowsEditing = canEdit
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let infoKey: UIImagePickerController.InfoKey = canEdit ? .editedImage : .originalImage
        guard let image = info[infoKey] as? UIImage else { return }
        self.containerIV.image = image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ViewController {
    
//    func alertForPicture() {
//        let alert = UIAlertController(title: "Prendre une photo", message: "Quel type de photo?", preferredStyle: .alert)
//        let cancel = UIAlertAction(title: "Annuler", style: .cancel, handler: nil)
//        alert.addAction(cancel)
//        if self.canUserCamera {
//            self.setupCamera()
//            let photo = UIAlertAction(title: "Appareil photo", style: .default) { action in
//                self.present(self.cameraPicker, animated: true, completion: nil)
//        }
//            alert.addAction(photo)
//        }
//        let library = UIAlertAction(title: "Librairie", style: .default) { action in
//            self.present(self.libraryPicker!, animated: true, completion: nil)
//        }
//        alert.addAction(library)
//        present(alert, animated: true, completion: nil)
//    }
//    
//    func alertForEditing() {
//        let alert = UIAlertController(title: "Editing?", message: nil, preferredStyle: .actionSheet)
//        let noEditing = UIAlertAction(title: "Original", style: .default) { action in
//            self.canEdit = false
//        }
//        let yesEditing = UIAlertAction(title: "Editable", style: .default) { action in
//            self.canEdit = true
//        }
//        alert.addAction(noEditing)
//        alert.addAction(yesEditing)
//        alert.addAction(UIAlertAction(title: "Annuler", style: .default, handler: nil))
//        present(alert, animated: true, completion: nil)
//    }
    
}
