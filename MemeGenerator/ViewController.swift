//
//  ViewController.swift
//  MemeGenerator
//
//  Created by alexander on 13.02.2020.
//  Copyright © 2020 alexander. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Meme Generator"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearTapped))
    }

    @objc func clearTapped() {
        imageView.image = nil
        button.isHidden = false
        navigationItem.rightBarButtonItem = nil
    }
    
    @objc func shareTapped() {
        guard let image = imageView.image else { return }

        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    @IBAction func choosePicture(_ sender: UIButton) {
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
           picker.sourceType = .camera
        }
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let gettedImage = info[.editedImage] as? UIImage else { return }
        
        button.isHidden = true
        
        dismiss(animated: true) { [weak self] in
            var upText = ""
            var downText = ""
            
            let upTextAc = UIAlertController(title: "Enter UP text", message: "Leave empty if you don't need it", preferredStyle: .alert)
            upTextAc.addTextField()
            upTextAc.addAction(UIAlertAction(title: "OK", style: .default) { [weak upTextAc] _ in
                guard let text = upTextAc?.textFields?[0].text?.capitalized else { return }
                upText = text
 
                let downTextAC = UIAlertController(title: "Enter DOWN text", message: "Leave empty if you don't need it", preferredStyle: .alert)
                downTextAC.addTextField()
                downTextAC.addAction(UIAlertAction(title: "OK", style: .default) { [weak downTextAC] _ in
                    guard let text = downTextAC?.textFields?[0].text?.capitalized else { return }
                    downText = text
                    
                    let renderer = UIGraphicsImageRenderer(size: gettedImage.size)

                    let image = renderer.image { ctx in
                        gettedImage.draw(at: CGPoint(x: 0, y: 0))
                        
                        let fontHeight = gettedImage.size.height / 7
                        
                        let attributes: [NSAttributedString.Key: Any] = [
                            .font: UIFont.boldSystemFont(ofSize: fontHeight),
                            .foregroundColor: UIColor.white
                        ]
                        
                        let upTextAttributed = NSAttributedString(string: upText, attributes: attributes)
                        let downTextAttributed = NSAttributedString(string: downText, attributes: attributes)
                        upTextAttributed.draw(at: CGPoint(x: 0, y: 5))
                        downTextAttributed.draw(at: CGPoint(x: 0, y: gettedImage.size.height - fontHeight - fontHeight / 5))
                    }

                    self?.imageView.image = image
                    
                    self?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self?.shareTapped))
                })
                self?.present(downTextAC, animated: true)
            })
            self?.present(upTextAc, animated: true)
        }
    }
}

