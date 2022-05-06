//
//  GameViewController.swift
//  WordGame
//
//  Created by Joel Kingsley on 05/05/2022.
//

import UIKit

// MARK: - GameViewControllerDelegate

protocol GameViewControllerDelegate: AnyObject {}

// MARK: - GameViewController

/**
 View Controller to display game screen
 */
class GameViewController: UIViewController {
    // MARK: - Properties
    
    let gameViewModel: GameViewModel

    weak var parentingCoordinator: GameViewControllerDelegate?
    
    // MARK: - UI Components
    
    let correctAttemptsLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizationKey.gameScreenCorrectAttemptsCounter(attempts: 0).string
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    let wrongAttemptsLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizationKey.gameScreenWrongAttemptsCounter(attempts: 0).string
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    let spanishTranslationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    let englishStringLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()
    
    let correctButton: UIButton = {
        let button = UIButton()
        button.setTitle(LocalizationKey.gameScreenCorrectButtonLabel.string, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let wrongButton: UIButton = {
        let button = UIButton()
        button.setTitle(LocalizationKey.gameScreenWrongButtonLabel.string, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    // MARK: - Lifecycle
    
    init(gameViewModel: GameViewModel) {
        self.gameViewModel = gameViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureViewController()
        
        // Start game
        getRandomWordPair()
    }
    
    // MARK: - UI Helpers

    func configureViewController() {
        view.addSubview(correctAttemptsLabel)
        view.addSubview(wrongAttemptsLabel)
        view.addSubview(spanishTranslationLabel)
        view.addSubview(englishStringLabel)
        view.addSubview(buttonStackView)
        
        correctAttemptsLabel.translatesAutoresizingMaskIntoConstraints = false
        correctAttemptsLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        correctAttemptsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        wrongAttemptsLabel.translatesAutoresizingMaskIntoConstraints = false
        wrongAttemptsLabel.rightAnchor.constraint(equalTo: correctAttemptsLabel.rightAnchor).isActive = true
        wrongAttemptsLabel.topAnchor.constraint(equalTo: correctAttemptsLabel.bottomAnchor, constant: 10).isActive = true
        
        englishStringLabel.translatesAutoresizingMaskIntoConstraints = false
        englishStringLabel.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 20).isActive = true
        englishStringLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        spanishTranslationLabel.translatesAutoresizingMaskIntoConstraints = false
        spanishTranslationLabel.bottomAnchor.constraint(equalTo: englishStringLabel.topAnchor, constant: -20).isActive = true
        spanishTranslationLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        buttonStackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        buttonStackView.addArrangedSubview(correctButton)
        buttonStackView.addArrangedSubview(wrongButton)
        
        correctButton.addTarget(self, action: #selector(handleCorrect), for: .touchUpInside)
        wrongButton.addTarget(self, action: #selector(handleWrong), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc func handleCorrect() {
        validateUserResponse(isCorrect: true)
    }
    
    @objc func handleWrong() {
        validateUserResponse(isCorrect: false)
    }
    
    // MARK: - Methods
    
    func getRandomWordPair() {
        switch gameViewModel.getRandomWordPair() {
        case let .success(wordPair):
            self.englishStringLabel.text = wordPair.textEnglish
            self.spanishTranslationLabel.text = wordPair.textSpanish
        case let .failure(error):
            fatalError("Unexpectedly got error while getting random word pair: \(error)")
        }
    }
    
    func validateUserResponse(isCorrect: Bool) {
        switch gameViewModel.validateUserResponse(isCorrect: isCorrect) {
        case let .success((correctAttempts, inCorrectAttempts)):
            correctAttemptsLabel.text = LocalizationKey.gameScreenCorrectAttemptsCounter(attempts: correctAttempts).string
            wrongAttemptsLabel.text = LocalizationKey.gameScreenWrongAttemptsCounter(attempts: inCorrectAttempts).string
            
            // Go to next word pair
            getRandomWordPair()
        case let .failure(error):
            fatalError("Unexpectedly got error while validating user response: \(error)")
        }
    }
}
