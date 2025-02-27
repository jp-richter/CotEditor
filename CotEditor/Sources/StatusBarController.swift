//
//  StatusBarController.swift
//
//  CotEditor
//  https://coteditor.com
//
//  Created by 1024jp on 2014-07-11.
//
//  ---------------------------------------------------------------------------
//
//  © 2014-2023 1024jp
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  https://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Combine
import Cocoa

@MainActor final class StatusBarController: NSViewController {
    
    // MARK: Public Properties
    
    weak var document: Document? {
        
        didSet {
            if let document, self.isViewShown {
                self.subscribe(document)
            }
        }
    }
    
    
    // MARK: Private Properties
    
    private var documentObservers: Set<AnyCancellable> = []
    private var encodingListObserver: AnyCancellable?
    private var defaultsObserver: AnyCancellable?
    
    @objc private dynamic var editorStatus: NSAttributedString?
    @objc private dynamic var fileSize: String?
    
    @IBOutlet private weak var encodingPopUpButton: NSPopUpButton?
    @IBOutlet private weak var lineEndingPopUpButton: NSPopUpButton?
    
    
    
    // MARK: -
    // MARK: View Controller Methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // set accessibility
        self.view.setAccessibilityElement(true)
        self.view.setAccessibilityRole(.group)
        self.view.setAccessibilityLabel("Status Bar".localized)
    }
    
    
    override func viewWillAppear() {
        
        super.viewWillAppear()
        
        // observe popup menu line-up change
        self.encodingListObserver = EncodingManager.shared.$encodings
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in self?.buildEncodingPopupButton() }
        
        // observe change in defaults
        let editorDefaultKeys: [DefaultKey<Bool>] = [
            .showStatusBarLines,
            .showStatusBarChars,
            .showStatusBarWords,
            .showStatusBarLocation,
            .showStatusBarLine,
            .showStatusBarColumn,
        ]
        let publishers = editorDefaultKeys.map { UserDefaults.standard.publisher(for: $0) }
        self.defaultsObserver = Publishers.MergeMany(publishers)
            .map { _ in UserDefaults.standard.statusBarEditorInfo }
            .sink { [weak self] in
                guard let document = self?.document else { return }
                document.analyzer.statusBarRequirements = $0
                self?.editorStatus = self?.statusAttributedString(result: document.analyzer.result, types: $0)
            }
        
        guard let document = self.document else { return assertionFailure() }
        
        self.subscribe(document)
    }
    
    
    override func viewDidDisappear() {
        
        super.viewDidDisappear()
        
        self.encodingListObserver = nil
        self.defaultsObserver = nil
        
        self.document?.analyzer.statusBarRequirements = []
        self.documentObservers.removeAll()
    }
    
    
    
    // MARK: Private Methods
    
    /// Synchronize UI with related document values.
    ///
    /// - Parameter document: The document to observe.
    private func subscribe(_ document: Document) {
        
        document.analyzer.statusBarRequirements = UserDefaults.standard.statusBarEditorInfo
        document.analyzer.invalidate()
        
        self.documentObservers.removeAll()
        
        // observe editor info update
        document.analyzer.$result
            .removeDuplicates()
            .map { [weak self] in self?.statusAttributedString(result: $0, types: UserDefaults.standard.statusBarEditorInfo) }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.editorStatus = $0 }
            .store(in: &self.documentObservers)
        
        // observe file size
        document.$fileAttributes
            .map { $0?[.size] as? UInt64 }
            .removeDuplicates()
            .map { $0?.formatted(.byteCount(style: .file, spellsOutZero: false)) }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.fileSize = $0 }
            .store(in: &self.documentObservers)
        
        // observe document status change
        document.$fileEncoding
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.invalidateEncodingSelection() }
            .store(in: &self.documentObservers)
        document.$lineEnding
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.invalidateLineEndingSelection(to: $0) }
            .store(in: &self.documentObservers)
    }
    
    
    /// update left side text
    @MainActor private func statusAttributedString(result: EditorCountResult, types: EditorInfoTypes) -> NSAttributedString {
        
        var status: [NSAttributedString] = []
        
        if types.contains(.lines) {
            status.append(.formatted(label: "Lines") + .formatted(state: result.lines.formatted))
        }
        if types.contains(.characters) {
            status.append(.formatted(label: "Characters") + .formatted(state: result.characters.formatted))
        }
        if types.contains(.words) {
            status.append(.formatted(label: "Words") + .formatted(state: result.words.formatted))
        }
        if types.contains(.location) {
            status.append(.formatted(label: "Location") + .formatted(state: result.location?.formatted()))
        }
        if types.contains(.line) {
            status.append(.formatted(label: "Line") + .formatted(state: result.line?.formatted()))
        }
        if types.contains(.column) {
            status.append(.formatted(label: "Column") + .formatted(state: result.column?.formatted()))
        }
        
        let attrStatus = status.joined(separator: "   ").mutable
        
        // truncate tail
        let paragraphStyle = NSParagraphStyle.default.mutable
        paragraphStyle.lineBreakMode = .byTruncatingTail
        attrStatus.addAttribute(.paragraphStyle, value: paragraphStyle, range: attrStatus.range)
        
        return attrStatus
    }
    
    
    /// build encoding popup item
    @MainActor private func buildEncodingPopupButton() {
        
        guard let popUpButton = self.encodingPopUpButton else { return }
        
        EncodingManager.shared.updateChangeEncodingMenu(popUpButton.menu!)
        
        self.invalidateEncodingSelection()
    }
    
    
    /// select item in the encoding popup menu
    @MainActor private func invalidateLineEndingSelection(to lineEnding: LineEnding) {
        
        self.lineEndingPopUpButton?.selectItem(withTag: lineEnding.index)
    }
    
    
    /// select item in the line ending menu
    @MainActor private func invalidateEncodingSelection() {
        
        guard let fileEncoding = self.document?.fileEncoding else { return }
        
        self.encodingPopUpButton?.selectItem(withTag: fileEncoding.tag)
    }
}



// MARK: -

private extension UserDefaults {
    
    /// info types needed to be calculated
    var statusBarEditorInfo: EditorInfoTypes {
        
        EditorInfoTypes()
            .union(self[.showStatusBarChars] ? .characters : [])
            .union(self[.showStatusBarLines] ? .lines : [])
            .union(self[.showStatusBarWords] ? .words : [])
            .union(self[.showStatusBarLocation] ? .location : [])
            .union(self[.showStatusBarLine] ? .line : [])
            .union(self[.showStatusBarColumn] ? .column : [])
    }
}


private extension NSAttributedString {
    
    /// Formatted state for status bar.
    static func formatted(state: String?) -> Self {
        
        if let state {
            return Self(string: state)
        } else {
            return Self(string: "-", attributes: [.foregroundColor: NSColor.disabledControlTextColor])
        }
    }
    
    
    /// Formatted label for status bar.
    static func formatted(label: String) -> Self {
        
        Self(string: (label + ": ").localized, attributes: [.foregroundColor: NSColor.secondaryLabelColor])
    }
}
