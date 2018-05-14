//
//  OpenVPNManagerConnect.swift
//  OpenVPNConnect
//
//  Created by apple on 5/11/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import NetworkExtension
import OpenVPNAdapter

class OpenVPNManagerConnect: NSObject {
    static let shared : OpenVPNManagerConnect = OpenVPNManagerConnect()
    
    let manager = {PacketTunnelProvider()}()
    public var status: OpenVPNAdapterEvent {
        get {
            return OpenVPNManagerConnect().status
        }
    }
    public var isConnected: Bool  {
        get {
            return status == .connected
        }
    }
    public var isDisconnected: Bool {
        get {
            return (status == .disconnected)
                || (status == .reconnecting)
        }
    }
    func startOpenVPNTunnel(){
        manager.startTunnel(options: nil) { (error) in
            print("\(error.debugDescription)")
        }
        print("Connected")
    }
    func stopOpenVPNTunnel() {
        manager.stopTunnel(with: .userLogout) {
            print("Stop Open VPN")
        }
    }
}
