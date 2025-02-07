//
//  emojis.swift
//  EmojiEditor
//
//  Created by 王宜婕 on 2025/2/7.
//

import Foundation

struct emoji: Codable {
    var mood: String
    var contents: [String]
    
    /// 檔案存放路徑
    static let fileURL = URL.documentsDirectory.appendingPathComponent("Emojis")
    
    /// 儲存 Emoji 資料
    static func saveData(_ EmojiData: [emoji]) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(EmojiData) else {return}
        try?data.write(to: fileURL)
    }
    
    /// 讀取儲存的 Emoji 資料
    static func loadData() -> [emoji]? {
        guard let data = try? Data(contentsOf: fileURL) else {return nil}
        let decoder = JSONDecoder()
        return try? decoder.decode([emoji].self, from: data)
    }
    
    static func updateContents(_ EmojiContents:emoji){
        // 讀取現有的 Emoji 資料
        guard var storedEmojis = emoji.loadData() else { return }

        // 找到要更新的 mood
        if let index = storedEmojis.firstIndex(where: { $0.mood == EmojiContents.mood }) {
            storedEmojis[index].contents = EmojiContents.contents  // 更新內容
        }

        // 儲存更新後的資料
        emoji.saveData(storedEmojis)
        
        
    }
    

}

