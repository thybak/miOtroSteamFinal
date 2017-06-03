//
//  FriendsController.swift
//  MiOtroSteam
//
//  Created by XCode on 9/5/17.
//  Copyright © 2017 etsisi. All rights reserved.
//

import UIKit

class FriendsTableCell : UITableViewCell {
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblNombre: UILabel!
    @IBOutlet var lblEstado: UILabel!
    @IBOutlet var btnPerfil: UIButton!
    @IBOutlet var imgEstado: UIImageView!
    var steamid: String = ""
    
    func setTableCell(perfil: Perfil){ //En esta función se configuran los elementos de las celdas

        let url = URL(string: perfil.avatarmedium)
        if url != nil {
            APIHelper.setImagenDesdeUrl(url: url!, updateUI: {(image) in self.imgProfile.image = image})
        }
        self.steamid = perfil.steamid
        lblNombre.text = perfil.personaname
        lblEstado.text = perfil.personastatestring
        if (perfil.personastate == Perfil.Estados.online.rawValue || perfil.personastate == Perfil.Estados.lookingToPlay.rawValue || perfil.personastate == Perfil.Estados.lookingToTrade.rawValue){
            imgEstado.image = #imageLiteral(resourceName: "online")
        } else if (perfil.personastate == Perfil.Estados.offline.rawValue){
            imgEstado.image = #imageLiteral(resourceName: "offline")
        } else {
            imgEstado.image = #imageLiteral(resourceName: "away")
        }
    }
    
    @IBAction
    func establecerPerfil(){
        UserDefaults.standard.set(self.steamid, forKey: APIHelper.UD_STID)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imgProfile.image = nil
        lblNombre.text = nil
        lblEstado.text = nil
    }
}

class FriendsController: UITableViewController, UISearchBarDelegate {
    
    var amigos: [Perfil] = []
    var amigosFiltrados: [Perfil] = []
    var isSearching = false
    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet var searchBar: UISearchBar!
    
    func cargarAmigos(){
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        if let stidAmigos = UserDefaults.standard.array(forKey: APIHelper.UD_STLA)! as? [String] {
            var idx = 0
            for amigo in stidAmigos {
                APIHelper.getPerfilUsuario(steamId: amigo, updateUI: {(perfil) in
                    self.amigos.append(perfil)
                    idx += 1
                    if idx == stidAmigos.count {
                        self.amigos.sort(by: {$0.personaname.lowercased() < $1.personaname.lowercased()})
                        self.tableView.reloadData()
                        self.activityIndicator.stopAnimating()
                    }
                })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        cargarAmigos()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return amigosFiltrados.count
        }
        return amigos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuse", for: indexPath) as! FriendsTableCell
        if isSearching {
            cell.setTableCell(perfil: amigosFiltrados[indexPath.row])
        } else {
            cell.setTableCell(perfil: amigos[indexPath.row])
        }
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text == nil || searchText == ""){
            isSearching = false
        } else {
            amigosFiltrados = amigos.filter({$0.personaname.lowercased().contains(searchText.lowercased())})
            isSearching = true
        }
        tableView.reloadData()
    }
}
