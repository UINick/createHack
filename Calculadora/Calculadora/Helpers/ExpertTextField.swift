import UIKit

class ExpertTextField: UITextField {

    // Botão para limpar o texto
    private var clearButton: UIButton? {
        didSet {
            self.rightView = clearButton
            self.rightViewMode = .whileEditing
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTextField()
    }

    private func setupTextField() {
        // Configurações básicas do textfield
        self.borderStyle = .none
        self.layer.cornerRadius = 6.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.backgroundColor = .white
        self.textColor = .darkText
        self.font = UIFont.systemFont(ofSize: 16)

        // Adiciona padding interno
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.frame.height))
        self.leftViewMode = .always

        // Adiciona observadores para eventos de edição
        self.addTarget(self, action: #selector(textFieldDidBeginEditing), for: .editingDidBegin)
        self.addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEnd)

        setupClearButton()
    }

    private func setupClearButton() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .lightGray
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        button.addTarget(self, action: #selector(clearText), for: .touchUpInside)
        self.clearButton = button
    }

    @objc private func clearText() {
        self.text = ""
        // Opcional: Adicionar feedback visual ou haptico
        // UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    @objc private func textFieldDidBeginEditing() {
        // Animação ao iniciar a edição
        UIView.animate(withDuration: 0.3) {
            self.layer.borderColor = UIColor.systemBlue.cgColor
            self.layer.borderWidth = 2.0
            self.transform = CGAffineTransform(scaleX: 1.02, y: 1.02)
        }
    }

    @objc private func textFieldDidEndEditing() {
        // Animação ao finalizar a edição
        UIView.animate(withDuration: 0.3) {
            self.layer.borderColor = UIColor.lightGray.cgColor
            self.layer.borderWidth = 1.0
            self.transform = .identity
        }
    }

    // Placeholder personalizado
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
    }
}

