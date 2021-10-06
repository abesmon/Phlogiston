//
//  ToolboxController.swift
//  Phlogiston
//
//  Created by Лысенко Алексей Димитриевич on 08/05/2019.
//  Copyright © 2019 Syrup Media Group. All rights reserved.
//

import UIKit

class ToolboxController: UIPageViewController {
    let brushVC = BrushVC()
    let processorVC = ProcessorVC()
    private var pages: [UIViewController] {
        return [
            brushVC,
            processorVC
        ]
    }
    
    convenience init() {
        self.init(transitionStyle: .scroll, navigationOrientation: .vertical, options: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        setViewControllers([brushVC], direction: .forward, animated: true, completion: nil)
    }
    
    // Responder
    weak var context: UIResponder?
    override var canBecomeFirstResponder: Bool { return true }
    override func resignFirstResponder() -> Bool {
        return super.resignFirstResponder()
//        return true
    }
    override var inputView: UIView? { return view }
    override var inputAccessoryView: UIView? {
        let parentWidth = (context as? UIViewController)?.view.bounds.width ?? 0
        let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: CGSize(width: parentWidth, height: 44)))
        toolbar.setItems([UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(resignFirstResponder))], animated: false)
        return toolbar
    }
    
    override var next: UIResponder? { return context }
}

extension ToolboxController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = (pages.firstIndex { $0 === viewController }) else { return nil }
        let prevIndex = currentIndex - 1
        guard prevIndex >= 0, prevIndex < pages.count else { return nil }
        return pages[prevIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = (pages.firstIndex { $0 === viewController }) else { return nil }
        let nextIndex = currentIndex + 1
        guard nextIndex < pages.count, nextIndex >= 0 else { return nil }
        return pages[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return pages.firstIndex { $0 === viewControllers?.first } ?? 0
    }
}

extension ToolboxController: UIPageViewControllerDelegate {
    
}

