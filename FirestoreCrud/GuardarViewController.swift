//
//  GuardarViewController.swift
//  FirestoreCrud
//
//  Created by Colimasoft on 02/03/22.
//

import UIKit
import FirebaseFirestore

class GuardarViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var titulo: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    
    let generos = ["Acción",  "Aventuras", "Ciencia Ficción", "Terror", "Drama"]
    var genero = ""
    let db = Firestore.firestore()
    var editarPelicula: Peliculas?
    var id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.dataSource = self
        titulo.text = editarPelicula?.titulo
        genero = editarPelicula?.genero ?? "sin genero"
        id = editarPelicula?.id ?? "vacio"
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return generos.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return generos[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genero =  generos[row]
        print(genero)
    }
    
    @IBAction func guardar(_ sender: UIButton) {
        let campos: [String:Any] = ["titulo": titulo.text ?? "sin titulo", "genero": genero]
        if id == "vacio" {
            db.collection("peliculas").addDocument(data: campos) { (error) in
                if let error = error {
                    print("Fallo al guardar", error.localizedDescription)
                }else{
                    print("Guardo correctamente")
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }else{
            db.collection("peliculas").document(id).setData(campos) { (error) in
                if let error = error {
                    print("Fallo al actualizar", error.localizedDescription)
                }else{
                    print("Edito correctamente")
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
}
