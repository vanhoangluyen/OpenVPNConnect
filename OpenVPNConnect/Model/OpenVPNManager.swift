//
//  VPNManager.swift
//  OpenVPNConnect
//
//  Created by apple on 5/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import OpenVPNAdapter
import NetworkExtension


class OpenVPNManager: NSObject {
    
    static let shared: OpenVPNManager = {
       let instance = OpenVPNManager()
        instance.providerManager.localizedDescription = Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String
        instance.loadProfile(callback: nil)
        return instance
    }()
    
    var ipServerAdress: String?
    var providerManager =  {NETunnelProviderManager.shared()}()
    public var status : NEVPNStatus { get { return providerManager.connection.status }}
    public var isConnected: Bool {
        get {
            return status == .connected
        }
    }
    public var isDisconnected: Bool {
        get {
            return (status == .invalid)
            || (status == .disconnected)
            || (status == .reasserting)
        }
    }
    func saveProfile(callback: ((Bool)->Void)?) {
        // Save configuration in the Network Extension preferences
        self.providerManager.saveToPreferences(completionHandler: { (error) in
            if error == nil {
                print("Save Error")
                callback?(false)
            } else {
                callback?(true)
            }
        })
    }
    public func connectWithCertificate(onError: @escaping (String)->Void) {
        // Assuming the app bundle contains a configuration file named 'client.ovpn' lets get its
        // Data representation
        guard let filePath = Bundle.main.url(forResource: "client", withExtension: "ovpn") else {return}
        guard let dataCertificate = try? Data(contentsOf: filePath) else {return}
        print("Content client certificate \(dataCertificate.debugDescription)")
        let tunnelProtocol = NETunnelProviderProtocol()
        
        // If the ovpn file doesn't contain server address you can use this property
        // to provide it. Or just set an empty string value because `serverAddress`
        // property must be set to a non-nil string in either case.
        //                tunnelProtocol.serverAddress = ""
        // The most important field which MUST be the bundle ID of our custom network
        // extension target.
        tunnelProtocol.providerBundleIdentifier = "com.BigZero.OpenVPNConnect"
        // Use `providerConfiguration` to save content of the ovpn file.
        tunnelProtocol.providerConfiguration = ["ovpn": dataCertificate]
        // Provide user credentials if needed. It is highly recommended to use
        // keychain to store a password.
        //tunnelProtocol.username = "username"
        //tunnelProtocol.passwordReference = "..." // A persistent keychain reference to an item containing the password
        tunnelProtocol.serverAddress = ipServerAdress
        self.providerManager.localizedDescription = "OpenVPN Client"
        loadProfile { _ in
            // Finish configuration by assigning tunnel protocol to `protocolConfiguration`
            // property of `providerManager` and by setting description.
            self.providerManager.protocolConfiguration = tunnelProtocol
            self.providerManager.isEnabled = true
            self.saveProfile { success in
                if !success {
                    onError("Unable to save vpn profile")
                    return
                }
                self.loadProfile() { success in
                    if !success {
                        onError("Unable to load profile")
                        return
                    }
                    let result = self.startOpenVPNTunnel()
                    if !result {
                        onError("Can't connect")
                    }
                }
            }
        }
    }
    private func loadProfile(callback: ((Bool)->Void)?) {
        providerManager.protocolConfiguration = nil
        NETunnelProviderManager.loadAllFromPreferences { (managers, error) in
            guard error == nil else { return }
            self.providerManager = managers?.first ?? NETunnelProviderManager()
            self.providerManager.loadFromPreferences(completionHandler: { (error) in
                if error == nil {
                    print("Failed to load preferences: \(String(describing: error?.localizedDescription))")
                    callback?(false)
                } else {
                    callback?(self.providerManager.protocolConfiguration != nil)
                }
            })
        }
//        providerManager.loadFromPreferences(completionHandler: { (error) in
//            if error == nil {
//                print("Failed to load preferences: \(String(describing: error?.localizedDescription))")
//                callback?(false)
//            } else {
//                callback?(self.providerManager.protocolConfiguration != nil)
//            }
//        })
    }
    private func startOpenVPNTunnel() -> Bool {
            do {
                try self.providerManager.connection.startVPNTunnel()
                return true
            } catch NEVPNError.configurationInvalid {
                print("Failed to start tunnel (configuration invalid)")
            } catch NEVPNError.configurationDisabled {
                print("Failed to start tunnel (configuration disabled)")
            } catch {
                print("Failed to start tunnel (other error)")
            }
            return false
    }
    public func stopOpenVPNTunnel(completionHandler: (()->Void)? = nil) {
        providerManager.saveToPreferences(completionHandler: { _  in
            self.providerManager.connection.stopVPNTunnel()
            completionHandler?()
        })
    }
    
}
