//
//  ViewController.swift
//  ECOMAPP
//
//  Created by SJM TECHNOLOGY on 03/01/19.
//  Copyright © 2019 SJM TECHNOLOGY. All rights reserved.
//

import UIKit
import Alamofire

let deviceIdiom_Ipad = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
  
   // MARK: - variables declarations
    var arryData : NSArray = []
    var arryRanking : NSArray = []
    var activityView: UIActivityIndicatorView!
    @IBOutlet var colView : UICollectionView!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "Categories"
        let logoutBarButtonItem = UIBarButtonItem(title: "View buy", style: .done, target: self, action: #selector(btnViewBuyPress))
        self.navigationItem.rightBarButtonItem  = logoutBarButtonItem
        
        self.checkdatafromdatabase()
        
       
        let nib1 = UINib(nibName: "categoriesCell", bundle: nil)
        self.colView.register(nib1, forCellWithReuseIdentifier:"categoriesCell")
        self.colView.allowsSelection = true
        self.colView.allowsMultipleSelection = false
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    // MARK: - check data from database
     func checkdatafromdatabase()
     {
        let nsquery1 = "SELECT * FROM tbl_categories"
        arryData = Database.share().selectAll(fromTable: nsquery1)
        if arryData.count == 0{
            activityView = UIActivityIndicatorView(style: .whiteLarge)
            activityView?.center = self.view.center
            activityView.color = UIColor.black
            
            
            self.view.addSubview(activityView)
            DispatchQueue.global(qos: .userInitiated).async {
                
                
                
                // return to the main thread
                DispatchQueue.main.async {
                    
                    // stop animating now that background task is finished
                    self.activityView?.startAnimating()
                    self.getRequestAPICall()
                }
            }
            
        }
    }
    // MARK: - UIButton Action
    @objc func btnViewBuyPress(){
        let alert = UIAlertController(title: "Products", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Most Viewed Products", style: .default , handler:{ (UIAlertAction)in
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ProductsVC") as! ProductsVC
            vc.strTitle = "Most Viewed Products"
            self.navigationController?.pushViewController(vc, animated: true)
           
        }))
        
        alert.addAction(UIAlertAction(title: "Most Ordered Products", style: .default , handler:{ (UIAlertAction)in
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ProductsVC") as! ProductsVC
            vc.strTitle = "Most OrdeRed Products"
            self.navigationController?.pushViewController(vc, animated: true)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Most Shared Products", style: .default , handler:{ (UIAlertAction)in
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ProductsVC") as! ProductsVC
            vc.strTitle = "Most ShaRed Products"
            self.navigationController?.pushViewController(vc, animated: true)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler:{ (UIAlertAction)in
            
        }))
        
        self.present(alert, animated: true, completion: {
            
        })
    }
    func getRequestAPICall()  {
        
        let todosEndpoint: String = "https://stark-spire-93433.herokuapp.com/json"
        
        Alamofire.request(todosEndpoint, method: .get, encoding: JSONEncoding.default)
            .responseJSON { response in
                debugPrint(response)
                
                if let data = response.result.value{
                    // Response
                    if  (data as? [String : AnyObject]) != nil{
                        
                        let dictResp = response.result.value as! NSDictionary
                        let arrcategory = dictResp.value(forKey: "categories") as! NSArray
                        let arrranking = dictResp.value(forKey: "rankings") as! NSArray
                        
//                        //save ranking data in database
                        for m in 0..<arrranking.count{
                            let dictRankingResult = arrranking[m] as! NSDictionary
                            let strRankName = dictRankingResult.value(forKey:  "ranking") as!  NSString
                             let arrRankproducts = dictRankingResult.value(forKey: "products") as! NSArray
                            if strRankName.isEqual(to: "Most Viewed Products")
                            {
                                for n in 0..<arrRankproducts.count
                                 {
                                    let dictRankproduct = arrRankproducts[n] as! NSDictionary
                                    let strRankId = dictRankproduct.value(forKey:  "id") as!  NSNumber
                                    let strRankCount = dictRankproduct.value(forKey:  "view_count") as!  NSNumber
                                    let strRankInsert = "INSERT INTO tbl_ranking (r_name,p_id,p_viewcount) values ('\(strRankName)','\(strRankId)','\(strRankCount)')"
                                    Database.share()?.insert(strRankInsert)
                                 }
                             }
                            if strRankName.isEqual(to: "Most OrdeRed Products")
                            {
                                for n in 0..<arrRankproducts.count
                                {
                                    let dictRankproduct = arrRankproducts[n] as! NSDictionary
                                    let strRankId = dictRankproduct.value(forKey:  "id") as!  NSNumber
                                    let strRankCount = dictRankproduct.value(forKey:  "order_count") as!  NSNumber
                                    let strRankInsert = "INSERT INTO tbl_ranking (r_name,p_id,p_viewcount) values ('\(strRankName)','\(strRankId)','\(strRankCount)')"
                                    Database.share()?.insert(strRankInsert)
                                }
                            }
                            if strRankName.isEqual(to: "Most ShaRed Products")
                            {
                                for n in 0..<arrRankproducts.count
                                {
                                    let dictRankproduct = arrRankproducts[n] as! NSDictionary
                                    let strRankId = dictRankproduct.value(forKey:  "id") as!  NSNumber
                                    let strRankCount = dictRankproduct.value(forKey:  "shares") as!  NSNumber
                                    let strRankInsert = "INSERT INTO tbl_ranking (r_name,p_id,p_viewcount) values ('\(strRankName)','\(strRankId)','\(strRankCount)')"
                                    Database.share()?.insert(strRankInsert)
                                }
                            }
                        }
                        //save data categories in database
                        for i in 0..<arrcategory.count{
                           
                            let dictCategoryResult = arrcategory[i] as! NSDictionary
                            let strCatName = dictCategoryResult.value(forKey:  "name") as!  NSString
                            let strCatId = dictCategoryResult.value(forKey:  "id") as!  NSNumber
                            
                            //insert categories in database
                            let strCatInsert = "INSERT INTO tbl_categories (c_id,c_name) values ('\(strCatId)','\(strCatName)')"
                            Database.share()?.insert(strCatInsert)
                            
                            //get product object
                            let arrproducts = dictCategoryResult.value(forKey: "products") as! NSArray
                            let arrChildCategories = dictCategoryResult.value(forKey: "child_categories") as! NSArray
                            
                            for j in 0..<arrChildCategories.count{
                               let strchildID = arrChildCategories[j] as! NSNumber
                                
                                //insert ChildCategories in database
                                let strChildCategoriesInsert = "INSERT INTO tbl_child (c_id,p_id) values ('\(strCatId)','\(strchildID)')"
                                Database.share()?.insert(strChildCategoriesInsert)
                            }
                            
                            for k in 0..<arrproducts.count{
                                
                                let dictProductResult = arrproducts[k] as! NSDictionary
                                
                                let strProName = dictProductResult.value(forKey:  "name") as!  NSString
                                let strProId = dictProductResult.value(forKey:  "id") as!  NSNumber
                                
                                //insert products in database
                                let strProInsert = "INSERT INTO tbl_product (c_id,p_id,p_name,p_date) values ('\(strCatId)','\(strProId)','\(strProName)','\(dictProductResult.value(forKey:  "date_added") as!  NSString)')"
                                Database.share()?.insert(strProInsert)
                                
                                //get tax object
                                let dictTaxResult = dictProductResult.value(forKey: "tax") as! NSDictionary
                                
                                //get varients object
                                let arrproductsvariants = dictProductResult.value(forKey: "variants") as! NSArray
                                for p in 0..<arrproductsvariants.count{
                                  let dictVariantResult = arrproductsvariants[p] as! NSDictionary
                                  let strVId = dictVariantResult.value(forKey: "id") as!  NSNumber
                                  let numsize = dictVariantResult.value(forKey: "size") as?  NSNumber ?? 0

                                   //Insert varients in database
                                    let strVariInsert = "INSERT INTO tbl_variants (c_id,p_id,v_id,v_color,v_size,v_price,v_taxname,v_taxvalue) values ('\(strCatId)','\(strProId)','\(strVId)','\(dictVariantResult.value(forKey: "color") as!  NSString)','\(numsize)','\(dictVariantResult.value(forKey: "price") as!  NSNumber)','\(dictTaxResult.value(forKey: "name") as!  NSString)','\(dictTaxResult.value(forKey: "value") as!  NSNumber)')"
                                  Database.share()?.insert(strVariInsert)
                                }
                            }
                        }
                      
                        DispatchQueue.global(qos: .userInitiated).async {
                            
                            //doSomethingThatTakesALongTime()
                            
                            // return to the main thread
                            DispatchQueue.main.async {
                                
                                // stop animating now that background task is finished
                                self.activityView.stopAnimating()
                            
                                self.checkdatafromdatabase()
                                self.colView.reloadData()
                            }
                        }
                    }
                
                }
        }
    }
    // MARK: - UICollectionview Delegate methode
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        return self.categorylists.count + 1
        return self.arryData.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:categoriesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoriesCell", for: indexPath as IndexPath) as! categoriesCell
        
        let dic = arryData[indexPath.row] as? NSDictionary
        cell.lbl_Cname?.text  = (dic?.value(forKey: "c_name") as! String)

        
        return cell
    }
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
       // Iphone 8
        return CGSize(width: 111, height: 114)
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        let dic = arryData[indexPath.row] as! NSDictionary
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ProductsVC") as! ProductsVC
        vc.strCID = dic.value(forKey: "c_id" ) as? NSString
        vc.strTitle=dic.value(forKey: "c_name")as? NSString
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

