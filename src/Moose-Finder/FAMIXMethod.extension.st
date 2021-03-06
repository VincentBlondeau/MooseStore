Extension { #name : #FAMIXMethod }

{ #category : #'*moose-finder' }
FAMIXMethod >> browseSource [
	<menuItem: 'Source' category: 'Browse'>
	
	|class browser |
	self mooseModel isSmalltalk ifTrue: [
		class := Smalltalk at: self parentType instanceSide name asSymbol.
		self hasClassScope
			ifFalse: [ Smalltalk tools browser fullOnClass: class selector: self name ]
			ifTrue: [ Smalltalk tools browser fullOnClass: class class selector: self name ]
		]
	ifFalse: [ 
		browser := MooseNamespacesCodeBrowser new browser.
		browser openOn: (self mooseModel allNamespaces select: #isRoot).
		(browser pane port: #focusOnMethod) value: self.
		 ]
]

{ #category : #'*moose-finder' }
FAMIXMethod >> mooseIcon [ 
	^ MooseIcons famixMethod
]
