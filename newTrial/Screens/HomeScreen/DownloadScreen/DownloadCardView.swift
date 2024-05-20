//
//  DownloadCardView.swift
//  newTrial
//
//  Created by Hitaishi Savanur on 08/05/24.
//
import SwiftUI

struct DownloadCardView: View {
    
    @ObservedObject var viewModel: DownloadViewModel
    @EnvironmentObject var saveViewModel: SettingsViewModel
    

    var body: some View {
        Form {
            VStack {
                Text("Paste Test Link")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(20)
                    .padding(.top, 30)
            }.listRowSeparator(.hidden)
            HStack {
                VStack {
                    Section {
                        TextField("test link...", text: $viewModel.text)
                            .padding(8)
                            
                    }
                }

                VStack {
                    Section {
                        Button(action: {
                            viewModel.pasteButtonTapped()
                        }) {
                            Text("Paste")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
            .padding(7)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.secondary, lineWidth: 1)
            )

            VStack {
                Button(action: {
                    viewModel.downloadButtonTapped(saveToPhotos: saveViewModel.settings.saveToPhotos)
                }) {
                    Text("Download")
                        .font(.title2)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                VStack {
//
                    Toggle("Save to Camera Roll", isOn: $saveViewModel.settings.saveToPhotos).onChange(of: saveViewModel.settings.saveToPhotos) { newValue in
                                        UserDefaults.standard.set(newValue, forKey: "saveToPhotos")
                                    }
                    .padding(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.secondary, lineWidth: 1)
                    )
                }
                .padding(.top, 40)
            }
        }
        .padding(.top, 30)
    }
}

struct DownloadCardView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadCardView(viewModel: DownloadViewModel()).environmentObject(SettingsViewModel())
    }
}
