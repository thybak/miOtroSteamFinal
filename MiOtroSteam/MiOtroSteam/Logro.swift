//
//  Logro.swift
//  MiOtroSteam
//
//  Created by XCode on 11/5/17.
//  Copyright © 2017 etsisi. All rights reserved.
//

import Foundation

class Logro {
    var codigo: String
    var conseguido: Bool
    var nombre: String
    var descripcion: String
    
    init(logro: [String: AnyObject]){
        self.codigo = logro["apiname"]! as! String
        self.conseguido = logro["achieved"]! as! Int == 1
        self.nombre = logro["name"]! as! String
        self.descripcion = logro["description"]! as! String
    }
    
}
