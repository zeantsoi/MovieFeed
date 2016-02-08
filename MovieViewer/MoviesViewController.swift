//
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by Zean Tsoi on 2/5/16.
//  Copyright © 2016 Zean Tsoi. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorLabel: UILabel!

    var movies: [NSDictionary]?
    var endpoint: String!
    var queryString: String!
    var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

        tableView.dataSource = self
        tableView.delegate = self
        
        errorLabel.hidden = true
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshFeed:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        searchBar = UISearchBar(frame: CGRectMake(0, 0, 140, 20))
        let searchBarView = UIView(frame: searchBar.bounds)
        searchBarView.addSubview(searchBar)

        searchBarView.center = CGPoint(x: (self.navigationController?.navigationBar.center.x)!, y: 20.0)
        self.navigationController?.navigationBar.addSubview(searchBarView)
        searchBar.delegate = self
        
        refreshFeed(refreshControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let m = movies {
            return m.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String

        let baseUrl = "http://image.tmdb.org/t/p/w500/"
        if let posterPath = movie["poster_path"] as? String {
            let posterUrl = NSURL(string: baseUrl + posterPath)
            cell.posterView.setImageWithURL(posterUrl!)
        }

        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        
        let movie = movies![indexPath!.row]
        
        let detailViewController = segue.destinationViewController as! DetailViewController
        detailViewController.movie = movie
        
    }
    
    func refreshFeed(sender: UIRefreshControl) {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url: NSURL!
        if (endpoint == "search") {
            navigationController?.navigationBar.topItem!.title = nil
            searchBar.hidden = false
            if (queryString != nil) {
                url = NSURL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(queryString)")
            } else {
                url = NSURL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)")
            }
        } else {
            navigationController?.navigationBar.topItem!.title = "Movies"
            searchBar.hidden = true
            url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        }
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                            self.tableView.reloadData()
                            sender.endRefreshing()
                            self.searchBar.resignFirstResponder()
                            MBProgressHUD.hideHUDForView(self.view, animated: true)
                    }
                } else {
                    self.errorLabel.hidden = false
                }
        })
        task.resume()
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let refreshControl = UIRefreshControl()
        queryString = searchBar.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        refreshFeed(refreshControl)
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
