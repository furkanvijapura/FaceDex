//
//  PeopleViewController.swift
//  FaceDex
//
//  Created by Benjamin Emdon on 2017-02-04.
//  Copyright © 2017 Benjamin Emdon. All rights reserved.
//

import UIKit

class PeopleViewController: UIViewController {

	override var prefersStatusBarHidden: Bool {
		return true
	}

	private var backgroundImage: UIImage
	fileprivate var peopleTableView: UITableView!
	fileprivate var viewModel: FaceViewModel!

	init(image: UIImage) {
		let imageData = UIImagePNGRepresentation(image)
		self.backgroundImage = image
		super.init(nibName: nil, bundle: nil)
		viewModel = FaceViewModel(imageData: imageData)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.gray

		let backgroundImageView = UIImageView(frame: view.frame)
		backgroundImageView.image = backgroundImage


		let cancelButton = UIButton(frame: CGRect(x: 10.0, y: 10.0, width: 30.0, height: 30.0))
		cancelButton.setImage(#imageLiteral(resourceName: "cancel"), for: UIControlState())
		cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)


		peopleTableView = UITableView(frame: view.bounds)
		peopleTableView.backgroundColor = .clear
		peopleTableView.contentInset = UIEdgeInsets(top: view.bounds.height - 64, left: 0, bottom: 0, right: 0)
		peopleTableView.rowHeight = 64
		peopleTableView.separatorStyle = .none
		peopleTableView.delegate = self
		peopleTableView.dataSource = self
		peopleTableView.register(ClearCell.self, forCellReuseIdentifier: String(describing: ClearCell.self))

		view.addSubview(backgroundImageView)
		view.addSubview(peopleTableView)
		view.addSubview(cancelButton)

		viewModel.recognize()
	}

	func cancel() {
		dismiss(animated: true, completion: nil)
	}
}

extension PeopleViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.persons.count + 1 // extra 1 for question cell
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ClearCell.self)) as! ClearCell
		if indexPath.row == viewModel.persons.count {
			cell.title = "This the droid you were looking for?"
		} else {
			cell.title = viewModel.persons[indexPath.row].name
		}
		cell.render()
		return cell
	}
}


extension PeopleViewController: UITableViewDelegate {
	// touch events
}

extension PeopleViewController: FaceModelDelegate {
	func responseReturned() {
		peopleTableView.reloadData()
	}
	
	func recognizeResponse() {
		// stuff here
	}
	
	func errorResponse() {
		// moar stuff
	}
}