//
//  MenuState.swift
//  GitHubReviews
//
//  Created by Etienne Martin on 2017-03-03.
//  Copyright © 2017 EtienneMartin. All rights reserved.
//

import Foundation
import OctoKit

class MenuState {
	var openPRs: [PullRequest] = []
	var reviewRequestedPRs: [PullRequest] = []
	var previouslyReviewedPRs: [PullRequest] = []
	var selectionAction: Selector?
	var selectionTarget: AnyObject?
	
	var totalPRs: Int {
		get { return openPRs.count + reviewRequestedPRs.count + previouslyReviewedPRs.count }
	}
}
