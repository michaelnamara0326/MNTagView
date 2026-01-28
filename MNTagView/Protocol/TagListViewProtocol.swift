//
//  TagListViewProtocol.swift
//
//
//  Created by Michael Namara on 2024/4/2.
//

import Foundation

// Protocol methods should adopt in SwiftUI and UIKit
@MainActor
public protocol TagListViewProtocol {
    var model: TagListViewModel { get }
    func addTag(title: String)
    func addTags(titles: [String])
    func addTagView(tag: TagSubView)
    func insertTag(_ title: String, at index: Int)
    func insertTagView(_ tagView: TagSubView, at index: Int)
    func removeTag(title: String)
    func removeTag(at index: Int)
    func removeTagView(tag: TagSubView)
    func removeAllTag()
    func getSelectedTags() -> [TagSubView]
    func getSelectedTagsIndex() -> [Int]
    func getSelectedTagsTitle() -> [String]
    func getAllTags() -> [TagSubView]
    func getAllTagsTitle() -> [String]
    func getTotalOfTag() -> Int
}

extension TagListViewProtocol {
    public func addTag(title: String) {
        let tag = model.createTag(title: title)
        addTagView(tag: tag)
    }
    
    public func addTags(titles: [String]) {
        let removeDuplicates = titles.reduce(into: [String]()) {
            if !$0.contains($1) { $0.append($1) }
        }
        removeDuplicates.forEach {
            addTag(title: $0)
        }
    }
    
    public func addTagView(tag: TagSubView) {
        tag.model.delegate = self.model.delegate
        model.tags.append(tag)
    }
    
    public func insertTag(_ title: String, at index: Int) {
        let tag = model.createTag(title: title)
        insertTagView(tag, at: index)
    }
    
    public func insertTagView(_ tagView: TagSubView, at index: Int) {
        guard (0...getTotalOfTag()).contains(index) else { return }
        model.tags.insert(tagView, at: index)
    }
    
    public func removeTag(title: String) {
        model.tags.filter({ $0.model.title == title }).forEach(removeTagView)
    }
    
    public func removeTag(at index: Int) {
        guard model.tags.indices.contains(index) else { return }
        model.tags.remove(at: index)
    }
    
    public func removeTagView(tag: TagSubView) {
        if let index = model.tags.firstIndex(of: tag) {
           removeTag(at: index)
        }
    }
    
    public func removeAllTag() {
        model.tags.removeAll()
    }
    
    public func getSelectedTags() -> [TagSubView] {
        return model.tags.filter { $0.model.isSelected }
    }
    
    public func getSelectedTagsIndex() -> [Int] {
        return model.tags.enumerated().filter { $1.model.isSelected }.map { $0.offset }
    }
    
    public func getSelectedTagsTitle() -> [String] {
        return model.tags.filter { $0.model.isSelected }.map { $0.model.title }
    }
    
    public func getAllTags() -> [TagSubView] {
        return model.tags
    }
    
    public func getAllTagsTitle() -> [String] {
        return model.tags.map { $0.model.title }
    }
    
    public func getTotalOfTag() -> Int {
        return model.tags.count
    }
}
