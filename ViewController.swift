//
//  ViewController.swift
//  FinalTest_Yeibin
//
//  Created by Yeibin Kang on 2021-12-13.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {



    @IBOutlet weak var TableView: UITableView!
    
    var countries:[CountryList] = [CountryList]()
    
    var tempCountry:Country = Country(name: "", code: "", population: 0, capital: "")
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return countries.count
    }
    
    //print in UI names of countries
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.row > countries.count-1){
            return UITableViewCell()
        }else{
            let cell = TableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)

            cell.textLabel?.text = self.countries[indexPath.row].countryName
            
            return cell
        }
        
   
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //row click action
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
        
        guard let detailsScreen = storyboard?.instantiateViewController(withIdentifier: "detailsScreen") as? detailsViewController else{
            print("Error while going to the second window")
            return
        }
        
        self.navigationController?.pushViewController(detailsScreen, animated: true)
        
        //send data
        let tempName:String = countries[indexPath.row].countryName ?? "N/A"
        let tempCapital:String = countries[indexPath.row].capital ?? "N/A"
        let tempCode:String = countries[indexPath.row].countryCode ?? "N/A"
        let tempPop:Int = countries[indexPath.row].population ?? 0
        
        tempCountry.name = tempName
        tempCountry.code = tempCode
        tempCountry.capital = tempCapital
        tempCountry.population = tempPop
        
        //send data to the second screen
        detailsScreen.receive(country: tempCountry)

        
        detailsScreen.viewDidLoad()
        
        
    }


    override func viewDidLoad() {

        
        super.viewDidLoad()

        TableView.dataSource = self
        TableView.delegate = self
     
        fetchData()
        

    }
    
    //Fetch data from API
    func fetchData(){    //running in the background
        
        //connect to API endpoint
        let apiEndpoint = "https://restcountries.com/v2/all"
        
        guard let apiURL = URL(string: apiEndpoint) else{
            print("Couldn't convert")
            return
        }
        
        URLSession.shared.dataTask(with: apiURL) { (data, URLResponse, error) in
            //this code should run after we receive a response from the web
            if let err = error{
                print("Error occured while fetching data from API")
                print(err)
                return
            }
            //assuming JSON data
            //data - convert into the Model class
            
            if let jsonData = data{
                
                print(jsonData)
                
                let decodedItem:[CountryList]
                //convert it to jsonData format
                do{
                    let decoder = JSONDecoder()
                    decodedItem = try decoder.decode([CountryList].self, from:jsonData)
 

                    DispatchQueue.main.sync {
                        self.countries = decodedItem
                    
                        
                        self.TableView.reloadData()
                    }
                 
                    
                }catch let error{
                    print("JSON decoding error")
                    print(error)
                }
                
                
            }
            
        }.resume()
        
    }

    
}

