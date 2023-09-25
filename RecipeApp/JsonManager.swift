//
//  JsonManager.swift
//  RecipeApp
//
//  Created by Mira Philip on 2023-08-13.
//

import Foundation

class JsonManager{
    
    static var shared = JsonManager()
    func fromJsonDataToRecipeArray(jsonData : Data)->[Recipe]{
        
        var recipesArray = [Recipe]()
        var ingredientsArray = [Ingredient]()
        var instructionArray = [InstructionInfo]()
        
        do {
            let json = try JSONSerialization.jsonObject(with: jsonData) as! NSDictionary
            let recipes = json["results"] as! NSArray
            for recipe in recipes {
                
                let recipeObj = recipe as! NSDictionary
                
                if let recipeIngredients = recipeObj["sections"] as? NSArray {
                    
                    let firstSection = recipeIngredients.firstObject as! NSDictionary
                    let componentsArray = firstSection["components"] as! NSArray
                    
                    for ingredient in componentsArray{
                        let ingredientObj = ingredient as! NSDictionary
                        let pos = ingredientObj["position"]
                        let raw_text = ingredientObj["raw_text"]
                        ingredientsArray.append(Ingredient(pos: pos as! Int, text: raw_text as! String))
                    }
                     
                    let recipeInstructions = recipeObj["instructions"] as! NSArray
                    
                    for instruction in recipeInstructions {
                        let instructionObj = instruction as! NSDictionary
                        let pos = instructionObj["position"]
                        let display_text = instructionObj["display_text"]
                        instructionArray.append(InstructionInfo(pos: pos as! Int, text: display_text as! String))
                    }
                }
                recipesArray.append(Recipe(recipeId: recipeObj["id"] as! Int, recipeName: recipeObj["name"] as! String, imgUrl: recipeObj["thumbnail_url"] as! String, recipeSections: [IngredientsInfo(comps: ingredientsArray)], recipeInstructions: instructionArray))
                
                ingredientsArray = [Ingredient]()
                instructionArray = [InstructionInfo]()
            }
        }
        catch{
            print(error)
        }
        return recipesArray
    }
    
    func fromJsonDataToRecipe(jsonData : Data)->Recipe{
        
        var recipe = Recipe()
        var ingredientsArray = [Ingredient]()
        var instructionArray = [InstructionInfo]()
        
        do {
            let recipeObj = try JSONSerialization.jsonObject(with: jsonData) as! NSDictionary
                if let recipeIngredients = recipeObj["sections"] as? NSArray {
                    
                    let firstSection = recipeIngredients.firstObject as! NSDictionary
                    let componentsArray = firstSection["components"] as! NSArray
                    
                    for ingredient in componentsArray{
                        let ingredientObj = ingredient as! NSDictionary
                        let pos = ingredientObj["position"]
                        let raw_text = ingredientObj["raw_text"]
                        ingredientsArray.append(Ingredient(pos: pos as! Int, text: raw_text as! String))
                    }
                     
                    let recipeInstructions = recipeObj["instructions"] as! NSArray
                    
                    for instruction in recipeInstructions {
                        let instructionObj = instruction as! NSDictionary
                        let pos = instructionObj["position"]
                        let display_text = instructionObj["display_text"]
                        instructionArray.append(InstructionInfo(pos: pos as! Int, text: display_text as! String))
                    }
                }
                recipe = Recipe(recipeId: recipeObj["id"] as! Int, recipeName: recipeObj["name"] as! String, imgUrl: recipeObj["thumbnail_url"] as! String, recipeSections: [IngredientsInfo(comps: ingredientsArray)], recipeInstructions: instructionArray)
                
                ingredientsArray = [Ingredient]()
                instructionArray = [InstructionInfo]()
            }
        
        catch{
            print(error)
        }
    return recipe;
    }

}
