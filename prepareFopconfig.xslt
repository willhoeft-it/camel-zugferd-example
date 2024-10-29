<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="#all" version="2.0">  
  <xsl:output method="xml" encoding="UTF-8"/>
  <xsl:param name="param.camelRoutePath" select="'UNSET'"/>
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy> 
  </xsl:template>
  <xsl:template match="/fop/base">
    <xsl:copy>
        <xsl:value-of select="$param.camelRoutePath"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/fop/font-base">
    <xsl:copy>
        <xsl:value-of select="concat($param.camelRoutePath, '/fonts')"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>