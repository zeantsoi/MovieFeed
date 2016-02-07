//
//  DetailViewController.swift
//  MovieViewer
//
//  Created by Zean Tsoi on 2/6/16.
//  Copyright © 2016 Zean Tsoi. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var infoView: UIView!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, infoView.frame.origin.y + infoView.frame.size.height)
        
        let title = movie["title"] as? String
        
        titleLabel.text = title
        overviewLabel.text = movie["overview"] as? String

        overviewLabel.sizeToFit()

        let baseUrl = "http://image.tmdb.org/t/p/w500/"
        if let posterPath = movie["poster_path"] as? String {
            let posterUrl = NSURL(string: baseUrl + posterPath)
            self.posterImageView.setImageWithURL(posterUrl!)
        }
        
//        let labelTitle = UILabel(frame: CGRectZero);
//        labelTitle.text = "Title";
//        labelTitle.textAlignment = NSTextAlignment.Center
//        
//        self.navigationController!.navigationBar.topItem!.title = title
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
