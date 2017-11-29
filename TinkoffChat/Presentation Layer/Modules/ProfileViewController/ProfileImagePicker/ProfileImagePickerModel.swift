//
//  ProfileImagePickerModel.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 29.11.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit

protocol IProfileImagePickerModel: class {
    func fetchImages(completionHandler: @escaping ((_ success: Bool) -> Void))
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
    
    func fetchImages(completionHandler: @escaping ((_ success: Bool) -> Void)) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.profileImageLoaderService.loadImages { (images, error) in
                if let loadedImages = images {
                    self.urls = loadedImages.flatMap { URL(string: $0.url) }
                    completionHandler(true)
                } else {
                    completionHandler(false)
                }
            }
        }
    }
    
    func fetchImage(from url: URL, for cell: ProfileImageCell, at indexPath: IndexPath) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.profileImageLoaderService.loadImage(from: url) { (result, error) in
                if let error = error {
                    print("\(error)")
                }
                if result != nil, cell.indexPath == indexPath {
                    cell.hasLoadedImage = true
                    DispatchQueue.main.async {
                        self.imagesCache[url] = result?.image
                        cell.image = result?.image
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCell.identifier, for: indexPath)
        guard let profileImageCell = cell as? ProfileImageCell else {
            assertionFailure("Wrong cell type in ProfileImagePickerViewController")
            return cell
        }
        profileImageCell.indexPath = indexPath
        profileImageCell.image = UIImage(named: "profileImagePlaceholder")
        let url = urls[indexPath.row]
        if let cachedImage = imagesCache[url] {
            profileImageCell.image = cachedImage
        } else {
            fetchImage(from: url, for: profileImageCell, at: indexPath)
        }
        return profileImageCell
    }
}
