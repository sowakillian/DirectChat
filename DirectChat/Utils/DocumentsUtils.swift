//
//  DocumentsUtils.swift
//  DirectChat
//
//  Created by SOWA KILLIAN on 09/02/2021.
//

import Foundation

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}
