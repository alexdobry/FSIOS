//
//  NotesViewController.swift
//  Yatodoa
//
//  Created by Alex on 28.11.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController {
    
    private struct Storyboard {
        static let UnwindSegue = "UnwindSegue"
    }
    
    var notes: String?
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textView.text = notes
    }
    
    @IBAction func done(_ sender: Any) {
        performSegue(withIdentifier: Storyboard.UnwindSegue, sender: textView.text)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case Storyboard.UnwindSegue:
            notes = sender as? String
            
        default: break
        }
    }
}
