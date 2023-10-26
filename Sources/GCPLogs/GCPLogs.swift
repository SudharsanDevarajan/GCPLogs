// The Swift Programming Language
// https://docs.swift.org/swift-book
import SwiftUI


struct configData{
    var gcpURL: String
}


public class ConfigInstance{
    public static let shared = ConfigInstance()
    private init(){}
    
    public static var gcpData: GCPConfig?
}

public class GCPLogs: NSObject{
    @available(iOS 13.0.0, *)
    public static func save(config: GCPConfig,logData: [String: Any]) async throws{
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
                    "jsonPayload": logData
                ]
            ],
            "logName": "projects/\(config.projectID)/logs/my-test-log"
        ]
        do{
            try await Networking.shared.logData(config.gcpUrl, config.gcpToken, params)
        }catch{
            throw error
        }
    }
}


public class GCPConfig{
    let gcpUrl: String
    let gcpToken: String
    let projectID: String
    
    public init(gcpUrl: String,gcpToken: String, projectID: String) {
        self.gcpUrl = gcpUrl
        self.gcpToken = gcpToken
        self.projectID = projectID
    }
}


enum LogType{
    case request
    case response
    case other(detail: String)
}
