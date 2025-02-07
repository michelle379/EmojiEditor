//
//  EmojiListTableViewController.swift
//  EmojiEditor
//
//  Created by 王宜婕 on 2025/2/7.
//

import UIKit

class EmojiListTableViewController: UITableViewController {
    
    var EmojiList:emoji! {
        didSet{
            emoji.updateContents(EmojiList)
        }
    }
    
    
    
    var moodIndex: Int! // 存放該 mood 在 Emojis 陣列中的索引

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = EmojiList.mood
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func unwindToList(_ unwindSegue: UIStoryboardSegue) {
        if unwindSegue.identifier == "Done", // 檢查是否是從 Done 的 segue 返回
               let source = unwindSegue.source as? EmojiEditTableViewController,
                let emojitext = source.chooseemoji {
                //若有點選的cell
                if let selectedIndexPath = selectedIndexPath {
                    EmojiList.contents[selectedIndexPath.row] = emojitext
                    //更新TableView
                    tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
                }else{
                    // 新增資料
                    EmojiList.contents.insert(emojitext, at: 0)
                    let indexPath = IndexPath(row: 0, section: 0)
                    //新增TableView
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    

                }
//            // 更新 TableView
//            tableView.reloadData()
            // **通知 MoodsTableViewController 更新 Emojis**

            }
        
        //Lover.saveLovers(Lovers)//改寫在didSet
        // Use data from the view controller which initiated the unwind segue

    }
    
    //delete
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        EmojiList.contents.remove(at: indexPath.row)
//        tableView.deleteRows(at: [indexPath], with: .automatic)
//        print(EmojiList.contents)
//    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return EmojiList.contents.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmojiListTableViewCell", for: indexPath) as! EmojiListTableViewCell
        cell.emojiLabel.text = EmojiList.contents[indexPath.row]
        
        
        return cell
    }
    var selectedIndexPath: IndexPath? // 用來存當前點擊的 indexPath
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // 🔵 建立 Edit 動作
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler) in
            self.selectedIndexPath = indexPath // 存儲當前點擊的 indexPath
            self.performSegue(withIdentifier: "Edit", sender: nil) // 觸發 Segue
            completionHandler(true) // 告知系統動作已完成
        }
        editAction.backgroundColor =   .gray // 設定顏色
        
        // 🔴 建立 Delete 動作
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            self.EmojiList.contents.remove(at: indexPath.row) // 刪除該行資料
            tableView.deleteRows(at: [indexPath], with: .automatic) // 更新 TableView
            completionHandler(true) // 告知系統動作已完成
        }
        
        // 🔥 加入 Edit 和 Delete 兩個按鈕
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    // MARK: - 點擊 Cell 複製文字
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let textToCopy = EmojiList.contents[indexPath.row]  // 取得對應的文字
        UIPasteboard.general.string = textToCopy  // 複製到剪貼簿
        
        // 顯示提示
        let alert = UIAlertController(title: "已複製", message: "文字：\(textToCopy)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確定", style: .default))
        present(alert, animated: true)
        
        // 取消選取動畫
        tableView.deselectRow(at: indexPath, animated: true)
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Edit",
            let navigationController = segue.destination as? UINavigationController,
           let destionation = navigationController.topViewController as? EmojiEditTableViewController,
           let row = selectedIndexPath {
            destionation.chooseemoji = EmojiList.contents[row.row]
        }
        let mood = EmojiList.mood
        let contents = EmojiList.contents
        EmojiList = emoji(mood: mood, contents: contents)
    }
    
    
    

    
}
