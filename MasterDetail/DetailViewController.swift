//
//  DetailViewController.swift
//  MasterDetail
//
//  Created by Chris Eidhof on 03/09/14.
//  Copyright (c) 2014 Chris Eidhof. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    var artist: Artist? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    var continuation : (((), UINavigationController) -> ())?

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.artist {
            if let label = self.detailDescriptionLabel {
                label.text = detail.additionalInformation
            }
            self.title = detail.name
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

