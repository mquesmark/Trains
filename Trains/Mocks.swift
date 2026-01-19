import SwiftUI

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

    
    static let stories: [Story] = [
        Story(isWatched: false, previewImage: Image(.story1Full), previewTitle: "Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1", fullImage: Image(.story1Full), title: "Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1", fullText: "Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1"),
        Story(isWatched: false, previewImage: Image(.story2Full), previewTitle: "Text2 Text2 Text2 Text2 Text2 Text2 Text2 Text2 Text2 Text2", fullImage: Image(.story2Full), title: "Text2 Text2 Text2 Text2 Text2 Text2 Text2 Text2 Text2 Text2", fullText: "Text2 Text2 Text2 Text2 Text2 Text2 Text2 Text2 Text2 Text2"),
        Story(isWatched: false, previewImage: Image(.story3Full), previewTitle: "Text3 Text3 Text3 Text3 Text3 Text3 Text3 Text3 Text3 Text3", fullImage: Image(.story3Full), title: "Text3 Text3 Text3 Text3 Text3 Text3 Text3 Text3 Text3 Text3", fullText: "Text3 Text3 Text3 Text3 Text3 Text3 Text3 Text3 Text3 Text3"),
        Story(isWatched: false, previewImage: Image(.story3Full), previewTitle: "Text4 Text4 Text4 Text4 Text4 Text4 Text4 Text4 Text4 Text4", fullImage: Image(.story3Full), title: "Text4 Text4 Text4 Text4 Text4 Text4 Text4 Text4 Text4 Text4", fullText: "Text4 Text4 Text4 Text4 Text4 Text4 Text4 Text4 Text4 Text4"),
        Story(isWatched: false, previewImage: Image(.story2Full), previewTitle: "Text5 Text5 Text5 Text5 Text5 Text5 Text5 Text5 Text5 Text5", fullImage: Image(.story2Full), title: "Text5 Text5 Text5 Text5 Text5 Text5 Text5 Text5 Text5 Text5", fullText: "Text5 Text5 Text5 Text5 Text5 Text5 Text5 Text5 Text5 Text5"),
        Story(isWatched: false, previewImage: Image(.story1Full), previewTitle: "Text6 Text6 Text6 Text6 Text6 Text6 Text6 Text6 Text6 Text6", fullImage: Image(.story1Full), title: "Text6 Text6 Text6 Text6 Text6 Text6 Text6 Text6 Text6 Text6", fullText: "Text6 Text6 Text6 Text6 Text6 Text6 Text6 Text6 Text6 Text6")
    ]
    
   // static let carrierInfo: CarrierInfo = .init(imageUrlString: "", name: "Нет информации о перевозчике", email: "–", phone: "–")
}
