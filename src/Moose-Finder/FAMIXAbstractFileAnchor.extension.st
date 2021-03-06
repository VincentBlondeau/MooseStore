Extension { #name : #FAMIXAbstractFileAnchor }

{ #category : #'*Moose-Finder' }
FAMIXAbstractFileAnchor >> intervalAsCharPos [
	self subclassResponsibility
]

{ #category : #'*Moose-Finder' }
FAMIXAbstractFileAnchor >> mooseFinderCompleteSourceTextIn: composite [
	<moosePresentationOrder: 11>
	composite custom: 
		((MooseFileSourceAnchorViewer startOn: self)
						title: 'Complete source';
						titleIcon: MooseIcons mooseSourceText;
						when: [ :input | input mooseInterestingEntity completeText notEmpty ])
]
