//
//  Game.swift
//  MiOtroSteam
//
//  Created by PC on 12/5/17.
//  Copyright © 2017 etsisi. All rights reserved.
//

import Foundation

class Game {
    var appId: Int = 0
    var name: String = ""
    var playTimeForever: Int = 0
    let urlLogo = "http://media.steampowered.com/steamcommunity/public/images/apps/{appid}/{hash}.jpg"
    var imgIconHash: String = ""
    var imgLogoHash: String = ""
    var imgIconUrl: String = ""
    var imgLogoUrl: String = ""
    
    init(claves: [String: AnyObject]){
        if claves["name"] != nil {
            self.name = claves["name"]! as! String
        }
        if let appId = claves["appid"] as? Int {
            self.appId = appId
        }
        if let playTimeForever = claves["playtime_forever"] as? Int {
            self.playTimeForever = playTimeForever
        }
        if claves["img_icon_url"] != nil {
            self.imgIconHash = claves["img_icon_url"]! as! String
            self.imgIconUrl = self.establecerUrlImagen(hash: self.imgIconHash, fromAppId: self.appId)
        }
        if claves["img_logo_url"] != nil {
            self.imgLogoHash = claves["img_logo_url"]! as! String
            self.imgLogoUrl = self.establecerUrlImagen(hash: self.imgLogoHash, fromAppId: self.appId)
        }
    }
    
    func establecerUrlImagen(hash: String, fromAppId: Int) -> String {
        var url = urlLogo.replacingOccurrences(of: "{appid}", with: String(fromAppId))
        url = url.replacingOccurrences(of: "{hash}", with: hash)
        return url
    }
}



