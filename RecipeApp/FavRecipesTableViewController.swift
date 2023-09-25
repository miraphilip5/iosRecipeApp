//
//  FavRecipesTableViewController.swift
//  RecipeApp
//
//  Created by Mira Philip on 2023-08-13.
//

import UIKit

class FavRecipesTableViewController: UITableViewController {
    
    var favRecipes : [FavRecipe] = [FavRecipe]()
    override func viewDidLoad() {
        super.viewDidLoad()
        performFetchFunction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        performFetchFunction()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favRecipes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = favRecipes[indexPath.row].name
        cell.detailTextLabel?.text = "\(favRecipes[indexPath.row].id)"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let alert = UIAlertController(title: "Delete Fav Recipe", message: "Are you sure you want to delete this recipe?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
                let deletedRecipe = self.favRecipes[indexPath.row]
                
                FirebaseManager.shared.deleteFav(recipe: deletedRecipe) { error in
                    if let error = error {
                        // Handle deletion error if needed
                        print("Error deleting recipe: \(error)")
                    } else {
                        // Deletion successful
                        self.performFetchFunction()
                    }
                }
      
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel))
            present(alert, animated: true)
            }
    }
    
    func performFetchFunction(){
        FirebaseManager.shared.getAllFavRecipes { array in
            self.favRecipes = array
            self.tableView.reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "FavRecipeDetail"){
            let photoRecipeVC = segue.destination as! FavRecipeDetailViewController
            photoRecipeVC.selectedRecipe = favRecipes[tableView.indexPathForSelectedRow!.row]
        }
    }
    

}
