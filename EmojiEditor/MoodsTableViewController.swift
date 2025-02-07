//
//  MoodsTableViewController.swift
//  EmojiEditor
//
//  Created by 王宜婕 on 2025/2/7.
//

import UIKit

class MoodsTableViewController: UITableViewController {
 
    var Emojis = [emoji](){
        didSet{
            emoji.saveData(Emojis)
        }
    }
    
    @IBAction func unwindToMood(_ unwindSegue: UIStoryboardSegue) {
        if let source = unwindSegue.source as? EmojiListTableViewController,
           let emojiList = source.EmojiList{
            print(emojiList)
            if let index = Emojis.firstIndex(where: { $0.mood == emojiList.mood }) {
                Emojis[index].contents = emojiList.contents
            }
         }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let loademoji = emoji.loadData() {
            self.Emojis = loademoji
        }
//        var fileURL = URL.documentsDirectory.appendingPathComponent("Emojis")
//        print(fileURL)
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Emojis.count
    }
//    //delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        Emojis.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)

    }
    

    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoodsTableViewCell", for: indexPath) as! MoodsTableViewCell
        cell.MoodLabel.text = Emojis[indexPath.row].mood

        // Configure the cell...

        return cell
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EmojiListTableViewController,
           let row = tableView.indexPathForSelectedRow?.row {
            let chooseMood = Emojis[row]
            destination.EmojiList = chooseMood
            destination.moodIndex = row 
        }
    }
    

    @IBAction func AddMood(_ sender: Any) {
        let alertController = UIAlertController(title: "Add Mood", message: "请输入新增情緒", preferredStyle: .alert)
        alertController.addTextField { textField in
           textField.placeholder = "情緒"
            textField.keyboardType = UIKeyboardType.default
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { [unowned alertController] _ in
            let newmood = alertController.textFields?[0].text?.trimmingCharacters(in: .whitespacesAndNewlines)
            if let newmood, !newmood.isEmpty {
                self.Emojis.append(emoji(mood: newmood, contents: []))
                self.tableView.reloadData()
            } else {
                let errorAlert = UIAlertController(title: "錯誤", message: "情緒名稱不能為空", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(errorAlert, animated: true)
            }
        }
        alertController.addAction(okAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
}
#Preview {
    UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
}

