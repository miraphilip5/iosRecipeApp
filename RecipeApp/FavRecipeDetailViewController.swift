//
//  FavRecipeDetailViewController.swift
//  RecipeApp
//
//  Created by Mira Philip on 2023-08-13.
//

import UIKit

class FavRecipeDetailViewController: UIViewController {

    var selectedRecipe = FavRecipe()
    var recipeFromAPI : Recipe = Recipe()
    var size : CGFloat = 200
    var pinchGesture : UIPinchGestureRecognizer = UIPinchGestureRecognizer()
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var ingredients: UILabel!
    @IBOutlet weak var recipeImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeName.text = selectedRecipe.name
        getRecipeDetail()
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(zoomInOut(gesture:) ))
        pinchGesture.scale = 4
    }

        @objc func zoomInOut(gesture: UIPinchGestureRecognizer){
            print("pinched")
            if gesture.scale > 0 && gesture.scale < 6 {
                recipeImg.frame = CGRect(x: 0, y: 0, width: Int(size) * Int(gesture.scale), height: Int(size) * Int(gesture.scale))
                recipeImg.center = view.center
            }
        }

    func getRecipeDetail(){
            let urlString = "https://tasty.p.rapidapi.com/recipes/get-more-info"
            
            NetworkingManager.shared.getRecipeDetail(url: urlString, id: selectedRecipe.id) { result in
             
                DispatchQueue.main.async {
                    switch result{
                    case .failure(let error):
                        print(error)
                        self.recipeFromAPI = Recipe()
                        break
                        
                    case .success(let data):
                        
                        self.recipeFromAPI =
                        JsonManager.shared.fromJsonDataToRecipe(jsonData: data)
                        var ingredientStr = ""
                        for component in self.recipeFromAPI.sections[0].components {
                            ingredientStr += "\(component.position). \(component.raw_text) \n"
                        }
                        self.ingredients.text = ingredientStr
                        self.loadingIndicator.startAnimating()
                        let myQ = DispatchQueue.init(label: "Q")
                        myQ.async {
                            do {
                                let imageData = try Data(contentsOf: URL(string: self.recipeFromAPI.thumbnail_url)!)

                                DispatchQueue.main.async {
                                    self.recipeImg.image = UIImage(data: imageData)
                                    self.loadingIndicator.stopAnimating()
                                    self.recipeImg.addGestureRecognizer(self.pinchGesture)
                                }

                            }catch {
                                print(error)
                            }
                        }
                        break
                    }
                }
            }
    }

}
