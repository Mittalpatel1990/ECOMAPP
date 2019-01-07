//
//  ProductsVC.swift
//  ECOMAPP
//
//  Created by Apple on 03/01/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ProductsVC: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
   // MARK: - variables declarations
    @IBOutlet var collview:UICollectionView!
    var strCID : NSString!
    var strTitle : NSString!
    var arrProducts : NSArray = []
    //var arrPRanking : NSArray = []
    
    // MARK: - view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = strTitle! as String
        
        if strTitle .isEqual(to: "Most Viewed Products") || strTitle .isEqual(to: "Most OrdeRed Products") || strTitle .isEqual(to: "Most ShaRed Products")
        {
            let nsquery1 = "SELECT * FROM tbl_ranking WHERE r_name = '\(String(describing: strTitle!))'"
            let arrPRanking = Database.share().selectAll(fromTable: nsquery1) as! NSArray
             print(arrPRanking)
             var strProductID = ""
             for mn in 0..<arrPRanking.count{
                let dictResult = arrPRanking[mn] as! NSDictionary
                let strid = dictResult.value(forKey:  "p_id") as!  NSString
                strProductID.append(strid as String)
                strProductID.append(",")
            }
            
            print("strProductID : \(strProductID.removeLast())")

            let strProductRanking = "SELECT * FROM tbl_product WHERE p_id IN (\(strProductID))"
            
            arrProducts = Database.share().selectAll(fromTable:strProductRanking)
           
        }
        else
        {
            let nsquery1 = "SELECT * FROM tbl_product where c_id= \(String(describing: strCID!))"
            

            arrProducts = Database.share().selectAll(fromTable: nsquery1)
            print(arrProducts)
        
            if arrProducts.count == 0{
               let nsquery1 = "SELECT * FROM tbl_child where c_id= \(String(describing: strCID!))"
                
            

                let  arrCProducts = Database.share().selectAll(fromTable: nsquery1) as NSArray
                
            
                var strProductID = ""
                for mn in 0..<arrCProducts.count{
                   let dictResult = arrCProducts[mn] as! NSDictionary
                   let strid = dictResult.value(forKey:  "p_id") as!  NSString
                   strProductID.append(strid as String)
                   strProductID.append(",")
                }
                print("strProductID : \(strProductID.removeLast())")
            
                let strChildCategoriesSelect = "SELECT * FROM tbl_product WHERE p_id IN (\(strProductID))"
                arrProducts = Database.share().selectAll(fromTable:strChildCategoriesSelect)

           }
        }
        let nib1 = UINib(nibName: "categoriesCell", bundle: nil)
        self.collview?.register(nib1, forCellWithReuseIdentifier:"categoriesCell")
        self.collview?.allowsSelection = true
        self.collview.allowsMultipleSelection = false
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - UICollectionView Delegate Methode
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        return self.categorylists.count + 1
        return arrProducts.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:categoriesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoriesCell", for: indexPath as IndexPath) as! categoriesCell
        
        let dic = arrProducts[indexPath.row] as? NSDictionary
        cell.lbl_Cname?.text  = (dic?.value(forKey: "p_name") as! String)
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
       
        let dic = arrProducts[indexPath.row] as? NSDictionary
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
        vc.strCID = dic?.value(forKey: "c_id" ) as? NSString
        vc.strPID = dic?.value(forKey: "p_id" ) as? NSString
        vc.strPName = dic?.value(forKey: "p_name" ) as? NSString
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}
