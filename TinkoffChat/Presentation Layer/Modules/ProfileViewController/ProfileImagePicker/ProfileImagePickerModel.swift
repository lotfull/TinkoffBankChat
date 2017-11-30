//
//  ProfileImagePickerModel.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 29.11.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit

protocol IProfileImagePickerModel: class {
    func fetchImages(completion: @escaping ((_ success: Bool) -> Void))
    func configureWith(_ collectionView: UICollectionView)
}

class ProfileImagePickerModel: NSObject, IProfileImagePickerModel {
    private let profileImageLoaderService: IProfileImageLoaderService
    private var urls = [URL]()
    private var imagesCache = [URL: UIImage]()
    
    init(_ profileImageLoaderService: IProfileImageLoaderService) {
        self.profileImageLoaderService = profileImageLoaderService
    }
    
    func configureWith(_ collectionView: UICollectionView) {
        collectionView.dataSource = self
    }
    
    func fetchImages(completion: @escaping ((_ success: Bool) -> Void)) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.profileImageLoaderService.loadImages { (images, error) in
                if let loadedImages = images {
                    self.urls = loadedImages.flatMap { URL(string: $0.url) }
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    func fetchImage(from url: URL, for cell: ImageCell, at indexPath: IndexPath) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.profileImageLoaderService.loadImage(from: url) { (result, error) in
                if let error = error {
                    print("\(error)")
                }
                if result != nil, cell.indexPath == indexPath {
                    cell.hasLoadedImage = true
                    DispatchQueue.main.async {
                        self.imagesCache[url] = result?.image
                        cell.imageView.image = result?.image
                    }
                }
            }
        }
    }
}

extension ProfileImagePickerModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath)
        guard let imageCell = cell as? ImageCell else {
            assertionFailure("Wrong cell type in ProfileImagePickerViewController")
            return cell
        }
        imageCell.indexPath = indexPath
        imageCell.imageView.image = UIImage(named: "profileImagePlaceholder")
        let url = urls[indexPath.row]
        if let cachedImage = imagesCache[url] {
            imageCell.imageView.image = cachedImage
        } else {
            fetchImage(from: url, for: imageCell, at: indexPath)
        }
        return imageCell
    }
}
