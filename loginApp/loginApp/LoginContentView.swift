//
//  LoginContentView.swift
//  loginApp
//
//  Created by Тарас Минин on 23/05/2021.
//

import SwiftUI
import Combine

struct LoginContentView: View {

    @ObservedObject private var viewModel = LoginViewModel()

    var body: some View {
        VStack(
            alignment: .center,
            spacing: 16,
            content: {

                Spacer()
                Text("LoginApp").font(.largeTitle).bold()


                VStack(alignment: .leading, spacing: 0, content: {
                    Text("Account name:").padding(.bottom, 8)
                    TextField("", text: $viewModel.accountName)

                    Text(viewModel.accountError)
                        .font(.footnote)
                        .foregroundColor(.red)
                })

                VStack(alignment: .leading, spacing: 0, content: {
                    Text("Password:").padding(.bottom, 8)
                    SecureField("", text: $viewModel.password)

                    Text(viewModel.passwordError)
                        .font(.footnote)
                        .foregroundColor(.red)
                })

                VStack(alignment: .leading, spacing: 0, content: {
                    Text("Repeat Password:").padding(.bottom, 8)
                    SecureField("", text: $viewModel.passwordRepeat)

                    Text(viewModel.passwordMatchError)
                        .font(.footnote)
                        .foregroundColor(.red)
                })

                VStack(alignment: .center, spacing: 4, content: {

                    Button("Create Account") {
                        accountCreated()
                    }.padding(8)
                    .font(.callout)
                    .disabled(!viewModel.isValid)
                })

                Spacer()
            }
        )
        .padding(.horizontal, 32.0)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(hue: 0.134, saturation: 0.106, brightness: 0.978, opacity: 0.501)/*@END_MENU_TOKEN@*/)
        .alert(isPresented: $created, content: {
            Alert(
                title: Text("Account created!"),
                dismissButton: .default(Text("OK"))
            )
        })
    }

    @State var created = false

    func accountCreated() {
        created = true
        viewModel.reset()

        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}

struct LoginContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginContentView()
    }
}
