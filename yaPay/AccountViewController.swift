//
//  AccountViewController.swift
//  allPay
//
//  Created by ANGELOS CONSTANTINIDES on 10/06/2017.
//  Copyright © 2017 Angelos Constantinides. All rights reserved.
//

import UIKit
import Foundation
import CoreFoundation
import CFNetwork

class AccountViewController: UIViewController
{
    @IBOutlet weak var m_AccountLabelValue: UILabel!
    @IBOutlet weak var m_IBANNumberLabelValue: UILabel!
    @IBOutlet weak var m_BalanceLabelValue: UILabel!
    @IBOutlet weak var m_CurrencyLabelValue: UILabel!

    
    private var m_AccountNumber: String?
    private var m_IbanNumber: String?
    private var m_Balance: Double?
    private var m_Currency : String?

    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.LoadAccountDetails()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func LoadAccountDetails()
    {
        let urlString = "http://codeduomobileapi.azurewebsites.net/api/Accounts/bda8eb884efcea209b2a6240"
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with:url!) { (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                    
                    self.m_AccountNumber = parsedData["number"] as? String
                    self.m_AccountLabelValue.text=self.m_AccountNumber
                    
                    self.m_IbanNumber = parsedData["iban"] as? String
                    self.m_IBANNumberLabelValue.text = self.m_IbanNumber
                    
                    self.m_Balance = parsedData["balance"] as? Double
                    self.m_BalanceLabelValue.text = parsedData["balance"] as? String
                    
                    self.m_Currency = parsedData["currency"] as? String
                    self.m_CurrencyLabelValue.text = self.m_Currency
                    


                } catch let error as NSError {
                    print(error)
                }
            }
            
            }.resume()
    }
}
