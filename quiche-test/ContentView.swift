//
//  ContentView.swift
//  quiche-test
//
//  Created by Anthony Doeraene on 05/09/2024.
//

import SwiftUI

struct Response{
    let data: String?
    let status: Int
    let len: Int

    init(raw_response: http_response_t?){
        if let raw_response{
            status = Int(raw_response.status)
            nb_bytes = Int(raw_response.len);
            if let res_unwraped = raw_response.data{
                res = String(cString: res_unwraped)
            }else{
                res = nil
            }
        }else{
            status = -1
            res = nil
            nb_bytes = 0
        }
    }
}

struct ContentView: View {
    @State private var response: Response? = nil;
    private let host = "cloudflare-quic.com"
    private var response_str: String{
        guard let response else { return "Empty response" }
        if response.len < 100{
            return response.data
        }
        return "First 100 bytes of response: \(response.data[..100])"
    }

    var body: some View {
        VStack {
            if let response{
                if response.status != 0{
                    Text("An error occurred: \(response.status)")
                }else{
                    Text("Received \(response.len) bytes")
                    Text(response_str)
                }
            }
            Button("Fetch \(host)"){
                quic_fetch()
            }
        }
        .padding()
    }

    func quic_fetch(){
        let host = makeCString(from: host)
        let port = makeCString(from: "443")
        let res = fetch(host, port)
        response = Response(raw_response: res?.pointee);

    }

    func makeCString(from str: String) -> UnsafeMutablePointer<Int8> {
        let count = str.utf8.count + 1
        let result = UnsafeMutablePointer<Int8>.allocate(capacity: count)
            str.withCString { (baseAddress) in
            result.initialize(from: baseAddress, count: count)
            }
        return result
    }
}

#Preview {
    ContentView()
}
