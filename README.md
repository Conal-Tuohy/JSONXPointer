# JSONXPointer
A demonstration of the use of XPointer URIs containing XPath 3.1 expressions to refer to JSON documents

The example demonstrates how a TEI XML file could use external JSON data files to specify the geometric properties of
`<zone>` elements (which specify geometric regions on a writing surface). Normally, a TEI `<zone>` specifies the vertices of the region directly as attributes. One method is to use the `points` attribute e.g.
```xml
<zone points="103.71093749999999,-43.83452678223682
  103.71093749999999,-32.54681317351514
  131.484375,-32.54681317351514
  131.484375,-43.83452678223682
  103.71093749999999,-43.83452678223682"/>
```
In this example, the TEI XML file `json-zone-test.xml` instead uses a custom attribute `pointsRef` on a `<zone>`
element to point, using an XPointer URI, to geometric data contained with an external geoJSON data file `zones.json`, as shown:
```json
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "properties": {},
      "geometry": {
        "type": "Polygon",
        "coordinates": [
          [
            [103.71093749999999, -43.83452678223682],
            [103.71093749999999, -32.54681317351514],
            [131.484375, -32.54681317351514],
            [131.484375, -43.83452678223682],
            [103.71093749999999, -43.83452678223682]
          ]
        ]
      }
    },
    {
      "type": "Feature",
      "properties": {},
      "geometry": {
        "type": "Polygon",
        "coordinates": [
          [
            [121.640625, -20.632784250388013],
            [121.640625, -11.178401873711772],
            [138.8671875, -11.178401873711772],
            [138.8671875, -20.632784250388013],
            [121.640625, -20.632784250388013]
          ]
        ]
      }
    }
  ]
}
```
The `pointsRef` URI resolves to a list of points in the same format as that required by the standard TEI `points` attribute, meaning that a document using this mechanism can be converted to standard TEI by replacing each `pointsRef` attribute with a `points` attribute whose value is set to the result of resolving the `pointsRef` URI. This demonstration performs this transformation.

The test TEI file includes two `<zone>` elements; one of which has a `pointsRef` which literally specifies an XPointer URI in full, and the other of which specifies an "abbreviated" `pointsRef`
by using the TEI `<prefixDef>` mechanism to define a custom `geojson:` URI scheme.

```xml
<zone pointsRef="#xpath(json-doc(%27zones.json%27)%3Ffeatures%3F1%3Fgeometry%3Fcoordinates%3F1%3F*!string-join(string-join(%3F*%2C%27%2C%27)%2C%27%20%27))"/>
<zone pointsRef="geojson:zones.json#2"/>
```

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
