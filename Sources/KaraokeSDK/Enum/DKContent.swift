//
//  DKContent.swift
//
//
//  Created by devonly on 2022/01/24.
//

import Foundation

public enum DKContent: Int, CaseIterable, Codable {
    case 精密採点 = 810006
    case 勝ち抜きバトル = 810012
    case 精密採点2 = 810014
    case シンプル採点 = 810020
    case 完唱通常 = 810023
    case 完唱激辛 = 810024
    case カラオケ紅白歌合戦 = 810025
    case 美川憲一 = 810028
    case おもしろコース = 810041
    case ONEPIECE採点 = 810042
    case 歌うまコース = 810044
    case みんなで歌合戦 = 810048
    case シンプル採点3D = 810052
    case カラオケ天下一歌唱会 = 810053
    case 精密採点DX = 810021
    case 精密採点DXG = 810039
    case 精密採点DXLite = 810045
    case 精密採点DXミリオン = 810047
    case 精密採点AI = 810051
    case ランキングバトル = 810022
    case 設定しない = 0
}

extension DKContent {
    var kindValue: String? {
        switch self {
            case .設定しない:
                nil
            case .精密採点:
                nil
            case .精密採点2:
                nil
            case .シンプル採点:
                "0817"
            case .シンプル採点3D:
                "0861"
            case .ONEPIECE採点:
                "0839"
            case .カラオケ天下一歌唱会:
                nil
            case .おもしろコース:
                nil
            case .歌うまコース:
                nil
            case .完唱通常:
                "0109"
            case .完唱激辛:
                "0197"
            case .みんなで歌合戦:
                nil
            case .カラオケ紅白歌合戦:
                nil
            case .美川憲一:
                "0819"
            case .勝ち抜きバトル:
                nil
            case .精密採点DX:
                "0194"
            case .精密採点DXG:
                "0283"
            case .精密採点DXミリオン:
                "0857"
            case .精密採点AI:
                "0286"
            case .精密採点DXLite:
                nil
            case .ランキングバトル:
                "0130"
        }
    }
}
