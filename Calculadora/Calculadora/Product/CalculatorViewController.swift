//
//  CalculatorViewController.swift
//  Calculadora
//
//  Created by Nicholas Forte on 30/08/25.
//

import Foundation
import UIKit

final class CalculatorViewController: UIViewController {

    private let display = UILabel()
    private var expression = "" {
        didSet { display.text = expression.isEmpty ? "0" : expression }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Calculadora"
        view.backgroundColor = .systemBackground
        setupUI()
    }

    private func setupUI() {
        display.text = "0"
        display.textAlignment = .right
        display.font = .systemFont(ofSize: 40, weight: .semibold)
        display.adjustsFontSizeToFitWidth = true
        display.minimumScaleFactor = 0.4
        display.numberOfLines = 1
        display.translatesAutoresizingMaskIntoConstraints = false

        let vStack = UIStackView(arrangedSubviews: [display])
        vStack.axis = .vertical
        vStack.spacing = 12
        vStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(vStack)

        // Linhas de botões (bem minimalista)
        let rows: [[String]] = [
            ["7","8","9","/"],
            ["4","5","6","*"],
            ["1","2","3","-"],
            ["0",".","C","+"]
        ]

        for row in rows {
            let h = UIStackView()
            h.axis = .horizontal
            h.distribution = .fillEqually
            h.spacing = 8
            for title in row { h.addArrangedSubview(makeButton(title)) }
            vStack.addArrangedSubview(h)
        }

        // Botão "=" ocupando largura total
        let equals = makeButton("=")
        equals.titleLabel?.font = .systemFont(ofSize: 28, weight: .bold)
        vStack.addArrangedSubview(equals)
        equals.heightAnchor.constraint(equalToConstant: 56).isActive = true

        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            vStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
        ])
    }

    private func makeButton(_ title: String) -> UIButton {
        let b = UIButton(type: .system)
        b.setTitle(title, for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 24, weight: .medium)
        b.backgroundColor = .secondarySystemBackground
        b.layer.cornerRadius = 12
        b.heightAnchor.constraint(equalToConstant: 56).isActive = true
        b.addTarget(self, action: #selector(tapButton(_:)), for: .touchUpInside)
        return b
    }

    @objc private func tapButton(_ sender: UIButton) {
        guard let t = sender.currentTitle else { return }
        switch t {
        case "C":
            expression = ""
        case "=":
            evaluate()
        default:
            expression.append(t)
        }
    }

    private func evaluate() {
        // Substitui símbolos bonitos por operadores do NSExpression, se houver
        let safe = expression
            .replacingOccurrences(of: "×", with: "*")
            .replacingOccurrences(of: "÷", with: "/")

        // Usa NSExpression para manter tudo super simples
        let exp = NSExpression(format: safe)
        if let num = exp.expressionValue(with: nil, context: nil) as? NSNumber {
            let value = num.doubleValue
            checkPiAndUnlock(value)
            expression = pretty(value)
        } else {
            expression = ""
            display.text = "Erro"
        }
    }

    private func pretty(_ value: Double) -> String {
        if value.isFinite == false { return "Erro" }
        if value.rounded() == value { return String(Int(value)) }
        // Limita casas para evitar infinitos decimais
        return String(format: "%.10g", value)
    }

    private func checkPiAndUnlock(_ value: Double) {
        // Tolerância para aceitar aproximações de π
        let epsilon = 1e-4
        if abs(value - .pi) < epsilon {
            let secret = UINavigationController(rootViewController: TabBarViewController())
            SceneDelegate.swapRoot(to: secret, animated: true)
        }
    }
}
