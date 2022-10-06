//
//  CollectionViewCell.swift
//  cartoon
//
//  Created by pawan kumar on 05/10/22.
//

import UIKit

extension HomeVC {

    func initialisePopularAndTrendingData() {
        self.popularItems.removeAll()
        self.trendingItems.removeAll()
        var items:[Items] = []
            //initialise category
        var effectsData:EffectsManager?
        
        effectsData = EffectsManager.loadFullChangeoverData()
        if let categories = effectsData?.categories  {
            for category in categories {
                if category.icon != nil && (category.items?.count ?? 0) > 0 {
                    for data in category.items ?? [] {
                        if data.bg != nil && data.icon != nil{
                            items.append(data)
                            items[items.count - 1].effect = .realisticCartoon
                        }
                    }
                    
                }
            }
        }
        
        effectsData = EffectsManager.loadFullChangeoverData()
        if let categories = effectsData?.categories  {
            for category in categories {
                if category.icon != nil && (category.items?.count ?? 0) > 0 {
                    for data in category.items ?? [] {
                        if data.bg != nil && data.icon != nil{
                            items.append(data)
                            items[items.count - 1].effect = .newProfilePic
                        }
                    }
                    
                }
            }
        }
        

        var maxCount = (items.count / 2) - 1
        if maxCount > 30 {
            maxCount = 30
        }
        
        let uniquePopularIndex = Int.getUniqueRandomNumbers(min: 0, max: items.count - 1 , count: maxCount)
        let uniqueTrendingIndex = Int.getUniqueRandomNumbers(min: 0, max: items.count - 1 , count: maxCount )

        for index in uniquePopularIndex {
            popularItems.append(items[index])
        }

        for index in uniqueTrendingIndex {
            trendingItems.append(items[index])
        }
    }
}
















//        effectsData = EffectsManager.loadToonAvatarsData()
//        if let categories = effectsData?.categories  {
//            for category in categories {
//                if category.icon != nil && (category.items?.count ?? 0) > 0 {
//                    for data in category.items ?? [] {
//                        if data.bg != nil && data.icon != nil{
//                            items.append(data)
//                            items[items.count - 1].effect = .funnyCaricatures
//                        }
//                    }
//
//                }
//            }
//        }
