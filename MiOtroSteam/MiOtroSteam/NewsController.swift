//
//  NewsController.swift
//  MiOtroSteam
//
//  Created by Thybak on 03/06/2017.
//  Copyright © 2017 etsisi. All rights reserved.
//

import UIKit

class NewCell : UITableViewCell {
    
    @IBOutlet var lblTitulo: UILabel!
    @IBOutlet var lblAutor: UILabel!
    @IBOutlet var lblFecha: UILabel!
    @IBOutlet var txtContenido: UITextView!
    @IBOutlet var btnVerMas: UIButton!
    var url: String = ""
    
    func setCell(noticia: Noticia){
        lblTitulo.text = noticia.title
        lblAutor.text = noticia.author
        let formatoFecha = DateFormatter()
        formatoFecha.dateFormat = "dd/MM/YYYY hh:mm a"
        let fechaString = formatoFecha.string(from: noticia.fulldate)
        lblFecha.text = fechaString
        txtContenido.text = noticia.contents.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil) // limpia HTML
        self.url = noticia.url
    }
    
    @IBAction
    func verMas(){
        if let url = URL(string: self.url) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
}

class NewsController: UITableViewController {
    
    var news: [Noticia] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appId = UserDefaults.standard.integer(forKey: APIHelper.UD_APID)
        APIHelper.getListaNews(appId: appId, numeroNews: 5, updateUI: { (_news) in
            if _news.count == 0 {
                let alert = UIAlertController(title: "No hay noticias", message: "No existen noticias para este juego",
                                              preferredStyle: UIAlertControllerStyle.alert)
                let cancel = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,
                                           handler: nil)
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
            } else {
                self.news = _news
                self.tableView.reloadData()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuse", for: indexPath) as! NewCell
        cell.setCell(noticia: news[indexPath.row])
        return cell
    }
}
