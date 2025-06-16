import SwiftUI

struct LoginView: View {
    @StateObject private var loginVM = LoginViewModel()
    @EnvironmentObject var auth: Auth
    var body: some View {
        ZStack{
            MeshGradient(width: 3, height: 3, points: [
                .init(0, 0), .init(0.5, 0), .init(1, 0),
                .init(0, 0.3), .init(0.5, 0.3), .init(1, 0.5),
                .init(0, 1), .init(0.5, 1), .init(1, 1)
            ], colors: [
                .clear, .clear, .clear,
                .green, .green, .teal,
                .blue, .teal, .mint
            ])
            .opacity(0.6)
            .ignoresSafeArea()
            Rectangle()
                .fill(Color(.systemBackground).opacity(0.3))
                .frame(maxWidth: 400, maxHeight: 500)
                .cornerRadius(20)
                .padding()
            VStack{
                Text("SwiftAP").font(.title).fontWeight(.bold).padding(.bottom,96)
                TextField("StudentID", text: $loginVM.credentials.studentid)
                    .padding()
                    .frame(width: 250)
                    .background(Color(.systemGray5))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                SecureField("Password", text: $loginVM.credentials.password)
                    .padding()
                    .frame(width: 250)
                    .background(Color(.systemGray5))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.bottom,loginVM.showProgressVIew ? 10 : 48)
                    .onSubmit{
                        loginVM.login{
                            success in
                            if success {
                                auth.updateValidation(success: true)
                            }
                        }
                    }
                if loginVM.showProgressVIew{
                    ProgressView().padding(.bottom,10)
                }
                Button("Login"){
                    loginVM.login{
                        success in
                        if success{
                            auth.updateValidation(success: true)
                        }
                    }
                }
                .disabled(loginVM.loginDisabled)
                .foregroundStyle(.white)
                .frame(width: 250, height: 50)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }.alert(item:$loginVM.error){error in
                Alert(title: Text("Invalid Login"), message: Text(error.localizedDescription), dismissButton: .default(Text("OK")))
            }
        }.toolbar(.hidden)
    }
    
}

#Preview {
    LoginView()
}
