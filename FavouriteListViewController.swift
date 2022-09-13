//
//  FavouriteListViewController.swift
//  FinalTest_Yeibin
//
//  Created by Yeibin Kang on 2021-12-13.
//

import UIKit
import CoreData

class FavouriteListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var myTableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var favouriteList:[Favourite] = []
    
    var canadaPopulation:Int = 38005238
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return favouriteList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.myTableView.dequeueReusableCell(withIdentifier: "myCell2", for: indexPath)
        cell.textLabel?.text = favouriteList[indexPath.row].name
        cell.detailTextLabel?.text = favouriteList[indexPath.row].population

        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //Deleting a data from CoreData by swaping
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            let currCountry = self.favouriteList[indexPath.row]
            
            
            
            self.context.delete(currCountry)
            
            do{
                try self.context.save()
                print("Succesfully deleted from CoreData")
                
                self.favouriteList.remove(at: indexPath.row)
                myTableView.deleteRows(at: [indexPath], with: .fade)
            }catch{
                print("Error: while deleting a data from CoreData")
            }
        }
        
    }
    
    //Changing row color based on the population
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //TODO: compare a population to Canada's population
        let populationString:String! = favouriteList[indexPath.row].population
        let tempPopulation:Int = Int(populationString) ?? 0
        let newcolor: UIColor;
        
        if(tempPopulation > canadaPopulation){
            newcolor = UIColor.yellow
            
        }else{
            newcolor = UIColor.white
        }

        cell.backgroundColor = newcolor;

    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.delegate = self
        myTableView.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("View will appear")
        let request:NSFetchRequest<Favourite> = Favourite.fetchRequest()
        
        do{
            let results:[Favourite] = try self.context.fetch(request)

            self.favouriteList = results
            
            self.myTableView.reloadData()
            
        }catch{
            print("Error: fetching data from CoreData")
            return
        }
        
        
    }

}
