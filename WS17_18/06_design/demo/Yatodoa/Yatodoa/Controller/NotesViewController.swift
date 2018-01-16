//
//  NotesViewController.swift
//  Yatodoa
//
//  Created by Alex on 28.11.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController {
    
    struct Storyboard {
        static let TextViewPlaceholder = "Notiz..."
        static let UnwindSegueIdentifier = "NotesUnwindSegueIdentifier"
    }

    var notes: String?
    
    @IBOutlet weak var notesTextView: UITextView! {
        didSet { notesTextView.delegate = self }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        notesTextView.text = notes
    }
    
    deinit {
        print(#file, #function)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: Storyboard.UnwindSegueIdentifier, sender: notesTextView.text)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case Storyboard.UnwindSegueIdentifier:
            notes = sender as? String
            
        default: break
        }
    }
}

extension NotesViewController: UITextViewDelegate {
    
     func textViewDidBeginEditing(_ textView: UITextView) {
         if textView.text == Storyboard.TextViewPlaceholder {
            textView.text = ""
         }
     }
    
     func textViewDidEndEditing(_ textView: UITextView) {
         if textView.text.isEmpty {
            textView.text = Storyboard.TextViewPlaceholder
         }
     }
 }
