//
//  ViewController.swift
//  Medicine Remainder
//
//  Created by Kaushik on 11/08/22.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .white
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    @IBAction func addReminderButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "addRemainder", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addRemainder" {
            let destinationVC = segue.destination as! AddRemainderViewController
        }
    }
}

