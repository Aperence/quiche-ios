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
            len = Int(raw_response.len);
            if let res_unwraped = raw_response.data{
                data = String(cString: res_unwraped)
            }else{
                data = nil
            }
        }else{
            status = -1
            data = nil
            len = 0
        }
    }
}

struct ContentView: View {
    @State private var response: Response? = nil;
    @State private var fetching = false;
    @State private var urlString = QuicTestUrl.quiche.rawValue;
    @FocusState private var urlFieldFocused: Bool;
    
    private var url: URL? {
        URL(string: urlString)
    }
    private var host: String? {
        url?.host()
    }
    private var path: String? {
        let path = url?.path()
        if path == ""{
            return "/"
        }
        return path
    }

    var body: some View {
        VStack {
            List{
                Picker("Test server", selection: $urlString){
                    ForEach(QuicTestUrl.allCases){ url in
                        Text(url.rawValue).tag(url.rawValue)
                    }
                }
                TextField("URL", text: $urlString)
                    .focused($urlFieldFocused)
                    .keyboardType(.URL)
                    .textContentType(.URL)
                if let host, let path{
                    Button("Fetch \(host)", systemImage: "dot.radiowaves.up.forward"){
                        quic_fetch()
                    }
                }
                if fetching{
                    ProgressView()
                }
                if let response{
                    if response.status != 0{
                        Text("An error occurred: \(response.status)")
                    }else{
                        HTMLStringView(htmlContent: response.data ?? "<p>Empty response</p>")
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 600)
                            .padding(0)
                    }
                }

            }

        }
        .padding()
    }

    func quic_fetch(){
        if fetching{
            // don't make twice a request at sale time
            return
        }
        Task{
            response = nil
            fetching = true
            let host = makeCString(from: host!)
            let port = makeCString(from: "443")
            let path = makeCString(from: path!)
            let res = fetch(host, port, path)
            response = Response(raw_response: res?.pointee);
            fetching = false
        }
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
