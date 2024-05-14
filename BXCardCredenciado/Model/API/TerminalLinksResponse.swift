//
//  TerminalLinksResponse.swift
//  BXCard
//
//  Created by Rafael Rocha Gans on 28/04/23.
//  Copyright © 2023 Fourtime Informática Ltda. All rights reserved.
//

import Foundation

struct TerminalLinksResponse: Decodable {
    let status: Int
    let results: LinksData
    
}

struct LinksData: Decodable {
    let avisosOperadora: URL?
    let contatoOperadora: URL?
}
