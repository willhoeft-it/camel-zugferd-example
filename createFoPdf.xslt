<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:pdf="http://xmlgraphics.apache.org/fop/extensions/pdf" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" version="2.0">
  <xsl:decimal-format decimal-separator="," grouping-separator="."/>
  <xsl:template match="/">
    <fo:root>
      <fo:layout-master-set>
        <fo:simple-page-master master-name="default-page" page-height="297mm" page-width="210mm" margin-left="20mm" margin-top="60mm" margin-right="20mm" margin-bottom="35mm">
          <fo:region-body region-name="page-content" />
        </fo:simple-page-master>
      </fo:layout-master-set>
      <fo:declarations>
        <x:xmpmeta xmlns:x="adobe:ns:meta/">
          <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
            <rdf:Description xmlns:dc="http://purl.org/dc/elements/1.1/" rdf:about="">
              <dc:title>
                <rdf:Alt>
                  <rdf:li xml:lang="x-default"><xsl:value-of select="concat(/invoice/creditor/address/name, ': Rechnung ', /invoice/id)"/></rdf:li>
                </rdf:Alt>
              </dc:title>
              <dc:creator>
                <rdf:Seq>
                  <rdf:li><xsl:value-of select="/invoice/creditor/address/name"/></rdf:li>
                </rdf:Seq>
              </dc:creator>
              <dc:description>
                <rdf:Alt>
                  <rdf:li xml:lang="x-default"><xsl:value-of select="/invoice/title"/></rdf:li>
                </rdf:Alt>
              </dc:description>
            </rdf:Description>
            <rdf:Description xmlns:xmp="http://ns.adobe.com/xap/1.0/" rdf:about="">
              <xmp:CreatorTool>Willhöft IT-Beratung GmbH, Camel ZugFERD Route 0.1</xmp:CreatorTool>
            </rdf:Description>
            <!-- 
              If this extension schema fails PDF/A 3 validation, be sure to not use Saxon as default transformer.
              Apache FOP 2.10 generates invalid XML here otherwise, see https://issues.apache.org/jira/browse/FOP-3217
              This is just the static embedded schema. Nothing to change here 
            -->
            <rdf:Description xmlns:pdfaExtension="http://www.aiim.org/pdfa/ns/extension/" xmlns:pdfaSchema="http://www.aiim.org/pdfa/ns/schema#" xmlns:pdfaProperty="http://www.aiim.org/pdfa/ns/property#" rdf:about="">
              <pdfaExtension:schemas>
                <rdf:Bag>
                  <rdf:li rdf:parseType="Resource">
                    <pdfaSchema:schema>Factur-X PDFA Extension Schema</pdfaSchema:schema>
                    <pdfaSchema:namespaceURI>urn:factur-x:pdfa:CrossIndustryDocument:invoice:1p0#</pdfaSchema:namespaceURI>
                    <pdfaSchema:prefix>fx</pdfaSchema:prefix>
                    <pdfaSchema:property>
                      <rdf:Seq>
                        <rdf:li rdf:parseType="Resource">
                          <pdfaProperty:name>DocumentFileName</pdfaProperty:name>
                          <pdfaProperty:valueType>Text</pdfaProperty:valueType>
                          <pdfaProperty:category>external</pdfaProperty:category>
                          <pdfaProperty:description>The name of the embedded XML document</pdfaProperty:description>
                        </rdf:li>
                        <rdf:li rdf:parseType="Resource">
                          <pdfaProperty:name>DocumentType</pdfaProperty:name>
                          <pdfaProperty:valueType>Text</pdfaProperty:valueType>
                          <pdfaProperty:category>external</pdfaProperty:category>
                          <pdfaProperty:description>The type of the hybrid document in capital letters, e.g. INVOICE or ORDER</pdfaProperty:description>
                        </rdf:li>
                        <rdf:li rdf:parseType="Resource">
                          <pdfaProperty:name>Version</pdfaProperty:name>
                          <pdfaProperty:valueType>Text</pdfaProperty:valueType>
                          <pdfaProperty:category>external</pdfaProperty:category>
                          <pdfaProperty:description>The actual version of the standard applying to the embedded XML document</pdfaProperty:description>
                        </rdf:li>
                        <rdf:li rdf:parseType="Resource">
                          <pdfaProperty:name>ConformanceLevel</pdfaProperty:name>
                          <pdfaProperty:valueType>Text</pdfaProperty:valueType>
                          <pdfaProperty:category>external</pdfaProperty:category>
                          <pdfaProperty:description>The conformance level of the embedded XML document</pdfaProperty:description>
                        </rdf:li>
                      </rdf:Seq>
                    </pdfaSchema:property>
                  </rdf:li>
                </rdf:Bag>
              </pdfaExtension:schemas>
            </rdf:Description>
            <!-- Reference to our embedded file. Keep ConformanceLevel in sync with the generated xml. -->
            <rdf:Description xmlns:fx="urn:factur-x:pdfa:CrossIndustryDocument:invoice:1p0#" rdf:about="">
              <fx:DocumentType>INVOICE</fx:DocumentType>
              <fx:DocumentFileName>factur-x.xml</fx:DocumentFileName>
              <fx:Version>1.0</fx:Version>
              <fx:ConformanceLevel>EXTENDED</fx:ConformanceLevel>
            </rdf:Description>
          </rdf:RDF>
        </x:xmpmeta>
        <!-- Embedding the actual file -->
        <!-- when using fopconfig.xml in work/ dir
        <pdf:embedded-file filename="factur-x.xml" src="url(file:../work/factur-x.xml)" description="Factur-X Rechnung"/>
         -->
         <pdf:embedded-file filename="factur-x.xml" src="url(file:../../../work/factur-x.xml)" description="Factur-X Rechnung"/>
      </fo:declarations>
      <fo:page-sequence master-reference="default-page">
        <fo:flow flow-name="page-content">
          <fo:block-container font="10pt 'Noto Sans Regular'">
            <fo:block padding-left="3mm" border-left-style="solid" border-left-width="0.5pt" font-size="12pt">
              <fo:block><xsl:value-of select="/invoice/customerAddress/name"/></fo:block>
              <fo:block><xsl:value-of select="/invoice/customerAddress/addressLine[1]"/></fo:block>
              <fo:block><xsl:value-of select="/invoice/customerAddress/addressLine[2]"/></fo:block>
              <fo:block><xsl:value-of select="concat(/invoice/customerAddress/postCode, ' ', /invoice/customerAddress/city)"/></fo:block>
            </fo:block>
            <fo:block>
              <!-- Indenting or right aligning the table had weird effects. Only percentages and a dummy column worked so far -->
              <fo:table table-layout="fixed" width="100%">
                <fo:table-column column-width="60%"/>
                <fo:table-column column-width="20%"/>
                <fo:table-column column-width="19%"/>
                <fo:table-body>
                  <fo:table-row>
                    <fo:table-cell><fo:block/></fo:table-cell>
                    <fo:table-cell>
                      <fo:block>Rechnung-Nr.:</fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                      <fo:block><xsl:value-of select="/invoice/id"/></fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                  <fo:table-row>
                    <fo:table-cell><fo:block/></fo:table-cell>
                    <fo:table-cell>
                      <fo:block>Beauftragung:</fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                      <fo:block>
                        <xsl:value-of select="/invoice/projectReference"/>
                      </fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                  <fo:table-row>
                    <fo:table-cell><fo:block/></fo:table-cell>
                    <fo:table-cell>
                      <fo:block>Leistungszeitraum:</fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                      <fo:block>
                        <xsl:value-of select="format-date(xs:date(/invoice/deliveryDate), '[MNn] [Y,4]')"/>
                      </fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                  <fo:table-row>
                    <fo:table-cell><fo:block/></fo:table-cell>
                    <fo:table-cell>
                      <fo:block>Datum:</fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                      <fo:block>
                        <xsl:value-of select="format-date(xs:date(/invoice/date), '[D,2].[M,2].[Y,4]')"/>
                      </fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                </fo:table-body>
              </fo:table>
            </fo:block>
            
            <fo:block space-before="4em" space-after="3em">
              <fo:inline font="12pt 'Noto Sans Medium'"><xsl:value-of select="/invoice/title"/></fo:inline>
            </fo:block>
            <fo:block linefeed-treatment="preserve"><xsl:value-of expand-text="true" select="/invoice/letterOpening"/></fo:block>
            <fo:block space-before="2em" space-after="2em">
              <fo:table table-layout="fixed" width="90%">
                <fo:table-column column-width="5%"/>
                <fo:table-column column-width="40%"/>
                <fo:table-column column-width="13%"/>
                <fo:table-column column-width="13%"/>
                <fo:table-column column-width="13%"/>
                <fo:table-column column-width="16%"/>
                <fo:table-header>
                  <fo:table-row font="10pt 'Noto Sans Medium'">
                    <fo:table-cell><fo:block/></fo:table-cell>
                    <fo:table-cell>
                      <fo:block>Beschreibung</fo:block>
                    </fo:table-cell>
                    <fo:table-cell text-align="right" padding-right="2mm">
                      <fo:block>Menge</fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                      <fo:block>Einheit</fo:block>
                    </fo:table-cell>
                    <fo:table-cell text-align="right" padding-right="2mm">
                      <fo:block>Preis/Einheit</fo:block>
                    </fo:table-cell>
                    <fo:table-cell text-align="right">
                      <fo:block>Betrag</fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                </fo:table-header>
                <fo:table-body>
                  <xsl:for-each select="/invoice/lineItem">
                    <fo:table-row>
                      <fo:table-cell text-align="right" padding-right="2mm"><fo:block>*</fo:block></fo:table-cell>
                      <fo:table-cell padding-right="2mm">
                        <fo:block><xsl:value-of select="description"/></fo:block>
                      </fo:table-cell>
                      <fo:table-cell text-align="right" padding-right="2mm">
                        <fo:block><xsl:value-of select="quantity"/></fo:block>
                      </fo:table-cell>
                      <fo:table-cell>
                        <fo:block><xsl:value-of select="unit"/></fo:block>
                      </fo:table-cell>
                      <fo:table-cell text-align="right" padding-right="2mm">
                        <fo:block><xsl:value-of select="format-number(unitPrice, '0,00€')"/></fo:block>
                      </fo:table-cell>
                      <fo:table-cell text-align="right">
                        <fo:block><xsl:value-of select="format-number(lineTotal, '0,00€')"/></fo:block>
                      </fo:table-cell>
                    </fo:table-row>
                  </xsl:for-each>
                  <fo:table-row height="2em">
                    <fo:table-cell><fo:block/></fo:table-cell>
                    <fo:table-cell><fo:block/></fo:table-cell>
                    <fo:table-cell><fo:block/></fo:table-cell>
                    <fo:table-cell><fo:block/></fo:table-cell>
                    <fo:table-cell><fo:block/></fo:table-cell>
                    <fo:table-cell><fo:block/></fo:table-cell>
                  </fo:table-row>
                  <fo:table-row>
                    <fo:table-cell><fo:block/></fo:table-cell>
                    <fo:table-cell>
                      <fo:block>Gesamtbetrag (netto)</fo:block>
                    </fo:table-cell>
                    <fo:table-cell><fo:block/></fo:table-cell>
                    <fo:table-cell><fo:block/></fo:table-cell>
                    <fo:table-cell><fo:block/></fo:table-cell>
                    <fo:table-cell text-align="right">
                      <fo:block font="10pt 'Noto Sans Medium'" text-decoration="underline"><xsl:value-of select="format-number(/invoice/netTotal, '0,00€')"/></fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                  <fo:table-row>
                    <fo:table-cell><fo:block/></fo:table-cell>
                    <fo:table-cell>
                      <fo:block>Gesetzl. USt. (<xsl:value-of select="/invoice/vat/@percentage"/>%)</fo:block>
                    </fo:table-cell>
                    <fo:table-cell><fo:block/></fo:table-cell>
                    <fo:table-cell><fo:block/></fo:table-cell>
                    <fo:table-cell><fo:block/></fo:table-cell>
                    <fo:table-cell text-align="right">
                      <fo:block><xsl:value-of select="format-number(/invoice/vat, '0,00€')"/></fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                  <fo:table-row>
                    <fo:table-cell><fo:block/></fo:table-cell>
                    <fo:table-cell>
                      <fo:block>Zu überweisender Betrag (brutto)</fo:block>
                    </fo:table-cell>
                    <fo:table-cell><fo:block/></fo:table-cell>
                    <fo:table-cell><fo:block/></fo:table-cell>
                    <fo:table-cell><fo:block/></fo:table-cell>
                    <fo:table-cell text-align="right">
                      <fo:block font="10pt 'Noto Sans Medium'" text-decoration="underline"><xsl:value-of select="format-number(/invoice/grossTotal, '0,00€')"/></fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                </fo:table-body>
              </fo:table>
            </fo:block>
            <fo:block linefeed-treatment="preserve"><xsl:value-of select="/invoice/letterFinish"/></fo:block>
          </fo:block-container>
        </fo:flow>
      </fo:page-sequence>
    </fo:root>
  </xsl:template>
</xsl:stylesheet>
