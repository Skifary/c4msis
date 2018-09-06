//
//  PacketTunnelProvider.swift
//  PacketTunnel
//
//  Created by Skifary on 25/12/2017.
//  Copyright © 2017 skifary. All rights reserved.
//

import NetworkExtension
import NEKit
import CocoaLumberjackSwift
import Yaml

typealias SSConfig = (address: String, port: Int, method: String, password: String, yamlString: String, customRules: String)

class PacketTunnelProvider: NEPacketTunnelProvider {

    var interface: TUNInterface!

    var proxyPort: Int = 9090

    var httpServer: ProxyServer!

    var socks5Server: ProxyServer!
    
    var lastPath:NWPath?

    override func startTunnel(options: [String : NSObject]?, completionHandler: @escaping (Error?) -> Void) {
        DDLog.removeAllLoggers()
        DDLog.add(DDASLLogger.sharedInstance, with: DDLogLevel.info)
        ObserverFactory.currentFactory = DebugObserverFactory()
        NSLog("-------------")

        guard let config = (protocolConfiguration as! NETunnelProviderProtocol).providerConfiguration else{
            NSLog("[ERROR] No ProtocolConfiguration Found")
            exit(EXIT_FAILURE)
        }

        guard let networkSettings = networkSettings(from: config)  else {
            NSLog("[ERROR] NetworkSettings Is Nil")
            exit(EXIT_FAILURE)
        }

        setTunnelNetworkSettings(networkSettings) { error in
            guard error == nil else {
                DDLogError("Encountered an error setting up the network: \(error.debugDescription)")
                completionHandler(error)
                return
            }

            self.httpServer = GCDHTTPProxyServer(address: IPAddress(fromString: "127.0.0.1"), port: NEKit.Port(port: UInt16(self.proxyPort)))
            
            self.socks5Server = GCDSOCKS5ProxyServer(address: IPAddress(fromString: "127.0.0.1"), port: NEKit.Port(port: UInt16(self.proxyPort + 1)))
 
            do {
                try self.httpServer.start()
                try self.socks5Server.start()
            } catch let error {
                
                self.httpServer.stop()
                self.socks5Server.stop()
                
                completionHandler(error)
            }
            
            completionHandler(nil)
        }

    }

    override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {

        if(httpServer != nil){
            httpServer.stop()
            httpServer = nil
            RawSocketFactory.TunnelProvider = nil
        }
        if(socks5Server != nil){
            socks5Server.stop()
            socks5Server = nil
            RawSocketFactory.TunnelProvider = nil
        }

        completionHandler()
        exit(EXIT_SUCCESS)
    }
}

extension PacketTunnelProvider {
    
    func check(config: [String : Any]) -> SSConfig? {
        
        guard let ssAddress = config["ss_address"] as? String  else {
            NSLog("[ERROR] Address Is Nil")
            return nil
        }
        
        guard let ssPort = config["ss_port"] as? Int  else {
            NSLog("[ERROR] Address Is Nil")
            return nil
        }
        
        guard let ssMethod = config["ss_method"] as? String  else {
            NSLog("[ERROR] Method Is Nil")
            return nil
        }
        
        guard let ssPassword = config["ss_password"] as? String  else {
            NSLog("[ERROR] Password Is Nil")
            return nil
        }
        
        guard let ssYAMLStr = config["ymal_conf"] as? String  else {
            NSLog("[ERROR] YAML Is Nil")
            return nil
        }
        
        guard let ssCustomRule = config["custome_rule"] as? String  else {
            NSLog("[ERROR] Custome Rule Is Nil")
            return nil
        }
        
        return (ssAddress, ssPort, ssMethod, ssPassword, ssYAMLStr, ssCustomRule)
    }
    
    func shadowsocksAdapterFactory(from ssConfig: SSConfig) -> ShadowsocksAdapterFactory {
    
        let algorithm: CryptoAlgorithm
        switch ssConfig.method {
        case "AES-128-CFB":
            algorithm = .AES128CFB
        case "AES-192-CFB":
            algorithm = .AES192CFB
        case "AES-256-CFB":
            algorithm = .AES256CFB
        case "CHACHA20":
            algorithm = .CHACHA20
        case "SALSA20":
            algorithm = .SALSA20
        case "RC4-MD5":
            algorithm = .RC4MD5
        default:
            fatalError("Undefined algorithm!")
        }
        
        let obfuscater = ShadowsocksAdapter.ProtocolObfuscater.OriginProtocolObfuscater.Factory()
        let cryptorFactory =  ShadowsocksAdapter.CryptoStreamProcessor.Factory(password: ssConfig.password, algorithm: algorithm)
        let streamObfuscaterFactory = ShadowsocksAdapter.StreamObfuscater.OriginStreamObfuscater.Factory()
        
        let ssAdapterFactory = ShadowsocksAdapterFactory(serverHost: ssConfig.address, serverPort: ssConfig.port, protocolObfuscaterFactory:obfuscater, cryptorFactory: cryptorFactory, streamObfuscaterFactory: streamObfuscaterFactory)
        
        return ssAdapterFactory
    }
    
    func setCurrentRules(_ ssConfig: SSConfig) {
        
        let ssAdapterFactory = shadowsocksAdapterFactory(from: ssConfig)
        let directAdapterFactory = DirectAdapterFactory()

//        //Get lists from conf
//        let yamlString = ssConfig.yamlString
//        let yamlValue = try! Yaml.load(yamlString)
//
//        var userRules: [NEKit.Rule] = []
//
//        for each in (yamlValue["rule"].array!) {
//
//            let adapter: NEKit.AdapterFactory = each["adapter"].string! == "direct" ? directAdapterFactory : ssAdapterFactory
//
//            let ruleType = each["type"].string!
//            switch ruleType {
//            case "domainlist":
//                var ruleArray: [NEKit.DomainListRule.MatchCriterion] = []
//                for dom in each["criteria"].array!{
//                    let rawDom: NSString = NSString(string: dom.string!)
//                    let type = rawDom.substring(to: 1)
//                    let url = rawDom.substring(from: 2)
//                    if type == "s" {
//                        ruleArray.append(DomainListRule.MatchCriterion.suffix(url))
//                    } else if type == "k" {
//                        ruleArray.append(DomainListRule.MatchCriterion.keyword(url))
//                    } else if type == "p" {
//                        ruleArray.append(DomainListRule.MatchCriterion.prefix(url))
//                    }
//                }
//                userRules.append(DomainListRule(adapterFactory: adapter, criteria: ruleArray))
//            case "iplist":
//                let ipArray = each["criteria"].array!.map{$0.string!}
//                userRules.append(try! IPRangeListRule(adapterFactory: adapter, ranges: ipArray))
//
//            default:
//                break
//            }
//
//        }
        
        var userRules: [NEKit.Rule] = []
        
        parseYAMLRule(ssConfig.yamlString, ssAdapterFactory, directAdapterFactory, &userRules)
        parseYAMLRule(ssConfig.customRules, ssAdapterFactory, directAdapterFactory, &userRules)

        // Rules
        let chinaRule = CountryRule(countryCode: "CN", match: true, adapterFactory: directAdapterFactory)
        let unknownLoc = CountryRule(countryCode: "--", match: true, adapterFactory: directAdapterFactory)
        let dnsFailRule = DNSFailRule(adapterFactory: ssAdapterFactory)
        
        let allRule = AllRule(adapterFactory: ssAdapterFactory)
        userRules.append(contentsOf: [chinaRule, unknownLoc, dnsFailRule, allRule])
        
        let manager = RuleManager(fromRules: userRules, appendDirect: true)
        
        RuleManager.currentManager = manager
    }
    
    func proxySettings() -> NEProxySettings {
        
        let proxySettings = NEProxySettings()
        proxySettings.httpEnabled = true
        proxySettings.httpServer = NEProxyServer(address: "127.0.0.1", port: proxyPort)
        proxySettings.httpsEnabled = true
        proxySettings.httpsServer = NEProxyServer(address: "127.0.0.1", port: proxyPort)
        proxySettings.excludeSimpleHostnames = true
        // This will match all domains
        proxySettings.matchDomains = [""]
        proxySettings.exceptionList = ["api.smoot.apple.com","configuration.apple.com","xp.apple.com","smp-device-content.apple.com","guzzoni.apple.com","captive.apple.com","*.ess.apple.com","*.push.apple.com","*.push-apple.com.akadns.net"]
        
        return proxySettings
    }
    
    func networkSettings(from config: [String : Any]) -> NETunnelNetworkSettings? {

        guard let ssConfig = check(config: config) else {
            NSLog("[ERROR] ss config Is Nil")
            return nil;
        }
        
        setCurrentRules(ssConfig)
        
        // the `tunnelRemoteAddress` is meaningless because we are not creating a tunnel.
        let networkSettings = NEPacketTunnelNetworkSettings(tunnelRemoteAddress: "8.8.8.8")
        networkSettings.mtu = 1500
        
        let ipv4Settings = NEIPv4Settings(addresses: ["192.169.89.1"], subnetMasks: ["255.255.255.0"])
        networkSettings.ipv4Settings = ipv4Settings
        networkSettings.proxySettings = proxySettings()
        
        return networkSettings
    }
    
    func parseYAMLRule(_ yamlString: String, _ ssAdapterFactory: ShadowsocksAdapterFactory, _ directAdapterFactory: DirectAdapterFactory, _ userRules: inout [NEKit.Rule]) {
        let yamlValue = try! Yaml.load(yamlString)
        

        for each in (yamlValue["rule"].array!) {
            
            let adapter: NEKit.AdapterFactory = each["adapter"].string! == "direct" ? directAdapterFactory : ssAdapterFactory
            
            let ruleType = each["type"].string!
            switch ruleType {
            case "domainlist":
                var ruleArray: [NEKit.DomainListRule.MatchCriterion] = []
                for dom in each["criteria"].array!{
                    let rawDom: NSString = NSString(string: dom.string!)
                    let type = rawDom.substring(to: 1)
                    let url = rawDom.substring(from: 2)
                    if type == "s" {
                        ruleArray.append(DomainListRule.MatchCriterion.suffix(url))
                    } else if type == "k" {
                        ruleArray.append(DomainListRule.MatchCriterion.keyword(url))
                    } else if type == "p" {
                        ruleArray.append(DomainListRule.MatchCriterion.prefix(url))
                    }
                }
                userRules.append(DomainListRule(adapterFactory: adapter, criteria: ruleArray))
            case "iplist":
                let ipArray = each["criteria"].array!.map{$0.string!}
                userRules.append(try! IPRangeListRule(adapterFactory: adapter, ranges: ipArray))
                
            default:
                break
            }
            
        }
    }

}
