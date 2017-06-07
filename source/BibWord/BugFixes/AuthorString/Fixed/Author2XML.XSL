<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:b="http://schemas.openxmlformats.org/officeDocument/2006/bibliography">
	<xsl:output method="xml" encoding="us-ascii"/>
	<xsl:template match="Field">
		<xsl:variable name="Authors"><xsl:value-of select="."/></xsl:variable>

		<b:NameList>
			<xsl:call-template name="ParseNames">
				<xsl:with-param name="Source" select="$Authors"/>
			</xsl:call-template>
		</b:NameList>
	</xsl:template>

	<xsl:template name="ParseNames">
		<xsl:param name="Source"/>

		<xsl:variable name="OneName">
			<xsl:value-of select="normalize-space(substring-before($Source, ';'))"/>
		</xsl:variable>
		<xsl:variable name="RestName">
			<xsl:value-of select="normalize-space(substring-after($Source, ';'))"/>
		</xsl:variable>

		<xsl:call-template name="ParseName">
			<xsl:with-param name="Source" select="normalize-space($OneName)"/>
		</xsl:call-template>

		<xsl:if test="string-length($RestName) > 0">
			<xsl:call-template name="ParseNames">
				<xsl:with-param name="Source" select="normalize-space($RestName)"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

  <!-- Alternative implementation by Yves Dhondt (http://bibword.codeplex.com) -->
  <!--   This implementation assumes a comma between first and middle names thereby
         allowing them to be separated again.
    -->
  <xsl:template name="ParseName">
		<xsl:param name="Source"/>

		<xsl:variable name="Last">
			<xsl:choose>
				<xsl:when test="contains($Source, ',')">
					<xsl:value-of select="normalize-space(substring-before($Source, ','))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space($Source)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="FirstMiddle">
			<xsl:choose>
				<xsl:when test="contains($Source, ',') and string-length(normalize-space(substring-after($Source, ','))) > 0">
					<xsl:value-of select="normalize-space(substring-after($Source, ','))"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="First">
			<xsl:choose>
				<xsl:when test="contains($FirstMiddle, ',')">
					<xsl:value-of select="normalize-space(substring-before($FirstMiddle, ','))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space($FirstMiddle)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="Middle">
			<xsl:choose>
				<xsl:when test="contains($FirstMiddle, ',')">
					<xsl:value-of select="normalize-space(substring-after($FirstMiddle, ','))"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:if test="string-length($Last) > 0">
			<b:Person>
				<b:Last><xsl:value-of select="$Last"/></b:Last>
				<b:First><xsl:value-of select="$First"/></b:First>
				<b:Middle><xsl:value-of select="$Middle"/></b:Middle>
			</b:Person>
		</xsl:if>
		<xsl:if test="string-length($Last) = 0 and (string-length($First) > 0 or string-length($Middle) > 0 )">
			<b:Person>
				<b:Last></b:Last>
				<b:First><xsl:value-of select="$First"/></b:First>
				<b:Middle><xsl:value-of select="$Middle"/></b:Middle>
			</b:Person>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>

