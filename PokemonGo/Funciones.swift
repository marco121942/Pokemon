//
//  Funciones.swift
//  PokemonGo
//
//  Created by Marco Antonio Sotomayor Lopez on 14/05/19.
//  Copyright © 2019 Tecsup. All rights reserved.
//
import UIKit
import CoreData

import Foundation
func agregarPokemon(){
    crearPokemon(xnombre: "Mew", ximagenNombre: "mew")
    crearPokemon(xnombre: "Meowth", ximagenNombre: "meowth")
    crearPokemon(xnombre: "Abra", ximagenNombre: "abra")
    crearPokemon(xnombre: "Bullbasaur", ximagenNombre: "bullbasaur")
    crearPokemon(xnombre: "Dratini", ximagenNombre: "dratini")
    crearPokemon(xnombre: "Eevee", ximagenNombre: "eevee")
    crearPokemon(xnombre: "Mankey", ximagenNombre: "mankey")
    crearPokemon(xnombre: "Pikachu", ximagenNombre: "pikachu-2")
    crearPokemon(xnombre: "Psyduck", ximagenNombre: "psyduck")
    crearPokemon(xnombre: "Rattata", ximagenNombre: "rattata")
    crearPokemon(xnombre: "Snorlax", ximagenNombre: "snorlax")
    crearPokemon(xnombre: "Squirtle", ximagenNombre: "squirtle")
    crearPokemon(xnombre: "Venonat", ximagenNombre: "venonat")
    crearPokemon(xnombre: "Weedle", ximagenNombre: "weedle")
    crearPokemon(xnombre: "Zubat", ximagenNombre: "zubat")
    crearPokemon(xnombre: "Meowth", ximagenNombre: "meowth")
   ( UIApplication.shared.delegate as! AppDelegate).saveContext()
}
func crearPokemon(xnombre:String, ximagenNombre:String){
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let pokemon = Pokemon(context:context)
    pokemon.nombre = xnombre
    pokemon.imagenNombre = ximagenNombre
}
func obtenerPokemons() ->[Pokemon]{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    do{
        let pokemons = try context.fetch(Pokemon.fetchRequest()) as! [Pokemon]
        if pokemons.count == 0 {
            agregarPokemon()
            return obtenerPokemons()
        }
        return pokemons
    }catch{}
    return []
}
func obtenerPokemonsAtrapados() -> [Pokemon]{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let queryConWhere = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
    queryConWhere.predicate = NSPredicate(format:  "atrapado == %@", true as CVarArg)
    do{
        let pokemons = try context.fetch(queryConWhere) as [Pokemon]
        return pokemons
    }catch{}
    return []
}
func obtenerPokemonsNoAtrapados() -> [Pokemon]{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let queryConWhere = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
    queryConWhere.predicate = NSPredicate(format : "atrapado == %@", false as CVarArg)
    do{
        let pokemons = try context.fetch(queryConWhere) as [Pokemon]
        return pokemons
    } catch{}
    return []
}
