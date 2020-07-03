//
//  Optional.swift
//  F1TV
//
//  Created by Ken Pham on 7/2/20.
//  Copyright © 2020 Phez Technologies. All rights reserved.
//

import SwiftUI

struct Optional<Value, Content: View, NilContent: View>: View {
	typealias ContentBuilder = (Value) -> Content
	typealias NilContentBuilder = () -> NilContent?
	
	private var value: Value?
	private var contentBuilder: ContentBuilder
	private var nilContentBuilder: NilContentBuilder
	
	init (_ value: Value?, @ViewBuilder content: @escaping ContentBuilder, @ViewBuilder nilContent: @escaping NilContentBuilder) {
		self.value = value
		self.contentBuilder = content
		self.nilContentBuilder = nilContent
	}
	
    var body: some View {
		if self.value == nil {
			return AnyView(nilContentBuilder())
		} else {
			return AnyView(value.map(contentBuilder))
		}
    }
}

extension Optional where NilContent == Never {
	init (_ value: Value?, @ViewBuilder content: @escaping ContentBuilder) {
		self.value = value
		self.contentBuilder = content
		self.nilContentBuilder = { nil }
	}
}
