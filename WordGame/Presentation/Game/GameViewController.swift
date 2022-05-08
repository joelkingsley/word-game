//
//  GameViewController.swift
//  WordGame
//
//  Created by Joel Kingsley on 05/05/2022.
//

import UIKit

// MARK: - GameViewControllerDelegate

protocol GameViewControllerDelegate: AnyObject {
    func exitApp()
}

// MARK: - GameViewController

/**
 View Controller to display game screen
 */
class GameViewController: UIViewController {
    // MARK: - Properties
    
    let gameViewModel: GameViewModel

    var parentingCoordinator: GameViewControllerDelegate?
    
    // MARK: - UI Components
    
    let correctAttemptsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    let wrongAttemptsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    let spanishTranslationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    let englishStringLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
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
    
    let textColors: [UIColor] = [
        .systemRed,
        .systemBlue,
        .systemBrown,
        .systemGray
    ]
    
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

        startGame()
    }
    
    deinit {
        print(".... GameViewController deinitialized")
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
    
    func startGame() {
        correctAttemptsLabel.text = LocalizationKey.gameScreenCorrectAttemptsCounter(attempts: 0).string
        wrongAttemptsLabel.text = LocalizationKey.gameScreenWrongAttemptsCounter(attempts: 0).string
        
        getRandomWordPair()
        initializeAndStartRoundTimer()
        startSpanishTranslationAnimation()
    }
    
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
            /*
             Update correct attempts and incorrect attempts after validating user response.
             
             Then check and load next question.
             */
            correctAttemptsLabel.text = LocalizationKey.gameScreenCorrectAttemptsCounter(attempts: correctAttempts).string
            wrongAttemptsLabel.text = LocalizationKey.gameScreenWrongAttemptsCounter(attempts: inCorrectAttempts).string
            
            checkAndLoadNextQuestion()
        case let .failure(error):
            fatalError("Unexpectedly got error while validating user response: \(error)")
        }
    }
    
    func initializeAndStartRoundTimer() {
        gameViewModel.initializeAndStartRoundTimer { [weak self] in
            /*
             NOTE: If timer gets fired, it means that 5 seconds has passes, and the attempt is considered as incorrect.
             
             Update incorrect attempts, and check and load next question.
             */
            self?.gameViewModel.gameState.inCorrectAttempts += 1
            guard let inCorrectAttempts = self?.gameViewModel.gameState.inCorrectAttempts else {
                fatalError("Unexpectedly got error while handling timer fire")
            }
            self?.wrongAttemptsLabel.text = LocalizationKey.gameScreenWrongAttemptsCounter(
                attempts: inCorrectAttempts).string
            
            self?.checkAndLoadNextQuestion()
        }
    }
    
    func checkAndLoadNextQuestion() {
        // Check if game should end
        if gameViewModel.checkIfGameShouldEnd() {
            gameViewModel.roundTimer?.stop()
            spanishTranslationLabel.layer.removeAllAnimations()
            presentGameOverModal()
            return
        }
        
        // Go to next word pair
        getRandomWordPair()
        
        // Reset and start question timer
        gameViewModel.resetRoundTimer()
        
        // Restart spanish translation animation
        startSpanishTranslationAnimation()
    }
    
    func presentGameOverModal() {
        let alert = UIAlertController(
            title: LocalizationKey.gameOverModalTitle.string,
            message: LocalizationKey.gameOverModalMessage.string,
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(
                title: LocalizationKey.gameOverModalAcceptActionLabel.string,
                style: .default,
                handler: { [weak self] _ in
                    // Reset game state
                    self?.gameViewModel.gameState = GameState(
                        correctAttempts: 0,
                        inCorrectAttempts: 0,
                        currentWordPair: nil,
                        wordPairsSeen: 0
                    )
                    self?.startGame()
                }))
        alert.addAction(
            UIAlertAction(
                title: LocalizationKey.gameOverModalRejectActionLabel.string,
                style: .default,
                handler: { [weak self] _ in
                    // Exit the app
                    guard let self = self else { return }
                    guard let parentingCoordinator = self.parentingCoordinator else {
                        return
                    }
                    parentingCoordinator.exitApp()
                }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func startSpanishTranslationAnimation() {
        spanishTranslationLabel.layer.removeAllAnimations()
        spanishTranslationLabel.textColor = textColors.randomElement() ?? .systemBrown
        spanishTranslationLabel.frame = CGRect(
            x: 0,
            y: view.frame.minY + 100,
            width: view.frame.size.width,
            height: 50
        )
        spanishTranslationLabel.layoutIfNeeded()
        
        UIView.animate(withDuration: 5.0, delay: 0, options: .curveLinear) { [weak self] in
            guard let self = self else {
                return
            }
            self.spanishTranslationLabel.frame = CGRect(
                x: 0,
                y: self.view.frame.maxY - (50+100),
                width: self.view.frame.size.width,
                height: 50
            )
            self.spanishTranslationLabel.layoutIfNeeded()
        } completion: { completed in
            print("Animation completed: \(completed)")
        }
    }
}
