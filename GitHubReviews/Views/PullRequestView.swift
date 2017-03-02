//
//  PullRequestView.swift
//  GitHubReviews
//
//  Created by Etienne Martin on 2017-03-03.
//  Copyright © 2017 EtienneMartin. All rights reserved.
//

import Foundation
import Cocoa
import OctoKit

class PullRequestView: NSView {
	private var pullRequest: PullRequest
	
	init(pullRequest: PullRequest) {
		self.pullRequest = pullRequest
		super.init(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
		
		translatesAutoresizingMaskIntoConstraints = false
		
		// PR Number
		
		let numberView = NSTextView()
		if let number = pullRequest.number {
			numberView.string = "#\(number)"
		}
		numberView.isEditable = false
		numberView.translatesAutoresizingMaskIntoConstraints = false
		numberView.font = NSFont.systemFont(ofSize: 18.0)
		numberView.textColor = .black
		addSubview(numberView)
		
		NSLayoutConstraint.activate([
			numberView.leadingAnchor.constraint(equalTo: leadingAnchor),
			numberView.topAnchor.constraint(equalTo: topAnchor),
			numberView.bottomAnchor.constraint(equalTo: bottomAnchor),
		])
		
		// PR title
		
		let titleView = NSTextView()
		numberView.isEditable = false
		titleView.string = pullRequest.title ?? ""
		titleView.translatesAutoresizingMaskIntoConstraints = false
		titleView.font = NSFont.systemFont(ofSize: 14.0)
		titleView.textColor = .gray
		addSubview(titleView)
		
		NSLayoutConstraint.activate([
			titleView.centerYAnchor.constraint(equalTo: centerYAnchor),
			titleView.leadingAnchor.constraint(equalTo: numberView.trailingAnchor),
			titleView.trailingAnchor.constraint(equalTo: trailingAnchor)
		])
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) is not supported")
	}
}
