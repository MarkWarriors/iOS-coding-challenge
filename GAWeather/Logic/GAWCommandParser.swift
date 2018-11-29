//
//  GAWCommandParser.swift
//  GAWeather
//
//  Created by Marco Guerrieri on 29/11/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import Foundation


public class GAWCommandParser {

    private typealias OperationBuilder = (NSString) -> GAWOperation
    private typealias AcceptedCommandTuple = (operationBuilder: OperationBuilder, pattern: String)
    
    private let operationsList : [AcceptedCommandTuple]
    
    init() {
        self.operationsList = [
            ({ GAWWeatherOperation(commandText: $0) }, GAWWeatherOperation.regex),
        ]
    }
    
    public func parse(_ command: NSString) -> (Any & GAWOperation)? {
        for (operation, pattern) in operationsList {
            if (command as String).range(of: pattern, options: .regularExpression) != nil {
                return operation(command)
            }
        }
        return nil
    }
    
}
