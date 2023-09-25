//
//  SearchTableViewController.swift
//  RecipeApp
//
//  Created by Mira Philip on 2023-08-13.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate {
   
    @IBOutlet weak var searchBar: UISearchBar!
    
    var allRecipesFromAPI = [Recipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allRecipesFromAPI = [Recipe]()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       allRecipesFromAPI = [Recipe]()
       tableView.reloadData()
       searchBar.text = ""
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allRecipesFromAPI.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(allRecipesFromAPI[indexPath.row].name)"
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if searchText.count > 2{
            
            let urlString = "https://tasty.p.rapidapi.com/recipes/list?from=0&size=10&q=\(searchText)"
            
            NetworkingManager.shared.getAllRecipes(url: urlString) { result in
             
                DispatchQueue.main.async {
                    switch result{
                    case .failure(let error):
                        print(error)
                        self.allRecipesFromAPI = [Recipe]()
                        self.tableView.reloadData()
                        break
                        
                    case .success(let data):
                        
                        self.allRecipesFromAPI =
                        JsonManager.shared.fromJsonDataToRecipeArray(jsonData: data)
                    
                        self.tableView.reloadData()
                        break
                    }
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let recipeVC = segue.destination as! RecipeDetailViewController
        recipeVC.selectedRecipe = allRecipesFromAPI[tableView.indexPathForSelectedRow!.row]
    }
}
