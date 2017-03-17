import UIKit
import Alamofire
import JAYSON
import ChameleonFramework

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var tableview:UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loadingView: UIView!

    var headers = ["Public","Private"]
    var popRooms = ["Random room","Sport room","News room"]

    var guttlerPageControl: GuttlerPageControl!
    let numOfpage = 3

    var pubRooms:Array<Room> = Array<Room>()
    var privRooms:Array<Room> = Array<Room>()
    
    var playback = [String]()

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        

        self.title = "Syncrew"
        
    
        //NavigationBar customization
        let navigationTitleFont = UIFont(name: "AvenirNext-Regular", size: 18)!
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: navigationTitleFont, NSForegroundColorAttributeName: UIColor.white]
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        
        //Right bar button item
        let rightBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        rightBtn.setImage(UIImage(named: "profile pic"), for: UIControlState.normal)
        
        rightBtn.addTarget(self, action: #selector(self.showProfile), for:  UIControlEvents.touchUpInside)
        
        let item = UIBarButtonItem(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = item
        
        
        self.view.backgroundColor = UIColor(hexString: "#FEFEFE")
        
        //Background TableView settings
        self.tableview.backgroundColor = UIColor(hexString: Constants.themeColor2)
        self.tableview.separatorStyle = UITableViewCellSeparatorStyle.none

        
        //Page control
        let pageSize = self.scrollView.frame.width
        
        scrollView.contentSize = CGSize(width: pageSize * CGFloat(numOfpage), height: scrollView.frame.height)
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.bounces = true
        scrollView.delegate = self
        
        for i in 0..<numOfpage {
            let subview = UIView(frame: CGRect(x: pageSize * CGFloat(i), y: 0, width: pageSize, height: scrollView.frame.height))
            subview.backgroundColor = randomColor(hue: .blue, luminosity: .bright)
            
            let cellLabel = UILabel(frame: CGRect(x: 0, y: (scrollView.frame.height / 2) - 20 , width:subview.frame.width , height: 40))
            
            cellLabel.adjustsFontSizeToFitWidth = true
            cellLabel.font = UIFont(name: "AvenirNext-Regular", size: 21)!
            cellLabel.textColor = .white
            cellLabel.textAlignment = .center
            
            if i == 0 {
                
                cellLabel.text = "Welcome" // \(AccountManager.getInstance().account.name)"

            }else {
                cellLabel.text = self.popRooms[i]

            }
            subview.addSubview(cellLabel)

            scrollView.addSubview(subview)
        }
        
        view.addSubview(scrollView)
        
        guttlerPageControl = GuttlerPageControl(center: CGPoint(x: self.scrollView.center.x, y: self.scrollView.center.y+110), pages: numOfpage)
        guttlerPageControl.bindScrollView = scrollView
        view.addSubview(guttlerPageControl)

        

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.pubRooms.removeAll()
        self.privRooms.removeAll()
        
        //get rooms from API
        self.retrieveRooms{
            self.hideLoading()
            self.tableview.reloadData()
        }

    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guttlerPageControl.scrollWithScrollView(scrollView)
    }

    
    func retrieveRooms(_ completed: @escaping DownloadComplete){
        
        let headers: HTTPHeaders = ["Authorization": AccountManager.getInstance().token]

        Alamofire.request("https://syncrew-auth0.herokuapp.com/api/rooms/", headers:headers).responseJSON { response in
            
            if let json = response.result.value {
                
                let jayson = try! JAYSON(any:json)
                
                for var i in (0..<jayson.array!.count){
                    
                    
                    let room:Room = Room(id: jayson[i]["roomId"].int!,name: jayson[i]["roomTitle"].string!, thumbnail: "", visibile: jayson[i]["visibility"].bool!,admin:jayson[i]["roomAdmin"]["userId"].int!)
                    
                    
                    for var j in (0..<jayson[i]["videoList"].array!.count){
                        
                        
                      
                        let video:Video = Video(title: jayson[i]["videoList"][j]["title"].string!, youtube: jayson[i]["videoList"][j]["url"].string!)
                            
                        room.addVideo(video: video)

                        
                        completed()                      
                       
 
                    }
                
                    if(room.visibile){
                        
                        self.pubRooms.append(room)
                        
                    } else {
                        
                        if(room.admin == AccountManager.getInstance().account.id){
                            
                            
                             self.privRooms.append(room)
                        }
                    }
                }
                
            }
            
            completed()
            
        }
    }
    
    
  
    // TABLEVIEW METHODS
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
 
 
    func numberOfSections(in tableView: UITableView) -> Int {
        return headers.count
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return headers.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.backgroundColor = UIColor(hexString: Constants.themeColor2)
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        guard let tableViewCell = cell as? TableViewCell else { return }


        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.section)
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        guard let tableViewCell = cell as? TableViewCell else { return }

        tableViewCell.backgroundColor = UIColor(hexString: Constants.themeColor2)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

//Collection view methods
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
        
        let cellView = UIView(frame: CGRect(x: 0, y: 0, width: 98, height: 68))
        let cellLabel = UILabel(frame: CGRect(x: 0, y: 14, width:cellView.frame.width , height: 40))
        cellView.backgroundColor = UIColor.randomBackColor()

        cellLabel.adjustsFontSizeToFitWidth = true
        cellLabel.font = UIFont(name: "AvenirNext-Regular", size: 16)!
        cellLabel.textColor = .white
        cellLabel.textAlignment = .center
        cellView.addSubview(cellLabel)
        
        
        
        if(collectionView.tag == 0){
            
            if(self.pubRooms.count > 0){
                
                if(self.pubRooms.count > indexPath.row){
                    
                    cellLabel.text = self.pubRooms[indexPath.row].name    
                    cell.addSubview(cellView)
                }

            }
            
        }else if(collectionView.tag == 1){
            
                if(self.privRooms.count > 0){
                
                    if(self.privRooms.count > indexPath.row){
                
                        cellLabel.text = self.privRooms[indexPath.row].name
                        cell.addSubview(cellView)
                    }
            }
        }
    
        

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Chat") as! ChatViewController
        
        switch collectionView.tag {
        case 0:
            vc.room = self.pubRooms[indexPath.row]
            break
        case 1:
            vc.room = self.privRooms[indexPath.row]
            break
        default: break
        }
        self.show(vc, sender: nil)
    }
    
    
    
    
    //Show Profile view
    func showProfile(){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Profile") as! ProfileViewController

        self.show(vc, sender: nil)

    }
    
    func hideLoading(){
        
        self.loadingView.isHidden = true
        
    }
}
