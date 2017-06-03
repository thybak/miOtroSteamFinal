//
//  GamesController.swift
//  MiOtroSteam
//
//  Created by PC on 12/5/17.
//  Copyright © 2017 etsisi. All rights reserved.
//

import UIKit

class GamesTableCell : UITableViewCell {
    @IBOutlet var lblNombreGame: UILabel!
    @IBOutlet var imgGame: UIImageView!
    @IBOutlet var lblTiempoJugado: UILabel!
    var appId: Int = 0
    
    func setTableCell(game: Game){ //En esta función se configuran los elementos de las celdas
        lblNombreGame.text = game.name
        let url = URL(string: game.imgLogoUrl)
        if url != nil {
            APIHelper.setImagenDesdeUrl(url: url!, updateUI: {(image) in self.imgGame.image = image})
        }
        lblTiempoJugado.text = String(game.playTimeForever/60) + " horas jugadas"
        self.appId = game.appId
    }
    
    @IBAction
    func setAppId() {
        UserDefaults.standard.setValue(self.appId, forKey: APIHelper.UD_APID)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        lblNombreGame.text = nil
        imgGame.image = nil
        lblTiempoJugado.text = nil
    }
}

class GamesController: UITableViewController {
    
    var games: [Game] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let steamId = UserDefaults.standard.string(forKey: APIHelper.UD_STID)
        if steamId != nil {
            APIHelper.getListaJuegos(steamId: steamId!, updateUI: {(games) in
                self.games = games
                if self.games.count == 0 {
                    let alert = UIAlertController(title: "No hay juegos", message: "No existen juegos para este usuario",
                                                  preferredStyle: UIAlertControllerStyle.alert)
                    let cancel = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,
                                               handler: nil)
                    alert.addAction(cancel)
                    self.present(alert, animated: true, completion: nil)
                }
                self.tableView.reloadData()
            })
        } else {
            print("NULO")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseGame", for: indexPath) as! GamesTableCell
        cell.setTableCell(game: games[indexPath.row])
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}
