//
//  FirebaseManager.swift
//  RecipeApp
//
//  Created by Mira Philip on 2023-08-12.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class FirebaseManager {
    static var shared  = FirebaseManager()
    let db = Firestore.firestore()
    
    func insertNewFavRecipe(r: FavRecipe ){
        
        let data = [
            "recipeName": r.name,
            "recipeId": r.id
        ] as [String : Any]
        
        let ref = db.collection("FavRecipes").document()
        ref.setData(data) { error in
            print(error ?? " error ")
        }
        
    }
    
    func getAllFavRecipes( completion: @escaping ([FavRecipe])->Void){
        
        var recipes = [FavRecipe]()
        
         db.collection("FavRecipes").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let firestoreMap = document.data()
                    let name = firestoreMap["recipeName"]!
                    let id = firestoreMap["recipeId"]!
            
                    recipes.append(FavRecipe(i: id as! Int, n: name as! String));
                }
                completion(recipes)
            }
        }
        
    }
    
    //delete recipe
    func deleteFav(recipe: FavRecipe, completion: @escaping (Error?) -> Void) {
        let recipeId = recipe.id // Assuming id is the recipeId field in the Firestore documents
        let collectionRef = db.collection("FavRecipes")

        collectionRef.whereField("recipeId", isEqualTo: recipeId).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(error)
            } else {
                for document in querySnapshot!.documents {
                    document.reference.delete { error in
                        if let error = error {
                            print("Error deleting document: \(error)")
                            completion(error)
                        } else {
                            print("Document successfully deleted!")
                            completion(nil)
                        }
                    }
                }
            }
        }
    }


}
