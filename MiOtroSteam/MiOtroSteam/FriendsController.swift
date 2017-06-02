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
    
    func setTableCell(perfil: Perfil){ //En esta función se configuran los elementos de las celdas

        let url = URL(string: perfil.avatarmedium)
        if url != nil {
            APIHelper.setImagenDesdeUrl(url: url!, updateUI: {(image) in self.imgProfile.image = image})
        }
        lblNombre.text = perfil.personaname
        lblEstado.text = perfil.personastatestring
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imgProfile.image = nil
        lblNombre.text = nil
        lblEstado.text = nil
    }
}

class FriendsController: UITableViewController {
    
    var amigos: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amigos = UserDefaults.standard.array(forKey: APIHelper.UD_STLA)! as? [String]
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    /*override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }*/

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return amigos!.count
    }

        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuse", for: indexPath) as! FriendsTableCell
        let steamId = amigos![indexPath.row]
        APIHelper.getPerfilUsuario(steamId: steamId, updateUI: {(perfil) in cell.setTableCell(perfil: perfil)})
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
