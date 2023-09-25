//
//  RecipeDetailViewController.swift
//  RecipeApp
//
//  Created by Mira Philip on 2023-08-13.
//

import UIKit

class RecipeDetailViewController: UIViewController {

    var selectedRecipe = Recipe()
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var ingredients: UILabel!
    @IBOutlet weak var recipeImg: UIImageView!
    
    @IBAction func saveAsFavRecipe(_ sender: Any) {
        
        let newFavRecipe : FavRecipe = FavRecipe()
        newFavRecipe.id = selectedRecipe.id
        newFavRecipe.name = selectedRecipe.name
    
        FirebaseManager.shared.insertNewFavRecipe(r: newFavRecipe)
        self.navigationController!.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeName.text = selectedRecipe.name
        var ingredientStr = ""
        for component in selectedRecipe.sections[0].components {
            ingredientStr += "\(component.position). \(component.raw_text) \n"
        }
        ingredients.text = ingredientStr
        loadingIndicator.startAnimating()
        let myQ = DispatchQueue.init(label: "Q")
        myQ.async {
            do {
                let imageData = try Data(contentsOf: URL(string: self.selectedRecipe.thumbnail_url)!)
                
                DispatchQueue.main.async {
                    self.recipeImg.image = UIImage(data: imageData)
                    self.loadingIndicator.stopAnimating()
                }
                
            }catch {
                print(error)
            }
        }
    }

}
