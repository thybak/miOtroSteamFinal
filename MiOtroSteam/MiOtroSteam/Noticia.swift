//
//  Noticia.swift
//  MiOtroSteam
//
//  Created by Thybak on 03/06/2017.
//  Copyright © 2017 etsisi. All rights reserved.
//

import Foundation

class Noticia {
    var title: String = ""
    var url: String = ""
    var author: String = ""
    var contents: String = ""
    var date: Int64 = -1
    var fulldate: Date = Date.init()
    
    func setFullDate(){
        self.fulldate = NSDate(timeIntervalSince1970: TimeInterval(self.date)) as Date
    }
    
    init(claves: [String: AnyObject]){
        if let title = claves["title"] as? String{
            self.title = title
        }
        if let url = claves["url"] as? String {
            self.url = url
        }
        if let author = claves["author"] as? String {
            self.author = author
        }
        if let contents = claves["contents"] as? String {
            self.contents = contents
        }
        if claves["date"] != nil {
            self.date = claves["date"] as! Int64
            setFullDate()
        }
    }
}
