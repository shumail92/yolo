//
//  SaveCityDelegate.swift
//  CityGuide
//
//  Created by Shumail Mohy ud Din on 4/26/17.
//  Copyright © 2017 TUM LS1. All rights reserved.
//

protocol SaveCityDelegate: class {
    func didPressSave(cityG: City) -> Bool
}
