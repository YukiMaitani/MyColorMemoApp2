//
//  MemoDetailViewController.swift
//  MyColorMemoApp2
//
//  Created by 米谷裕輝 on 2021/11/25.
//


import UIKit
import RealmSwift

class MemoDetailViewController:UIViewController{
    @IBOutlet weak var textView: UITextView!
    var dateFormat:DateFormatter{
       let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        return dateFormatter
    }
    // MemoDataModelをインスタンス化しているからmemoData
    var memoData = MemoDataModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        displayData()
        setDoneButton()
        textView.delegate = self
    }
    
    func configure(memoDetailData:MemoDataModel){
        memoData.text = memoDetailData.text
        memoData.recordDate = memoDetailData.recordDate
    }
    
    func displayData(){
        textView.text = memoData.text
        navigationItem.title = dateFormat.string(from: memoData.recordDate)
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
    
    func saveData(with text:String){
        let realm = try! Realm()
        try! realm.write {
            memoData.text = text
            memoData.recordDate = Date()
            realm.add(memoData)
        }
        print("text:\(memoData.text) recordData:\(memoData.recordDate)")
    }
}

extension MemoDetailViewController:UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        let updateText = textView.text ?? ""
        saveData(with:updateText)
    }
}
