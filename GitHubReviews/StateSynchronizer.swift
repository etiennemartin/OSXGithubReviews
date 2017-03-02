//
//  StateSynchronizer.swift
//  GitHubReviews
//
//  Created by Etienne Martin on 2017-03-03.
//  Copyright © 2017 EtienneMartin. All rights reserved.
//

import Foundation
import OctoKit

class StateSynchronizer {
	struct Constants {
		static let syncTimeInterval: TimeInterval = 30.0 // seconds
	}
	
	private var timer: Timer?
	var stateChanged: ((MenuState) -> ())?
	
	init() {
		start()
	}
	
	func start() {
		if let timer = timer {
			timer.invalidate()
		}

		timer = Timer.scheduledTimer(withTimeInterval: Constants.syncTimeInterval, repeats: true) { [weak self] timer in
			self?.synchronizeData()
		}
	}
	
	func stop() {
		timer?.invalidate()
	}
	
	func sync() {
		timer?.fire()
	}
	
	private func synchronizeData() {
		
		NSLog("Syncronizing with Github...")
		
		let state = MenuState()
		let config = TokenConfiguration("<INSERT_YOUR_TOKEN_HERE>")
		let user = "etiennemartin"
		
		// Fetch open PRs for the user
		_ = Octokit(config).openUserPullRequests(user: user) { response in
			switch response {
			case .success(let searchResult):
				if let count = searchResult.totalCount {
					NSLog("Receipted \(count) open pull requests")
				}
				state.openPRs = searchResult.pullRequests
				self.stateChanged?(state)
			case .failure(let error):
				NSLog("Failed to pull open PRs with error: \(error)")
			}
		}
		
		// Fetch pending review requests
		_ = Octokit(config).openReviewRequests(user: user) { response in
			switch response {
			case .success(let searchResult):
				if let count = searchResult.totalCount {
					NSLog("Receipted \(count) open review requests")
				}
				state.reviewRequestedPRs = searchResult.pullRequests
				self.stateChanged?(state)
			case .failure(let error):
				NSLog("Failed to pull pending review requests with error: \(error)")
			}
		}
		
		// Fetch previously reviewed PRs
		_ = Octokit(config).openOngoingPullRequestReviews(user: user) { response in
			switch response {
			case .success(let searchResult):
				if let count = searchResult.totalCount {
					NSLog("Receipted \(count) open ongoing reviews")
				}
				state.previouslyReviewedPRs = searchResult.pullRequests
				self.stateChanged?(state)
			case .failure(let error):
				NSLog("Failed to pull previously reviewed PRs with error: \(error)")
			}
		}
	}
}
