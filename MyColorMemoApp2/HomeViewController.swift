//
//  HomeViewController.swift
//  MyColorMemoApp2
//
//  Created by 米谷裕輝 on 2021/11/25.
//

import Foundation
import UIKit

class HomeViewController:UIViewController{
    @IBOutlet weak var tableView: UITableView!
    var memoDataList:[MemoDataModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setMemoData()
        
    }
    
    func setMemoData(){
        for i in 1...5{
            let memoDataModel = MemoDataModel(text: "\(i)番目のセル", recordDate: Date())
            memoDataList.append(memoDataModel)
        }
    }
}

extension HomeViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoDataList.count
    }
    
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
    }
}
