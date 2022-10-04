//
//  ContentView.swift
//  KaraokeSDKDemo
//
//  Created by devonly on 2022/04/17.
//

import SwiftUI
import KaraokeSDK
import Combine

struct ContentView: View {
    @State private var requestId: String = "189604"
    @State private var cancellable: AnyCancellable?

    var body: some View {
        Form(content: {
            TextField("189604", text: $requestId)
        })
        .onSubmit({
            if let reqeuestNo: Int = Int(requestId.replacingOccurrences(of: "-", with: "")) {
                cancellable = DKKaraoke.shared.ranking(requestNo: reqeuestNo)
                    .sink(receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            print(error)
                        }
                    }, receiveValue: { response in
                        print(response)
                    })
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
