//
//  TagListViewUIKit.swift
//
//
//  Created by Michael Namara on 2024/3/19.
//

import Combine
import SwiftUI
import UIKit

// MARK: - UIView Setup
public class TagListViewUIKit: UIView, TagListViewProtocol {
    private var cancellables = Set<AnyCancellable>()
    private let hostingController = UIHostingController(rootView: TagListViewSwiftUI())
    private var rootView: TagListViewSwiftUI { return hostingController.rootView }
    private var hostingView: UIView { return hostingController.view }
    
    public var model: TagListViewModel { return rootView.model }
    
    public weak var delegate: TagViewDelegate? {
        didSet {
            model.delegate = delegate
        }
    }
    
    public init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        hostingView.backgroundColor = .clear
        addSubview(hostingView)
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingView.topAnchor.constraint(equalTo: topAnchor),
            hostingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            hostingView.trailingAnchor.constraint(equalTo: trailingAnchor),
            hostingView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        model.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.hostingView.invalidateIntrinsicContentSize()
                self?.invalidateIntrinsicContentSize()
            }
            .store(in: &cancellables)
    }
}
