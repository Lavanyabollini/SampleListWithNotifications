//
//  ViewController.swift
//  SampleList
//
//  Created by TailWebs on 06/08/18.
//  Copyright © 2018 Tailwebs. All rights reserved.
//

import UIKit
import  CoreData
class ViewController: UIViewController,UITextFieldDelegate ,UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate{
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var scoreTextField: UITextField!
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var userDetails:[NSManagedObject] = []
    var picker  = UIPickerView()
    var subjectArray = ["Maths","Physics","Chemistry"]
    @IBOutlet weak var detailsScrollView: UIScrollView!
    var tap : UITapGestureRecognizer?
    
    
    //MARK:-View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.becomeFirstResponder()
        //methos to add picker view to tableview
        addPicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // add observer to notify when the keyboard opens
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        // add observer to notify when the keyboard close
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    func addPicker()
    {
        picker.delegate = self
        subjectTextField.inputView = picker
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelPicker))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        subjectTextField.inputAccessoryView = toolBar
        
    }
    
    @objc func donePicker (sender:UIBarButtonItem)
    {
        scoreTextField.becomeFirstResponder()
        
    }
    
    @objc func cancelPicker (sender:UIBarButtonItem)
    {
        self.view.endEditing(true)
    }
    //MARK:-UITextfield delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField{
            nameTextField.resignFirstResponder()
            subjectTextField.becomeFirstResponder()
        }else if textField == subjectTextField{
            subjectTextField.resignFirstResponder()
            scoreTextField.becomeFirstResponder()
        }else if textField == scoreTextField{
            scoreTextField.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool  {
        if textField == subjectTextField {
            return false
        }else{
            return true
        }
    }
    
    //MARK:- IBAction
    @IBAction func  saveClicked(sender:Any){
        //custom method to check the record already exist or not and if exist update the data otherwise add the new data
        if !((nameTextField.text?.isEmpty)!) && !((subjectTextField.text?.isEmpty)!) && !((scoreTextField.text?.isEmpty)!){
            self.fetchRecordAndUpdateData()
            addAlert(title: "Success", message: "Details saved successfully")
        }else{
            addAlert(title: "Error", message: "Please enter all the fields")
        }
    }
    
    func addAlert(title:String,message:String){
        
        //alert to show the success message
        let alert = UIAlertController(title:title, message: message, preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) { _ in
            self.nameTextField.text = nil
            self.subjectTextField.text = nil
            self.scoreTextField.text = nil
        }
        // relate action to controller
        alert.addAction(dismiss)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func  listButtonClicked(sender:Any){
    }
    
    //custom method
    func fetchRecordAndUpdateData(){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSFetchRequestResult>(entityName: "UserDetails")
        fetchRequest.predicate = NSPredicate(format: "name = %@ AND subject = %@",argumentArray: [nameTextField.text as Any, subjectTextField.text as Any])
        do {
            userDetails = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            // if same record exist update
            if userDetails.count != 0 {
                let score =  userDetails[0].value(forKeyPath: "score") as? String
                if let score = score, let newScore = scoreTextField.text{
                    let finalScore = Int(score)! + Int(newScore)!
                    userDetails[0].setValue(String(finalScore), forKey: "score")
                }
            }else{
                let entity =
                    NSEntityDescription.entity(forEntityName: "UserDetails",
                                               in: managedContext)!
                
                let user = NSManagedObject(entity: entity,
                                           insertInto: managedContext)
                user.setValue(nameTextField.text, forKeyPath: "name")
                user.setValue(subjectTextField.text, forKeyPath: "subject")
                user.setValue(scoreTextField.text, forKeyPath: "score")
            }
            try managedContext.save()
        } catch
            let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    //MARK:- Pickerview datsource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return subjectArray.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return subjectArray[row]
    }
    
    //MARK:-Pickerview delgate
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        subjectTextField.text = subjectArray[row]
    }
    
    // MARK: Keyboard
    @objc func keyboardWillHide(_ sender: Notification) {
        // remove the gesture to activate tableview selection
        if tap != nil {
            detailsScrollView.removeGestureRecognizer(tap!)
            tap = nil
        }
        detailsScrollView.contentInset = UIEdgeInsets.zero
        detailsScrollView.scrollIndicatorInsets = UIEdgeInsets.zero
        detailsScrollView.contentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.height)
    }
    @objc func keyboardWillShow(_ sender: Notification) {
        // add tap gesture to hide keyboard when tap anywhere on the screen
        if tap == nil {
            tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapHideKeyboard(_:)))
            tap!.delegate = self
            detailsScrollView.addGestureRecognizer(tap!)
        }
        let userInfo: Dictionary = sender.userInfo! as Dictionary
        let keyBoardInfo = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect
        let keyBoardSize =  keyBoardInfo?.size
        
        let contentInsets = UIEdgeInsets(top:50, left: 0, bottom: (keyBoardSize?.height)!, right: 0)
        //set the content size  to scrollview to scroll
        detailsScrollView.contentInset = contentInsets
        detailsScrollView.scrollIndicatorInsets = contentInsets
        
        var viewRect = self.view.frame
        viewRect.size.height -= keyBoardSize?.height ?? 0
        if !viewRect.contains(self.saveButton.frame.origin){
            self.detailsScrollView.scrollRectToVisible(self.saveButton.frame, animated: true)
        }
    }
    
    // Handle Tap Guesture used to open the links or Images in other page or controller
    @objc func handleTapHideKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}

