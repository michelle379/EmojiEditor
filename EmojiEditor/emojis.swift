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
    

}

