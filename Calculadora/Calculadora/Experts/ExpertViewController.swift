//
//  ExpertViewController.swift
//  Calculadora
//
//  Created by Nicholas Forte on 30/08/25.
//

import Foundation
import UIKit
import SwiftUI

final class ExpertViewController: UIViewController {
    // UI
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()

    private let nameField = ExpertTextField()
    private let ageField = ExpertTextField()
    private let regionField = ExpertTextField()
//    private let expField = ExpandingTextViewController()
    private let expField: ExpandingTextView = {
        let tv = ExpandingTextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = .systemFont(ofSize: 16)
        tv.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
        tv.maxHeight = 200 // ajuste como quiser
        return tv
    }()

    private let summarizeButton = UIButton(type: .system)

//    // Inline AI section
//    private let aiSectionTitle = UILabel()
//    private let aiTextView = UITextView()
//    private let openInNewScreenButton = UIButton(type: .system)

    // Services
    private let summarizer: AISummarizing

    // MARK: - Init
    init(summarizer: AISummarizing = LocalAISummarizer()) {
        self.summarizer = summarizer
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    lazy var centralLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Como posso te ajudar em sua missão?"
        lbl.font = UIFont.systemFont(ofSize: 28)
        lbl.numberOfLines = 2
        lbl.lineBreakMode = .byWordWrapping
       return lbl
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupKeyboardHandling()
        setupTapToDismiss()
        setupBehavior()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - UI Setup
    private func setupUI() {
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(centralLabel)
        view.addSubview(expField)
        view.addSubview(summarizeButton)
//        NSLayoutConstraint.activate([
//            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])

//        contentStack.axis = .vertical
//        contentStack.spacing = 12
//        contentStack.translatesAutoresizingMaskIntoConstraints = false
////        scrollView.addSubview(contentStack)
//        NSLayoutConstraint.activate([
//            contentStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
//            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            contentStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24)
//        ])

        // Fields
//        contentStack.addArrangedSubview(makeFieldBlock(title: "Nome", field: nameField, placeholder: "Seu nome completo"))
//        contentStack.addArrangedSubview(makeFieldBlock(title: "Região", field: regionField, placeholder: "Cidade/Estado/País"))
//        contentStack.addArrangedSubview(expField)
        // Action button
        centralLabel.translatesAutoresizingMaskIntoConstraints = false
        expField.translatesAutoresizingMaskIntoConstraints = false
        summarizeButton.translatesAutoresizingMaskIntoConstraints = false
        
        summarizeButton.setTitle("Resumir com IA", for: .normal)
        summarizeButton.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        summarizeButton.configuration = .filled()
        summarizeButton.addTarget(self, action: #selector(didTapSummarize), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            centralLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            centralLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 16),
            centralLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            centralLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    
        NSLayoutConstraint.activate([
            summarizeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            summarizeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            summarizeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -104)
        ])
        
        NSLayoutConstraint.activate([
            expField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            expField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            expField.bottomAnchor.constraint(equalTo: summarizeButton.topAnchor, constant: -24)
        ])

        
//        contentStack.addArrangedSubview(summarizeButton)

        // AI Section
//        aiSectionTitle.text = "Resumo (IA)"
//        aiSectionTitle.font = .preferredFont(forTextStyle: .title3)
//        contentStack.addArrangedSubview(aiSectionTitle)
//
//        aiTextView.isEditable = false
//        aiTextView.text = "O resumo aparecerá aqui após gerar."
//        aiTextView.font = .preferredFont(forTextStyle: .body)
//        aiTextView.textColor = .secondaryLabel
//        aiTextView.backgroundColor = .secondarySystemBackground
//        aiTextView.layer.cornerRadius = 12
//        aiTextView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
//        aiTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 140).isActive = true
//        contentStack.addArrangedSubview(aiTextView)
//
//        openInNewScreenButton.setTitle("Abrir em nova tela", for: .normal)
//        openInNewScreenButton.addTarget(self, action: #selector(openSummaryScreen), for: .touchUpInside)
//        openInNewScreenButton.isHidden = true
//        contentStack.addArrangedSubview(openInNewScreenButton)
    }

    private func makeFieldBlock(title: String, field: ExpertTextField, placeholder: String, keyboard: UIKeyboardType = .default, experiencesField: Bool = false) -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .preferredFont(forTextStyle: .subheadline)
        field.borderStyle = .roundedRect
        field.placeholder = placeholder
        field.keyboardType = keyboard
        field.autocorrectionType = .no
        field.autocapitalizationType = .words
        field.returnKeyType = .next
        field.heightAnchor.constraint(equalToConstant: experiencesField ? 150 : 44).isActive = true

        let stack = UIStackView(arrangedSubviews: [titleLabel, field])
        stack.axis = .vertical
        stack.spacing = 6
        return stack
    }
    
    private var spinner = UIActivityIndicatorView()
    
    private var loadingVC: LoadingViewController? // Armazena a instância do loading
    private func setupBookLoadingView() {
        loadingVC = LoadingViewController.show(on: self)
    }
    
    
    @objc private func simulateLoading() {
        // 1. Mostrar o loading
        loadingVC = LoadingViewController.show(on: self)
    }

    // Exemplo de como você poderia remover o loading view quando a tarefa estiver completa
    func hideBookLoadingView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.loadingVC?.hide()
        }
    }

    // MARK: - Actions
    @objc private func didTapSummarize() {
        view.endEditing(true)

        guard let text = expField.text,
              !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            self.showAlert(title: "Campos incompletos",
                           message: "Preencha todos os campos para gerar o resumo.")
            return
        }

        let repo = ApologeticsChatRepository(apiKey: "")
        setupBookLoadingView()
        repo.makeAPIRequest(prompt: expField.text, completition: { [weak self] response in
            self?.hideBookLoadingView()
            self?.openSummaryScreen(summary: response)
        })
//        repo.makeAPIRequest(prompt: expField.text)

//        repo.createCompletion(model: "gpt-4",
//                              messages: [.init(role: "user", content: text)]) { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let completion):
//                    print("Resposta OK:", completion)
//                    self.showAlert(title: "Resumo", message: completion.sources.first?.title ?? "Sem resumo")
//                case .failure(let error):
//                    print("Erro:", error)
//                    self.showAlert(title: "Erro", message: error.localizedDescription)
//                }
//            }
//        }
    }
//    @objc private func didTapSummarize() async {
//        view.endEditing(true)
//        
//        guard let text = expField.text,
//              !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
//            self.showAlert(title: "Campos incompletos",
//                           message: "Preencha todos os campos para gerar o resumo.")
//            return
//        }
//        DispatchQueue.main.async {
//            Task {
//                do {
//                    try await self.demo() // aqui você chama sua função async
//                } catch {
//                    print("Erro ao buscar: \(error)")
//                }
//            }
//        }
//        summarizer.summarize(name: name, region: region, experiences: exp) { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let text):
//                    print(text)
//                    self?.openSummaryScreen()
////                    self?.aiTextView.text = text
////                    self?.aiTextView.textColor = .label
////                    self?.openInNewScreenButton.isHidden = false
//                case .failure:
//                    self?.showAlert(title: "Campos incompletos", message: "Preencha todos os campos para gerar o resumo.")
//                }
//            }
//        }
        
//    }
    
//    func demo() {
//        let repo = ApologeticsChatRepository(
//            apiKey: "apg_IoUmbsVAa6Fhh54xEOv8mDLLr9f6"
//        )
//
//        do {
//            let completion = try await repo.createCompletion(
//                model: "gpt-4",
//                messages: [
//                    .init(role: "user", content: "Olá, tudo bem?")
//                ]
//            )
//            print("ID:", completion.id)
//            print("Modelo:", completion.model)
//            print("Primeira fonte:", completion.sources.first?.title ?? "-")
//        } catch let ChatRepositoryError.badStatus(code, data) {
//            print("HTTP \(code)", String(data: data ?? Data(), encoding: .utf8) ?? "")
//        } catch {
//            print("Falha:", error)
//        }
//    }
    
    private func setupBehavior() {
        expField.heightAnchor.constraint(equalToConstant: CGFloat(300)).isActive = true
        expField.delegate = self

        // (Opcional) se quiser reagir à mudança de altura
        expField.onHeightChange = { [weak self] newHeight in
            // Poderia ajustar outro layout/scrollView se necessário
            // print("Nova altura do TextView:", newHeight)
            self?.view.layoutIfNeeded()
        }
    }

    private func openSummaryScreen(summary: String) {
        DispatchQueue.main.async { [weak self] in
            let vc = SummaryViewController(summary: summary)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }

    // MARK: - Helpers
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func setupTapToDismiss() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() { view.endEditing(true) }

    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func handleKeyboard(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? .zero
        let endFrameInView = view.convert(endFrame, from: view.window)
        let intersects = view.bounds.intersects(endFrameInView)

        var inset = scrollView.contentInset
        inset.bottom = intersects ? max(0, view.bounds.maxY - endFrameInView.origin.y) + 12 : 0
        scrollView.contentInset = inset
        scrollView.verticalScrollIndicatorInsets.bottom = inset.bottom

        let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.25
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }
}

extension ExpertViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        // Ex.: validação em tempo real
        // belowLabel.text = "Chars: \(textView.text.count)"
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        // Ex.: mudar aparência ao focar
        expField.layer.borderWidth = 1
        expField.layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.3).cgColor
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        expField.layer.borderWidth = 0
        expField.layer.borderColor = UIColor.clear.cgColor
    }
}


// MARK: - Protocol to plug a real AI service later
protocol AISummarizing {
    func summarize(name: String, region: String, experiences: String, completion: @escaping (Result<String, Error>) -> Void)
}


// Simple placeholder "AI" summarizer. Swap this for a real implementation.
final class LocalAISummarizer: AISummarizing {
    
    enum SummarizerError: Error { case empty }

    func summarize(name: String, region: String, experiences: String, completion: @escaping (Result<String, Error>) -> Void) {
        // Simulate light processing and basic normalization
        let trimmed = [name, region, experiences].map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        guard trimmed.allSatisfy({ !$0.isEmpty }) else { return completion(.failure(SummarizerError.empty)) }

        let (n, r, e) = (trimmed[0], trimmed[1], trimmed[2])
        let bullets = [
            "Name: \(n)",
            "Region: \(r)",
            "Experience: \(e)"
        ]
        let summary = "Candidate Summary\n• " + bullets.joined(separator: "\n• ")
        completion(.success(summary))
    }
}

// MARK: - Summary Screen (optional second controller)
final class SummaryViewController: UIViewController {
    private let textView = UITextView()
    private let summary: String

    init(summary: String) {
        self.summary = summary
        super.init(nibName: nil, bundle: nil)
        self.title = "Resumo da IA"
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.font = .preferredFont(forTextStyle: .body)
        textView.text = summary
        textView.adjustsFontForContentSizeCategory = true
        textView.backgroundColor = .secondarySystemBackground
        textView.layer.cornerRadius = 12

        view.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}
