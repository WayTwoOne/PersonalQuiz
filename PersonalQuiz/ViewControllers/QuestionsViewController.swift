//
//  ViewController.swift
//  PersonalQuiz
//
//  Created by Vladimir on 01.06.2023.
//

import UIKit

class QuestionsViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionProgressVIew: UIProgressView!
    
    @IBOutlet weak var singleStackView: UIStackView!
    @IBOutlet var singleButtons: [UIButton]!
    
    @IBOutlet weak var multipleStackVIew: UIStackView!
    @IBOutlet var multipleLabels: [UILabel]!
    @IBOutlet var MultipleSwitches: [UISwitch]!
    
    
    @IBOutlet weak var rangedStackView: UIStackView!
    @IBOutlet var rangedLabels: [UILabel]!
    @IBOutlet weak var rangedSlider: UISlider! {
        didSet {
            let answerCount = Float(currentAnswers.count - 1)
            
            rangedSlider.maximumValue = answerCount
            rangedSlider.value = answerCount / 2
        }
    }
    
    // MARK: Private Properties
    private let questions = Question.getQuestion()
    private var answerChosen: [Answer] = []
    private var questionIndex = 0 // Index of current question
    
    private var currentAnswers: [Answer] {
           questions[questionIndex].answers
       }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    // MARK: IBActions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let resultVC = segue.destination as? ResultViewController else { return }
        resultVC.answers = answerChosen
    }
    
    
    @IBAction func singleAnswersButtonPressed(_ sender: UIButton) {
        guard let currentIndex = singleButtons.firstIndex(of: sender) else { return }

           let currentAnswer = currentAnswers[currentIndex]
           answerChosen.append(currentAnswer)

           nextQuestion()
    }
    
    @IBAction func multipleQuestionButtonPressed() {
        
        for (multipleSwitch, answer) in zip(MultipleSwitches, currentAnswers) {
            if multipleSwitch.isOn {
                answerChosen.append(answer)
            }
        }
        
        nextQuestion()
    }
    
    @IBAction func rangedAnswerButtonPressed() {
        let index = lrintf(rangedSlider.value) // по этой функции получаем округленное значение до Int
        
        answerChosen.append(currentAnswers[index])
        
        nextQuestion()
    }
}


// MARK: User Interface
extension QuestionsViewController {
    private func updateUI() {
        // Hide stacks
        for stackView in [singleStackView, multipleStackVIew, rangedStackView] {
            stackView?.isHidden = true
        }
        
        // get current question
        let currentQuestion = questions[questionIndex]
        
        // set current question for question label
        questionLabel.text = currentQuestion.title
        
        // set progress for questionProgressView
        let totalProgress = Float(questionIndex) / Float(questions.count)
        
        // set progress for questionProgressView
        questionProgressVIew.setProgress(totalProgress, animated: true)
        
        title = "Вопрос №\(questionIndex + 1) из \(questions.count)"
        
        showCurrentAnswers(for: currentQuestion.type)
    }
    
    private func showCurrentAnswers(for type: ResponceType) {
        switch type {
        case .single:
            showSingleStackView(with: currentAnswers)
        case .multiple:
            ShowMultipleStackView(with: currentAnswers)
        case .ranged:
            ShowRangedStackView(with: currentAnswers)
        }
    }
    
    private func showSingleStackView(with answers: [Answer]) {
        singleStackView.isHidden = false
        
        for (button, answer) in zip(singleButtons, answers) {
            button.setTitle(answer.title, for: .normal)
        }
    }
    
    private func ShowMultipleStackView(with answers: [Answer]) {
        multipleStackVIew.isHidden = false
        
        for (label, answer) in zip(multipleLabels, answers) {
            label.text = answer.title
        }
    }
    
    private func ShowRangedStackView(with answers: [Answer]) {
        rangedStackView.isHidden = false
        
        rangedLabels.first?.text = answers.first?.title
        rangedLabels.last?.text = answers.last?.title
    }
    
    private func nextQuestion() {
        questionIndex += 1
        if questionIndex < questions.count {
            updateUI()
            return
        }
        performSegue(withIdentifier: "showResult", sender: nil)
    }
    
}
