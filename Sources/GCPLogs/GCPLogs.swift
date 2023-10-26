// The Swift Programming Language
// https://docs.swift.org/swift-book
import SwiftUI

public class GCPLogs: NSObject{
    @available(iOS 13.0.0, *)
    public static func save(config: GCPConfigure,jsonPayload: [String: Any], forToken: String) async throws{
        let params : [String:Any] = [
            "entries": [
                [
                    "logName": "projects/\(config.projectID)/logs/my-test-log",
                    "resource": [
                        "labels": [
                            "projectId": config.projectID,
                            "instance_id":"api",
                            "zone":"india"
                        ],
                        "type": "gce_instance"
                    ],
                    "severity": "INFO",
                    "jsonPayload": jsonPayload
                ]
            ],
            "logName": "projects/\(config.projectID)/logs/my-test-log"
        ]
        
        do{
            try await Networking.shared.logData(config.gcpUrl, params, forToken)
        }catch{
            throw error
        }
    }
}


public class GCPConfigure{
    let gcpUrl: String
    let projectID: String
    
    public init(gcpUrl: String, projectID: String) {
        self.gcpUrl = gcpUrl
        self.projectID = projectID
    }
}


enum LogType{
    case request
    case response
    case other(detail: String)
}
