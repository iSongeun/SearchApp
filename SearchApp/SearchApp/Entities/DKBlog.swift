//
//  DKBlog.swift
//  SearchApp
//
//  Created by 이송은 on 2022/12/01.
//

import Foundation

struct DKBlog : Decodable {
    let documents : [DKDocument]
}

struct DKDocument : Decodable {
    let title : String?
    let name : String?
    let thumbnail : String?
    let datetime : Date?
    
    enum CodingKeys : String, CodingKey {
        case title, thumbnail, datetime
        case name = "blogname"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try? values.decode(String?.self, forKey: .title)
        self.name = try? values.decode(String?.self, forKey: .name)
        self.thumbnail = try? values.decode(String?.self, forKey: .thumbnail)
        self.datetime = Date.parse(values, key: .datetime)
    }
}
extension Date {
    static func parse<K:CodingKey>( _ values : KeyedDecodingContainer<K>, key : K) -> Date? {
        guard let dateString = try? values.decode(String.self, forKey: key),
              let date = from(dateString : dateString) else{
            return nil
        }
        return date
    }
    
    static func from(dateString : String) -> Date? {
        let dateFormmater = DateFormatter()
        
        dateFormmater.dateFormat = "yyyy=MM-dd'T'HH:mm:ss.SSSXXXXX"
        dateFormmater.locale = Locale(identifier: "ko_kr")
        if let date = dateFormmater.date(from: dateString){
            return date
        }
        return nil
    }
}
