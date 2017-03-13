//
//  ViewController.swift
//  Project10
//
//  Created by Mehmet Sadıç on 13/03/2017.
//  Copyright © 2017 Mehmet Sadıç. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  // Store all the person info into people array
  var people = [Person]()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Add a bar button item to the left of navigation bar
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(selectImage))
  }
  
  // Define the number of items in collection view
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    // Number of items in people array is equal to number of items in collection view
    return people.count
  }
  
  // Assign image and name of the item cell
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as! PersonCell
    
    let person = people[indexPath.item]
    
    let path = getDocumentsDirectory().appendingPathComponent(person.image)
    cell.imageView.image = UIImage(contentsOfFile: path.path)
    cell.name.text = person.name
    
    return cell
  }
  
  // When the image selection is finished run the code below
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
    
    // Choose an unique name for the image chosen
    let imageName = UUID().uuidString
    
    // Find the path of image to save
    let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
    
    // Transform image to image data and save it to image path
    if let imageData = UIImageJPEGRepresentation(image, 80) {
      try? imageData.write(to: imagePath)
    }
    
    // Create a Person instance called person. The name is unknown and will be defined later
    let person = Person(name: "unknown", image: imageName)
    people.append(person)
    
    // We should reload our data so the the changes are reflected.
    collectionView?.reloadData()
    
    // dismiss the view controller which was previously selected.
    dismiss(animated: true)
  }
  
  // Run this code when the image is tapped.
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let person = people[indexPath.item]
    
    let ac = UIAlertController(title: "Choose the action to proceed", message: nil, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "Delete Image", style: .default) { [unowned self] _ in
      self.people.remove(at: indexPath.item)
      self.collectionView?.reloadData()
    })
    ac.addAction(UIAlertAction(title: "Rename Person", style: .default) { [unowned self] _ in
      self.rename(person)
    })
    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    present(ac, animated: true)


  }
  
  private func rename(_ person: Person) {
    let ac = UIAlertController(title: "Rename Person", message: nil, preferredStyle: .alert)
    ac.addTextField()
    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    ac.addAction(UIAlertAction(title: "OK", style: .default) { [unowned self, ac] _ in
      let newName = ac.textFields![0]
      person.name = newName.text!
      self.collectionView?.reloadData()
    })
    
    present(ac, animated: true)
  }
  
  private func getDocumentsDirectory() -> URL {
    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentDirectory = path[0]
    return documentDirectory
  }
  
  
  func selectImage() {
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.allowsEditing = true
    
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      picker.sourceType = .camera
    }
    
    present(picker, animated: true)
  }


}

