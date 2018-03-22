//
//  PhotoSelector.swift
//  InstagramFirebase
//
//  Created by Amith Dubbasi on 3/21/18.
//  Copyright © 2018 iDiscover. All rights reserved.
//

import UIKit
import Photos

class PhotoSelectorController : UICollectionViewController, UICollectionViewDelegateFlowLayout
{
    
    let cellId = "cellId"
    let headerId = "headerId"
    var images  = [UIImage]() //push in to array when we retrieve all the Photos from devices
    var selectedImage : UIImage?
    var assets = [PHAsset]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.white
        
        setUpNavigationBar()
        
        //register Header(that will be a collection view cell)
        collectionView?.register(PhotoSelectorHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        
        //register collection view cells
        collectionView?.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: cellId)
        
        fetchPhotos()
    }
    
    
    fileprivate func assetsFetchOptions() -> PHFetchOptions
    {
        let fetchPhotoOptions = PHFetchOptions()
        fetchPhotoOptions.fetchLimit = 100
        
        //To sort out the latest photos taken just add sort Descriptors to Fetch options to fetch images in descending of creationDate
        let sortDescriptor  = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchPhotoOptions.sortDescriptors = [sortDescriptor]
        return fetchPhotoOptions
    }
    //Use Photos framework to display device photos
   fileprivate func fetchPhotos()
    {
        let allPhotos = PHAsset.fetchAssets(with: .image, options: assetsFetchOptions())
        //looping through all received photos, just like a for loop where count starts from 0 to allPhotos.count
        
        DispatchQueue.global(qos: .background).async {
            
            allPhotos.enumerateObjects({ (asset, count, stop) in
                
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options) { (photo,info) in
                    
                    guard let image = photo else {
                        return
                    }
                    self.images.append(image)
                    self.assets.append(asset)
                    if self.selectedImage == nil{
                        self.selectedImage = image
                    }
                    
                    if count == allPhotos.count - 1 {
                        //when reloading data, cell for item at method is called depending number of cells we have
                        DispatchQueue.main.async {
                            self.collectionView?.reloadData()
                        }
                        
                    }
                    
                }
            })
        }
    }
    
    
    fileprivate func setUpNavigationBar()
    {
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNextAction))
        
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PhotoSelectorCell
        
        cell.photoImageView.image = images[indexPath.item]
        
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedImage = images[indexPath.item]
        collectionView.reloadData()
        
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3) / 4
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    var header : PhotoSelectorHeader?
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! PhotoSelectorHeader
        
        self.header = header
        if let selectedPhoto = selectedImage {
            if let index = self.images.index(of: selectedPhoto) {
                
                let selectedAsset = self.assets[index]
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 600, height: 600)
                imageManager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .default, options: nil, resultHandler: { (image,info) in
                    header.latestImageView.image = image
                })
            }
        }
        return header
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
    //1 pixel distance from Header to Collection view cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }

    
    @objc func handleCancelAction()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleNextAction()
    {
        let sharePhotocontroller = SharePhotoController()
        sharePhotocontroller.selectedImage = self.header?.latestImageView.image
        navigationController?.pushViewController(sharePhotocontroller, animated: true)
        
    }
}
