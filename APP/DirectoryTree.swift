//
//  DirectoryTree.swift
//  APP
//
//  Created by 段剀越 on 16/1/11.
//  Copyright © 2016年 段剀越. All rights reserved.
//目录树——目录树管理模块负责对本地目录树进行管理,包括文件/子目录节点的添加、文件/子目录 节点的删除、指向父/子目录等

import Foundation
class Directory
{
    func path()
    {}
    
    func name()
    {}
    
    func timeStamp()
    {}
    
    func parent()
    {}
    
    func subFiles()
    {}
    
    func subDirectories()
    {}
}

class SubDirectory:Directory
{
    func layout()
    {}
    
    func createTime()
    {}
}

class SubFile
{
    func name()
    {}
    
    func path()
    {}
    
    func timeStamp()
    {}
    
    func modifyDate()
    {}
    
    func size()
    {}
    
    func segSize()
    {}
    
    func method()
    {}
    
    func segs()
    {}
}

class Segment
{
    func name()
    {}
    
    func ID()
    {}
    
    func size()
    {}
    
    func checkSum()
    {}
    
    func parity()
    {}
}
