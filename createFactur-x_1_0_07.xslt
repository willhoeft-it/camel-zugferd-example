<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" exclude-result-prefixes="#all" version="2.0">
  <xsl:output method="xml" encoding="UTF-8"/>
  <xsl:template match="/">
    
    <rsm:CrossIndustryInvoice xmlns:rsm="urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100" xmlns:qdt="urn:un:unece:uncefact:data:standard:QualifiedDataType:100" xmlns:ram="urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:udt="urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100">
      <rsm:ExchangedDocumentContext>
        <ram:GuidelineSpecifiedDocumentContextParameter>
          <ram:ID>urn:cen.eu:en16931:2017#conformant#urn:factur-x.eu:1p0:extended</ram:ID>
        </ram:GuidelineSpecifiedDocumentContextParameter>
      </rsm:ExchangedDocumentContext>
      <rsm:ExchangedDocument>
        <!--
             The sequential number required in Article 226(2) of the directive 2006/112/EC [2], to uniquely identify the Invoice within the business context, time-frame, operating systems and records of the Seller . It may be based on one or more series of numbers, which may include alphanumeric characters. No identification scheme is to be used.
        -->
        <ram:ID><xsl:value-of select="/invoice/id"/></ram:ID>
        <!--
             380: Commercial Invoice
             381: Credit note
             384: Corrected invoice
             389: Self-billied invoice (created by the buyer on behalf of the supplier)
             261: Self billed credit note (not accepted by CHORUSPRO)
             386: Prepayment invoice
             751: Invoice information for accounting purposes (not accepted by CHORUSPRO)
        -->
        <ram:TypeCode>380</ram:TypeCode>
        <ram:IssueDateTime>
          <udt:DateTimeString format="102"><xsl:value-of select="format-date(/invoice/date, '[Y,4][M,2][D,2]')"/></udt:DateTimeString>
        </ram:IssueDateTime>
        <ram:IncludedNote>
          <ram:Content><xsl:value-of select="/invoice/title"/></ram:Content>
        </ram:IncludedNote>
        <ram:IncludedNote>
          <ram:Content><xsl:value-of select="/invoice/letterOpening"/></ram:Content>
        </ram:IncludedNote>
        <ram:IncludedNote>
          <ram:Content><xsl:value-of select="/invoice/letterFinish"/></ram:Content>
        </ram:IncludedNote>
        <!-- Handelsregisterreferenz -->
        <ram:IncludedNote>
          <ram:Content><xsl:value-of select="/invoice/creditor/address/name"/><xsl:text>
</xsl:text><xsl:value-of select="/invoice/creditor/address/addressLine[1]"/><xsl:text>
</xsl:text><xsl:value-of select="/invoice/creditor/address/addressLine[2]"/><xsl:text>
</xsl:text><xsl:value-of select="concat(/invoice/creditor/address/postCode, ' ', /invoice/creditor/address/city)"/>
Deutschland				
Geschäftsführer/in: <xsl:value-of select="/invoice/creditor/director"/><xsl:text>
</xsl:text><xsl:value-of select="/invoice/creditor/companyRegistry"/>
Registernummer: <xsl:value-of select="/invoice/creditor/companyRegistrationId"/>
          </ram:Content>
          <ram:SubjectCode>REG</ram:SubjectCode>
        </ram:IncludedNote>
      </rsm:ExchangedDocument>
      <rsm:SupplyChainTradeTransaction>
        <xsl:for-each select="/invoice/lineItem">
          <ram:IncludedSupplyChainTradeLineItem>
            <ram:AssociatedDocumentLineDocument>
              <ram:LineID><xsl:value-of select="position()"/></ram:LineID>
            </ram:AssociatedDocumentLineDocument>
            <ram:SpecifiedTradeProduct>
              <ram:Name><xsl:value-of select="description"/></ram:Name>
            </ram:SpecifiedTradeProduct>
            <ram:SpecifiedLineTradeAgreement>
              <ram:NetPriceProductTradePrice>
                <ram:ChargeAmount><xsl:value-of select="unitPrice"/></ram:ChargeAmount>
              </ram:NetPriceProductTradePrice>
            </ram:SpecifiedLineTradeAgreement>
            <ram:SpecifiedLineTradeDelivery>
              <!-- The unit of measure shall be chosen from the lists in UN/ECE Recommendation N°. 20 “Codes for Units of
                Measure Used in International Trade” [7] and UN/ECE Recommendation N° 21 “Codes for Passengers, Types of
                Cargo, Packages and Packaging Materials (with Complementary Codes for Package Names)” [19] applying the
                method described in UN/ECE Rec N° 20 Intro 2.a)
                Some:
                one = C62
                hour = HUR
                labour hour = LH
                overtime hour = OT
                mutually defined = ZZ
              -->  
              <ram:BilledQuantity unitCode="LH"><xsl:value-of select="quantity"/></ram:BilledQuantity>
            </ram:SpecifiedLineTradeDelivery>
            <ram:SpecifiedLineTradeSettlement>
              <ram:ApplicableTradeTax>
                <ram:TypeCode>VAT</ram:TypeCode>
                <!-- here "S" = Standard rate, will also apply for reduced 7%, but not for zero or exempted tax -->
                <ram:CategoryCode>S</ram:CategoryCode>
                <!-- here we assume the same VAT for all items  -->
                <ram:RateApplicablePercent><xsl:value-of select="../vat/@percentage"/></ram:RateApplicablePercent>
              </ram:ApplicableTradeTax>
              <ram:SpecifiedTradeSettlementLineMonetarySummation>
                <ram:LineTotalAmount><xsl:value-of select="lineTotal"/></ram:LineTotalAmount>
              </ram:SpecifiedTradeSettlementLineMonetarySummation>
            </ram:SpecifiedLineTradeSettlement>
          </ram:IncludedSupplyChainTradeLineItem>
        </xsl:for-each>
        <ram:ApplicableHeaderTradeAgreement>
          <ram:SellerTradeParty>
            <ram:Name><xsl:value-of select="/invoice/creditor/address/name"/></ram:Name>
            <ram:PostalTradeAddress>
              <ram:PostcodeCode><xsl:value-of select="/invoice/creditor/address/postCode"/></ram:PostcodeCode>
              <ram:LineOne><xsl:value-of select="/invoice/creditor/address/addressLine[1]"/></ram:LineOne>
              <xsl:if test="/invoice/creditor/address/addressLine[2]">
                <ram:LineTwo><xsl:value-of select="/invoice/creditor/address/addressLine[2]"/></ram:LineTwo>                
              </xsl:if>
              <ram:CityName><xsl:value-of select="/invoice/creditor/address/city"/></ram:CityName>
              <ram:CountryID>DE</ram:CountryID>
            </ram:PostalTradeAddress>
            <ram:URIUniversalCommunication>
              <ram:URIID schemeID="EM"><xsl:value-of select="/invoice/creditor/email"/></ram:URIID>
            </ram:URIUniversalCommunication>
            <!-- Lokale Steuernummer. In manchen Ländern relevant, weil dort der Käufer u.U. die Steuer einbehält und selbst an das Finanzamt überweist.
            <ram:SpecifiedTaxRegistration>
              <ram:ID schemeID="FC">201/113/40209</ram:ID>
            </ram:SpecifiedTaxRegistration>
             -->
            <ram:SpecifiedTaxRegistration>
              <ram:ID schemeID="VA"><xsl:value-of select="/invoice/creditor/vatId"/></ram:ID>
            </ram:SpecifiedTaxRegistration>
          </ram:SellerTradeParty>
          <ram:BuyerTradeParty>
            <ram:Name><xsl:value-of select="/invoice/customerAddress/name"/></ram:Name>
            <ram:PostalTradeAddress>
              <ram:PostcodeCode><xsl:value-of select="/invoice/customerAddress/postCode"/></ram:PostcodeCode>
              <ram:LineOne><xsl:value-of select="/invoice/customerAddress/addressLine[1]"/></ram:LineOne>
              <xsl:if test="/invoice/customerAddress/addressLine[2]">
                <ram:LineTwo><xsl:value-of select="/invoice/customerAddress/addressLine[2]"/></ram:LineTwo>                
              </xsl:if>
              <ram:CityName><xsl:value-of select="/invoice/customerAddress/city"/></ram:CityName>
              <ram:CountryID>DE</ram:CountryID>
            </ram:PostalTradeAddress>
          </ram:BuyerTradeParty>
        </ram:ApplicableHeaderTradeAgreement>
        <ram:ApplicableHeaderTradeDelivery>
          <ram:ActualDeliverySupplyChainEvent>
            <ram:OccurrenceDateTime>
              <udt:DateTimeString format="102"><xsl:value-of select="format-date(/invoice/deliveryDate, '[Y,4][M,2][D,2]')"/></udt:DateTimeString>
            </ram:OccurrenceDateTime>
          </ram:ActualDeliverySupplyChainEvent>
        </ram:ApplicableHeaderTradeDelivery>
        <ram:ApplicableHeaderTradeSettlement>
          <ram:InvoiceCurrencyCode>EUR</ram:InvoiceCurrencyCode>
          <ram:SpecifiedTradeSettlementPaymentMeans>
            <!-- Entries from the UNTDID 4461 code list [6] shall be used. Distinction should be made
                between SEPA and non-SEPA payments, and between credit payments, direct debits, card payments and other
                instruments.
            -->    
            <ram:TypeCode>58</ram:TypeCode>
            <ram:PayeePartyCreditorFinancialAccount>
              <ram:IBANID><xsl:value-of select="/invoice/creditor/ibanId"/></ram:IBANID>
              <ram:AccountName><xsl:value-of select="/invoice/creditor/address/name"/></ram:AccountName>
            </ram:PayeePartyCreditorFinancialAccount>
          </ram:SpecifiedTradeSettlementPaymentMeans>
          <ram:ApplicableTradeTax>
            <ram:CalculatedAmount><xsl:value-of select="/invoice/vat"/></ram:CalculatedAmount>
            <ram:TypeCode>VAT</ram:TypeCode>
            <ram:BasisAmount><xsl:value-of select="/invoice/netTotal"/></ram:BasisAmount>
            <ram:CategoryCode>S</ram:CategoryCode>
            <ram:RateApplicablePercent><xsl:value-of select="format-number(/invoice/vat/@percentage, '0.00')"/></ram:RateApplicablePercent>
          </ram:ApplicableTradeTax>
          <ram:SpecifiedTradePaymentTerms>
            <ram:DueDateDateTime>
              <udt:DateTimeString format="102"><xsl:value-of select="format-date(/invoice/dueDate, '[Y,4][M,2][D,2]')"/></udt:DateTimeString>
            </ram:DueDateDateTime>
          </ram:SpecifiedTradePaymentTerms>
          <!-- BillingSpecifiedPeriod erlaubt auch einen Zeitbereich anzugeben -->
          <ram:SpecifiedTradeSettlementHeaderMonetarySummation>
            <ram:LineTotalAmount><xsl:value-of select="/invoice/netTotal"/></ram:LineTotalAmount>
            <!-- Zuschläge: Spesen, Gebühren -->
            <ram:ChargeTotalAmount>0.00</ram:ChargeTotalAmount>
            <!-- Abschläge: Rabatte, Discounts können auch noch weiter spezifiert werden. -->
            <ram:AllowanceTotalAmount>0.00</ram:AllowanceTotalAmount>
            <ram:TaxBasisTotalAmount><xsl:value-of select="/invoice/netTotal"/></ram:TaxBasisTotalAmount>
            <ram:TaxTotalAmount currencyID="EUR"><xsl:value-of select="/invoice/vat"/></ram:TaxTotalAmount>
            <ram:GrandTotalAmount><xsl:value-of select="/invoice/grossTotal"/></ram:GrandTotalAmount>
            <ram:DuePayableAmount><xsl:value-of select="/invoice/grossTotal"/></ram:DuePayableAmount>
          </ram:SpecifiedTradeSettlementHeaderMonetarySummation>
        </ram:ApplicableHeaderTradeSettlement>
      </rsm:SupplyChainTradeTransaction>
    </rsm:CrossIndustryInvoice>
  </xsl:template>
</xsl:stylesheet>