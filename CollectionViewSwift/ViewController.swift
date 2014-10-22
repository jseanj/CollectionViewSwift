//
//  ViewController.swift
//  CollectionViewSwift
//
//  Created by jins on 14-10-21.
//  Copyright (c) 2014 BlackWater. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var testCollectionView: UICollectionView!
    
    var selectionModelArray: [AFSelectionModel]!
    var imageURLs = [String]()
    var images = [UIImage]()
    var tempImages = [UIImage]()


    @IBAction func add(sender: AnyObject) {
        self.testCollectionView.performBatchUpdates({
            let image = self.images[0]
            self.images.append(image)
            self.testCollectionView.insertItemsAtIndexPaths([NSIndexPath(forItem: self.images.count-2, inSection: 0)])
        }, completion: nil)
    }
    @IBAction func deleteItem(sender: AnyObject) {
        self.testCollectionView.performBatchUpdates({
            self.images.removeLast()
            self.testCollectionView.deleteItemsAtIndexPaths([NSIndexPath(forItem: self.images.count-1, inSection: 0)])
        }, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.images.append(UIImage(named:"add")!)
        // Do any additional setup after loading the view, typically from a nib.
        var error: NSError?
        AFRequestManager.sharedManager().requestWithUrl("https://api.douban.com/v2/album/71575659/photos") {
            data in
            var json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &error) as Dictionary<String, AnyObject>
//            println(json)
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                if let photos = json["photos"] as? NSArray {
                    for photo in photos {
                        if let imageUrl = photo["image"] as? NSString {
                            println(imageUrl)
                            var url = NSURL(string: imageUrl)
                            var data = NSData(contentsOfURL: url!)
                            var image = UIImage(data: data!)
                            self.images.append(image!)
                            self.imageURLs.append(imageUrl)
                        }
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        self.testCollectionView.reloadData()
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: tableview dataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("tableViewCell", forIndexPath: indexPath) as AFTableViewCell
            cell.backgroundColor = UIColor.grayColor()
            cell.label.text = "hello"
            return cell
    }
    
    // MARK: tableview delegate
    
    
    // MARK: collection dataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as AFCollectionViewCell
        cell.backgroundColor = UIColor.whiteColor()
        cell.imageView.image = self.images[indexPath.row]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        println(kind)
        if kind == "UICollectionElementKindSectionFooter" {
            let footer = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "footer", forIndexPath: indexPath) as AFCollectionFooterView
            return footer
        } else {
            let header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "header", forIndexPath: indexPath) as AFCollectionHeaderView
            return header
        }
    }
    
    // MARK: collection delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let retval: CGSize = CGSizeMake(100, 100)//self.images[indexPath.row].size.width > 0 ? self.images[indexPath.row].size : CGSizeMake(100, 100)
        return retval
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(50, 20, 50, 20)
    }
}

