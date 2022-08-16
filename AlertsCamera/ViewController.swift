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
        // Do any additional setup after loading the view.
    }


    @IBAction func editingPressed(_ sender: Any) {
    }
    @IBAction func takeAPicPressed(_ sender: Any) {
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
