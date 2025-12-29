import SwiftUI

struct UserAgreementView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                VStack(alignment: .leading, spacing: 8) {
                    // Оферта
                    Text(AgreementMocks.offerTitle)
                        .font(.system(size: 24, weight: .bold))

                    Text(AgreementMocks.offerIntro)
                        .font(.system(size: 17, weight: .regular))
                }

                VStack(alignment: .leading, spacing: 8) {
                    // Термины
                    Text(AgreementMocks.termsTitle)
                        .font(.system(size: 24, weight: .bold))

                    Text(AgreementMocks.termsBody)
                    .font(.system(size: 17, weight: .regular))
                }
            }
            .padding(16)
        }
        .navigationTitle("Пользовательское соглашение")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
}

private enum AgreementMocks {
    static let offerTitle = "Оферта на оказание образовательных услуг дополнительного образования Яндекс.Практикум для физических лиц"

    static let offerIntro = """
Данный документ является действующим, если расположен по адресу: https://yandex.ru/legal/practicum_offer

Российская Федерация, город Москва
"""

    static let termsTitle = "1. ТЕРМИНЫ"

    static let termsBody = """
Понятия, используемые в Оферте, означают следующее:

Авторизованные адреса — адреса электронной почты каждой Стороны.
Авторизованным адресом Исполнителя является адрес электронной почты, указанный в разделе 11 Оферты.
Авторизованным адресом Студента является адрес электронной почты, указанный Студентом в Личном кабинете.

Вводный курс — начальный Курс обучения по представленным на Сервисе Программам обучения в рамках выбранной Студентом Профессии или Курсу, рассчитанный на определенное количество часов самостоятельного обучения, который предоставляется Студенту единожды при регистрации на Сервисе на безвозмездной основе.

В процессе обучения в рамках Вводного курса Студенту предоставляется возможность ознакомления с работой Сервиса и определения возможности Студента продолжить обучение в рамках Полного курса по выбранной Студентом Программе обучения.

Точное количество часов обучения в рамках Вводного курса зависит от выбранной Студентом Профессии или Курса и определяется в Программе обучения, размещенной на Сервисе.

Максимальный срок освоения Вводного курса составляет 1 (один) год с даты начала обучения.
"""
}

#Preview {
    UserAgreementView()
}
