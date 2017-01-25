<TEI xmlns="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xsl:version="3.0" xml:space="preserve">
	<teiHeader>
		<fileDesc>
			<titleStmt>
				<title>JSON Zone test</title>
				<author>Conal Tuohy</author>
			</titleStmt>
			<publicationStmt>
				<p>Published on github</p>
			</publicationStmt>
			<sourceDesc>
				<p>Written to test the idea of using JSON to encode geometric data for tei:zone elements</p>
			</sourceDesc>
		</fileDesc>
		<encodingDesc>
			<listPrefixDef>
				<prefixDef ident="geojson" matchPattern="(.+)#(.+)" replacementPattern="#xpath(json-doc(%27$1%27)%3Ffeatures%3F$2%3Fgeometry%3Fcoordinates%3F1%3F*!string-join(string-join(%3F*%2C%27%2C%27)%2C%27%20%27))">
					<p>This pointer pattern looks up the nth geojson feature in a given geojson resource, and formats its geometry as a list of points.</p>
					<p>Note that the XPath expression enclosed within the XPointer fragment part delimited by the initial <hi>#xpath(</hi> and the final <hi>)</hi> is properly expressed in URI-encoded form, e.g. using <hi>%27</hi> for <hi>'</hi> characters, <hi>%3F</hi> for <hi>?</hi> characters, etc.</p>
					<p>The effective XPath 3.1 expression would be, e.g. <formula>json-doc('zones.json')?features?1?geometry?coordinates?1?*!string-join(string-join(?*,','),' ')</formula>.</p>
				</prefixDef>
			</listPrefixDef>
		</encodingDesc>
	</teiHeader>
	<facsimile>
		<surface>
			<zone points="{json-doc('zones.json')?features?1?geometry?coordinates?1?*!string-join(string-join(?*,','),' ')}"/>
			<zone points="{json-doc('zones.json')?features?2?geometry?coordinates?1?*!string-join(string-join(?*,','),' ')}"/>
		</surface>
	</facsimile>
</TEI>