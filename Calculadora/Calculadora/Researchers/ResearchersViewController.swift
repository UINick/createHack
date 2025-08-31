//
//  ResearchersViewController.swift
//  Calculadora
//
//  Created by Nicholas Forte on 30/08/25.
//

import Foundation
import UIKit

// MARK: - ResearchersViewController (Países da Ásia > Tabela)
final class ResearchersViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Data (mock: todos os países da Ásia)
    private static let allAsianCountries: [String] = [
        "Afeganistão", "Arábia Saudita", "Armênia", "Azerbaijão", "Bahrein", "Bangladesh", "Butão", "Brunei",
        "Camboja", "Cazaquistão", "China", "Chipre", "Coreia do Norte", "Coreia do Sul", "Emirados Árabes Unidos",
        "Filipinas", "Geórgia", "Iêmen", "Índia", "Indonésia", "Irã", "Iraque", "Israel", "Japão", "Jordânia",
        "Kuwait", "Laos", "Líbano", "Malásia", "Maldivas", "Mianmar", "Mongólia", "Nepal", "Omã", "Paquistão",
        "Catar", "Quirguistão", "Singapura", "Síria", "Sri Lanka", "Tadjiquistão", "Tailândia", "Timor-Leste",
        "Turcomenistão", "Turquia", "Uzbequistão", "Vietnã", "Palestina"
    ]
    private lazy var countries: [String] = {
        let locale = Locale(identifier: "pt_BR")
        return Self.allAsianCountries.sorted { $0.compare($1, options: .caseInsensitive, range: nil, locale: locale) == .orderedAscending }
    }()

    private var selectedRow: Int = 0
    private var selectedCountry: String?

    // Placeholder dos dados da tabela (serão definidos na próxima etapa)
    private var items: [ResearchItem] = [] {
        didSet { updateEmptyState() }
    }

    // MARK: UI
    private let picker = UIPickerView()
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    private lazy var confirmButton = UIBarButtonItem(title: "Confirmar", style: .done, target: self, action: #selector(confirmTapped))
    private lazy var editButton = UIBarButtonItem(title: "Trocar país", style: .plain, target: self, action: #selector(editTapped))

    private let emptyLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.numberOfLines = 0
        l.textColor = .secondaryLabel
        l.font = .preferredFont(forTextStyle: .body)
        l.text = "Selecione um país para ver a lista."
        return l
    }()

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Researchers"
        view.backgroundColor = .systemBackground
        setupPicker()
        setupTable()
        navigationItem.rightBarButtonItem = confirmButton
    }

    // MARK: Setup
    private func setupPicker() {
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.dataSource = self
        picker.delegate = self
        view.addSubview(picker)

        NSLayoutConstraint.activate([
            picker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            picker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            picker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            picker.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupTable() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.register(ResearcherCell.self, forCellReuseIdentifier: ResearcherCell.reuseId)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        updateEmptyState()
    }

    private func updateEmptyState() {
        if items.isEmpty {
            tableView.backgroundView = emptyLabel
        } else {
            tableView.backgroundView = nil
        }
        tableView.reloadData()
    }

    // MARK: Actions
    @objc private func confirmTapped() {
        let chosen = countries[safe: selectedRow] ?? countries.first
        guard let country = chosen else { return }
        selectedCountry = country
        title = country
        // Transição: some o picker, entra a table
        UIView.transition(with: view, duration: 0.25, options: .transitionCrossDissolve) {
            self.picker.isHidden = true
            self.tableView.isHidden = false
        }
        navigationItem.rightBarButtonItem = editButton
        // Reset/placeholder de conteúdo até receber detalhes
        items = [ResearchItem(title: "Missão Esperança", description: "Organização cristã que apoia comunidades carentes na Índia com programas de alimentação e educação."), ResearchItem(title: "Luz do Oriente", description: "Projeto missionário focado em traduzir e distribuir a Bíblia em diferentes dialetos indianos."), ResearchItem(title: "Água Viva", description: "Missão que constrói poços de água potável em vilarejos indianos e compartilha mensagens de fé."),
            ResearchItem(title: "Mãos Servindo", description: "Iniciativa cristã de assistência médica gratuita em áreas rurais da Índia."),
            ResearchItem(title: "Caminho da Vida", description: "Programa de discipulado e apoio espiritual para jovens em grandes cidades indianas.")
        ]
    }

    @objc private func editTapped() {
        title = "Researchers"
        UIView.transition(with: view, duration: 0.25, options: .transitionCrossDissolve) {
            self.tableView.isHidden = true
            self.picker.isHidden = false
        }
        navigationItem.rightBarButtonItem = confirmButton
    }

    // MARK: UIPickerViewDataSource/Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { countries.count }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { countries[row] }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) { selectedRow = row }

    // MARK: UITableViewDataSource/Delegate (placeholder)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ResearcherCell.reuseId) as? ResearcherCellProtocol
        let content = items[indexPath.row]
        cell?.addInfo(content)
        return cell as? UITableViewCell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        let controller = SummaryViewController(summary: item.description)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        130
    }
    
}

// MARK: - Safe subscript helper
private extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
