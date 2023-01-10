//
//  Helper.swift
//  FilmCollectionView
//
//  Created by Deniz Ata Eş on 10.01.2023.
//

import Foundation
import UIKit

class Helper {
    static let shared = Helper()
    
    func height(for text: String, with font: UIFont, width: CGFloat) -> CGFloat
    {
        let nsstring = NSString(string: text)
        let maxHeight = CGFloat(MAXFLOAT)//alabileceği maximumum değer
        let textAttributes = [NSAttributedString.Key.font : font]
        let boundingRect = nsstring.boundingRect(with: CGSize(width: width, height: maxHeight), options: .usesLineFragmentOrigin, attributes: textAttributes, context: nil)
        return ceil(boundingRect.height)
    }
    
    func convertDate(dateString: String?) -> String{
        guard dateString != nil else {return ""}
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-DD"
        
        let date = dateFormatter.date(from: dateString!)
        let formatted = date?.formatted(
            .dateTime
                .day().month(.wide).year()
        )
        return formatted ?? ""
    }
    
    
}
