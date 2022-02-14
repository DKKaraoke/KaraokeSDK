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
                return nil
            case .精密採点:
                return nil
            case .精密採点2:
                return nil
            case .シンプル採点:
                return "0817"
            case .シンプル採点3D:
                return "0861"
            case .ONEPIECE採点:
                return "0839"
            case .カラオケ天下一歌唱会:
                return nil
            case .おもしろコース:
                return nil
            case .歌うまコース:
                return nil
            case .完唱通常:
                return "0109"
            case .完唱激辛:
                return "0197"
            case .みんなで歌合戦:
                return nil
            case .カラオケ紅白歌合戦:
                return nil
            case .美川憲一:
                return "0819"
            case .勝ち抜きバトル:
                return nil
            case .精密採点DX:
                return "0194"
            case .精密採点DXG:
                return "0283"
            case .精密採点DXミリオン:
                return "0857"
            case .精密採点AI:
                return "0286"
            case .精密採点DXLite:
                return nil
            case .ランキングバトル:
                return "0130"
        }
    }
}
