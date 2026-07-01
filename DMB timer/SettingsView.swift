import SwiftUI
import PhotosUI

struct SettingsView: View {
    @AppStorage("percentageAccuracy") private var percentageAccuracy = 5
    // Сохраняем картинку в виде бинарных данных
    @AppStorage("backgroundImageData") private var backgroundImageData: Data?
    
    @State private var showAboutAlert = false
    @State private var selectedItem: PhotosPickerItem?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .systemBackground).ignoresSafeArea()
                
                VStack {
                    ScrollView {
                        VStack(spacing: 12) {
                            
                            // 1. Фото фона
                            VStack(spacing: 0) {
                                PhotosPicker(selection: $selectedItem, matching: .images) {
                                    SettingRow(title: "Выбрать фото фона")
                                }
                                .onChange(of: selectedItem) {_, newItem in
                                    // Асинхронно загружаем фото и сохраняем его в AppStorage
                                    Task {
                                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                            backgroundImageData = data
                                        }
                                    }
                                }
                                
                                // Кнопка сброса фона
                                if backgroundImageData != nil {
                                    Button(action: {
                                        backgroundImageData = nil
                                        selectedItem = nil
                                    }) {
                                        Text("Удалить фон (вернуть темный)")
                                            .font(.footnote)
                                            .foregroundColor(.red)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.horizontal)
                                            .padding(.top, 8)
                                    }
                                }
                            }
                            
                            // 2. Точность процента
                            HStack {
                                Text("Точность процента")
                                    .foregroundColor(.white)
                                Spacer()
                                Picker("", selection: $percentageAccuracy) {
                                    Text("2 знака").tag(2)
                                    Text("3 знака").tag(3)
                                    Text("4 знака").tag(4)
                                    Text("5 знаков").tag(5)
                                    Text("6 знаков").tag(6)
                                }
                                .pickerStyle(.menu)
                                .tint(.gray)
                            }
                            .padding()
                            .background(Color(uiColor: .secondarySystemBackground))
                            .cornerRadius(12)
                            
                            // 3. Сообщить о проблеме (открывает почту)
                            Button(action: {
                                let email = "maksbuk.dev@gmail.com"
                                let subject = "DMB Timer: Ошибка"
                                let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                                if let url = URL(string: "mailto:\(email)?subject=\(encodedSubject)") {
                                    UIApplication.shared.open(url)
                                }
                            }) {
                                SettingRow(title: "Сообщить о проблеме")
                            }
                            
                            // 4. О разработчике
                            Button(action: { showAboutAlert = true }) {
                                SettingRow(title: "О разработчике")
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 16)
                    }
                    
                    Spacer()
                    
                    Link("Политика конфиденциальности", destination: URL(string: "https://example.com/privacy")!)
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(.bottom, 20)
                }
            }
            .navigationTitle("Настройки")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(.dark)
            .alert("О разработчике", isPresented: $showAboutAlert) {
                Button("ОК", role: .cancel) {}
            } message: {
                Text("Приложение разработано в рамках практики.\nАвтор: Bukatsin Maksimilian.")
            }
        }
    }
}

// Вспомогательный компонент строки настроек
struct SettingRow: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.white)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .font(.footnote)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}
