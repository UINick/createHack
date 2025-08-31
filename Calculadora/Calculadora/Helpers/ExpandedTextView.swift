//
//  ExpandedTextView.swift
//  Calculadora
//
//  Created by Nicholas Forte on 30/08/25.
//

import Foundation
import UIKit

import UIKit

/// UITextView que se expande até `maxHeight`. Ao passar disso, ativa scroll.
final class ExpandingTextView: UITextView {

    /// Altura máxima antes de habilitar scroll.
    var maxHeight: CGFloat = 200 {
        didSet { recalcAndUpdate() }
    }

    /// Callback opcional quando a altura muda (útil para ajustar layouts ao redor).
    var onHeightChange: ((CGFloat) -> Void)?

    private var cachedHeight: CGFloat = 0

    override var text: String! {
        didSet { recalcAndUpdate() }
    }

    override var attributedText: NSAttributedString! {
        didSet { recalcAndUpdate() }
    }

    override var font: UIFont? {
        didSet { recalcAndUpdate() }
    }

    override var textContainerInset: UIEdgeInsets {
        didSet { recalcAndUpdate() }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        isScrollEnabled = false // começa expandindo
        showsVerticalScrollIndicator = true
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 8

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textDidChangeNotification(_:)),
            name: UITextView.textDidChangeNotification,
            object: self
        )
    }

    @objc private func textDidChangeNotification(_ note: Notification) {
        recalcAndUpdate()
        // Se estiver rolando, mantém o caret visível
        if isScrollEnabled { scrollRangeToVisible(selectedRange) }
    }

    private func measureHeight(for width: CGFloat) -> CGFloat {
        let targetSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let fitted = sizeThatFits(targetSize).height
        // Altura calculada precisa considerar bordas/insets
        return ceil(fitted)
    }

    private func recalcAndUpdate() {
        let width = bounds.width > 0 ? bounds.width : preferredMaxLayoutWidthFallback()
        let natural = measureHeight(for: width)
        let newHeight = min(natural, maxHeight)
        let shouldScroll = natural > maxHeight + 0.5

        if abs(newHeight - cachedHeight) > 0.5 || shouldScroll != isScrollEnabled {
            cachedHeight = newHeight
            isScrollEnabled = shouldScroll
            invalidateIntrinsicContentSize()
            onHeightChange?(cachedHeight)
        }
    }

    /// Retorna um chute de largura para o cálculo quando ainda não temos bounds válidos
    private func preferredMaxLayoutWidthFallback() -> CGFloat {
        // Se ainda não tem largura (ex.: durante o primeiro layout),
        // usa o tamanho de tela menos margens típicas.
        if let win = window {
            return win.bounds.width - 40
        }
        return UIScreen.main.bounds.width - 40
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // Recalcula quando a largura muda
        recalcAndUpdate()
    }

    override var intrinsicContentSize: CGSize {
        // Altura dinâmica; largura é livre para o Auto Layout decidir
        CGSize(width: UIView.noIntrinsicMetric, height: cachedHeight > 0 ? cachedHeight : 50)
    }
}
