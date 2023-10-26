//
//  File.swift
//  
//
//  Created by htcuser on 26/10/23.
//

import Foundation

public class GCPLogConfig{
    public static let shared = GCPLogConfig()
    private init(){}
        
    public var gcpURL: String = ""
    public var gcpToken: String = ""
    public var projectID: String = ""
    
    public func config(gcpUrl: String, gcpToken: String, projectID: String){
        self.gcpURL = gcpUrl
        self.gcpToken = gcpToken
        self.projectID = projectID
    }
}
