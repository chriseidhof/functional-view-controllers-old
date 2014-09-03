//
//  MasterViewController.swift
//  MasterDetail
//
//  Created by Chris Eidhof on 03/09/14.
//  Copyright (c) 2014 Chris Eidhof. All rights reserved.
//

import UIKit

struct Artist {
    let name: String
    let additionalInformation: String
    let albums: [Album]
}

struct Album {
    let name: String
}

let myArtists : [Artist] = [
    Artist(name: "Death Cab for Cutie", additionalInformation: "Some more info", albums: [Album(name: "Transatlanticism")]),
    Artist(name: "The XX", additionalInformation: "Bla bla", albums: [Album(name: "The XX")])
]


let storyboard = UIStoryboard(name: "Main", bundle: nil)

let artistSelection : VC<[Artist],Either<Artist,[Album]>> = VC(artistMasterViewController)
let artistDetail    : VC<Artist,()> = VC(artistDetailViewController)
let albumSelection  : VC<[Album],()> = VC(albumsViewController)

func artistMasterViewController(artists: [Artist], continuation: (Either<Artist,[Album]>, UINavigationController) -> ()) -> UIViewController {
    let vc = storyboard.instantiateViewControllerWithIdentifier("Artists") as MasterViewController
    vc.artists = artists
    vc.continuation = continuation
    return vc
}

func albumsViewController(albums: [Album], continuation: ((), UINavigationController) -> ()) -> UIViewController {
    let vc = storyboard.instantiateViewControllerWithIdentifier("Albums") as AlbumsViewController
    vc.albums = albums
    vc.continuation = {_, x in continuation((), x) }
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
    var continuation: ((Either<Artist,[Album]>, UINavigationController) -> ())?

    override func viewDidLoad() {
        println("load")
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("Cell")as UITableViewCell?
        cell?.textLabel.text = artists![indexPath.row].name
        cell?.accessoryType = UITableViewCellAccessoryType.DetailDisclosureButton
        

        
        return cell
    }
    
    override func tableView(tableView: UITableView!, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath!) {
        let artist = artists![indexPath.row]
        continuation?(.Left(Box(artist)), self.navigationController)
    }

    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return artists?.count ?? 0
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        let artist = artists![indexPath.row]
        continuation?(.Right(Box(artist.albums)), self.navigationController)
    }

}

// TODO: this is exactly the same as above. Not sure if it is currently possible to make this generic...

class AlbumsViewController : UITableViewController {
    
    var albums : [Album]?
    var continuation: ((Album, UINavigationController) -> ())?
    
    override func viewDidLoad() {
        println("load")
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell?
        cell?.textLabel.text = albums![indexPath.row].name
        
        return cell
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return albums?.count ?? 0
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        let artist = albums![indexPath.row]
        continuation?(artist, self.navigationController)
    }
    
}


