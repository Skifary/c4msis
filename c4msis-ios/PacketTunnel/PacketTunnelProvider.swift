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

typealias SSConfig = (address: String, port: Int, method: String, password: String, yamlString: String)

class PacketTunnelProvider: NEPacketTunnelProvider {
    
    var interface: TUNInterface!
    
    var proxyPort: Int = 9090
    
    var proxyServer: ProxyServer!
    
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
            
            self.proxyServer = GCDHTTPProxyServer(address: IPAddress(fromString: "127.0.0.1"), port: NEKit.Port(port: UInt16(self.proxyPort)))
            try! self.proxyServer.start()
            
            completionHandler(nil)
        }
        
    }
    
    override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {

        if(proxyServer != nil){
            proxyServer.stop()
            proxyServer = nil
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
    
        return (ssAddress, ssPort, ssMethod, ssPassword, ssYAMLStr);
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
        
        //Get lists from conf
        let yamlString = ssConfig.yamlString
        let yamlValue = try! Yaml.load(yamlString)
        
        var UserRules:[NEKit.Rule] = []
        
        for each in (yamlValue["rule"].array!) {
            
            let adapter: NEKit.AdapterFactory
            if each["adapter"].string! == "direct"{
                adapter = directAdapterFactory
            }else{
                adapter = ssAdapterFactory
            }
            
            let ruleType = each["type"].string!
            switch ruleType {
            case "domainlist":
                var ruleArray: [NEKit.DomainListRule.MatchCriterion] = []
                for dom in each["criteria"].array!{
                    let rawDom = dom.string?.split(separator: ",")
                    let type = rawDom?[0]
                    let url = String(describing: rawDom?[1])
                    if type == "s"{
                        ruleArray.append(DomainListRule.MatchCriterion.suffix(url))
                    }else if type == "k"{
                        ruleArray.append(DomainListRule.MatchCriterion.keyword(url))
                    }else if type == "p"{
                        ruleArray.append(DomainListRule.MatchCriterion.prefix(url))
                    }
                }
                UserRules.append(DomainListRule(adapterFactory: adapter, criteria: ruleArray))
            case "iplist":
                let ipArray = each["criteria"].array!.map{$0.string!}
                UserRules.append(try! IPRangeListRule(adapterFactory: adapter, ranges: ipArray))
            default:
                break
            }
        }
        
        // Rules
        let chinaRule = CountryRule(countryCode: "CN", match: true, adapterFactory: directAdapterFactory)
        let unknownLoc = CountryRule(countryCode: "--", match: true, adapterFactory: directAdapterFactory)
        let dnsFailRule = DNSFailRule(adapterFactory: ssAdapterFactory)
        
        let allRule = AllRule(adapterFactory: ssAdapterFactory)
        UserRules.append(contentsOf: [chinaRule, unknownLoc, dnsFailRule, allRule])
        
        let manager = RuleManager(fromRules: UserRules, appendDirect: true)
        
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
            NSLog("[ERROR] YAML Is Nil")
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

}
