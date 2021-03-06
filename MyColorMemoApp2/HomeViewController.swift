//
//  HomeViewController.swift
//  MyColorMemoApp2
//
//  Created by 米谷裕輝 on 2021/11/25.
//

import Foundation
import UIKit
import RealmSwift
import CoreData

class HomeViewController:UIViewController{
    @IBOutlet weak var tableView: UITableView!
    var memoDataList:[MemoDataModel] = []
    let themeColoTypeKey = "themeColoTyperKey"
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setNavigationBarButton()
        setNavigationBarLeftButton()
        let themeColorTypeInt = UserDefaults.standard.integer(forKey: themeColoTypeKey)
        let themeColorType:MyColorType = MyColorType(rawValue: themeColorTypeInt) ?? .default
        setThemeColor(type: themeColorType)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setMemoData()
        tableView.reloadData()
    }
    
    func setMemoData(){
       let realm = try! Realm()
       let result = realm.objects(MemoDataModel.self)
       memoDataList = Array(result)
    }
    
    @objc func tapAddButton(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let memoDetailViewController = storyboard.instantiateViewController(identifier: "MemoDetailViewController") as! MemoDetailViewController
        navigationController?.pushViewController(memoDetailViewController, animated: true)
    }
    
    func setNavigationBarButton(){
        let buttonActionSelecter:Selector = #selector(tapAddButton)
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: buttonActionSelecter)
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func setNavigationBarLeftButton(){
        let buttonActionSelecter:Selector = #selector(didTapSettingColorButton)
        let leftButtonImage = UIImage(named: "colorSettingIcon")
        let leftBarButton = UIBarButtonItem(image: leftButtonImage, style: .plain, target: self, action: buttonActionSelecter)
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @objc func didTapSettingColorButton(){
        let defaultAction = UIAlertAction(title: "デフォルト", style: .default, handler:{_ -> Void in self.setThemeColor(type: .default)})
        let orangeAction = UIAlertAction(title: "オレンジ", style: .default, handler:{_ -> Void in self.setThemeColor(type: .orange)})
        let redAction = UIAlertAction(title: "レッド", style: .default, handler:{_ -> Void in self.setThemeColor(type: .red)})
        let blueAction = UIAlertAction(title: "ブルー", style: .default, handler:{_ -> Void in self.setThemeColor(type: .blue)})
        let pinkAction = UIAlertAction(title: "ピンク", style: .default, handler:{_ -> Void in self.setThemeColor(type: .pink)})
        let greenAction = UIAlertAction(title: "グリーン", style: .default, handler:{_ -> Void in self.setThemeColor(type: .green)})
        let purpleAction = UIAlertAction(title: "パープル", style: .default, handler:{_ -> Void in self.setThemeColor(type: .purple)})
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler:nil)
        let alert = UIAlertController(title: "テーマカラーを選択してください", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(defaultAction)
        alert.addAction(orangeAction)
        alert.addAction(redAction)
        alert.addAction(blueAction)
        alert.addAction(pinkAction)
        alert.addAction(greenAction)
        alert.addAction(purpleAction)
        alert.addAction(cancelAction)
        
        present(alert,animated: true)   
    }
    
    func setThemeColor(type:MyColorType){
        let appearance = UINavigationBarAppearance()
        let isDefault = type == .default
        let tintColor:UIColor = isDefault ? .black : .white
        navigationController?.navigationBar.tintColor = tintColor
        appearance.backgroundColor = type.color
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:tintColor]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationItem.compactAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        saveThemeColor(type: type)
    }
    
    func saveThemeColor(type:MyColorType){
        UserDefaults.standard.setValue(type.rawValue, forKey: themeColoTypeKey)
    }
}

extension HomeViewController:UITableViewDataSource{
    //セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoDataList.count
    }
    //セルの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let memoDataModel:MemoDataModel = memoDataList[indexPath.row]
        cell.textLabel?.text = memoDataModel.text
        cell.detailTextLabel?.text = "\(memoDataModel.recordDate)"
        return cell
    }
}

extension HomeViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let memoDetailViewController = storyboard.instantiateViewController(identifier: "MemoDetailViewController") as! MemoDetailViewController
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(memoDetailViewController, animated: true)
        var memoData = memoDataList[indexPath.row]
        memoDetailViewController.configure(memoDetailData: memoData)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let target = memoDataList[indexPath.row]
        let realm = try! Realm()
        try! realm.write{
            realm.delete(target)
        }
        memoDataList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
