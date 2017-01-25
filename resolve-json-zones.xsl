<xsl:transform version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
>
	<!-- converts an XML document containing @pointsRef attributes whose values are XPointer URIs 
	using the #xpath URI scheme into an XSLT stylesheet which when executed generates a copy
	of the original TEI document, with each of the @pointsRef attributes removed, and replaced with 
	a @points attribute whose value is the result of the evaluating (transcluding) the XPointer URIs -->
	<xsl:import href="url-decode.xsl"/>
	<xsl:template match="/*">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:attribute name="xsl:version" select="'3.0'"/>
			<xsl:attribute name="xml:space" select="'preserve'"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="comment()">
		<xsl:element name="xsl:comment"><xsl:value-of select="."/></xsl:element>
	</xsl:template>
	<xsl:template match="processing-instruction()">
		<xsl:element name="xsl:processing-instruction">
			<xsl:attribute name="name"><xsl:value-of select="name()"/></xsl:attribute>
			<xsl:value-of select="."/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="*|@*">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	<!-- replace e.g. <zone pointsRef="#xpath('0,0 0,1 1,1 1,0')"/> with <zone points="0,0 0,1 1,1 1,0"/> -->
	<xsl:template match="@pointsRef[starts-with(., '#xpath(')]">
		<xsl:attribute name="points">
			<xsl:variable name="xpath" select="substring(., 8, string-length(.) - 8)"/>
			<xsl:text>{</xsl:text>
			<xsl:call-template name="decode">
				<xsl:with-param name="text" select="$xpath"/>
			</xsl:call-template>
			<xsl:text>}</xsl:text>
		</xsl:attribute>
	</xsl:template>
</xsl:transform>
