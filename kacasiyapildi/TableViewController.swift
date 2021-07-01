//
//  TableViewController.swift
//  kacasiyapildi
//
//  Created by Barış Can Akkaya on 28.06.2021.
//

import UIKit


class TableViewController: UITableViewController {
    

    var safeHeight: CGFloat?
    var count = 0
    var string = ["Toplam Yapılan Aşı Sayısı", "1. Doz Uygulanan Kişi Sayısı", "2. Doz Uygulanan Kişi Sayısı"]
    var colors = [UIColor.purple, UIColor.orange, UIColor.red]
    var datas = [String]()
    var toplamData = [Int]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDatas()
    }
    
    
    @IBAction func reloadData(_ sender: UIBarButtonItem) {
        print("tap")
        getDatas()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.safeAreaLayoutGuide.layoutFrame.height/12
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return view.safeAreaLayoutGuide.layoutFrame.height/12
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return configureCell(count: &count, indexPath: indexPath)
    }
    
    
    
}


extension TableViewController {
    func getDatas() {
        datas.removeAll()
        toplamData.removeAll()
        count = 0
        var array = [String]()
        
        if let url = URL(string: "https://covid19asi.saglik.gov.tr") {
            do {
                let contents = try String(contentsOf: url)
                let contentsArray = contents.components(separatedBy: "\n")
                for i in contentsArray {
                    array.append(i.trimmingCharacters(in: .whitespaces))
                    
                }
            } catch {
                // contents could not be loaded
            }
        } else {
            // the URL was bad!
        }
        
        
        for i in array {
            if i.hasPrefix("<script>var asiyapilan") {
                if let data = i.slice(from: "<script>var asiyapilankisisayisi1Doz = ", to: ";</script>") {
                    toplamData.append(Int(data)!)
                    var newData = data
                    newData.insert(string: ".", ind: 2)
                    newData.insert(string: ".", ind: 6)
                    datas.append(newData)
                } else if let data = i.slice(from: "<script>var asiyapilankisisayisi2Doz = ", to: ";</script>") {
                    toplamData.append(Int(data)!)
                    var newData = data
                    newData.insert(string: ".", ind: 2)
                    newData.insert(string: ".", ind: 6)
                    datas.append(newData)
                }
            }
        }
        
    }
    
    func configureCell(count: inout Int, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Configure the cell...
        if count == 1 {
            cell.backgroundColor = colors[0]
            cell.textLabel?.textColor = .white
            cell.textLabel?.text = datas[0]
            cell.textLabel?.textAlignment = .center
        } else if count == 3 {
            cell.backgroundColor = colors[1]
            cell.textLabel?.textColor = .white
            cell.textLabel?.text = datas[1]
            cell.textLabel?.textAlignment = .center
        } else if count == 5 {
            cell.backgroundColor = colors[2]
            cell.textLabel?.textColor = .white
            cell.textLabel?.text = getToplamAsiSayisi()
            cell.textLabel?.textAlignment = .center
        }
        
        if count == 0 {
            cell.backgroundColor = colors[0]
            cell.textLabel?.textColor = .white
            cell.textLabel?.text = "1. Doz Uygulanan Kişi Sayısı"
            cell.textLabel?.textAlignment = .center
        } else if count == 2 {
            cell.backgroundColor = colors[1]
            cell.textLabel?.textColor = .white
            cell.textLabel?.text = "2. Doz Uygulanan Kişi Sayısı"
            cell.textLabel?.textAlignment = .center
        } else if count == 4 {
            cell.backgroundColor = colors[2]
            cell.textLabel?.textColor = .white
            cell.textLabel?.text = "Toplam Yapılan Aşı Sayısı"
            cell.textLabel?.textAlignment = .center
        }
        count += 1
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
    
    func getToplamAsiSayisi() -> String {
        if toplamData.count > 1 {
            var toplam = "\(toplamData[0] + toplamData[1])"
            toplam.insert(string: ".", ind: 2)
            toplam.insert(string: ".", ind: 6)
            return String(toplam)
        }
        return ""
    }
}

extension String {
    
    func slice(from: String, to: String) -> String? {
        
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
    mutating func insert(string:String,ind:Int) {
        self.insert(contentsOf: string, at:self.index(self.startIndex, offsetBy: ind) )
    }
}
