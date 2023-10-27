// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

public class GCPLogging: NSObject{
    
    public static func save(logData: [String: Any]) {
        if GCPLogConfig.shared.gcpURL != "" && GCPLogConfig.shared.gcpURL != "" && GCPLogConfig.shared.projectID != ""{
            let param = gcpParams(projcetId: GCPLogConfig.shared.projectID, logData: logData)
            
            DispatchQueue(label: "com.gcp.logging", qos: .background).async {
                GCPNetworking.shared.logData(with: GCPLogConfig.shared.gcpURL, token: GCPLogConfig.shared.gcpToken, params: param)
            }
        }else{
            print("GCPLogs - Configuration Missing")
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

