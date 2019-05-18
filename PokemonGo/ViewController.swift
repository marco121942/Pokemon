//
//  ViewController.swift
//  PokemonGo
//
//  Created by Marco Antonio Sotomayor Lopez on 14/05/19.
//  Copyright © 2019 Tecsup. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController , CLLocationManagerDelegate , MKMapViewDelegate{
//var contActualizaciones = 0
     var conActualizaciones : Int = 0
    var pokemons:[Pokemon] = []
    @IBOutlet weak var mapView: MKMapView!
    var ubicacion = CLLocationManager();
    override func viewDidLoad() {
        super.viewDidLoad()
        ubicacion.delegate = self
        pokemons = obtenerPokemons()
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            
            setup()
            
        }else{
            ubicacion.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if(conActualizaciones < 1){
            let region = MKCoordinateRegionMakeWithDistance(ubicacion.location!.coordinate, 1000, 1000)
            mapView.setRegion(region, animated: true)
            conActualizaciones += 1
        }else{
            ubicacion.stopUpdatingLocation()
        }
    }
    
    @IBAction func centrarTapped(_ sender: Any) {
        
        if let coord = ubicacion.location?.coordinate{
            let region = MKCoordinateRegionMakeWithDistance(coord, 1000, 1000)
            mapView.setRegion(region, animated: true)
            conActualizaciones+=1
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            let pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            pinView.image = UIImage(named: "player")
            
            var frame = pinView.frame
            frame.size.height = 50
            frame.size.width = 50
            pinView.frame = frame
            
            return pinView
        }
        let pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        let pokemon = (annotation as! PokePin).pokemon
        pinView.image = UIImage(named: pokemon.imagenNombre!)
        var frame = pinView.frame
        frame.size.height = 50
        frame.size.width = 50
        pinView.frame = frame
        
        return pinView
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        if view.annotation is MKUserLocation{
            return
        }
        
        let region  = MKCoordinateRegionMakeWithDistance(view.annotation!.coordinate, 200, 200)
        mapView.setRegion(region, animated: true)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer) in
            if let coord = self.ubicacion.location?.coordinate {
                let pokemon = (view.annotation as! PokePin).pokemon
                if MKMapRectContainsPoint(mapView.visibleMapRect, MKMapPointForCoordinate(coord)){
                    print("Puede atrapar al pokemon")
                    
                    
                    //Obteniendo el nombre para comparar
                    let nombre = pokemon.nombre
                    let pokemones = obtenerPokemonsAtrapados();
                    
                    //Mostrar el alert y el for con la comparación
                    for pokemone in pokemones{
                        if(nombre == pokemone.nombre){
                            let alertVC = UIAlertController(title: "Alerta!", message: "El pokemon \(pokemon.nombre!) ya fue capturado.", preferredStyle: .alert)
                            let pokedexAccion = UIAlertAction(title: "Capturar", style: .default, handler: {(action) in
                                mapView.removeAnnotation(view.annotation!)
                                self.performSegue(withIdentifier: "pokedexSegue", sender: nil)
                            })
                            alertVC.addAction(pokedexAccion)
                            
                            let okAction = UIAlertAction(title: "Cerrar", style: .default, handler: {(action) in
                                return
                            })
                            alertVC.addAction(okAction)
                            self.present(alertVC, animated: true, completion: nil)
                            return
                        }
                    }
                    
                    
                    
                    
                    
                    
                    pokemon.atrapado = true
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    mapView.removeAnnotation(view.annotation!)
                    
                    let alertaVC = UIAlertController(title: "Felicidades!", message: "Atrapaste a \(pokemon.nombre!)", preferredStyle: .alert)
                    let pokedexAccion = UIAlertAction(title: "Pokedex", style: .default, handler : {
                        (action) in
                        self.performSegue(withIdentifier: "pokedexSegue", sender: nil)
                    })
                    alertaVC.addAction(pokedexAccion)
                    let okAccion = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertaVC.addAction(okAccion)
                    self.present(alertaVC, animated: true, completion: nil)
                    
                }else{
                    let alertaVC = UIAlertController(title: "Ups!", message: "Estas muy lejos de ese \(pokemon.nombre!)", preferredStyle: .alert)
                    let okAccion = UIAlertAction(title: "OK", style: .default, handler : nil)
                    alertaVC.addAction(okAccion)
                    self.present(alertaVC, animated: true, completion: nil)
                    
                }
            }
        })
    }
    
    
    func setup(){
        mapView.delegate = self
        mapView.showsUserLocation = true
        ubicacion.startUpdatingLocation()
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: {(timer) in
            if let coord = self.ubicacion.location?.coordinate{
                let pokemon = self.pokemons[Int(arc4random_uniform(UInt32(self.pokemons.count)))]
                let pin = PokePin(coord:coord, pokemon:pokemon)
                let randomLat = (Double(arc4random_uniform(200))-100.0)/5000.0
                let randomLon = (Double(arc4random_uniform(200))-100.0)/5000.0
                pin.coordinate.longitude += randomLon
                pin.coordinate.latitude += randomLat
                self.mapView.addAnnotation(pin)
            }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            setup()
        }
    }
    
}

