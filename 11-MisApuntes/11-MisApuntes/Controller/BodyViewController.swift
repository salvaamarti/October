//
//  BodyViewController.swift
//  11-MisApuntes
//
//  Created by Salvador Martí Solsona on 25/09/2019.
//  Copyright © 2019 Salvador Martí Solsona. All rights reserved.
//

import UIKit
import CoreData

class BodyViewController: UIViewController {

    //Class attr
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var okButton: UIBarButtonItem!
    var apunte : Annotation?
    var modeEdit : Bool = false
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.textView.delegate = self
        self.loadAnnotation()
        self.okButton.isEnabled = false

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - Cuando el usuario hace click en trash (1) o edit (0)
    @IBAction func itemPressed(_ sender: UIBarButtonItem) {

        if self.textView.text.count > 0 {
            
            let alert = UIAlertController(title: "Delete note content", message: "¿Are you sure you want to delete this content?", preferredStyle: .actionSheet)
            let ok = UIAlertAction(title: "OK", style: .destructive) { _ in
                self.apunte?.body = ""
                DispatchQueue.main.async { self.persistAnnotations() }
                self.loadAnnotation()
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            alert.addAction(ok)
            alert.addAction(cancel)
            
            present(alert, animated: true)
            
        }
    }
    
    
    //MARK: - Action of OK Button
    @IBAction func okPressed(_ sender: UIBarButtonItem) {
        sender.isEnabled = false
        self.apunte?.body = self.textView.text
        textView.resignFirstResponder()
        
        DispatchQueue.main.async { self.persistAnnotations() }
    }
    
    //MARK: - Persist annotations core data
    
    func persistAnnotations() {
        do { try context.save() }
        catch { print("Error al intentar guardar el contexto: \(error)") }
    }
    
    
    func loadAnnotation() ->  Void {
        self.navigationItem.title = apunte?.title
        self.textView.text = self.apunte?.body
    }

}

extension BodyViewController : UITextViewDelegate {

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.okButton.isEnabled = true
        return true
    }
}
