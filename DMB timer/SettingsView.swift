import SwiftUI

struct SettingsView: View {
    // Используем @AppStorage для автоматического сохранения настроек в память устройства
    @AppStorage("percentageAccuracy") private var percentageAccuracy = 5
    @State private var showAboutAlert = false
    @State private var showProblemAlert = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .systemBackground).ignoresSafeArea()
                
                VStack {
                    ScrollView {
                        VStack(spacing: 12) {
                            
                            // 1. Фото фона
                            NavigationLink(destination: Text("Выбор фото фона").preferredColorScheme(.dark)) {
                                SettingRow(title: "Фото фона")
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
                            
                            // 3. Сообщить о проблеме
                            Button(action: { showProblemAlert = true }) {
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
                    
                    // Политика конфиденциальности внизу экрана
                    Link("Политика конфиденциальности", destination: URL(string: "https://example.com/privacy")!)
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(.bottom, 20)
                }
            }
            .navigationTitle("Настройки")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Сохранить") {
                        // В SwiftUI @AppStorage сохраняет всё автоматически,
                        // кнопка здесь для соответствия дизайну макета.
                    }
                    .foregroundColor(.white)
                    .bold()
                }
            }
            .preferredColorScheme(.dark)
            // Кастомные алерты для интерактива
            .alert("О разработчике", isPresented: $showAboutAlert) {
                Button("ОК", role: .cancel) {}
            } message: {
                Text("Приложение разработано в рамках практики.\nАвтор: Bukatsin Maksimilian.")
            }
            .alert("Сообщить о проблеме", isPresented: $showProblemAlert) {
                Button("Отмена", role: .cancel) {}
                Button("Отправить", role: .none) {}
            } message: {
                Text("Опишите возникшую проблему. Логи будут отправлены разработчику автоматически.")
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
