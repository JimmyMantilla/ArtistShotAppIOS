import Resolver
import SwiftUI

struct LoginView: View {
    @InjectedObject var viewModel: NotesViewModel

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Notes Pro")
                    .font(.largeTitle)
                    .bold()

                TextField("Username", text: $viewModel.username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .disableAutocorrection(true)

                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button("Login") {
                    viewModel.login()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)

                if viewModel.loginFailed {
                    Text("Invalid credentials")
                        .foregroundColor(.red)
                }

                NavigationLink(
                    destination: NotesListView(),
                    isActive: $viewModel.isLoggedIn,
                    label: { EmptyView() }
                )
            }
            .padding()
        }
    }
}
