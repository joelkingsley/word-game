//
//  GameViewController.swift
//  WordGame
//
//  Created by Joel Kingsley on 05/05/2022.
//

import UIKit
import Combine

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
    
    var cancellables = Set<AnyCancellable>()
    
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
        bindViewModel()
        startGame()
    }
    
    deinit {
        print(".... GameViewController deinitialized")
    }
    
    func startGame() {
        gameViewModel.setNextRandomWordPair()
        gameViewModel.initializeAndStartRoundTimer()
        gameViewModel.restartAnimationSubject.send()
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
    
    func bindViewModel() {
        gameViewModel.gameState.sink { [weak self] gameState in
            self?.englishStringLabel.text = gameState.currentWordPair?.textEnglish
            self?.spanishTranslationLabel.text = gameState.currentWordPair?.textSpanish
            self?.correctAttemptsLabel.text = LocalizationKey.gameScreenCorrectAttemptsCounter(
                attempts: gameState.correctAttempts).string
            self?.wrongAttemptsLabel.text = LocalizationKey.gameScreenWrongAttemptsCounter(
                attempts: gameState.incorrectAttempts).string
        }.store(in: &cancellables)
        
        gameViewModel.restartAnimationSubject.sink { [weak self] _ in
            self?.restartAnimation()
        }.store(in: &cancellables)
        
        gameViewModel.endAnimationSubject.sink { [weak self] _ in
            self?.spanishTranslationLabel.layer.removeAllAnimations()
        }.store(in: &cancellables)
        
        gameViewModel.presentGameOverModalSubject.sink { [weak self] _ in
            self?.presentGameOverModal()
        }.store(in: &cancellables)
    }
    
    func restartAnimation() {
        spanishTranslationLabel.layer.removeAllAnimations()
        spanishTranslationLabel.textColor = textColors.randomElement() ?? .systemBrown
        spanishTranslationLabel.frame = CGRect(
            x: 0,
            y: view.frame.minY + 100,
            width: view.frame.size.width,
            height: 50
        )
        spanishTranslationLabel.layoutIfNeeded()
        
        UIView.animate(withDuration: 6.0, delay: 0, options: .curveLinear) { [weak self] in
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
        }
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
                    // Reset game state and restart game
                    self?.gameViewModel.gameState.value = GameState()
                    self?.startGame()
                }))
        alert.addAction(
            UIAlertAction(
                title: LocalizationKey.gameOverModalRejectActionLabel.string,
                style: .default,
                handler: { [weak self] _ in
                    // Exit the app
                    self?.parentingCoordinator?.exitApp()
                }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    
    @objc func handleCorrect() {
        gameViewModel.validateUserResponse(isCorrect: true)
        gameViewModel.checkAndLoadNextRound()
    }
    
    @objc func handleWrong() {
        gameViewModel.validateUserResponse(isCorrect: false)
        gameViewModel.checkAndLoadNextRound()
    }
}
