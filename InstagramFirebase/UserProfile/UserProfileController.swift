//
//  UserProfileController.swift
//  InstagramFirebase
//
//  Created by Amith Dubbasi on 3/17/18.
//  Copyright © 2018 iDiscover. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD


class UserProfileController : UICollectionViewController,UICollectionViewDelegateFlowLayout, UserProfileHeaderDelegate
{
    var user: User?
    let cellId = "cellId"
    let homePostCellId = "homePostCellId"
    var userId : String?
    
    var isGridView = true
    
    func didChangeToGridView() {
        isGridView = true
        collectionView?.reloadData()
    }
    
    func didChangeToListView() {
        isGridView = false
        collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.white
        fetchUser()
        
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerId")
        collectionView?.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: homePostCellId)
        setUpLogoutButton()
    
    }
    var isPagingFinished = false
    fileprivate func paginatePosts()
    {
        /*Fetch 5 - 6 posts at a time, depending on requirement.
         remember last fetched post and then repeat the above method till n
         */
        
        guard let uid = self.user?.uid else{ return }
        let ref = Database.database().reference().child("posts").child(uid)
        
        // var query = ref.queryOrderedByKey()
        var query = ref.queryOrdered(byChild: "creationDate")
        
       
        //queryEnding - traverses Up from given node, queryStarting - traverses down
        if posts.count > 0{
            //let value = posts.last?.id //start retrieving from last post in array
            let value = posts.last?.creationDate.timeIntervalSince1970
            
            query = query.queryEnding(atValue:value)
        }
        
        query.queryLimited(toLast: 4).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard var allObjects = snapshot.children.allObjects as? [DataSnapshot] else{
                return
            }
            
            //reverse the array inorder get the remaning objects
            allObjects.reverse()
            
            if allObjects.count < 4 {
               self.isPagingFinished = true
            }
            
            //post repeats itself when we start retrieving from last item in array
            if self.posts.count > 0 && allObjects.count > 0 {
                  allObjects.removeFirst()
            }
            allObjects.forEach({ (snapshot) in
                print(snapshot.key)
                guard let user = self.user else {
                    return
                }
                guard let dictionary = snapshot.value as? [String:Any] else {
                    return
                }
                var post = Post(user: user,dictionary: dictionary)
                post.id = snapshot.key
                self.posts.append(post)
                //self.posts.insert(post, at: 0)
            })
            self.collectionView?.reloadData()
            
        }) { (error) in
            print("Failed to paginate :", error)
        }
        
        
    }
    
    var posts = [Post]()
    
    fileprivate func fetchOrderedPosts() {
        
        //After calling fetchUser we set the user either from Login or Search Controller
        guard let uid = user?.uid else{
            return
        }
        let ref = Database.database().reference().child("posts").child(uid)
        
        //perhaps later on we'll implement some pagination of data
        ref.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            
            guard let user = self.user else { return }
            let post = Post(user: user,dictionary: dictionary)
            //self.posts.append(post)
            self.posts.insert(post, at: 0)
            self.collectionView?.reloadData()
            
        }) { (err) in
            print("Failed to fetch ordered posts:", err)
        }
    }
    

    fileprivate func setUpLogoutButton()
    {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogoutButton))
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isGridView {
            let width = (view.frame.width - 2) / 3
            return CGSize(width: width, height: width)
        } else {
            
            var height: CGFloat = 40 + 8 + 8 //username userprofileimageview
            height += view.frame.width
            height += 50
            height += 60
            
            return CGSize(width: view.frame.width, height: height)
        }
    }
    //Horizontal Spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    //Vertical Spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //fire of the paginate cell when you reach last item in Posts array and if you don't use isPagingFinished then you keep calling paginatePosts where reloading collectionView will never settle
        if indexPath.item == self.posts.count - 1 && !isPagingFinished{
            print("Paginating for posts")
            paginatePosts()
            
        }
        
        if isGridView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserProfilePhotoCell
            cell.post = posts[indexPath.item]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homePostCellId, for: indexPath) as! HomePostCell
            cell.post = posts[indexPath.item]
            return cell
        }
    }
    
    //Header for CollectionView Cell
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeader
        header.user = self.user
        header.delegate=self
        
        //not correct
        //header.addSubView(UIImageView())
        return header
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    
    fileprivate func fetchUser() {
        guard let uid = userId ?? Auth.auth().currentUser?.uid else { return }
        
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.user = user
            self.navigationItem.title = self.user?.username
            
            self.collectionView?.reloadData()
            //self.fetchOrderedPosts()
            self.paginatePosts()
        }
    }
    
    @objc func handleLogoutButton()
    {
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .actionSheet)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        
        let logOutAction: UIAlertAction = UIAlertAction(title: "Log Out",style: .destructive) { action -> Void in
            do{
            try Auth.auth().signOut()
                
            let loginController = LoginController()
            let navController = UINavigationController(rootViewController: loginController)
            self.present(navController, animated: true, completion: nil)
                
            }
            catch let signOutErr{
                print("Failed to SignOut",signOutErr)
            }
            
        }
        actionSheetController.addAction(logOutAction)
        actionSheetController.addAction(cancelAction)
        present(actionSheetController, animated: true, completion: nil)
    }
}


