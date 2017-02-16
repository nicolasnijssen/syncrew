import UIKit
import Alamofire
import JAYSON
import ChameleonFramework

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var tableview:UITableView!
    
    var headers = ["Public","Private"]

    
    @IBOutlet weak var scrollView: UIScrollView!
    var guttlerPageControl: GuttlerPageControl!
    let numOfpage = 7

    
    let model = generateRandomData()
    var storedOffsets = [Int: CGFloat]()
    
    let api = APICommunicator.instance
    var rooms:Array<Room> = Array<Room>()
    var pubRooms:Array<Room> = Array<Room>()
    var privRooms:Array<Room> = Array<Room>()

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(hexString: "#FEFEFE")
        
        
        self.tableview.backgroundColor = .clear
        self.tableview.separatorStyle = UITableViewCellSeparatorStyle.none

        
        /* PAGE CONTROL */
        let pageSize = self.scrollView.frame.width
        
        scrollView.contentSize = CGSize(width: pageSize * CGFloat(numOfpage), height: scrollView.frame.height)
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.bounces = true
        scrollView.delegate = self
        
        for i in 0..<numOfpage {
            let subview = UIView(frame: CGRect(x: pageSize * CGFloat(i), y: 0, width: pageSize, height: scrollView.frame.height))
            subview.backgroundColor = randomColor(hue: .blue, luminosity: .bright)
            scrollView.addSubview(subview)
        }
        
        view.addSubview(scrollView)
        
        // Just init with position and numOfpage
        guttlerPageControl = GuttlerPageControl(center: CGPoint(x: self.scrollView.center.x, y: self.scrollView.center.y+110), pages: numOfpage)
        // Must bind pageControl with the scrollView
        guttlerPageControl.bindScrollView = scrollView
        view.addSubview(guttlerPageControl)

        /* PAGE CONTROL */

        /* CUSTOM NAVBAR */

        let navigationTitleFont = UIFont(name: "AvenirNext-Regular", size: 18)!
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: navigationTitleFont, NSForegroundColorAttributeName: UIColor.white]
        
        /* CUSTOM NAVBAR */

        self.retrieveRooms{
            
            self.tableview.reloadData()
        }

        
    }
    
 
    
    func retrieveRooms(_ completed: @escaping DownloadComplete){
        
        Alamofire.request("http://127.0.0.1:8000/api/rooms").responseJSON { response in
            
            if let json = response.result.value {
                
                let jayson = try! JAYSON(any:json)
                
                for var i in (0..<jayson.array!.count){
                    
                    let room:Room = Room(id: jayson[i]["id"].int!,name: jayson[i]["name"].string!, thumbnail: jayson[i]["thumbnail"].string!, type: jayson[i]["room_type"].string!)
                    
                    
                    if(room.type == "PUBLIC"){
                        
                        self.pubRooms.append(room)
                        
                    }else if (room.type == "PRIVATE") {
                        
                        self.privRooms.append(room)
                    }
                }
                
            }
            
            completed()
            
        }
    }

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 20))
        headerView.backgroundColor = UIColor.clear
        
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = headers[section]
        label.font = UIFont(name: "AvenirNext-Regular", size: 16)!
        label.textColor = UIColor(hexString: "#4979e8")
        headerView.addSubview(label)
        
        label.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant:6.5).isActive = true
        label.rightAnchor.constraint(equalTo: headerView.rightAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        return headerView

        
    }
 
   
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       
        return headers[section]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return headers.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.backgroundColor = .clear
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        guard let tableViewCell = cell as? TableViewCell else { return }
        cell.backgroundColor = .clear


        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        guard let tableViewCell = cell as? TableViewCell else { return }

        tableViewCell.backgroundColor = .clear
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(collectionView.tag == 0){
            
            return self.pubRooms.count
        }else {
            
            return self.privRooms.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)

        cell.backgroundColor = .clear
        
        let cellImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 98, height: 68))
        
        
        if(indexPath.section == 0){
            
            if(self.pubRooms.count > 0){
                
                if(self.pubRooms.count > indexPath.row){
                    cellImage.image = UIImage.contentOfURL(link: self.pubRooms[indexPath.row].thumbnail)
                    cell.addSubview(cellImage)
                }

            }
            
        }else if(indexPath.section == 1){
            
             if(self.privRooms.count > 0){
                
                if(self.privRooms.count > indexPath.row){

                    cellImage.image = UIImage.contentOfURL(link: self.privRooms[indexPath.row].thumbnail)
                    cell.addSubview(cellImage)
                }

            }
        }
    
    
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath.row)")
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Video") as! VideoViewController

        vc.room_id = "\(self.pubRooms[indexPath.row].id)"
        //self.show(vc, sender: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guttlerPageControl.scrollWithScrollView(scrollView)
    }

}
