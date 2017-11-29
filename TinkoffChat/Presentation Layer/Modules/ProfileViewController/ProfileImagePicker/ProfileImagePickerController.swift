//
//  ProfileImagePickerController.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 29.11.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit

class ProfileImagePickerViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let numberOfCellsPerRow = 3
    
    var model: IProfileImagePickerModel!
    var onSelectProfileImage: ((UIImage) -> Void)?
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.configureWith(collectionView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchImages()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - Actions
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Private methods
    
    private func fetchImages() {
        activityIndicator.startAnimating()
        self.model.fetchImages { success in
            if success {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.activityIndicator.stopAnimating()
                }
            } else {
                self.showFetchError()
            }
        }
    }
    
    private func showFetchError() {
        let alertViewController = UIAlertController(title: "Ошибка", message: "Нет доступа к сети", preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in
            self.dismiss(animated: true, completion: nil)
        })
        present(alertViewController, animated: true)
    }
}

extension ProfileImagePickerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        guard let profileImageCell = cell as? ProfileImageCell else {
            assertionFailure("Wrong cell type was selected")
            return
        }
        if profileImageCell.hasLoadedImage, let image = profileImageCell.image {
            guard let onSelectProfileImageCompletion = onSelectProfileImage else {
                assertionFailure("onSelectProfileImage completion is nil")
                return
            }
            dismiss(animated: true) {
                onSelectProfileImageCompletion(image)
            }
        }
    }
}

extension ProfileImagePickerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            preconditionFailure("Wrong layout type")
        }
        let marginsAndInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right + flowLayout.minimumInteritemSpacing * CGFloat((numberOfCellsPerRow - 1))
        let itemWidth = ((collectionView.bounds.width - marginsAndInsets) / CGFloat(numberOfCellsPerRow)).rounded(.down)
        return CGSize(width: itemWidth, height: itemWidth)
    }
}
