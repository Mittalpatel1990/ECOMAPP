//
//  ProductDetailsVC.swift
//  ECOMAPP
//
//  Created by Apple on 03/01/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ProductDetailsVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
   // MARK: - Variables Declarations
    @IBOutlet var imgVW: UIImageView?
    @IBOutlet var viewSize: UIView?
    @IBOutlet var viewColor: UIView?

    @IBOutlet var lblName : UILabel?
    @IBOutlet var lblPrice : UILabel?
    @IBOutlet var lblViewCount : UILabel?
    @IBOutlet var sizeColVW :UICollectionView?
    @IBOutlet var colorColVW :UICollectionView?
    
    var strCID : NSString!
    var strPName : NSString!
    var strPID : NSString!
   
    var arrySize: NSArray = []
    var arryColor :NSArray = []
   // var arrProductVarients: NSArray = []
    
   // MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = strPName! as String
        
        let nsquery1 = "SELECT * FROM tbl_variants where c_id= \(String(describing: strCID!)) and p_id =\(String(describing: strPID!))"
        let arrProductVarients = Database.share().selectAll(fromTable: nsquery1) as NSArray
        
        
        lblName?.text =  strPName! as String
        
        arryColor = self.noDuplicatesForColor(arrProductVarients as! [[String : String]]) as NSArray
        
        arrySize = self.noDuplicatesForSize(arrProductVarients as! [[String : String]]) as NSArray
        
        
        let nib1 = UINib(nibName: "sizecolorCell", bundle: nil)
        self.sizeColVW?.register(nib1, forCellWithReuseIdentifier:"sizecolorCell")
        self.colorColVW?.register(nib1, forCellWithReuseIdentifier:"sizecolorCell")

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let indexPathForFirstRow = IndexPath(row: 0, section: 0)
        
        if arrySize.count > 0{
            let dic = arrySize[0] as? NSDictionary
            let vsize  = dic?.value(forKey: "v_size") as! String
            if vsize != "0"
            {
                viewSize?.isHidden = false
                sizeColVW?.selectItem(at: indexPathForFirstRow, animated: false, scrollPosition: [])
                collectionView(sizeColVW!, didSelectItemAt: indexPathForFirstRow)
            }
        }
        
        if arryColor.count > 0{
            viewColor?.isHidden = false
            colorColVW?.selectItem(at: indexPathForFirstRow, animated: false, scrollPosition: [])
            collectionView(colorColVW!, didSelectItemAt: indexPathForFirstRow)
        }
        
    }
    //MARK: - Remove Duplication from array
    func noDuplicatesForColor(_ arrayOfDicts: [[String: String]]) -> [[String: String]] {
        var noDuplicates = [[String: String]]()
        var usedNames = [String]()
        for dict in arrayOfDicts {
            if let name = dict["v_color"], !usedNames.contains(name) {
                noDuplicates.append(dict)
                usedNames.append(name)
            }
        }
        return noDuplicates
    }
    
    func noDuplicatesForSize(_ arrayOfDicts: [[String: String]]) -> [[String: String]] {
        var noDuplicates = [[String: String]]()
        var usedNames = [String]()
        for dict in arrayOfDicts {
            if let name = dict["v_size"], !usedNames.contains(name) {
                noDuplicates.append(dict)
                usedNames.append(name)
            }
        }
        return noDuplicates
    }
    
    
    // MARK: - UICollectionView Delegate Methode
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        return self.categorylists.count + 1
        
        if collectionView == colorColVW{
            return arryColor.count
        }
        return arrySize.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:sizecolorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "sizecolorCell", for: indexPath as IndexPath) as! sizecolorCell
        
        if collectionView == colorColVW{
            let dic = arryColor[indexPath.row] as? NSDictionary
            cell.lbl_Color?.text  = (dic?.value(forKey: "v_color") as! String)
            
            if (cell.isSelected) {
                cell.layer.borderColor=UIColor.red.cgColor
                cell.layer.borderWidth=0.5
                //cell.backgroundColor = UIColor.red; // highlight selection
            }
            else
            {
                cell.layer.borderColor=UIColor.white.cgColor
                cell.layer.borderWidth=0.5
                //cell.backgroundColor = UIColor.white; // Default color
            }
            return cell
        }
        
        let dic = arrySize[indexPath.row] as? NSDictionary
        cell.lbl_Color?.text  = (dic?.value(forKey: "v_size") as! String)
        
        if (cell.isSelected) {
            cell.layer.borderColor=UIColor.red.cgColor
            cell.layer.borderWidth=0.5;
           // cell.backgroundColor = UIColor.red; // highlight selection
        }
        else
        {
            
            cell.layer.borderColor = UIColor.white.cgColor // Default color
            cell.layer.borderWidth=0.5
        }
        return cell
        
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Iphone 8
        return CGSize(width: 50, height: 40)
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        if collectionView == sizeColVW{
            
            let datasetCell: sizecolorCell? = sizeColVW?.cellForItem(at: indexPath) as? sizecolorCell
            datasetCell?.layer.borderColor = UIColor.red.cgColor
            datasetCell?.layer.borderWidth=0.5
       
            let dic = arrySize[indexPath.row] as? NSDictionary
            let strSize = dic?.value(forKey: "v_size") as! String
            let strPrice = dic?.value(forKey: "v_price") as! String
            lblPrice?.text = "Price - \(strPrice)"

            let nsquery1 = "SELECT * FROM tbl_variants where c_id=\(String(describing: strCID!)) and p_id =\(String(describing: strPID!)) and v_size = \(strSize)"
           

            arryColor = Database.share().selectAll(fromTable: nsquery1) as NSArray
            
            colorColVW?.reloadData()
            
            let indexPathForFirstRow = IndexPath(row: 0, section: 0)
            colorColVW?.selectItem(at: indexPathForFirstRow, animated: false, scrollPosition: [])
        }
        else{
        let datasetCell: sizecolorCell? = colorColVW?.cellForItem(at: indexPath) as? sizecolorCell
        datasetCell?.layer.borderColor = UIColor.red.cgColor
        datasetCell?.layer.borderWidth=0.5
        let dic = arryColor[indexPath.row] as? NSDictionary
        let strPrice = dic?.value(forKey: "v_price") as! String
        lblPrice?.text = "Price - \(strPrice)"
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let datasetCell: UICollectionViewCell? = collectionView.cellForItem(at: indexPath)
        datasetCell?.layer.borderColor = UIColor.white.cgColor // Default color
        datasetCell?.layer.borderWidth=0.5
    }

}
