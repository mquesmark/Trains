final class Mocks {
    static let citiesStrings =  [
        "Москва", "Санкт-Петербург", "Новосибирск", "Казань",
        "Омск", "Томск", "Челябинск", "Иркутск",
        "Ярославль", "Нижний Новгород"
    ]
    static let stationsStrings = [
        "Киевский вокзал",
        "Курский вокзал",
        "Ярославский вокзал",
        "Белорусский вокзал",
        "Савеловский вокзал",
        "Ленинградский вокзал"
    ]

    static let moscowMockStations = [
        "Киевский вокзал",
        "Курский вокзал",
        "Ярославский вокзал",
        "Белорусский вокзал",
        "Савеловский вокзал",
        "Ленинградский вокзал"
    ]

    static let spbMockStations = [
        "Московский вокзал",
        "Ладожский вокзал",
        "Финляндский вокзал",
        "Балтийский вокзал",
        "Витебский вокзал"
    ]

    static let novosibirskMockStations = [
        "Новосибирск-Главный",
        "Новосибирск-Южный",
        "Новосибирск-Западный"
    ]

    static let kazanMockStations = [
        "Казань-Пассажирская",
        "Казань-2",
        "Юдино"
    ]

    static let omskMockStations = [
        "Омск-Пассажирский",
        "Омск-Восточный"
    ]

    static let tomskMockStations = [
        "Томск-1",
        "Томск-2"
    ]

    static let chelyabinskMockStations = [
        "Челябинск-Главный",
        "Челябинск-Южный"
    ]

    static let irkutskMockStations = [
        "Иркутск-Пассажирский",
        "Иркутск-Сортировочный"
    ]

    static let yaroslavlMockStations = [
        "Ярославль-Главный",
        "Ярославль-Московский"
    ]

    static let nizhnyNovgorodMockStations = [
        "Нижний Новгород-Московский",
        "Сормово"
    ]
    
    static let mockCarrierCards: [CarrierCardModel] = [
        CarrierCardModel(
            date: "24 сентября",
            startTime: "22:30",
            endTime: "18:30",
            routeTime: "20 часов",
            logo: "rzd",
            name: "РЖД",
            warningText: "С пересадкой в Костроме"
        ),
        CarrierCardModel(
            date: "24 сентября",
            startTime: "01:15",
            endTime: "10:15",
            routeTime: "9 часов",
            logo: "fgk",
            name: "ФГК"
        ),
        CarrierCardModel(
            date: "24 сентября",
            startTime: "12:30",
            endTime: "21:30",
            routeTime: "9 часов",
            logo: "ural",
            name: "Урал логистика"
        ),
        CarrierCardModel(
            date: "25 сентября",
            startTime: "06:20",
            endTime: "14:10",
            routeTime: "8 часов",
            logo: "rzd",
            name: "РЖД"
        ),
        CarrierCardModel(
            date: "25 сентября",
            startTime: "09:40",
            endTime: "18:30",
            routeTime: "9 часов",
            logo: "fgk",
            name: "ФГК",
            warningText: "Возможна задержка"
        ),
        CarrierCardModel(
            date: "26 сентября",
            startTime: "00:15",
            endTime: "11:20",
            routeTime: "11 часов",
            logo: "ural",
            name: "Урал логистика"
        ),
        CarrierCardModel(
            date: "26 сентября",
            startTime: "17:10",
            endTime: "03:40",
            routeTime: "11 часов",
            logo: "rzd",
            name: "РЖД",
            warningText: "Ночной рейс"
        )
    ]
}
