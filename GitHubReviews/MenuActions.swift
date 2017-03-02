//
//  MenuActions.swift
//  GitHubReviews
//
//  Created by Etienne Martin on 2017-03-03.
//  Copyright © 2017 EtienneMartin. All rights reserved.
//

import Foundation
import OctoKit

enum MenuActions {
	case openPullRequest(PullRequest)
	case quit
	case settings
}
