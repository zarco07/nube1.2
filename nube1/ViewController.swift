//
//  ViewController.swift
//  nube1
//
//  Created by Oscar Zarco on 26/08/16.
//  Copyright © 2016 oscarzarco. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet var buscarText: UITextField!
    @IBOutlet var resultadoTextView: UITextView!
    
    @IBOutlet var portada: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        buscarText.delegate = self
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func textFieldShouldReturn(textField: UITextField) -> Bool {
        buscar()
        return true
    }
    
    
    func buscar(){
        print("Inicio busqueda")
        
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + buscarText.text! //978-84-376-0494-7"
        let url = NSURL(string: urls)
        var datos : NSData? = nil
        
        do {
            datos = try NSData(contentsOfURL: url!,options: [])
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
                let dico1 = json  as! NSDictionary
                let dico2 = dico1["ISBN:"+buscarText.text!] as! NSDictionary
                let titulo = dico2["title"] as! NSString as String
                print(titulo)
                let dico3 = dico2["authors"] as! [[String : String]]
                print(dico3)
                var autores : String = ""
                for i in 1...dico3.count {
                    autores = autores + " " + (dico3[i-1]["name"] as Optional)! as String
                }

    
            let te : String = "Titulo: " + titulo + "\r" + "Autores: " + autores
            self.resultadoTextView.text = te
            }
            catch _ {
                
            }
            
            let urlsPortada = "http://covers.openlibrary.org/b/isbn/" + buscarText.text! + "-M.jpg"
            let urlPortada = NSURL(string: urlsPortada)
            do {
                let DatoPortada = try NSData(contentsOfURL: urlPortada!, options: [])
                self.portada.image = UIImage(data: DatoPortada)
            } catch _{
                
            }
            
            
        } catch {
             print("Error")
            let mensaje = UIAlertController.init(title:"Error", message: "Hay un error de conexion", preferredStyle: UIAlertControllerStyle.Alert )
            let accionOK = UIAlertAction(title: "OK",style: .Default){ accion in
                print("OK")
            }
            
            mensaje.addAction(accionOK)
            self.presentViewController(mensaje, animated: true, completion: nil)
            }
    }
       
}