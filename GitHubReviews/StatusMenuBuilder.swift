//
//  StatusMenuBuilder.swift
//  GitHubReviews
//
//  Created by Etienne Martin on 2017-03-03.
//  Copyright © 2017 EtienneMartin. All rights reserved.
//

import Foundation
import Cocoa
import OctoKit

class StatusMenuBuilder {
	static func menus(_ state: MenuState) -> NSMenu {
		let menu = NSMenu()
		
		createOpenPullRequestMenuItems(state).forEach { menu.addItem($0) }
		menu.addItem(NSMenuItem.separator())
		createPendingReviewRequestMenuItems(state).forEach { menu.addItem($0) }
		menu.addItem(NSMenuItem.separator())
		createPreviouslyReviewedPullRequestMenuItems(state).forEach { menu.addItem($0) }
		menu.addItem(NSMenuItem.separator())
		menu.addItem(NSMenuItem.applicationTerminator(state))
		
		return menu
	}

	static func createOpenPullRequestMenuItems(_ state: MenuState) -> [NSMenuItem] {
		var menuItems: [NSMenuItem] = []
		
		let header = NSMenuItem()
		header.title = "Your Pull Requests"
		menuItems.append(header)
		
		for pr in state.openPRs {
			if let item = NSMenuItem.createPullRequestCell(pullRequest: pr, target: state.selectionTarget, action: state.selectionAction) {
				menuItems.append(item)
			}
		}

		return menuItems
	}
	
	static func createPendingReviewRequestMenuItems(_ state: MenuState) -> [NSMenuItem] {
		var menuItems: [NSMenuItem] = []
		
		let header = NSMenuItem()
		header.title = "New Reviews"
		menuItems.append(header)
		
		for pr in state.reviewRequestedPRs {
			if let item = NSMenuItem.createPullRequestCell(pullRequest: pr, target: state.selectionTarget, action: state.selectionAction) {
				menuItems.append(item)
			}
		}

		return menuItems
	}
	
	static func createPreviouslyReviewedPullRequestMenuItems(_ state: MenuState) -> [NSMenuItem] {
		var menuItems: [NSMenuItem] = []
		
		let header = NSMenuItem()
		header.title = "On-going Reviews"
		menuItems.append(header)
		
		for pr in state.previouslyReviewedPRs {
			if let item = NSMenuItem.createPullRequestCell(pullRequest: pr, target: state.selectionTarget, action: state.selectionAction) {
				menuItems.append(item)
			}
		}
		
		return menuItems
	}
}

extension NSMenuItem {
	static func createPullRequestCell(pullRequest: PullRequest, target: AnyObject?, action: Selector?) -> NSMenuItem? {
		guard let number = pullRequest.number, let title = pullRequest.title else {
			return nil
		}
		
		let menuItem = NSMenuItem(title: "#\(number) - \(title)", action: nil, keyEquivalent: "")
		menuItem.representedObject = MenuActions.openPullRequest(pullRequest)
		menuItem.target = target
		menuItem.action = action
		
		return menuItem
	}
	
	static func applicationTerminator(_ state: MenuState) -> NSMenuItem {
		let menuItem = NSMenuItem(title: "Quit", action: nil, keyEquivalent: "")
		menuItem.representedObject = MenuActions.quit
		menuItem.target = state.selectionTarget
		menuItem.action = state.selectionAction
		return menuItem
	}
}
