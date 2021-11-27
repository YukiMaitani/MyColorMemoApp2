//
//  HomeViewController.swift
//  MyColorMemoApp2
//
//  Created by 米谷裕輝 on 2021/11/25.
//

import Foundation
import UIKit
import RealmSwift

class HomeViewController:UIViewController{
    @IBOutlet weak var tableView: UITableView!
    var memoDataList:[MemoDataModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setNavigationBarButton()
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
}
