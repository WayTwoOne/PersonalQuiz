//
//  ResultViewController.swift
//  PersonalQuiz
//
//  Created by Vladimir on 02.06.2023.
//

import UIKit

class ResultViewController: UIViewController {
    
    
    @IBOutlet weak var youAreLable: UILabel!
    @IBOutlet weak var whoAreYouLabel: UILabel!
    
    var answers: [Answer] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
//        getResult(with: results)
        getResults()
    }
    
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
//        navigationController?.dismiss(animated: true)  если нет модального перехода то через этот метод можно закрыть
//       view.window?.rootViewController?.dismiss(animated: true)  если нет навигейшн котроллера то так можно закрыть
    }
}

extension ResultViewController {
    
    private func getResults() {
        var frequencyOfAnimalType: [AnimalType: Int] = [:]
        let animals = answers.map { $0.type }
        
        for animal in animals {
            if let animalTypeCount = frequencyOfAnimalType[animal] {
                frequencyOfAnimalType.updateValue(animalTypeCount + 1, forKey: animal)
            } else {
                frequencyOfAnimalType[animal] = 1
            }
        }
        
        let sortedFrequencyOfAnimalType = frequencyOfAnimalType.sorted { $0.value > $1.value }
        guard let mostFrequencyOfAnimalType = sortedFrequencyOfAnimalType.first?.key else { return }
        
        updateUI(with: mostFrequencyOfAnimalType)
    }
    
    private func updateUI(with animal: AnimalType) {
        youAreLable.text = "Вы - \(animal.rawValue)"
        whoAreYouLabel.text = "\(animal.definition)"
    }
    
    
//    private func getResult(with: [Answer]) {
//
//        var dogs = 0
//        var cats = 0
//        var rabbits = 0
//        var turtles = 0
//
//        for result in results {
//            if result.type == .dog {
//                dogs += 1
//            } else if result.type == .cat {
//                cats += 1
//            } else if result.type == .rabbit {
//                rabbits += 1
//            } else {
//                turtles += 1
//            }
//        }
//
//        if dogs > cats && dogs > rabbits && dogs > turtles {
//            youAreLable.text = "Вы - \(AnimalType.dog.rawValue)"
//            whoAreYouLabel.text = "\(AnimalType.dog.definition)"
//        } else if cats > dogs && cats > rabbits && cats > turtles {
//            youAreLable.text = "Вы - \(AnimalType.cat.rawValue)"
//            whoAreYouLabel.text = "\(AnimalType.cat.definition)"
//        } else if rabbits > dogs && rabbits > cats && rabbits > turtles {
//            youAreLable.text = "Вы - \(AnimalType.rabbit.rawValue)"
//            whoAreYouLabel.text = "\(AnimalType.rabbit.definition)"
//        } else {
//            youAreLable.text = "Вы - \(AnimalType.turtle.rawValue)"
//            whoAreYouLabel.text = "\(AnimalType.turtle.definition)"
//        }
//    }
}
