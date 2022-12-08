//
//  ContentView.swift
//  DallApi
//
//  Created by Christopher Samso on 12/8/22.
//

import SwiftUI

struct ContentView: View {
    @State private var prompt: String = ""
    @State private var image: UIImage? = nil
    @State private var isLoading: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                    TextField("Enter prompt", text: $prompt, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .ignoresSafeArea(.keyboard)
                    
                    Button("Generate") {
                        isLoading = true
                        Task {
                            do {
                                let response = try await DalleImageGenerator.shared.genImage(withPrompt: prompt, apiKey: Secrets.apiKey)
                                if let url = response.data.map(\.url).first {
                                    let (data, _) = try await URLSession.shared.data(from: url)
                                    
                                    image = UIImage(data: data)
                                    isLoading = false
                                }
                            } catch {
                                print(error)
                            }
                            
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    
                    if let image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 300, height: 450)
                            .cornerRadius(8.0)
                            .overlay {
                                if isLoading {
                                    VStack {
                                        ProgressView()
                                        Text("Loading...")
                                    }
                                }
                            }
                        Button {
                            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                        } label: {
                            Text("Save Image")
                        }
                    } else {
                        Rectangle()
                            .fill(Color.blue)
                            .frame(width: 350, height: 450)
                            .cornerRadius(8.0)
                            .overlay {
                                if isLoading {
                                    VStack {
                                        ProgressView()
                                        Text("Loading...")
                                    }
                                }
                            }
                    }
                    Spacer()
                }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
