//
//  AchievementsController.swift
//  MiOtroSteam
//
//  Created by XCode on 11/5/17.
//  Copyright © 2017 etsisi. All rights reserved.
//

import UIKit

class AchievementCell : UITableViewCell {
    @IBOutlet var imgLogro: UIImageView!
    @IBOutlet var lblNombre: UILabel!
    @IBOutlet var lblDescripcion: UILabel!
    @IBOutlet var lblConseguido: UILabel!
    
    func setTableCell(logro: Logro){ //En esta función se configuran los elementos de las celdas

        lblNombre.text = logro.nombre
        lblDescripcion.text = logro.descripcion
        lblConseguido.text = logro.conseguido ? "Logro conseguido" : "Logro por conseguir"
        if (logro.conseguido){
            imgLogro.image = #imageLiteral(resourceName: "trophy_filled")
        } else {
            imgLogro.image = #imageLiteral(resourceName: "trophy_empty")
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imgLogro.image = nil
        lblNombre.text = nil
        lblDescripcion.text = nil
        lblConseguido.text = nil
    }
}

class AchievementsController: UITableViewController {
    
    var steamId: String?
    var appId: Int?
    var logros: [Logro] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        steamId = UserDefaults.standard.string(forKey: APIHelper.UD_STID)!
        let appActual = UserDefaults.standard.integer(forKey: APIHelper.UD_APID)
        self.appId = appActual
        APIHelper.getListaLogros(steamId: steamId!, appId: appId!, updateUI: { (logros) in
            self.logros = logros
            if self.logros.count == 0 {
                let alert = UIAlertController(title: "No hay logros", message: "No existen logros para este juego",
                                              preferredStyle: UIAlertControllerStyle.alert)
                let cancel = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,
                                           handler: nil)
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
            }
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logros.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuse", for: indexPath) as! AchievementCell
        if logros.count > 0 {
            cell.setTableCell(logro: logros[indexPath.row])
        }
        return cell
    }

}
