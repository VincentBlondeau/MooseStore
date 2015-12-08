Class {
	#name : #DudeMooseMetricsTest,
	#superclass : #MooseFileStructureImporterTest,
	#category : #'SmallDude-Tests-Core'
}

{ #category : #setUp }
DudeMooseMetricsTest >> file1 [ 
	 
	^' 
    			fclose( hFrom ) ; 
    			fclose( hTo ) ; 
    			return ; 
    		} 
    		if ( feof( hFrom ) ) 
    			break ; 
    		fputc( c, hTo ) ; 
    		if ( ferror( hTo ) ) 
    		{ 
    			printf( "\nCF write error - ende\n" ) ; 
    			fclose( hFrom ) ; 
    			fclose( hTo ) ; 
    			return ; 
 
asdfasdf 
sdfasdf 
sdfsadf 
ghasdjfghj 
 
 
    			fclose( hFrom ) ; 
    			fclose( hTo ) ; 
    			return ; 
    		} 
    		if ( feof( hFrom ) ) 
    			break ; 
    		fputc( c, hTo ) ; 
    		if ( ferror( hTo ) ) 
    		{ 
    			printf( "\nCF write error - ende\n" ) ; 
    			fclose( hFrom ) ; 
    			fclose( hTo ) ; 
    			return ; 
 
fghfghj 
fghjfghj 
gfhjgfhj 
ghjfghj 
 
 
    			fclose( hFrom ) ; 
    			fclose( hTo ) ; 
    			return ; 
    		} 
    		if ( feof( hFrom ) ) 
    			break ; 
    		fputc( c, hTo ) ; 
    		if ( ferror( hTo ) ) 
    		{ 
    			printf( "\nCF write error - ende\n" ) ; 
    			fclose( hFrom ) ; 
    			fclose( hTo ) ; 
    			return ; 
'
]

{ #category : #setUp }
DudeMooseMetricsTest >> setUp [
	| stream detector rootFileReference |
	rootFileReference := self createDirectory: self foldersString.
	[ 
	stream := (self createFile: self foldersString , 'file1') writeStream.
	stream nextPutAll: self file1 ]
		ensure: [ stream close ].
	model := MooseModel new.
	MooseFileStructureImporter runOn: model withFolders: (OrderedCollection with: rootFileReference).
	detector := DudeDetector new: DudeCStyleFiles from: model allFiles inModel: model.
	detector getMultiplicationsWith1032
]

{ #category : #testing }
DudeMooseMetricsTest >> testInternalDupFragmentGrouping [
	self assert: model allFiles size equals: 1.
	self assert: model allDuplications size equals: 3.
	self assert: model allMultiplications size equals: 1.
	self assert: model allFiles first internalFragments size equals: 3.
	self assert: model allFiles first allInternalDuplications size equals: 3.
	self assert: model allFiles first allInternalMultiplications size equals: 1
]
