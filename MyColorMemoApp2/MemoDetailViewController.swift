//
//  MemoDetailViewController.swift
//  MyColorMemoApp2
//
//  Created by 米谷裕輝 on 2021/11/25.
//

import Foundation
import UIKit

class MemoDetailViewController:UIViewController{
    @IBOutlet weak var textView: UITextView!
    var dateFormat:DateFormatter{
       let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        return dateFormatter
    }
    var text:String = ""
    var recordDate:Date = Date()
    override func viewDidLoad() {
        super.viewDidLoad()
        displayData()
        setDoneButton()
        print("detail")
    }
    
    func configure(memoDetailData:MemoDataModel){
        text = memoDetailData.text
        recordDate = memoDetailData.recordDate
    }
    
    func displayData(){
        textView.text = text
        navigationItem.title = dateFormat.string(from: recordDate)
    }
    //いつこのメソッドが呼び出されるか
    @objc func tapDoneButton(){
        view.endEditing(true)
    }
    //viewに配置
    func setDoneButton(){
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 30, width: 320, height: 40))
        let commitButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapDoneButton))
        toolBar.items = [commitButton]
        textView.inputAccessoryView = toolBar
    }
}
