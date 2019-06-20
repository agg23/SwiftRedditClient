//
//  ViewController.swift
//  Reddit
//
//  Created by Adam Gastineau on 6/17/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import AppKit
import SnapKit
import Moya
import PromiseKit

let viewIdentifier = NSUserInterfaceItemIdentifier("listingViewRow")

class ListingViewController: NSViewController {
    let redditProvider = MoyaProvider<RedditAPITarget>()
    
    let scrollView = NSScrollView()
    let tableView = NSTableView()
    
    let progressView = NSProgressIndicator()
    
    let topStackView = NSStackView()
    let subredditTextField = NSTextField()
    
    let hotButton = NSButton()
    let newButton = NSButton()
    let topButton = NSButton()
    let buttonStackView = NSStackView()
    
    var subreddit = "programming"
    var data: Listing<Link>?
    
    override func loadView() {
        view = NSView()
        view.addSubview(scrollView)
        view.addSubview(topStackView, positioned: .above, relativeTo: nil)
        view.addSubview(progressView, positioned: .above, relativeTo: nil)
        view.addSubview(buttonStackView, positioned: .above, relativeTo: nil)
        
        scrollView.hasVerticalScroller = true
        scrollView.documentView = tableView

        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(topStackView.snp.bottom)
            make.left.equalTo(self.view.snp.leftMargin)
            make.right.equalTo(self.view.snp.rightMargin)
            make.bottom.equalTo(self.view.snp.bottomMargin)
        }
        
        progressView.isIndeterminate = true
        progressView.style = .spinning
        progressView.isHidden = true
        
        progressView.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
        }
        
        subredditTextField.action = #selector(subredditEntered)
        subredditTextField.target = self
        subredditTextField.stringValue = subreddit
        
        topStackView.setViews([subredditTextField], in: .center)
        topStackView.orientation = .horizontal
        
        topStackView.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.top.equalTo(self.view.snp.topMargin)
            make.left.equalTo(self.view.snp.leftMargin)
            make.right.equalTo(self.view.snp.rightMargin)
        }
        
        hotButton.title = "Hot"
        hotButton.action = #selector(hotClicked)
        hotButton.target = self
        hotButton.bezelStyle = .rounded
        newButton.title = "New"
        newButton.action = #selector(newClicked)
        newButton.target = self
        newButton.bezelStyle = .rounded
        topButton.title = "Top"
        topButton.action = #selector(topClicked)
        topButton.target = self
        topButton.bezelStyle = .rounded
        
        buttonStackView.setViews([hotButton, newButton, topButton], in: .center)
        buttonStackView.orientation = .horizontal
        
        buttonStackView.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.left.equalTo(self.view.snp.leftMargin)
            make.right.equalTo(self.view.snp.rightMargin)
            make.bottom.equalTo(self.view.snp.bottomMargin)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.addTableColumn(NSTableColumn())
        tableView.headerView = nil
        
        tableView.layer = CALayer()
        tableView.layer?.backgroundColor = .white
    }
    
    override func viewDidAppear() {
        fetchSubreddit(from: subreddit, with: .hot)
    }
    
    private func fetchSubreddit(from subreddit: String, with type: RedditAPISubredditType) {
        firstly { () -> Promise<Listing<Link>> in
            self.showSpinner()
            self.subreddit = subreddit
            return redditProvider.request(from: .subreddit(subreddit, type: type))
        }.done { (data) in
            self.data = data
            self.tableView.reloadData()
            self.hideSpinner()
        }.catch { (error) in
            print(error)
        }
    }
    
    private func showSpinner() {
        progressView.isHidden = false
        progressView.startAnimation(self)
    }
    
    private func hideSpinner() {
        progressView.stopAnimation(self)
        progressView.isHidden = true
    }
    
    // MARK: Input
    
    @objc private func subredditEntered() {
        fetchSubreddit(from: subredditTextField.stringValue, with: .hot)
    }
    
    @objc private func hotClicked() {
        fetchSubreddit(from: subreddit, with: .hot)
    }
    
    @objc private func newClicked() {
        fetchSubreddit(from: subreddit, with: .new)
    }
    
    @objc private func topClicked() {
        fetchSubreddit(from: subreddit, with: .top(.all))
    }
}

extension ListingViewController: NSTableViewDelegate, NSTableViewDataSource {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var rowView = tableView.makeView(withIdentifier: viewIdentifier, owner: self) as? LinkTableViewRow
        
        if rowView == nil {
            rowView = LinkTableViewRow()
            rowView?.identifier = viewIdentifier
        }
        
        guard let link = data?.children[row] else {
            return rowView
        }
        
        rowView?.titleLabel.stringValue = link.title
        
        return rowView
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return data?.children.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 40
    }
}
