//
//  QuicheTestUrls.swift
//  quiche-test
//
//  Created by Anthony Doeraene on 08/09/2024.
//

import Foundation

enum QuicTestUrl: String, Identifiable, CaseIterable{
    var id: String{
        rawValue
    }
    
    // list taken from https://bagder.github.io/HTTP3-test/
    case aioquic = "https://quic.aiortc.org"
    case aioquic_2 = "https://pgjones.dev"
    case quiche = "https://cloudflare-quic.com"
    case quiche_2 = "https://quic.tech"
    case mvfst = "https://fb.mvfst.net"
    case google_quiche = "https://quic.rocks"
    case f5 = "https://f5quic.com"
    case lsquic = "https://www.litespeedtech.com"
    case ngtcp2 = "https://nghttp2.org"
    case picoquic = "https://test.privateoctopus.com"
    case h20 = "https://h2o.examp1e.net"
    case msquic = "https://quic.westus.cloudapp.azure.com"
    case apache = "https://docs.trafficserver.apache.org"
}
