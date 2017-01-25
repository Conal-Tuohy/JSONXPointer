<xsl:transform version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns="http://www.tei-c.org/ns/1.0"
	exclude-result-prefixes="tei">
	<xsl:template match="*|@*|comment()|processing-instruction()">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	<xsl:key name="prefix-def" match="tei:prefixDef" use="@ident"/>
	<xsl:template match="@pointsRef">
		<xsl:variable name="prefix" select="substring-before(., ':')"/>
		<xsl:variable name="prefix-def" select="key('prefix-def', $prefix)"/>
		<xsl:choose>
			<xsl:when test="$prefix-def">
				<xsl:attribute name="pointsRef">
					<xsl:value-of select="
						replace(
							substring-after(., concat($prefix, ':')), 
							$prefix-def/@matchPattern, 
							$prefix-def/@replacementPattern
					)"/>
				</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:transform>
