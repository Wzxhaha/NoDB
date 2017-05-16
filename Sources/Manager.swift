//
//  Manager.swift
//  NoDB
//
//  Created by WzxJiang on 17/5/16.
//  Copyright © 2016年 WzxJiang. All rights reserved.
//
//  https://github.com/Wzxhaha/NoDB
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.


import Foundation

public class Manager<SQLite: SQLiteDBable> {
    
    public var tables: [Tableable]?
    
    private var db: SQLite = SQLite.shared
    
    public func start() {
        db.open { _ in 
            tables?.forEach {
                create(withTable: $0)
            }
        }
    }
    
    private func create(withTable table: Tableable) {
        db.execute(sql: table.createSQL, parameters: nil)
    }
    
    func insert<T: Tableable>(model: T) {
        db.open {
            $0.execute(sql: model.updateSQL, parameters: model.propertys.map { $0.value ?? "" })
        }
    }
    
    func fetch<T: Tableable>(model: T, propertys: [Property]? = nil) -> [T]? {
        db.open {
           return $0.query(sql: model.name, parameters: nil)
        }
        return []
    }
}
