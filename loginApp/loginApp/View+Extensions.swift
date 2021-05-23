//
//  View+Extensions.swift
//  loginApp
//
//  Created by Тарас Минин on 23/05/2021.
//

import SwiftUI

extension View {

    @ViewBuilder func hidden(_ isHidden: Bool) -> some View {
        if isHidden { hidden() }
        else { self }
    }
}
