//
//  detailsViewController.swift
//  FinalTest_Yeibin
//
//  Created by Yeibin Kang on 2021-12-13.
//

import UIKit
import CoreData

class detailsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if(isNill == false){
            countryNamelbl?.text = self.name
            capitallbl?.text = self.capital
            countryCodelbl?.text = self.code
            populationlbl?.text = String(self.population)
        }else{
            countryNamelbl?.text = ""
            capitallbl?.text = ""
            countryCodelbl?.text = ""
            populationlbl?.text = ""
            nilDatalbl?.text = "Sorry, no country information found"
        }
        
    }
    
    
    @IBOutlet weak var countryNamelbl: UILabel!
    
    @IBOutlet weak var capitallbl: UILabel!
    
    
    @IBOutlet weak var countryCodelbl: UILabel!
    
    @IBOutlet weak var populationlbl: UILabel!
    
    @IBOutlet weak var nilDatalbl: UILabel!
    
    var name:String = ""
    var capital:String = ""
    var code:String = ""
    var population:Int = 0
    var isNill:Bool = false
     
    var booleanValue:Bool = true
    var isAlreadyExist:Bool = false
    var alertMessage:String = ""
    
    //CoreData
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    //create a fav obj
    func addFavourite(){
        
        //check if the data is already in CoreData
        self.isAlreadyExist = checkIsExist()
        
        if(isAlreadyExist){
            // do nothing
        }else{
            //1. create fav obj
            let tempFav = Favourite(context: self.context)
            //2. set the properties of that obj
            tempFav.name = self.name
            tempFav.population = String(self.population)

            //3. save
            do{
                try self.context.save()
                print("Country saved!")
            }catch{
                print("Error: Saving to the db fail")
                return
            }
        }
        
        
        

        
    }
    
    //receive an obj from the main screen
    func receive(country:Country){
        
        if(country == nil){
            self.isNill = true
        }else{
            self.name = country.name ?? "N/A"
            self.capital = country.capital ?? "N/A"
            self.code = country.code ?? "N/A"
            self.population = country.population ?? 0
        }

        
    }
    
    //check is the data already exist or not
    func checkIsExist() -> Bool{
        
        var tempExist:Bool = false
        
        let tempName = self.name
        
        let request:NSFetchRequest<Favourite> = Favourite.fetchRequest()
        request.predicate = NSPredicate(format:"name == %@", tempName)  //check is the name equal to current country name
        do{
            let results:[Favourite] = try self.context.fetch(request)
            
            if(results.isEmpty == false){
                var tempCon = results.first!
                print("printed from add \(tempCon.name)")
                tempExist = true
            }else{
                tempExist = false
            }
            
            
            return tempExist
            
        }catch{
            print("Error: checking existence of the country")
        }
        
        return tempExist
    }
    
    
    //try to add country into db
        //based on the existence, it will pop up different alert box
    @IBAction func addFavouritePressed(_ sender: Any) {
        addFavourite()

         
         if(isAlreadyExist){
             alertMessage = "Fail. The data is already exist"
         }else{
             alertMessage = "Success. The data is added to db"
         }
         
         //alert box
         let box = UIAlertController(title: "Alert box", message: alertMessage, preferredStyle: .alert)
         box.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
             print("tapped ok")
         }))
         
         present(box, animated: true)
    }


}
