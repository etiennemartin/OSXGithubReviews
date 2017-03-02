//
//  AppDelegate.swift
//  GitHubReviews
//
//  Created by Etienne Martin on 2017-03-02.
//  Copyright © 2017 EtienneMartin. All rights reserved.
//

import Cocoa
import OctoKit
import RequestKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet weak var window: NSWindow!

	private var statusItem: NSStatusItem = NSStatusItem()
	private var darkModeOn: Bool = false
	private var state: MenuState = MenuState()
	private var stateSynchronizer = StateSynchronizer()
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
		statusItem.image = NSImage(named: "icon")
		
		stateSynchronizer.stateChanged = { [weak self] state in
			self?.state = state
			self?.rebuildMenu()
		}
		
		rebuildMenu() // Done for initial state.
		stateSynchronizer.start() // Kick start sync
		stateSynchronizer.sync()
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		stateSynchronizer.stop()
	}

	@objc private func executeMenuAction(sender: Any?) {
		if let menuItem = sender as? NSMenuItem, let menuAction = menuItem.representedObject as? MenuActions {
			switch menuAction {
			case .openPullRequest(let pullRequest):
				if let url = pullRequest.url {
					NSWorkspace.shared().open(url)
				} else {
					NSLog("Failed to open PR due to nil or invalid URL \(pullRequest.url)")
				}
			case .quit:
				NSApplication.shared().terminate(self)
				break
			case .settings:
				break
			}
		}
	}
	
	private func rebuildMenu() {
		state.selectionAction = #selector(executeMenuAction(sender:))
		state.selectionTarget = self
		
		let menu = StatusMenuBuilder.menus(state)
		statusItem.menu = menu
	}
}

