import UIKit

class RowCategory : UITableViewCell {
    
    var type = ""
    
}

extension RowCategory : UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var puThumbs = ["http://3g28wn33sno63ljjq514qr87.wpengine.netdna-cdn.com/wp-content/uploads/2014/05/Screen-Shot-2014-05-19-at-11.23.09-AM.png","https://i.ytimg.com/vi/s5y-4EpmfRQ/maxresdefault.jpg","https://www.snapchat.com/global/social-lg.jpg","https://www.androidplanet.nl/wp-content/uploads/2016/09/instagram-uitg2-882x571.jpg"]

        
       if self.type == "public"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellHorizontal1", for: indexPath) as! PublicCollectionViewCell
        
            cell.thumbnail?.image = UIImage.contentOfURL(link: puThumbs[indexPath.row])
        
            return cell
        
        }else if self.type == "private"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellHorizontal2", for: indexPath) as! PrivateCollectionViewCell
        
            cell.thumbnail?.image = UIImage.contentOfURL(link: puThumbs[(puThumbs.count - 1) - indexPath.row ])

            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        
        
    
        print("clicked")
        
    }
   
    
    
}


