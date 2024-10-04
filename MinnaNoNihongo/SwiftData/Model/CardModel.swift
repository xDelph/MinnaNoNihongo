//
//  CardModel.swift
//  MinnaNoNihongo
//
//  Created by Thomas Delalonde on 04/10/2024.
//

import Foundation

import SwiftData

@Model
class Card {
    var id: UUID
    
    var chapter: Chapter?
    @Attribute(.unique) var kana: String
    var kanji: String
    var furigana: String
    var romaji: String
    var traduction: String
    var sampleKanji: String
    var sampleKana: String
    var sampleTraduction: String
    var type: String
    var subGroup: String
    var group: String
    var jlpt: String
    var tags: String
    var value: Int

    init(
        id: UUID = UUID(),
        chapter: Chapter?,
        kana: String,
        kanji: String,
        furigana: String,
        romaji: String,
        traduction: String,
        sampleKanji: String,
        sampleKana: String,
        sampleTraduction: String,
        type: String,
        subGroup: String,
        group: String,
        jlpt: String,
        tags: String,
        value: Int
    ) {
        self.id = id
        self.chapter = chapter
        self.kana = kana
        self.kanji = kanji
        self.furigana = furigana
        self.romaji = romaji
        self.traduction = traduction
        self.sampleKanji = sampleKanji
        self.sampleKana = sampleKana
        self.sampleTraduction = sampleTraduction
        self.type = type
        self.subGroup = subGroup
        self.group = group
        self.jlpt = jlpt
        self.tags = tags
        self.value = value
    }
    
    convenience init(cardDTO: CardDTO) {
        self.init(
            id: cardDTO.id ?? UUID(),
            chapter: nil,
            kana: cardDTO.kana,
            kanji: cardDTO.kanji,
            furigana: cardDTO.furigana,
            romaji: cardDTO.romaji,
            traduction: cardDTO.traduction,
            sampleKanji: cardDTO.sampleKanji,
            sampleKana: cardDTO.sampleKana,
            sampleTraduction: cardDTO.sampleTraduction,
            type: cardDTO.type,
            subGroup: cardDTO.subGroup,
            group: cardDTO.group,
            jlpt: cardDTO.jlpt,
            tags: cardDTO.tags,
            value: cardDTO.value ?? 0
        )
    }
}

/// Creates Card Data Transfer Objects
final class CardDTO: Sendable, Identifiable, Codable, Equatable {
    let id: UUID?
    
    let chapter: Int
    let kana: String
    let kanji: String
    let furigana: String
    let romaji: String
    let traduction: String
    let sampleKanji: String
    let sampleKana: String
    let sampleTraduction: String
    let type: String
    let subGroup: String
    let group: String
    let jlpt: String
    let tags: String
    let value: Int?

    init(
        id: UUID?,
        chapter: Int,
        kana: String,
        kanji: String,
        furigana: String,
        romaji: String,
        traduction: String,
        sampleKanji: String,
        sampleKana: String,
        sampleTraduction: String,
        type: String,
        subGroup: String,
        group: String,
        jlpt: String,
        tags: String,
        value: Int?
    ) {
        self.id = id ?? UUID()
        self.chapter = chapter
        self.kana = kana
        self.kanji = kanji
        self.furigana = furigana
        self.romaji = romaji
        self.traduction = traduction
        self.sampleKanji = sampleKanji
        self.sampleKana = sampleKana
        self.sampleTraduction = sampleTraduction
        self.type = type
        self.subGroup = subGroup
        self.group = group
        self.jlpt = jlpt
        self.tags = tags
        self.value = value ?? 0
    }
    
    convenience init(card: Card) {
        self.init(
            id: card.id,
            chapter: 0,
            kana: card.kana,
            kanji: card.kanji,
            furigana: card.furigana,
            romaji: card.romaji,
            traduction: card.traduction,
            sampleKanji: card.sampleKanji,
            sampleKana: card.sampleKana,
            sampleTraduction: card.sampleTraduction,
            type: card.type,
            subGroup: card.subGroup,
            group: card.group,
            jlpt: card.jlpt,
            tags: card.tags,
            value: card.value
        )
    }
    
    static let empty = CardDTO(
        id: UUID(),
        chapter: 0,
        kana: "",
        kanji: "",
        furigana: "",
        romaji: "",
        traduction: "",
        sampleKanji: "",
        sampleKana: "",
        sampleTraduction: "",
        type: "",
        subGroup: "",
        group: "",
        jlpt: "",
        tags: "",
        value: 0
    )
    
    static let sample = CardDTO(
        id: UUID(),
        chapter: 1,
        kana: "ちゅうごく",
        kanji: "中国",
        furigana: "中国[ちゅうごく]",
        romaji: "chūgoku",
        traduction: "Chine",
        sampleKanji: "パンダは &lt;b&gt;中国[ちゅうごく]&lt;/b&gt;から 来[き]ています",
        sampleKana: "",
        sampleTraduction: "Les pandas viennent de Chine.",
        type: "(Nom) 普通名詞[ふつうめいし]",
        subGroup: "Pays, ville, langues",
        group: "Commun",
        jlpt: "X",
        tags: "Chapitre_01 Noms NX",
        value: 0
    )
    
    static let sample2 = CardDTO(
        id: UUID(),
        chapter: 1,
        kana: "せつじ",
        kanji: "せつじ",
        furigana: "せつじ",
        romaji: "〜san",
        traduction: "Mme. M. (titre de respect ajouté à un nom)",
        sampleKanji: "",
        sampleKana: "",
        sampleTraduction: "",
        type: "(Affixe) 接辞[せつじ]",
        subGroup: "(Suffixe) 接尾辞[せつびじ]",
        group: "Other",
        jlpt: "5",
        tags: "Affixes Chapitre_01 N5",
        value: 0
    )
    
    static func ==(lhs: CardDTO, rhs: CardDTO) -> Bool {
        lhs.id == rhs.id
    }
}
