import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol = QuestionFactory(moviesLoader: MoviesLoader(), delegate: nil)
    private var currentQuestion: QuizQuestion?
    private var statisticService: StatisticService?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        
        statisticService = StatisticServiceImplementation()
        showLoadingIndicator()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // добавил паузу чтобы можно было увидеть индикатор загрузки
            self.questionFactory.loadData()
        }
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        if currentQuestion.correctAnswer == true{
            showAnswerResult(true)
        }else {
            showAnswerResult(false)
        }
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        if currentQuestion.correctAnswer == false{
            showAnswerResult(true)
        }else {
            showAnswerResult(false)
        }
    }
    
    private func showAnswerResult(_ isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        
        if isCorrect {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            correctAnswers+=1
        }else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        yesButton.isEnabled = false
        noButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.imageView.layer.borderWidth = 0
            self.showNextQuestionOrResults()
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
        }
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func show(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        textLabel.text = step.question
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alertModel = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText,
            completion: {
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                self.questionFactory.requestNextQuestion()
            }
        )
        
        AlertPresenter.presentAlert(with: alertModel, from: self)
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 { // 1
            statisticService?.store(correct: correctAnswers, total: 10)
            guard let statisticService = statisticService else {
                return
            }
            let accuracy = String(format: "%.2f",statisticService.totalAccuracy)
            let model = QuizResultsViewModel(title: "Этот раунд окончен!", text: """
    Ваш результат: \(correctAnswers)/10\nКоличество сыгранных квизов: \(String(describing:
    statisticService.gamesCount))\nРекорд:\(String(describing:
    statisticService.bestGame!.correct))/\(String(describing: statisticService.bestGame!.total)) \(String(describing:
    statisticService.bestGame!.date.dateTimeString))\nСредняя точность: \(accuracy)%
    """, buttonText: "Сыграть ещё раз")
            show(quiz: model)
            
        } else { // 2
            currentQuestionIndex += 1
            
            questionFactory.requestNextQuestion()
        }
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator() // скрываем индикатор загрузки
        
        let alertModel = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать еще раз",
            completion: {
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                self.questionFactory.requestNextQuestion()
            }
        )
        
        AlertPresenter.presentAlert(with: alertModel, from: self)
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        
        questionFactory.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
}
