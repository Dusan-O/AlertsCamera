//
//  AlertHelper.swift
//  AlertsCamera
//
//  Created by Dusan Orescanin on 17/08/2022.
//

import UIKit
import PhotosUI

class AlertHelper {
    
    static let shared = AlertHelper()
    
    func alertForPicture(_ controller: UIViewController, _ canUserCamera: Bool, _ camera: UIImagePickerController, _ library: PHPickerViewController) {
        let alert = UIAlertController(title: "Prendre une photo", message: "Quel type de photo?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Annuler", style: .cancel, handler: nil)
        alert.addAction(cancel)
        if canUserCamera {
            let photo = UIAlertAction(title: "Appareil photo", style: .default) { action in
                controller.present(camera, animated: true, completion: nil)
        }
            alert.addAction(photo)
        }
        let library = UIAlertAction(title: "Librairie", style: .default) { action in
            controller.present(library, animated: true, completion: nil)
        }
        alert.addAction(library)
        controller.present(alert, animated: true, completion: nil)
    }
    
    func alertForEditing(_ controller: UIViewController, completion: ((Bool) -> Void)?) {
        let alert = UIAlertController(title: "Editing?", message: nil, preferredStyle: .actionSheet)
        let noEditing = UIAlertAction(title: "Original", style: .default) { action in
            //self.canEdit = false
            completion?(false)
        }
        let yesEditing = UIAlertAction(title: "Editable", style: .default) { action in
            //self.canEdit = true
            completion?(true)
        }
        alert.addAction(noEditing)
        alert.addAction(yesEditing)
        alert.addAction(UIAlertAction(title: "Annuler", style: .default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
}
