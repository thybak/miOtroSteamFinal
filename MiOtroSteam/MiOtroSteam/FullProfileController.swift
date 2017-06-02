//
//  FullProfileController.swift
//  MiOtroSteam
//
//  Created by XCode on 9/5/17.
//  Copyright © 2017 etsisi. All rights reserved.
//

import UIKit

class FullProfileController: UIViewController {
    var perfil: Perfil?
    @IBOutlet var lblNombre: UILabel!
    @IBOutlet var lblURL: UILabel!
    @IBOutlet var lblUltimoInicioSesion: UILabel!
    @IBOutlet var lblNumeroAmigos: UILabel!
    @IBOutlet var lblEstado: UILabel!
    @IBOutlet var imgProfile: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let steamID = UserDefaults.standard.string(forKey: APIHelper.UD_STID)
        if steamID != nil { //Si el steamId no es nulo, se procede a recoger los datos del usuario
            APIHelper.getPerfilUsuario(steamId: steamID!, updateUI: { (Perfil) in
                self.perfil = Perfil
                if self.perfil != nil {
                    self.lblNombre.text = self.perfil!.personaname
                    let url = URL(string: self.perfil!.avatarfull)
                    if url != nil {
                        APIHelper.setImagenDesdeUrl(url: url!, updateUI: {(image) in self.imgProfile.image = image})
                    }
                    self.lblURL.text = self.perfil!.profileurl
                    let formatoFecha = DateFormatter()
                    formatoFecha.dateFormat = "dd/MM/YYYY hh:mm a"
                    let fechaString = formatoFecha.string(from: self.perfil!.lastlogoffdate)
                    self.lblUltimoInicioSesion.text = "Último inicio de sesión: " + String(fechaString)
                    self.lblEstado.text = "Estado: " + self.perfil!.personastatestring
                    let numAmigos = UserDefaults.standard.array(forKey: APIHelper.UD_STLA)!.count
                    self.lblNumeroAmigos.text = self.lblNumeroAmigos.text?.replacingOccurrences(of: "{0}", with: String(numAmigos))
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
