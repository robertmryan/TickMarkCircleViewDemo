//
//  ViewController.swift
//  TickMarkCircleViewDemo
//
//  Created by Robert Ryan on 9/4/20.
//

import UIKit
import TickMarkCircleViewDemoKit

class ViewController: UIViewController {

    @IBOutlet weak var tickCircleView: TickMarkCircleView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func handleTap(_ sender: Any) {
        let value = tickCircleView.percent

        tickCircleView.percent = 2 / 3

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.tickCircleView.percent = value
        }
    }
}

