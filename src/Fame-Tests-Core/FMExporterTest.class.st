Class {
	#name : #FMExporterTest,
	#superclass : #TestCase,
	#category : #'Fame-Tests-Core'
}

{ #category : #running }
FMExporterTest >> testExportAsMSE [
	| printer |
	printer := FMMSEPrinter new onString.
	FMMetaRepository fm3 accept: printer.
	printer stream contents isString should beTrue.
	printer stream contents first should = $(
]

{ #category : #running }
FMExporterTest >> testExportAsXML [
	| printer |
	printer := FMXMLPrinter new onString.
	FMMetaRepository fm3 accept: printer.
	printer stream contents isString should beTrue.
	printer stream contents first should = $<
]

{ #category : #running }
FMExporterTest >> testExportCommentsAsXML [
	| entity printer tower mooseModel |
	printer := FMXMLPrinter new onString.
	entity := FAMIXComment new
		content:
			'This is a test"
	'.
	mooseModel := MooseModel
		new
		add: entity;
		yourself.
	tower := FMCompleteTower new.
	tower metaMetamodel: MooseModel meta metamodel.
	tower metamodel: MooseModel meta.
	tower model: ((FMRepository with: MooseModel meta) addAll: mooseModel entities).
	tower model accept: printer.
	self
		assert:
			printer stream contents
				=
 '<?xml version="1.0"?>
<Document>
	<Element name="FAMIX.Comment" id="1">
		<Attribute name="content">
			<String value="This is a test\"\n\t"/>
		</Attribute>
	</Element>
</Document>'
]
