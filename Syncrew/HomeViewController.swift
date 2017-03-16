import UIKit
import Alamofire
import JAYSON
import ChameleonFramework

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var tableview:UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loadingView: UIView!

    var headers = ["Public","Private"]

    var guttlerPageControl: GuttlerPageControl!
    let numOfpage = 7

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
                        
                        
                      
                        let video:Video = Video(title: jayson[i]["videoList"][j]["title"].string!, youtube: jayson[i]["videoList"][j]["url"].string!, playback: "https://redirector.googlevideo.com/videoplayback?mime=video%2Fmp4&pl=33&expire=1489593525&ipbits=0&beids=%5B9466593%5D&key=yt6&lmt=1474374983720626&source=youtube&ratebypass=yes&dur=342.494&signature=6153614DBA1A964DEB41403E405E366172609949.B13C5EE73D09D43AE6724C463F811DFABBFC253A&ip=2600%3A3c01%3A%3Af03c%3A91ff%3Afe24%3Ab564&requiressl=yes&sparams=dur%2Cei%2Cid%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Clmt%2Cmime%2Cmm%2Cmn%2Cms%2Cmv%2Cpcm2%2Cpl%2Cratebypass%2Crequiressl%2Csource%2Cupn%2Cexpire&id=o-AE3yuRZx8DRfP_cF9BRHcCtUL9e0XRFlWXPz--cASy6w&initcwndbps=7568750&mm=31&mn=sn-n4v7sn7y&upn=17xCGttPyww&pcm2=no&ei=VRDJWIjXEIzI-APwuIzICg&itag=22&ms=au&mt=1489571843&mv=m")
                            
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
