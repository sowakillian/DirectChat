//
//  GATTJSON.swift
//  Mentalist
//
//  Created by AL on 04/01/2019.
//  Copyright © 2019 AL. All rights reserved.
//

import Foundation

let gattJSON = """
{
"services": [
{
"name": "Service",
"uuid": "D1BDC928-3032-4AE9-9D7F-11BE146252B1",
"characteristics": [
    {
        "name": "ReadChar_UserID",
        "uuid": "F1D117A8-6CC5-43A6-B469-9DDC38A26256",
        "accessType": 0
    },
    {
        "name": "WriteChar",
        "uuid": "B0D0B4FF-B2BE-476B-83C2-228F8D66C3F4",
        "accessType": 1}]
    }

]
}
"""
