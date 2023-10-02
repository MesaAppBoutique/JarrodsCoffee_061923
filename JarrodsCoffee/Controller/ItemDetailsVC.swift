//
//  MenuItemDetailViewController.swift
//  JarrodsMenuRev
//
//  Created by Jason Carter on 4/4/22.
//  Modified by David Levy on 8/7/23.

import UIKit

class DropdownCell: UITableViewCell {
    
}
    
class ItemDetailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MenuItem selected from MenuTableViewController
    
    let transparentView = UIView()
    
    let tableView = UITableView()
    
    var selectedButton = UIButton()
    
    var dataSource = [String]()
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var optionButton: UIButton!
    @IBOutlet weak var editItemButton: UIBarButtonItem!

    @IBOutlet weak var addToOrderButton1: UIButton!
    @IBOutlet weak var addToOrderButton2: UIButton!
    
    // bounce animation after addToOrder buttons pressed
    @IBAction func addToOrderButton1Tapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.addToOrderButton1.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        UIApplication.shared.open(NSURL(string:"https://www.grubhub.com/restaurant/jarrods-coffee-tea--gallery-154-w-main-st-mesa/393316")! as URL)
    }
    
    // bounce animation after addToOrder buttons pressed
    @IBAction func addToOrderButton2Tapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.addToOrderButton2.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        UIApplication.shared.open(NSURL(string:"https://www.seamless.com/menu/jarrods-coffee-tea--gallery-154-w-main-st-mesa/393316?utm_source=google&utm_medium=organic&utm_campaign=place-action-link&rwg_token=ADQ7psQKJP0bzQDOC0LmkTCJrS3tyD00iRFfISZwq23K5UWfwJ55tSuRgYh29TbVsObHmnTDaN1tmzNFYdjBLYweN-XbaCAsIA%3D%3D")! as URL)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DropdownCell.self, forCellReuseIdentifier: "Cell")
        //listenForChanges()
        updateDesign()

        populateOptionModelArray()
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        updateItem(item: AppData.shared.showItems[AppData.shared.selectedItemIndex])

        if AppData.shared.isAdminLoggedIn {
            self.editItemButton.isHidden = false
        } else {
            self.editItemButton.isHidden = true
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.optionModelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text =  self.dataSource[indexPath.row]
        
        return cell
    }
    
    var optionModelArray: [OptionModel] = [OptionModel]()
    
    // update the screen with menuItem values
    func updateDesign() {
        optionButton.layer.cornerRadius = 5
        addToOrderButton1.layer.cornerRadius = 5
        addToOrderButton2.layer.cornerRadius = 5
    }
    
    func populateOptionModelArray(){
        let optionModel = OptionModel(sizeOption: AppData.shared.showItems[AppData.shared.selectedItemIndex].size, priceOption: AppData.shared.showItems[AppData.shared.selectedItemIndex].price)
        self.optionModelArray.append(optionModel)
    }
    
    func addTransparentView(frames: CGRect) {
        let window = UIApplication.shared.keyWindow
        transparentView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparentView)
        
        tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        self.view.addSubview(tableView)
        tableView.layer.cornerRadius = 5
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        tableView.reloadData()
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapgesture)
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: CGFloat(self.dataSource.count * 50))
        }, completion: nil)
    }
    
    @objc func removeTransparentView() {
        let frames = selectedButton.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        }, completion: nil)
    }
    
    @IBAction func optionButton(_ sender: Any) {
        dataSource = AppData.shared.showItems[AppData.shared.selectedItemIndex].size
        populateOptionModelArray()
        selectedButton = optionButton
        addTransparentView(frames: optionButton.frame)
    }
    
    @IBAction func editButton (_ sender: Any) {
        print("EDIT!")
        
        //AppData.shared.selectedCategory
        
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedButton.setTitle(String(format: "%.2f", AppData.shared.showItems[AppData.shared.selectedItemIndex].price[indexPath.row]), for: .normal)
        removeTransparentView()
    }
    
    
    func listenForChanges() {
        let collectionRef = AppData.shared.db.collection("menuItems")
        collectionRef.addSnapshotListener { [weak self] snapshot, error in
            
            guard let changes = snapshot?.documentChanges(includeMetadataChanges: false), error == nil else { return }
            
            guard let data = snapshot?.documentChanges.first?.document.data(with: .none) else { return }
            
            let item = AppData.shared.itemFrom(data: data)
  
            guard let item = item else { return }
            
            self?.updateItem(item: item)
            
            print("\(changes.count) changes happened in ItemDetailsVC!")
        }
    }
    
    func updateItem (item:MenuItem) {
        DispatchQueue.main.async {
            
            
            self.titleLabel.text = AppData.shared.showItems[AppData.shared.selectedItemIndex].name
            
            self.imageView.image = AppData.shared.showItems[AppData.shared.selectedItemIndex].image
            
        }
    }
    
    /// Passes MenuItem to MenuItemDetailViewController before the segue
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // checks this segue is from MenuTableViewController to MenuItemDetailViewController
//        if segue.identifier == "editItem" {
//            // we can safely downcast to MenuItemDetailViewController
//            let editCtrl = segue.destination as! EditItemVC
//
//            print("PREPARE! \(menuItem.id):\(menuItem.name)")
//            // selected cell's row is the index for array of menuItems
//            let index = tableView.indexPathForSelectedRow!.row
//
//            // pass selected menuItem to destination MenuItemDetailViewController
//            AppData.shared.selectedItem = menuItem
//        }
//    }
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
