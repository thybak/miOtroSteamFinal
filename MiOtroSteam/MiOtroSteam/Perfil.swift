//
//  Perfil.swift
//  MiOtroSteam
//
//  Created by Thybak on 04/05/2017.
//  Copyright © 2017 etsisi. All rights reserved.
//

import Foundation

class Perfil {
    var steamid: String = ""
    var personaname: String = ""
    var profileurl: String = ""
    var avatar: String = ""
    var avatarmedium: String = ""
    var avatarfull: String = ""
    var personastate: Int = -1
    var personastatestring: String = ""
    var communityvisibilitystate: Int = -1
    var profilestate: Int = -1
    var lastlogoff: Int64 = -1
    var lastlogoffdate: Date = Date.init()
    var commentpermission: Bool = false
    //0 - Offline, 1 - Online, 2 - Busy, 3 - Away, 4 - Snooze, 5 - looking to trade, 6 - looking to play.
    enum Estados: Int {
        case offline
        case online
        case busy
        case away
        case snooze
        case lookingToTrade
        case lookingToPlay
    }
    
    func setPersonaStateName() {
        let estado: Estados = Estados(rawValue: personastate)!
        switch estado {
        case .offline:
            personastatestring = "Desconectado"
        case .online:
            personastatestring = "En línea"
        case .busy:
            personastatestring = "Ocupado"
        case .away:
            personastatestring = "Ausente"
        case .snooze:
            personastatestring = "En hibernación"
        case .lookingToPlay:
            personastatestring = "Deseando jugar"
        case .lookingToTrade:
            personastatestring = "Deseando intercambiar objetos"
        }
    }
    
    func setLastLogOffDate(){
        self.lastlogoffdate = NSDate(timeIntervalSince1970: TimeInterval(self.lastlogoff)) as Date
    }
    
    init(claves: [String: AnyObject]){
        if let steamid = claves["steamid"] as? String{
            self.steamid = steamid
        }
        if let personaname = claves["personaname"] as? String {
            self.personaname = personaname
        }
        if let profileurl = claves["profileurl"] as? String{
            self.profileurl = profileurl
        }
        if let avatar = claves["avatar"] as? String {
            self.avatar = avatar
        }
        if let avatarmedium = claves["avatarmedium"] as? String {
            self.avatarmedium = avatarmedium
        }
        if let avatarfull = claves["avatarfull"] as? String {
            self.avatarfull = avatarfull
        }
        if let personastate = claves["personastate"] as? Int {
            self.personastate = personastate
            setPersonaStateName()
        }
        if let communityvisibilitystate = claves["communityvisibilitystate"] as? Int{
            self.communityvisibilitystate = communityvisibilitystate
        }
        if claves["profilestate"] != nil {
            self.profilestate = 1
        }
        if claves["lastlogoff"] != nil {
            self.lastlogoff = claves["lastlogoff"]! as! Int64
            setLastLogOffDate()
        }
        if claves["commentpermission"] != nil {
            self.commentpermission = true
        }
    }
}
