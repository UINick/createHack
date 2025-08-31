import UIKit

class LoadingViewController: UIViewController {

    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let overlayView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupOverlayView()
        setupActivityIndicator()
    }

    private func setupOverlayView() {
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overlayView)

        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupActivityIndicator() {
        activityIndicator.color = .white // Define a cor do spinner
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor)
        ])

        activityIndicator.startAnimating()
    }

    // Função para mostrar o loading
    static func show(on viewController: UIViewController) -> LoadingViewController {
        let loadingVC = LoadingViewController()
        loadingVC.modalPresentationStyle = .overFullScreen // Permite transparência
        loadingVC.modalTransitionStyle = .crossDissolve // Animação suave
        viewController.present(loadingVC, animated: true, completion: nil)
        return loadingVC
    }

    // Função para esconder o loading
    func hide(completion: (() -> Void)? = nil) {
        dismiss(animated: true, completion: completion)
    }
}
