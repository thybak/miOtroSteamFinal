//
//  Logro.swift
//  MiOtroSteam
//
//  Created by XCode on 11/5/17.
//  Copyright © 2017 etsisi. All rights reserved.
//

import Foundation

class Logro {
    var codigo: String = ""
    var conseguido: Bool = false
    var nombre: String = ""
    var descripcion: String = ""
    
    init(logro: [String: AnyObject]){
        if let codigo = logro["apiname"] as? String{
            self.codigo = codigo
        }
        if let conseguido = logro["achieved"] as? Int{
            self.conseguido = (conseguido == 1)
        }
        if let nombre = logro["name"] as? String {
            self.nombre = nombre
        }
        if let descripcion = logro["description"] as? String{
            self.descripcion = descripcion
        }
    }
    
}
