//
//
//import SwiftUI
//
//import SwiftUI
//
//struct BuyProView: View {
//
//    @Binding var buyPremium: Bool
//
//    @ObservedObject var viewModel: BuyProViewModel
//
//    var body: some View {
//        ZStack {
//            LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.5), Color.white.opacity(0.5)]), startPoint: .topLeading, endPoint: .bottomTrailing)
//                .background(Color.black)
//                .ignoresSafeArea()
//
//            ScrollView {
//                VStack {
//                    VStack {
//                        Text("Unlock Unlimited Access")
//                            .font(.title2)
//                            .fontWeight(.bold)
//                            .foregroundColor(.white)
//                    }.padding(.bottom, 5)
//
//                    VStack {
//                        HStack {
//                            Button(action: {
//                                buyPremium = false
//                            }) {
//                                Text("x")
//                                    .font(.title)
//                                    .foregroundColor(.blue)
//                                    .frame(width: 35, height: 35)
//                                    .background(Color.blue.opacity(0.2))
//                                    .cornerRadius(10)
//                            }.padding(.horizontal, 10)
//
//                            Spacer()
//
//                            Button(action: {
//                                print("Restored")
//                            }) {
//                                Text("Restore")
//                                    .font(.title2)
//                                    .foregroundColor(.blue)
//                                    .padding(5)
//                                    .background(Color.blue.opacity(0.2))
//                                    .cornerRadius(10)
//                            }.padding(.horizontal, 10)
//                        }
//
//                        VStack(alignment: .leading) {
//                            HStack {
//                                Text(Image(systemName: "checkmark.seal")) + Text(" Unlock All Features")
//                            }.padding(.bottom, 10)
//                            .foregroundColor(.white)
//
//                            HStack {
//                                Text(Image(systemName: "checkmark.seal")) + Text(" Unlimited Saving")
//                            }.padding(.bottom, 10)
//                            .foregroundColor(.white)
//
//                            HStack {
//                                Text(Image(systemName: "checkmark.seal")) + Text(" 100% Secure")
//                            }.padding(.bottom, 10)
//                            .foregroundColor(.white)
//
//                            HStack {
//                                Text(Image(systemName: "checkmark.seal")) + Text(" No Ads")
//                            }.foregroundColor(.white)
//                            .padding(.bottom, 10)
//                        }.padding(.top, 5)
//
//                        VStack(alignment: .leading) {
//                            ForEach(viewModel.packages.indices) { index in
//                                Button(action: {
//                                    viewModel.selectedOption = index
//                                }) {
//                                    PackageRowView(package: viewModel.packages[index], isSelected: viewModel.selectedOption == )
//                                }
//                                .padding(.vertical, 5)
//                            }
//                        }.padding()
//                        .onAppear {
//                            viewModel.selectedOption = 1 // Default selected option is Yearly Package
//                        }.padding(.all, 7)
//
//                        VStack {
//                            Button(action: {
//                                viewModel.subscribe()
//                            }) {
//                                Text("Subscribe Now")
//                                    .font(.title2)
//                                    .padding()
//                                    .frame(maxWidth: .infinity)
//                            }
//                            .buttonStyle(.borderedProminent)
//                            .padding(.horizontal, 40)
//                            .padding(.bottom, 10)
//
//                            Text("Auto-renewable. Cancel anytime.")
//                                .foregroundColor(.init(white: 0.85))
//                                .font(.title3)
//                        }
//                    }
//                    Spacer()
//                }
//            }
//            .navigationBarBackButtonHidden(true)
//            .navigationBarHidden(true)
//        }
//    }
//}
//
//struct PackageRowView: View {
//    let package: ProPackage
//    let isSelected: Bool
//
//    var body: some View {
//        HStack {
//            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
//                .resizable()
//                .frame(width: 20, height: 20)
//
//            VStack(alignment: .leading) {
//                Text(package.name)
//                    .font(.headline)
//
//                Text(package.pricePerWeek)
//                    .font(.subheadline)
//                    .foregroundColor(.init(white: 0.85))
//            }
//
//            Spacer()
//            Text(package.totalPrice)
//        }
//        .padding()
//        .background(isSelected ? Color.blue.opacity(0.2) : Color.clear)
//        .cornerRadius(10)
//    }
//}
//
//struct BuyProView_Previews: PreviewProvider {
//    static var previews: some View {
//        BuyProView(buyPremium: .constant(true), viewModel: BuyProViewModel())
//    }
//}
