//
//  Recipe.swift
//  RecipeApp
//
//  Created by Mira Philip on 2023-08-12.
//

import Foundation

class Recipe: Codable{
    
    var id : Int = 0
    var name : String = ""
    var thumbnail_url : String = ""
    var sections : [IngredientsInfo] = [IngredientsInfo]()
    var instructions: [InstructionInfo] = [InstructionInfo]()
    
    init(){
        id = 0
        name = ""
        thumbnail_url = ""
        sections = [IngredientsInfo]()
        instructions = [InstructionInfo]()
    }
    
    init(recipeId: Int, recipeName: String, imgUrl: String, recipeSections: [IngredientsInfo], recipeInstructions: [InstructionInfo]){
        id = recipeId
        name = recipeName
        thumbnail_url = imgUrl
        sections = recipeSections
        instructions = recipeInstructions
    }
}

class IngredientsInfo : Codable{
    
    var components : [Ingredient] = [Ingredient]()
    
    init(){
        components = [Ingredient]()
    }
    
    init(comps: [Ingredient]){
        components = comps
    }
}

class Ingredient : Codable{
    
    var position : Int = 0
    var raw_text : String = ""
    
    init(){
        position = 0
        raw_text = ""
    }
    
    init(pos: Int, text: String){
        position = pos
        raw_text = text
    }
   
}

class InstructionInfo : Codable{
    
    var position : Int = 0
    var display_text : String = ""
    
    init(){
        position = 0
        display_text = ""
    }
    
    init(pos: Int, text: String){
        position = pos
        display_text = text
    }
}

class FavRecipe: Codable{
    
    var id : Int = 0
    var name : String = ""
    
    init(){
        id = 0
        name = ""
    }
    
    init(i: Int, n: String){
        id = i
        name = n
    }
}
