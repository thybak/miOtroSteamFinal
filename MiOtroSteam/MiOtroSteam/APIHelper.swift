//
//  APIHelper.swift
//  MiOtroSteam
//
//  Created by XCode on 25/4/17.
//  Copyright © 2017 etsisi. All rights reserved.
//

import Foundation
import UIKit


class APIHelper {
    
    static let API_KEY = "89431E4E87AC40D8070E25CAD6C5592A"
    static let URL_BASE = "http://api.steampowered.com"
    static let UD_STID = "steamID"
    static let UD_STLA = "listaAmigos"
    static let UD_APID = "appID"
    static var cache = NSCache<NSString, AnyObject>()
    
    /* En esta función se comprueba si existe cache, si es así se carga esta, si no tenemos cache se procede a cargar los datos de la API */
    static func getFromAPIOrCache(url: String, parseJson: @escaping (AnyObject) -> Void){
        let _url = URL(string: url)
        let cacheJson = cache.object(forKey: url as NSString)
        
        if cacheJson == nil {
            URLSession.shared.dataTask(with: _url!, completionHandler: {
                (data, response, error) in
                if(error != nil) {
                    print("error")
                } else {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as? [String : AnyObject] {
                            cache.setObject(json as AnyObject, forKey: url as NSString)
                            parseJson(json as AnyObject)
                        } else {
                            print("Ha habido un error a la hora de obtener el JSON")
                        }
                    }
                    catch let error as NSError{
                        print(error)
                    }
                }
            }).resume()
        } else {
            parseJson(cacheJson as AnyObject)
        }
    }
    /* En esta función se consulta a la API para obtener los logros de cada juego*/
    static func getListaLogros (steamId: String, appId: Int, updateUI: @escaping ([Logro]) -> Void){
        let urlAchievementsInfo = URL_BASE + "/ISteamUserStats/GetPlayerAchievements/v0001/?key=" + API_KEY + "&steamid=" + steamId + "&appid=" + String(appId) + "&format=json&l=spanish"
        getFromAPIOrCache(url: urlAchievementsInfo, parseJson: { (json) in
            var listaLogros : [Logro] = []
            let playerstats = json["playerstats"] as! [String: AnyObject]
            let exito = playerstats["success"] as? Bool
            if exito == true && playerstats["achievements"] != nil {
                let achievements = playerstats["achievements"] as! [[String : AnyObject]]
                for achievement in achievements {
                    listaLogros.append(Logro(logro: achievement))
                }
            }
            DispatchQueue.main.async{
                updateUI(listaLogros)
            }
        })
    }
    /* En esta función se consulta a la API para obtener los juegos del usuario*/
    static func getListaJuegos (steamId: String, updateUI: @escaping ([Game]) -> Void){
        let urlGamesInfo = URL_BASE + "/IPlayerService/GetOwnedGames/v0001/?key=" + API_KEY + "&steamid=" + steamId + "&format=json&include_appinfo=1"
        getFromAPIOrCache(url: urlGamesInfo, parseJson: { (json) in
            var listaJuegos : [Game] = []
            let gamelist = json["response"] as! [String: AnyObject]
            if let games = gamelist["games"] as? [[String : AnyObject]] {
                for game in games {
                    let oGame = Game(claves: game)
                    listaJuegos.append(oGame)
                }
            }
            DispatchQueue.main.async{
                updateUI(listaJuegos)
            }
        })
    }
    /* En esta función se consulta a la API para obtener las noticias relativas a un juego pasado por parámetro */
    static func getListaNews (appId: Int, numeroNews: Int, updateUI: @escaping ([Noticia]) -> Void){
        let urlNewsInfo = URL_BASE + "/ISteamNews/GetNewsForApp/v0002/?appid=" + String(appId) + "&count=" + String(numeroNews) + "&maxlength=255&format=json"
        getFromAPIOrCache(url: urlNewsInfo, parseJson: { (json) in
            var listaNews : [Noticia] = []
            let newsJson = json["appnews"] as! [String: AnyObject]
            if let news = newsJson["newsitems"] as? [[String: AnyObject]]{
                for new in news {
                    let oNew = Noticia(claves: new)
                    listaNews.append(oNew)
                }
            }
            DispatchQueue.main.async {
                updateUI(listaNews)
            }
            
        })
    }
    /* En esta función se consulta a la API para obtener los amigos del usuario*/
    static func getListaAmigos (steamId: String, updateUI: @escaping () -> Void){
        let urlUserInfo = URL_BASE + "/ISteamUser/GetFriendList/v0001/?key=" + API_KEY + "&steamid=" + steamId + "&relationship=friend"
        getFromAPIOrCache(url: urlUserInfo, parseJson: {(json) in
            var listaAmigos : [String] = []
            let defaults = UserDefaults.standard
            if let friendlist = json["friendslist"] as? [String: AnyObject] {
                let friends = friendlist["friends"] as! [[String : AnyObject]]
                for friend in friends {
                    listaAmigos.append(friend["steamid"] as! String)
                }
            }
            defaults.setValue(listaAmigos, forKey: APIHelper.UD_STLA)
            DispatchQueue.main.async {
                updateUI()
            }
        })
    }
    /* En esta función se consulta a la API para obtener  los datos del perfil del usuario que se ha autentificado anteriormente */
    static func getPerfilUsuario (steamId: String, updateUI: @escaping (Perfil) -> Void){
        let urlUserInfo = URL_BASE + "/ISteamUser/GetPlayerSummaries/v0001/?key=" + API_KEY + "&steamids=" + steamId
        getFromAPIOrCache(url: urlUserInfo, parseJson: { (json) in
            let response = json["response"] as! [String:AnyObject]
            let playerlist = response["players"] as! [String: AnyObject]
            if let players = playerlist["player"] as? [[String: AnyObject]] {
                for player in players {
                    let perfil = Perfil(claves: player)
                    DispatchQueue.main.async {
                        updateUI(perfil)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    let perfil = Perfil(claves: [:])
                    updateUI(perfil)
                }
            }
        })
    }
    /* En esta función se consulta a la API para obtener  un resumen de los juegos del usuario */
    static func getSchemaGame (gameId: Int, updateUI: @escaping (String) -> Void){
        let urlGameInfo = URL_BASE + "/ISteamUserStats/GetSchemaForGame/v2/?key=" + API_KEY + "&appid="+String(gameId)+"&l=spanish"
        getFromAPIOrCache(url: urlGameInfo, parseJson: { (json) in
            let responsegame = json["game"] as! [String:AnyObject]
            if let gameName = responsegame["gameName"] as? String {
                if (gameName.isEmpty){
                    updateUI("Nombre vacio")
                } else {
                    updateUI(gameName)
                }
            } else {
                updateUI("No es posible recuperar este nombre")
            }
        })
    }
    /* En esta función se consulta a la API para obtener  las imagenes asociadas a una URL */
    static func setImagenDesdeUrl(url: URL, updateUI: @escaping ((UIImage) -> Void)){
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("error")
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200
                else {
                    print("Error de respuesta en imagen")
                    return
                }
            DispatchQueue.main.async {
                let image = UIImage(data:data!)
                if image != nil {
                    updateUI(image!)
                }
            }
        }.resume()
    }
    
}
