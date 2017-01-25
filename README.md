# JSONXPointer
A demonstration of the use of XPointer URIs containing XPath 3.1 expressions to refer to JSON documents

The example demonstrates how a TEI XML file could use external JSON data files to specify the geometric properties of
`<zone>` elements. In the example, the TEI XML file `json-zone-test.xml` uses a custom attribute `pointsRef` on a `<zone>`
element to point, using an XPointer URI, to geometric data contained with an external geoJSON data file `zones.json`.

The test file includes both a "simple" `pointsRef` which literally specifies an XPointer URI, and an "abbreviated" `pointsRef`
which uses the TEI `<prefixDef>` mechanism to define a custom `geojson:` URI scheme.

The data flow is controlled by the XProc pipeline `resolve-json-zones.xpl`, and consists of these steps:

1. The `json-zone-test.xml` is first transformed by the `resolve-prefixes.xsl` stylesheet, which replaces the custom URIs
with XPointer fragment URIs. This replacement is a standard TEI processing behaviour, specified by a TEI `<prefixDef>` element.
The resulting document contains two `<zone>` elements, both with `pointsRef` attributes containing XPointer fragment URIs.
2. The document is then transformed by the stylesheet `resolve-json-zones.xsl` (and subsidiary stylesheet `url-decode.xsl`), 
to convert the TEI into a [simplified XSLT stylesheet](https://www.w3.org/TR/xslt-30/#simplified-stylesheet) which simply
"quotes" the original TEI file, but in which the XPointer URIs are URI-decoded to yield the XPath expressions, and
used to specify the value of `points` elements using Attribute Value Templates in the XSLT. 
The stylesheet produced in this step is only an intermediate file, but for the sake of demonstration, it is saved as 
`json-zone-test-output.xsl`.
3. The resulting XSLT is then executed to produce a TEI document in which the `points` attribute values are set to the
result of evaluating the XPath expressions contained in those Attribute Value Templates. 
Finally the resulting document is stored as `json-zone-test-output.xml`.
