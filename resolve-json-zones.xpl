<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0" name="main">
	<!-- expand URIs in the TEI document using local URI schemes into full URIs --> 
	<p:xslt name="resolve-prefixes">
		<p:input port="parameters">
			<p:empty/>
		</p:input>
		<p:input port="source">
			<p:document href="json-zone-test.xml"/>
		</p:input>
		<p:input port="stylesheet">
			<p:document href="resolve-prefixes.xsl"/>
		</p:input>
	</p:xslt>
	<!-- convert the TEI document into a stylesheet, so that XPath expressions in XPointer URIs can be resolved by the XSLT processor --> 
	<p:xslt name="make-stylesheet">
		<p:input port="parameters">
			<p:empty/>
		</p:input>
		<p:input port="stylesheet">
			<p:document href="resolve-json-zones.xsl"/>
		</p:input>
	</p:xslt>
	<!-- apply the stylesheet to a dummy document, evaluating the embedded XPath expressions -->
	<p:xslt>
		<p:input port="parameters">
			<p:empty/>
		</p:input>
		<p:input port="source">
			<p:inline>
				<irrelevant/>
			</p:inline>
		</p:input>
		<p:input port="stylesheet">
			<p:pipe step="make-stylesheet" port="result"/>
		</p:input>
	</p:xslt>
	<!-- store the processed TEI -->
	<p:store href="json-zone-test-output.xml"/>
	<!-- store the (temporary) output stylesheet -->
	<p:store href="json-zone-test-output.xsl">
		<p:input port="source">
			<p:pipe step="make-stylesheet" port="result"/>
		</p:input>
	</p:store>
</p:declare-step>
