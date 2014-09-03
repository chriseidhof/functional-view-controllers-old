//
//  MasterViewController.swift
//  MasterDetail
//
//  Created by Chris Eidhof on 03/09/14.
//  Copyright (c) 2014 Chris Eidhof. All rights reserved.
//

import UIKit

struct Artist {
    let name : String
    let additionalInformation : String
}

let myArtists : [Artist] = [
    Artist(name: "One", additionalInformation: "Some more info"),
    Artist(name: "Two", additionalInformation: "Bla bla")
]

struct VC<From,To> {
    typealias Func = (From, (To, UINavigationController) -> ()) -> UIViewController
    let vc : Func
    
    init(_ vc: Func) {
        self.vc = vc
    }
}

func present<A>(navigationController: UINavigationController, initialValue: A, viewController: VC<A,()>) {
    let vc = viewController.vc(initialValue) { _, _ in () }
    if navigationController.viewControllers.count >= 1 {
        navigationController.pushViewController(vc, animated: true)
    } else {
        navigationController.viewControllers = [vc]
    }
    
}

let storyboard = UIStoryboard(name: "Main", bundle: nil)
let artistSelection : VC<[Artist],Artist> = VC(artistMasterViewController)
let artistDetail    : VC<Artist,()> = VC(artistDetailViewController)

func artistMasterViewController(artists: [Artist], continuation: (Artist, UINavigationController) -> ()) -> UIViewController {
    let vc = storyboard.instantiateViewControllerWithIdentifier("Artists") as MasterViewController
    vc.artists = artists
    vc.continuation = continuation
    return vc

}

func artistDetailViewController(artist: Artist, continuation: ((), UINavigationController) -> ()) -> UIViewController {
    let vc = storyboard.instantiateViewControllerWithIdentifier("Detail") as DetailViewController
    vc.artist = artist
    vc.continuation = continuation
    return vc
}



class MasterViewController: UITableViewController {
    
    var artists : [Artist]?
    var continuation: ((Artist, UINavigationController) -> ())?

    override func viewDidLoad() {
        println("load")
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("Cell")as UITableViewCell?
        cell?.textLabel.text = artists![indexPath.row].name
        
        return cell
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return artists?.count ?? 0
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        let artist = artists![indexPath.row]
        continuation?(artist, self.navigationController)
    }

}

