//
//  ViewController.swift
//  FirestoreCrud
//
//  Created by Colimasoft on 02/03/22.
//

import UIKit
import FirebaseFirestore

struct Peliculas {
    var titulo: String
    var genero: String
    var id: String
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tabla: UITableView!
    
    var db: Firestore!
    var lista = [Peliculas]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self
        db = Firestore.firestore()
        traerDatosRealTime()
        //traerDatosWhere()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //traerDatos()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lista.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tabla.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let pelicula = lista[indexPath.row]
        cell.textLabel?.text = pelicula.titulo
        cell.detailTextLabel?.text = pelicula.genero
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Eliminar") { (_,_,_) in
            let pelicula: Peliculas
            pelicula = self.lista[indexPath.row]
            let id = pelicula.id
            self.db.collection("peliculas").document(id).delete()
        }
        let configuracion = UISwipeActionsConfiguration(actions: [delete])
        return configuracion
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "editar", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editar" {
            if let id = tabla.indexPathForSelectedRow {
                let fila = lista[id.row]
                let destino = segue.destination as! GuardarViewController
                destino.editarPelicula = fila
            }
        }
    }

    func traerDatos(){
        db.collection("peliculas").getDocuments { (querySnapshot,error) in
            if let error = error {
                print("Error al traer los datos", error.localizedDescription)
            }else{
                self.lista.removeAll()
                for document in querySnapshot!.documents{
                    let valores = document.data()
                    let id = document.documentID
                    let titulo = valores["titulo"] as? String ?? "Sin titulo"
                    let genero = valores["genero"] as? String ?? "Sin genero"
                    let pelicula = Peliculas(titulo: titulo, genero: genero, id: id)
                    self.lista.append(pelicula)
                    DispatchQueue.main.async {
                        self.tabla.reloadData()
                    }
                }
            }
        }
    }
    
    func traerDatosRealTime(){
        db.collection("peliculas").addSnapshotListener { (querySnapshot,error) in
            if let error = error {
                print("Error al traer los datos", error.localizedDescription)
            }else{
                self.lista.removeAll()
                for document in querySnapshot!.documents{
                    let valores = document.data()
                    let id = document.documentID
                    let titulo = valores["titulo"] as? String ?? "Sin titulo"
                    let genero = valores["genero"] as? String ?? "Sin genero"
                    let pelicula = Peliculas(titulo: titulo, genero: genero, id: id)
                    self.lista.append(pelicula)
                    DispatchQueue.main.async {
                        self.tabla.reloadData()
                    }
                }
            }
        }
    }
    
    func traerDatosWhere(){
        db.collection("peliculas").whereField("genero", isEqualTo: "Drama").getDocuments { (querySnapshot, error)in
            if let error = error {
                print("Error al traer los datos", error.localizedDescription)
            }else{
                self.lista.removeAll()
                for document in querySnapshot!.documents{
                    let valores = document.data()
                    let id = document.documentID
                    let titulo = valores["titulo"] as? String ?? "Sin titulo"
                    let genero = valores["genero"] as? String ?? "Sin genero"
                    let pelicula = Peliculas(titulo: titulo, genero: genero, id: id)
                    self.lista.append(pelicula)
                    DispatchQueue.main.async {
                        self.tabla.reloadData()
                    }
                }
            }
        }
    }
}

