// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

public class GCPLogging: NSObject{
    
    @available(iOS 13.0.0, *)
    public static func save(logData: [String: Any]) async throws{
        let params = gcpParams(projcetId: GCPLogConfig.shared.projectID, logData: logData)
        do{
            try await GCPNetworking.shared.logData(GCPLogConfig.shared.gcpURL, GCPLogConfig.shared.gcpToken, params)
        }catch{
            throw error
        }
    }
    
    private static func gcpParams(projcetId: String,logData: [String: Any]) -> [String: Any]{
        return [
            "entries": [
                [
                    "logName": "projects/\(projcetId)/logs/my-test-log",
                    "resource": [
                        "labels": [
                            "projectId": projcetId,
                            "instance_id":"api",
                            "zone":"india"
                        ],
                        "type": "gce_instance"
                    ],
                    "severity": "INFO",
                    "jsonPayload": logData
                ]
            ],
            "logName": "projects/\(projcetId)/logs/my-test-log"
        ]
    }
}

enum LogType{
    case request
    case response
    case other(detail: String)
}
