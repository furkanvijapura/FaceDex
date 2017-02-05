//
//  FaceViewModel.swift
//  FaceDex
//
//  Created by Benjamin Emdon on 2017-02-04.
//  Copyright © 2017 Benjamin Emdon. All rights reserved.
//

import Alamofire
import Argo

protocol FaceModelDelegate: class {
	func enrollResponse(enrollResponse: EnrollResponse)
	func recognizeResponse()
	func errorResponse(message: String)
}

class FaceViewModel {
	var persons: [Person] = []
	var imageData: Data?
	weak var delegate: FaceModelDelegate?
	
	init(imageData: Data?) {
		self.imageData = imageData
	}

	func enrollFace(name: String) {
		guard let imageData = imageData else { return }
		let params: Parameters = [
			"name": name,
			"image": imageData.base64EncodedString()
		]
		
		Alamofire.request(API.enroll.url, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
			debugPrint(response)
			if let value = response.result.value, let enrollResponse: EnrollResponse = decode(value) {
				self.delegate?.enrollResponse(enrollResponse: enrollResponse)
			}
		}
	}
	
	func recognizeFace() {
		guard let imageData = imageData else { return }
		let params: Parameters = [
			"image": imageData.base64EncodedString()
		]
		
		Alamofire.request(API.recognize.url, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
			debugPrint(response)
			if response.result.isSuccess {
				if let value = response.result.value, let recognizeResponse: RecognizeResponse = decode(value) {
					if let error = recognizeResponse.error {
						self.delegate?.errorResponse(message: error)
					} else {
						self.persons = recognizeResponse.persons
						self.delegate?.recognizeResponse()
					}
				}
			} else {
				self.delegate?.errorResponse(message: "API Broke")
			}
		}
	}
}
