//
//  Request.swift
//  YATADemo
//
//  Created by Alejandro Ravasio on 09/09/2022.
//

import Foundation
import SwiftUI

protocol Request: ObservableObject {
    var baseUrl: String { get }
    var method: String { get }
    var apiKey: String { get }
}
