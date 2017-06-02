//
//  ProfileController.swift
//  MiOtroSteam
//
//  Created by XCode on 4/5/17.
//  Copyright © 2017 etsisi. All rights reserved.
//

import UIKit

class ProfileController : UIViewController {
    var perfil: Perfil?
    @IBOutlet var btnGames: UIButton!
    @IBOutlet var btnFriends: UIButton!
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var welcomeLbl: UILabel!
    @IBOutlet var btnFullProfile: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let steamID = UserDefaults.standard.string(forKey: APIHelper.UD_STID)
        if steamID != nil { //Si el steamId no es nulo, se procede a recoger los datos del usuario
            APIHelper.getPerfilUsuario(steamId: steamID!, updateUI: { (Perfil) in
                self.perfil = Perfil
                if self.perfil?.personaname != "" {
                    self.btnFullProfile.isEnabled = true
                    self.welcomeLbl.text = self.welcomeLbl.text! + self.perfil!.personaname
                    let url = URL(string: self.perfil!.avatarfull)
                    if url != nil {
                        APIHelper.setImagenDesdeUrl(url: url!, updateUI: {(image) in self.profileImg.image = image})
                    }
                    if self.perfil?.communityvisibilitystate != 3 {
                        let alert = UIAlertController(title: "Perfil privado", message: "Desafortunadamente, este usuario tiene establecido su perfil como privado. No se podrá ver su listado de amigos, ni de juegos ni de logros",
                                                      preferredStyle: UIAlertControllerStyle.alert)
                        let cancel = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,
                                                   handler: nil)
                        alert.addAction(cancel)
                        self.present(alert, animated: true, completion: nil)
                        self.btnGames.isEnabled = false
                    } else {
                        APIHelper.getListaAmigos(steamId: steamID!, updateUI: {self.checkListaAmigos()})
                        self.btnGames.isEnabled = true
                    }
                } else {
                    let alert = UIAlertController(title: "No existe el usuario", message: "No existe ningún usuario asociado al identificador que has facilitado",
                                                  preferredStyle: UIAlertControllerStyle.alert)
                    let cancel = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,
                                               handler: nil)
                    alert.addAction(cancel)
                    self.present(alert, animated: true, completion: nil)
                    self.btnGames.isEnabled = false
                }
            })
            
        }
        
    }
    
    func checkLista(key: String) -> Bool {
        let array = UserDefaults.standard.array(forKey: key)
        return array != nil && (array!.count > 0)
    }
    
    func checkListaAmigos() {
        self.btnFriends.isEnabled = checkLista(key: APIHelper.UD_STLA)
    }
}
