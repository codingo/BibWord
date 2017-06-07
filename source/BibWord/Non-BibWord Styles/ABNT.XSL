<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt"	xmlns:b="http://schemas.openxmlformats.org/officeDocument/2006/bibliography" xmlns:t="http://www.microsoft.com/temp">
  <xsl:output method="html" encoding="us-ascii"/>



  <xsl:template match="*" mode="outputHtml2">
    <xsl:apply-templates mode="outputHtml"/>
  </xsl:template>

  <xsl:template name="StringFormatDot">
    <xsl:param name="format" />
    <xsl:param name="parameters" />

    <xsl:variable name="prop_EndChars">
      <xsl:call-template name="templ_prop_EndChars"/>
    </xsl:variable>


    <xsl:choose>
      <xsl:when test="$format = ''"></xsl:when>
      <xsl:when test="substring($format, 1, 2) = '%%'">
        <xsl:text>%</xsl:text>
        <xsl:call-template name="StringFormatDot">
          <xsl:with-param name="format" select="substring($format, 3)" />
          <xsl:with-param name="parameters" select="$parameters" />
        </xsl:call-template>
        <xsl:if test="string-length($format)=2">
          <xsl:call-template name="templ_prop_Dot"/>
        </xsl:if>
      </xsl:when>
      <xsl:when test="substring($format, 1, 1) = '%'">
        <xsl:variable name="pos" select="substring($format, 2, 1)" />
        <xsl:apply-templates select="msxsl:node-set($parameters)/t:params/t:param[position() = $pos]" mode="outputHtml2"/>
        <xsl:call-template name="StringFormatDot">
          <xsl:with-param name="format" select="substring($format, 3)" />
          <xsl:with-param name="parameters" select="$parameters" />
        </xsl:call-template>
        <xsl:if test="string-length($format)=2">
          <xsl:variable name="temp2">
            <xsl:call-template name="handleSpaces">
              <xsl:with-param name="field" select="msxsl:node-set($parameters)/t:params/t:param[position() = $pos]"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:variable name="lastChar">
            <xsl:value-of select="substring($temp2, string-length($temp2))"/>
          </xsl:variable>
          <xsl:if test="not(contains($prop_EndChars, $lastChar))">
            <xsl:call-template name="templ_prop_Dot"/>
          </xsl:if>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="substring($format, 1, 1)" />
        <xsl:call-template name="StringFormatDot">
          <xsl:with-param name="format" select="substring($format, 2)" />
          <xsl:with-param name="parameters" select="$parameters" />
        </xsl:call-template>
        <xsl:if test="string-length($format)=1">
          <xsl:if test="not(contains($prop_EndChars, $format))">
            <xsl:call-template name="templ_prop_Dot"/>
          </xsl:if>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="StringFormat">
    <xsl:param name="format" />
    <xsl:param name="parameters" />
    <xsl:choose>
      <xsl:when test="$format = ''"></xsl:when>
      <xsl:when test="substring($format, 1, 2) = '%%'">
        <xsl:text>%</xsl:text>
        <xsl:call-template name="StringFormat">
          <xsl:with-param name="format" select="substring($format, 3)" />
          <xsl:with-param name="parameters" select="$parameters" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="substring($format, 1, 1) = '%'">
        <xsl:variable name="pos" select="substring($format, 2, 1)" />
        <xsl:apply-templates select="msxsl:node-set($parameters)/t:params/t:param[position() = $pos]" mode="outputHtml2"/>
        <xsl:call-template name="StringFormat">
          <xsl:with-param name="format" select="substring($format, 3)" />
          <xsl:with-param name="parameters" select="$parameters" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="substring($format, 1, 1)" />
        <xsl:call-template name="StringFormat">
          <xsl:with-param name="format" select="substring($format, 2)" />
          <xsl:with-param name="parameters" select="$parameters" />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>




  <xsl:template name="localLCID">
    <xsl:param name="LCID"/>

    <xsl:variable name="_LCID1">
      <xsl:choose>
        <xsl:when test="$LCID!='0' and $LCID!=''">
          <xsl:value-of select="$LCID"/>
        </xsl:when>
        <xsl:when test="/b:Citation">
          <xsl:value-of select="/*/b:Locals/b:DefaultLCID"/>
        </xsl:when>
        <xsl:when test="b:LCID">
          <xsl:value-of select="b:LCID"/>
        </xsl:when>
        <xsl:when test="../b:LCID">
          <xsl:value-of select="../b:LCID"/>
        </xsl:when>
        <xsl:when test="../../b:LCID">
          <xsl:value-of select="../../b:LCID"/>
        </xsl:when>
        <xsl:when test="../../../b:LCID">
          <xsl:value-of select="../../../b:LCID"/>
        </xsl:when>
        <xsl:when test="../../../../b:LCID">
          <xsl:value-of select="../../../../b:LCID"/>
        </xsl:when>
        <xsl:when test="../../../../b:LCID">
          <xsl:value-of select="../../../../b:LCID"/>
        </xsl:when>
        <xsl:when test="../../../../../b:LCID">
          <xsl:value-of select="../../../../../b:LCID"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="/*/b:Locals/b:DefaultLCID"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$_LCID1!='0' and string-length($_LCID1)>0">
        <xsl:value-of select="$_LCID1"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="/*/b:Locals/b:DefaultLCID"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>


  <xsl:template name="templ_prop_NoItalics" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:NoItalics"/>
  </xsl:template>


  <xsl:template name="templ_prop_TitleOpen" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:TitleOpen"/>
  </xsl:template>


  <xsl:template name="templ_prop_TitleClose" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:TitleClose"/>
  </xsl:template>



  <xsl:template name="templ_prop_MLA_CitationLong_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:CitationLong/b:FML"/>
  </xsl:template>


  <xsl:template name="templ_prop_MLA_CitationLong_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:CitationLong/b:FM"/>
  </xsl:template>


  <xsl:template name="templ_prop_MLA_CitationLong_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:CitationLong/b:ML"/>
  </xsl:template>


  <xsl:template name="templ_prop_MLA_CitationLong_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:CitationLong/b:FL"/>
  </xsl:template>


  <xsl:template name="templ_prop_MLA_CitationShort_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:CitationShort/b:FML"/>
  </xsl:template>


  <xsl:template name="templ_prop_MLA_CitationShort_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:CitationShort/b:FM"/>
  </xsl:template>


  <xsl:template name="templ_prop_MLA_CitationShort_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:CitationShort/b:ML"/>
  </xsl:template>


  <xsl:template name="templ_prop_MLA_CitationShort_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:CitationShort/b:FL"/>
  </xsl:template>


  <xsl:template name="templ_prop_APA_CitationLong_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:CitationLong/b:FML"/>
  </xsl:template>


  <xsl:template name="templ_prop_APA_CitationLong_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:CitationLong/b:FM"/>
  </xsl:template>


  <xsl:template name="templ_prop_APA_CitationLong_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:CitationLong/b:ML"/>
  </xsl:template>


  <xsl:template name="templ_prop_APA_CitationLong_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:CitationLong/b:FL"/>
  </xsl:template>


  <xsl:template name="templ_prop_APA_CitationShort_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:CitationShort/b:FML"/>
  </xsl:template>


  <xsl:template name="templ_prop_APA_CitationShort_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:CitationShort/b:FM"/>
  </xsl:template>


  <xsl:template name="templ_prop_APA_CitationShort_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:CitationShort/b:ML"/>
  </xsl:template>


  <xsl:template name="templ_prop_APA_CitationShort_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:CitationShort/b:FL"/>
  </xsl:template>


  <xsl:template name="templ_prop_Chicago_CitationLong_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:CitationLong/b:FML"/>
  </xsl:template>


  <xsl:template name="templ_prop_Chicago_CitationLong_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:CitationLong/b:FM"/>
  </xsl:template>


  <xsl:template name="templ_prop_Chicago_CitationLong_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:CitationLong/b:ML"/>
  </xsl:template>


  <xsl:template name="templ_prop_Chicago_CitationLong_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:CitationLong/b:FL"/>
  </xsl:template>


  <xsl:template name="templ_prop_Chicago_CitationShort_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:CitationShort/b:FML"/>
  </xsl:template>


  <xsl:template name="templ_prop_Chicago_CitationShort_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:CitationShort/b:FM"/>
  </xsl:template>


  <xsl:template name="templ_prop_Chicago_CitationShort_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:CitationShort/b:ML"/>
  </xsl:template>


  <xsl:template name="templ_prop_Chicago_CitationShort_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:CitationShort/b:FL"/>
  </xsl:template>


  <xsl:template name="templ_prop_Gost_CitationLong_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Gost/b:CitationLong/b:FML"/>
  </xsl:template>


  <xsl:template name="templ_prop_Gost_CitationLong_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Gost/b:CitationLong/b:FM"/>
  </xsl:template>


  <xsl:template name="templ_prop_Gost_CitationLong_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Gost/b:CitationLong/b:ML"/>
  </xsl:template>


  <xsl:template name="templ_prop_Gost_CitationLong_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Gost/b:CitationLong/b:FL"/>
  </xsl:template>


  <xsl:template name="templ_prop_Gost_CitationShort_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Gost/b:CitationShort/b:FML"/>
  </xsl:template>


  <xsl:template name="templ_prop_Gost_CitationShort_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Gost/b:CitationShort/b:FM"/>
  </xsl:template>


  <xsl:template name="templ_prop_Gost_CitationShort_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Gost/b:CitationShort/b:ML"/>
  </xsl:template>


  <xsl:template name="templ_prop_Gost_CitationShort_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Gost/b:CitationShort/b:FL"/>
  </xsl:template>


  <xsl:template name="templ_prop_ISO690_CitationLong_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:CitationLong/b:FML"/>
  </xsl:template>


  <xsl:template name="templ_prop_ISO690_CitationLong_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:CitationLong/b:FM"/>
  </xsl:template>


  <xsl:template name="templ_prop_ISO690_CitationLong_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:CitationLong/b:ML"/>
  </xsl:template>


  <xsl:template name="templ_prop_ISO690_CitationLong_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:CitationLong/b:FL"/>
  </xsl:template>


  <xsl:template name="templ_prop_ISO690_CitationShort_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:CitationShort/b:FML"/>
  </xsl:template>


  <xsl:template name="templ_prop_ISO690_CitationShort_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:CitationShort/b:FM"/>
  </xsl:template>


  <xsl:template name="templ_prop_ISO690_CitationShort_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:CitationShort/b:ML"/>
  </xsl:template>


  <xsl:template name="templ_prop_ISO690_CitationShort_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:CitationShort/b:FL"/>
  </xsl:template>


  <xsl:template name="templ_str_OnlineCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:OnlineCap"/>
  </xsl:template>


  <xsl:template name="templ_str_OnlineUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:OnlineUnCap"/>
  </xsl:template>


  <xsl:template name="templ_str_FiledCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:FiledCap"/>
  </xsl:template>


  <xsl:template name="templ_str_PatentFiledCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:PatentFiledCap"/>
  </xsl:template>


  <xsl:template name="templ_str_InCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:InCap"/>
  </xsl:template>


  <xsl:template name="templ_str_InNameCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:InNameCap"/>
  </xsl:template>


  <xsl:template name="templ_str_WithUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:WithUnCap"/>
  </xsl:template>


  <xsl:template name="templ_str_VersionShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:VersionShortCap"/>
  </xsl:template>


  <xsl:template name="templ_str_InterviewCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:InterviewCap"/>
  </xsl:template>


  <xsl:template name="templ_str_InterviewWithCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:InterviewWithCap"/>
  </xsl:template>


  <xsl:template name="templ_str_InterviewByCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:InterviewByCap"/>
  </xsl:template>


  <xsl:template name="templ_str_ByCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ByCap"/>
  </xsl:template>


  <xsl:template name="templ_str_AndUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:AndUnCap"/>
  </xsl:template>


  <xsl:template name="templ_str_AndOthersUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:AndOthersUnCap"/>
  </xsl:template>


  <xsl:template name="templ_str_MotionPictureCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:MotionPictureCap"/>
  </xsl:template>


  <xsl:template name="templ_str_PatentCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:PatentCap"/>
  </xsl:template>


  <xsl:template name="templ_str_EditionShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:EditionShortUnCap"/>
  </xsl:template>


  <xsl:template name="templ_str_EditionUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:EditionUnCap"/>
  </xsl:template>


  <xsl:template name="templ_str_RetrievedFromCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:RetrievedFromCap"/>
  </xsl:template>


  <xsl:template name="templ_str_RetrievedCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:RetrievedCap"/>
  </xsl:template>


  <xsl:template name="templ_str_FromCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:FromCap"/>
  </xsl:template>


  <xsl:template name="templ_str_FromUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:FromUnCap"/>
  </xsl:template>


  <xsl:template name="templ_str_NoDateShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:NoDateShortUnCap"/>
  </xsl:template>


  <xsl:template name="templ_str_NumberShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:NumberShortCap"/>
  </xsl:template>


  <xsl:template name="templ_str_NumberShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:NumberShortUnCap"/>
  </xsl:template>


  <xsl:template name="templ_str_PatentNumberShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:PatentNumberShortCap"/>
  </xsl:template>


  <xsl:template name="templ_str_PagesCountinousShort" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:PagesCountinousShort"/>
  </xsl:template>


  <xsl:template name="templ_str_PageShort" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:PageShort"/>
  </xsl:template>


  <xsl:template name="templ_str_SineNomineShort" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:SineNomineShort"/>
  </xsl:template>


  <xsl:template name="templ_str_SineLocoShort" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:SineLocoShort"/>
  </xsl:template>


  <xsl:template name="templ_str_SineLocoSineNomineShort" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:SineLocoSineNomineShort"/>
  </xsl:template>


  <xsl:template name="templ_str_VolumeOfShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:VolumeOfShortCap"/>
  </xsl:template>


  <xsl:template name="templ_str_VolumesOfShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:VolumesOfShortCap"/>
  </xsl:template>


  <xsl:template name="templ_str_VolumeShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:VolumeShortCap"/>
  </xsl:template>


  <xsl:template name="templ_str_VolumeShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:VolumeShortUnCap"/>
  </xsl:template>


  <xsl:template name="templ_str_VolumesShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:VolumesShortUnCap"/>
  </xsl:template>


  <xsl:template name="templ_str_VolumesShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:VolumesShortCap"/>
  </xsl:template>


  <xsl:template name="templ_str_VolumeCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:VolumeCap"/>
  </xsl:template>


  <xsl:template name="templ_str_AuthorShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:AuthorShortUnCap"/>
  </xsl:template>


  <xsl:template name="templ_str_BookAuthorShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:BookAuthorShortUnCap"/>
  </xsl:template>


  <xsl:template name="templ_str_ArtistShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ArtistShortUnCap"/>
  </xsl:template>


  <xsl:template name="templ_str_WriterCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:WriterCap"/>
  </xsl:template>


  <xsl:template name="templ_str_WritersCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:WritersCap"/>
  </xsl:template>


  <xsl:template name="templ_str_WriterShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:WriterShortUnCap"/>
  </xsl:template>


  <xsl:template name="templ_str_ConductedByCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ConductedByCap"/>
  </xsl:template>


  <xsl:template name="templ_str_ConductedByUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ConductedByUnCap"/>
  </xsl:template>


  <xsl:template name="templ_str_ConductorCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ConductorCap"/>
  </xsl:template>


  <xsl:template name="templ_str_ConductorsCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ConductorsCap"/>
  </xsl:template>


  <xsl:template name="templ_str_ConductorShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ConductorShortCap"/>
  </xsl:template>


  <xsl:template name="templ_str_ConductorShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ConductorShortUnCap"/>
  </xsl:template>


  <xsl:template name="templ_str_ConductorsShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ConductorsShortCap"/>
  </xsl:template>


  <xsl:template name="templ_str_ConductorsShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ConductorsShortUnCap"/>
  </xsl:template>


  <xsl:template name="templ_str_CounselShortUnCapIso" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:CounselShortUnCapIso"/>
  </xsl:template>


  <xsl:template name="templ_str_CounselShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:CounselShortUnCap"/>
  </xsl:template>


  <xsl:template name="templ_str_DirectedByCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:DirectedByCap"/>
  </xsl:template>


  <xsl:template name="templ_str_DirectedByUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:DirectedByUnCap"/>
  </xsl:template>


  <xsl:template name="templ_str_DirectorCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:DirectorCap"/>
  </xsl:template>


  <xsl:template name="templ_str_DirectorsCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:DirectorsCap"/>
  </xsl:template>


  <xsl:template name="templ_str_DirectorShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:DirectorShortCap"/>
  </xsl:template>


  <xsl:template name="templ_str_DirectorShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:DirectorShortUnCap"/>
  </xsl:template>


  <xsl:template name="templ_str_DirectorsShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:DirectorsShortCap"/>
  </xsl:template>


  <xsl:template name="templ_str_DirectorsShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:DirectorsShortUnCap"/>
  </xsl:template>


  <xsl:template name="templ_str_EditedByCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:EditedByCap"/>
  </xsl:template>


  <xsl:template name="templ_str_EditedByUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:EditedByUnCap"/>
  </xsl:template>


  <xsl:template name="templ_str_EditorCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:EditorCap"/>
  </xsl:template>


  <xsl:template name="templ_str_EditorsCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:EditorsCap"/>
  </xsl:template>


  <xsl:template name="templ_str_EditorShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:EditorShortCap"/>
  </xsl:template>


  <xsl:template name="templ_str_EditorShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:EditorShortUnCap"/>
  </xsl:template>


  <xsl:template name="templ_str_EditorsShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:EditorsShortCap"/>
  </xsl:template>


  <xsl:template name="templ_str_EditorsShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:EditorsShortUnCap"/>
  </xsl:template>


  <xsl:template name="templ_str_IntervieweeShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:IntervieweeShortUnCap"/>
  </xsl:template>


  <xsl:template name="templ_str_InterviewerCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:InterviewerCap"/>
  </xsl:template>


  <xsl:template name="templ_str_InterviewersCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:InterviewersCap"/>
  </xsl:template>


  <xsl:template name="templ_str_InventorShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:InventorShortUnCap"/>
  </xsl:template>


  <xsl:template name="templ_str_PerformedByCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:PerformedByCap"/>
  </xsl:template>


  <xsl:template name="templ_str_PerformedByUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:PerformedByUnCap"/>
  </xsl:template>


  <xsl:template name="templ_str_PerformerCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:PerformerCap"/>
  </xsl:template>


  <xsl:template name="templ_str_PerformersCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:PerformersCap"/>
  </xsl:template>


  <xsl:template name="templ_str_PerformerShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:PerformerShortCap"/>
  </xsl:template>


  <xsl:template name="templ_str_PerformerShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:PerformerShortUnCap"/>
  </xsl:template>


  <xsl:template name="templ_str_PerformersShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:PerformersShortCap"/>
  </xsl:template>


  <xsl:template name="templ_str_PerformersShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:PerformersShortUnCap"/>
  </xsl:template>


  <xsl:template name="templ_str_ProducedByCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ProducedByCap"/>
  </xsl:template>


  <xsl:template name="templ_str_ProducedByUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ProducedByUnCap"/>
  </xsl:template>


  <xsl:template name="templ_str_ProducerCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ProducerCap"/>
  </xsl:template>


  <xsl:template name="templ_str_ProducersCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ProducersCap"/>
  </xsl:template>


  <xsl:template name="templ_str_ProductionCompanyShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ProductionCompanyShortCap"/>
  </xsl:template>


  <xsl:template name="templ_str_ProducerShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ProducerShortCap"/>
  </xsl:template>


  <xsl:template name="templ_str_ProducersShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ProducersShortCap"/>
  </xsl:template>


  <xsl:template name="templ_str_ProducerShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ProducerShortUnCap"/>
  </xsl:template>


  <xsl:template name="templ_str_TranslatedByCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:TranslatedByCap"/>
  </xsl:template>


  <xsl:template name="templ_str_TranslatedByUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:TranslatedByUnCap"/>
  </xsl:template>


  <xsl:template name="templ_str_TranslatorCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:TranslatorCap"/>
  </xsl:template>


  <xsl:template name="templ_str_TranslatorsCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:TranslatorsCap"/>
  </xsl:template>


  <xsl:template name="templ_str_TranslatorShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:TranslatorShortCap"/>
  </xsl:template>


  <xsl:template name="templ_str_TranslatorShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:TranslatorShortUnCap"/>
  </xsl:template>


  <xsl:template name="templ_str_TranslatorsShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:TranslatorsShortCap"/>
  </xsl:template>


  <xsl:template name="templ_str_TranslatorsShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:TranslatorsShortUnCap"/>
  </xsl:template>


  <xsl:template name="templ_str_ComposerCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ComposerCap"/>
  </xsl:template>


  <xsl:template name="templ_str_ComposersCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ComposersCap"/>
  </xsl:template>


  <xsl:template name="templ_str_ComposerShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ComposerShortCap"/>
  </xsl:template>


  <xsl:template name="templ_str_ComposersShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ComposersShortCap"/>
  </xsl:template>


  <xsl:template name="templ_str_ComposerShortUnCapIso" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ComposerShortUnCapIso"/>
  </xsl:template>


  <xsl:template name="templ_str_CompiledByCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:CompiledByCap"/>
  </xsl:template>


  <xsl:template name="templ_str_CompiledByUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:CompiledByUnCap"/>
  </xsl:template>


  <xsl:template name="templ_str_CompilerCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:CompilerCap"/>
  </xsl:template>


  <xsl:template name="templ_str_CompilersCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:CompilersCap"/>
  </xsl:template>


  <xsl:template name="templ_str_CompilerShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:CompilerShortCap"/>
  </xsl:template>


  <xsl:template name="templ_str_CompilerShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:CompilerShortUnCap"/>
  </xsl:template>


  <xsl:template name="templ_str_CompilersShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:CompilersShortCap"/>
  </xsl:template>


  <xsl:template name="templ_str_CompilersShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:CompilersShortUnCap"/>
  </xsl:template>


  <xsl:template name="templ_str_CompilerShortUnCapIso" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:CompilerShortUnCapIso"/>
  </xsl:template>


  <xsl:template name="templ_str_CitedCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:CitedCap"/>
  </xsl:template>





  <xsl:template name="templ_prop_Culture" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/@Culture"/>
  </xsl:template>


  <xsl:template name="templ_prop_Direction" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Properties/b:Direction"/>
  </xsl:template>





  <xsl:template name="templ_prop_EndChars" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:EndChars"/>
  </xsl:template>


  <xsl:template name="templ_prop_NormalizeSpace" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>no</xsl:text>

  </xsl:template>


  <xsl:template name="templ_prop_Space" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:Space"/>
  </xsl:template>


  <xsl:template name="templ_prop_NonBreakingSpace" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:NonBreakingSpace"/>
  </xsl:template>


  <xsl:template name="templ_prop_ListSeparator" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:ListSeparator"/>
  </xsl:template>


  <xsl:template name="templ_prop_Dot" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:Dot"/>
  </xsl:template>


  <xsl:template name="templ_prop_DotInitial" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:DotInitial"/>
  </xsl:template>


  <xsl:template name="templ_prop_GroupSeparator" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:GroupSeparator"/>
  </xsl:template>


  <xsl:template name="templ_prop_EnumSeparator" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:EnumSeparator"/>
  </xsl:template>


  <xsl:template name="templ_prop_Equal" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:Equal"/>
  </xsl:template>


  <xsl:template name="templ_prop_Enum" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:Enum"/>
  </xsl:template>


  <xsl:template name="templ_prop_OpenQuote" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:OpenQuote"/>
  </xsl:template>


  <xsl:template name="templ_prop_CloseQuote" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:CloseQuote"/>
  </xsl:template>


  <xsl:template name="templ_prop_OpenBracket" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:OpenBracket"/>
  </xsl:template>


  <xsl:template name="templ_prop_CloseBracket" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:CloseBracket"/>
  </xsl:template>


  <xsl:template name="templ_prop_FromToDash" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:FromToDash"/>
  </xsl:template>


  <xsl:template name="templ_prop_OpenLink" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:OpenLink"/>
  </xsl:template>


  <xsl:template name="templ_prop_CloseLink" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:CloseLink"/>
  </xsl:template>


  <xsl:template name="templ_prop_AuthorsSeparator" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:AuthorsSeparator"/>
  </xsl:template>


  <xsl:template name="templ_prop_NoAndBeforeLastAuthor" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:NoAndBeforeLastAuthor"/>
  </xsl:template>


  <xsl:template name="templ_prop_SimpleAuthor_F" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:SimpleAuthor/b:F"/>
  </xsl:template>


  <xsl:template name="templ_prop_SimpleAuthor_M" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:SimpleAuthor/b:M"/>
  </xsl:template>


  <xsl:template name="templ_prop_SimpleAuthor_L" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:SimpleAuthor/b:L"/>
  </xsl:template>


  <xsl:template name="templ_prop_SimpleDate_D" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:SimpleDate/b:D"/>
  </xsl:template>


  <xsl:template name="templ_prop_SimpleDate_M" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:SimpleDate/b:M"/>
  </xsl:template>


  <xsl:template name="templ_prop_SimpleDate_Y" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:SimpleDate/b:Y"/>
  </xsl:template>


  <xsl:template name="templ_prop_MLA_SameAuthor" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:SameAuthor"/>
  </xsl:template>


  <xsl:template name="templ_prop_MLA_MainAuthor_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:MainAuthor/b:FML"/>
  </xsl:template>


  <xsl:template name="templ_prop_MLA_MainAuthor_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:MainAuthor/b:FM"/>
  </xsl:template>


  <xsl:template name="templ_prop_MLA_MainAuthor_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:MainAuthor/b:ML"/>
  </xsl:template>


  <xsl:template name="templ_prop_MLA_MainAuthor_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:MainAuthor/b:FL"/>
  </xsl:template>


  <xsl:template name="templ_prop_MLA_OtherAuthors_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:OtherAuthors/b:FML"/>
  </xsl:template>


  <xsl:template name="templ_prop_MLA_OtherAuthors_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:OtherAuthors/b:FM"/>
  </xsl:template>


  <xsl:template name="templ_prop_MLA_OtherAuthors_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:OtherAuthors/b:ML"/>
  </xsl:template>


  <xsl:template name="templ_prop_MLA_OtherAuthors_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:OtherAuthors/b:FL"/>
  </xsl:template>


  <xsl:template name="templ_prop_MLA_SecondaryAuthors_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:SecondaryAuthors/b:FML"/>
  </xsl:template>


  <xsl:template name="templ_prop_MLA_SecondaryAuthors_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:SecondaryAuthors/b:FM"/>
  </xsl:template>


  <xsl:template name="templ_prop_MLA_SecondaryAuthors_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:SecondaryAuthors/b:ML"/>
  </xsl:template>


  <xsl:template name="templ_prop_MLA_SecondaryAuthors_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:SecondaryAuthors/b:FL"/>
  </xsl:template>


  <xsl:template name="templ_prop_MLA_Date_DMY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:Date/b:DMY"/>
  </xsl:template>


  <xsl:template name="templ_prop_MLA_Date_DM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:Date/b:DM"/>
  </xsl:template>


  <xsl:template name="templ_prop_MLA_Date_MY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:Date/b:MY"/>
  </xsl:template>


  <xsl:template name="templ_prop_MLA_Date_DY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:Date/b:DY"/>
  </xsl:template>


  <xsl:template name="templ_prop_APA_MainAuthors_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:MainAuthors/b:FML"/>
  </xsl:template>


  <xsl:template name="templ_prop_APA_MainAuthors_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:MainAuthors/b:FM"/>
  </xsl:template>


  <xsl:template name="templ_prop_APA_MainAuthors_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:MainAuthors/b:ML"/>
  </xsl:template>


  <xsl:template name="templ_prop_APA_MainAuthors_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:MainAuthors/b:FL"/>
  </xsl:template>


  <xsl:template name="templ_prop_APA_SecondaryAuthors_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:SecondaryAuthors/b:FML"/>
  </xsl:template>


  <xsl:template name="templ_prop_APA_SecondaryAuthors_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:SecondaryAuthors/b:FM"/>
  </xsl:template>


  <xsl:template name="templ_prop_APA_SecondaryAuthors_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:SecondaryAuthors/b:ML"/>
  </xsl:template>


  <xsl:template name="templ_prop_APA_SecondaryAuthors_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:SecondaryAuthors/b:FL"/>
  </xsl:template>


  <xsl:template name="templ_prop_APA_BeforeLastAuthor" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:BeforeLastAuthor"/>
  </xsl:template>


  <xsl:template name="templ_prop_APA_GeneralOpen" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:GeneralOpen"/>
  </xsl:template>


  <xsl:template name="templ_prop_APA_GeneralClose" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:GeneralClose"/>
  </xsl:template>


  <xsl:template name="templ_prop_APA_SecondaryOpen" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:SecondaryOpen"/>
  </xsl:template>


  <xsl:template name="templ_prop_APA_SecondaryClose" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:SecondaryClose"/>
  </xsl:template>


  <xsl:template name="templ_prop_Hyphens" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:Hyphens"/>
  </xsl:template>


  <xsl:template name="templ_prop_APA_Date_DMY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:Date/b:DMY"/>
  </xsl:template>


  <xsl:template name="templ_prop_APA_Date_DM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:Date/b:DM"/>
  </xsl:template>


  <xsl:template name="templ_prop_APA_Date_MY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:Date/b:MY"/>
  </xsl:template>


  <xsl:template name="templ_prop_APA_Date_DY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:Date/b:DY"/>
  </xsl:template>


  <xsl:template name="templ_prop_APA_DateAccessed_DMY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:DateAccessed/b:DMY"/>
  </xsl:template>


  <xsl:template name="templ_prop_APA_DateAccessed_DM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:DateAccessed/b:DM"/>
  </xsl:template>


  <xsl:template name="templ_prop_APA_DateAccessed_MY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:DateAccessed/b:MY"/>
  </xsl:template>


  <xsl:template name="templ_prop_APA_DateAccessed_DY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:DateAccessed/b:DY"/>
  </xsl:template>


  <xsl:template name="templ_prop_APA_DateCourt_DMY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:DateCourt/b:DMY"/>
  </xsl:template>


  <xsl:template name="templ_prop_APA_DateCourt_DM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:DateCourt/b:DM"/>
  </xsl:template>


  <xsl:template name="templ_prop_APA_DateCourt_MY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:DateCourt/b:MY"/>
  </xsl:template>


  <xsl:template name="templ_prop_APA_DateCourt_DY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:DateCourt/b:DY"/>
  </xsl:template>


  <xsl:template name="templ_prop_Chicago_SameAuthor" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:SameAuthor"/>
  </xsl:template>


  <xsl:template name="templ_prop_Chicago_MainAuthor_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:MainAuthor/b:FML"/>
  </xsl:template>


  <xsl:template name="templ_prop_Chicago_MainAuthor_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:MainAuthor/b:FM"/>
  </xsl:template>


  <xsl:template name="templ_prop_Chicago_MainAuthor_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:MainAuthor/b:ML"/>
  </xsl:template>


  <xsl:template name="templ_prop_Chicago_MainAuthor_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:MainAuthor/b:FL"/>
  </xsl:template>


  <xsl:template name="templ_prop_Chicago_OtherAuthors_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:OtherAuthors/b:FML"/>
  </xsl:template>


  <xsl:template name="templ_prop_Chicago_OtherAuthors_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:OtherAuthors/b:FM"/>
  </xsl:template>


  <xsl:template name="templ_prop_Chicago_OtherAuthors_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:OtherAuthors/b:ML"/>
  </xsl:template>


  <xsl:template name="templ_prop_Chicago_OtherAuthors_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:OtherAuthors/b:FL"/>
  </xsl:template>


  <xsl:template name="templ_prop_Chicago_SecondaryAuthors_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:SecondaryAuthors/b:FML"/>
  </xsl:template>


  <xsl:template name="templ_prop_Chicago_SecondaryAuthors_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:SecondaryAuthors/b:FM"/>
  </xsl:template>


  <xsl:template name="templ_prop_Chicago_SecondaryAuthors_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:SecondaryAuthors/b:ML"/>
  </xsl:template>


  <xsl:template name="templ_prop_Chicago_SecondaryAuthors_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:SecondaryAuthors/b:FL"/>
  </xsl:template>


  <xsl:template name="templ_prop_Chicago_Date_DMY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:Date/b:DMY"/>
  </xsl:template>


  <xsl:template name="templ_prop_Chicago_Date_DM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:Date/b:DM"/>
  </xsl:template>


  <xsl:template name="templ_prop_Chicago_Date_MY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:Date/b:MY"/>
  </xsl:template>


  <xsl:template name="templ_prop_Chicago_Date_DY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:Date/b:DY"/>
  </xsl:template>


  <xsl:template name="templ_prop_ISO690_MainAuthors_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:MainAuthors/b:FML"/>
  </xsl:template>


  <xsl:template name="templ_prop_ISO690_MainAuthors_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:MainAuthors/b:FM"/>
  </xsl:template>


  <xsl:template name="templ_prop_ISO690_MainAuthors_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:MainAuthors/b:ML"/>
  </xsl:template>


  <xsl:template name="templ_prop_ISO690_MainAuthors_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:MainAuthors/b:FL"/>
  </xsl:template>


  <xsl:template name="templ_prop_ISO690_SecondaryAuthors_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:SecondaryAuthors/b:FML"/>
  </xsl:template>


  <xsl:template name="templ_prop_ISO690_SecondaryAuthors_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:SecondaryAuthors/b:FM"/>
  </xsl:template>


  <xsl:template name="templ_prop_ISO690_SecondaryAuthors_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:SecondaryAuthors/b:ML"/>
  </xsl:template>


  <xsl:template name="templ_prop_ISO690_SecondaryAuthors_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:SecondaryAuthors/b:FL"/>
  </xsl:template>


  <xsl:template name="templ_prop_ISO690_SameAuthor" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:SameAuthor"/>
  </xsl:template>


  <xsl:template name="templ_prop_ISO690_GeneralOpen" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:GeneralOpen"/>
  </xsl:template>


  <xsl:template name="templ_prop_ISO690_GeneralClose" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:GeneralClose"/>
  </xsl:template>


  <xsl:template name="templ_prop_ISO690_Date_DMY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:Date/b:DMY"/>
  </xsl:template>


  <xsl:template name="templ_prop_ISO690_Date_DM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:Date/b:DM"/>
  </xsl:template>


  <xsl:template name="templ_prop_ISO690_Date_MY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:Date/b:MY"/>
  </xsl:template>


  <xsl:template name="templ_prop_ISO690_Date_DY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:Date/b:DY"/>
  </xsl:template>


  <xsl:template name="templ_prop_ISO690_DateAccessed_DMY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:DateAccessed/b:DMY"/>
  </xsl:template>


  <xsl:template name="templ_prop_ISO690_DateAccessed_DM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:DateAccessed/b:DM"/>
  </xsl:template>


  <xsl:template name="templ_prop_ISO690_DateAccessed_MY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:DateAccessed/b:MY"/>
  </xsl:template>


  <xsl:template name="templ_prop_ISO690_DateAccessed_DY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:DateAccessed/b:DY"/>
  </xsl:template>


  <xsl:template name="templ_prop_Gost_Authors_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Gost/b:Authors/b:FML"/>
  </xsl:template>


  <xsl:template name="templ_prop_Gost_Authors_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Gost/b:Authors/b:FM"/>
  </xsl:template>


  <xsl:template name="templ_prop_Gost_Authors_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Gost/b:Authors/b:ML"/>
  </xsl:template>


  <xsl:template name="templ_prop_Gost_Authors_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Gost/b:Authors/b:FL"/>
  </xsl:template>


  <xsl:template name="templ_prop_Gost_Date_DMY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Gost/b:Date/b:DMY"/>
  </xsl:template>


  <xsl:template name="templ_prop_Gost_Date_DM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Gost/b:Date/b:DM"/>
  </xsl:template>


  <xsl:template name="templ_prop_Gost_Date_MY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Gost/b:Date/b:MY"/>
  </xsl:template>


  <xsl:template name="templ_prop_Gost_Date_DY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Gost/b:Date/b:DY"/>
  </xsl:template>


  <xsl:template name="templ_prop_Gost_GeneralOpen" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Gost/b:GeneralOpen"/>
  </xsl:template>


  <xsl:template name="templ_prop_Gost_GeneralClose" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Gost/b:GeneralClose"/>
  </xsl:template>


  <xsl:template name="templ_prop_Gost_OneSlash" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Gost/b:OneSlash"/>
  </xsl:template>


  <xsl:template name="templ_prop_Gost_TwoSlash" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Gost/b:TwoSlash"/>
  </xsl:template>


  <xsl:template name="templ_prop_SIST_MainAuthors_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:SIST/b:MainAuthors/b:FML"/>
  </xsl:template>


  <xsl:template name="templ_prop_SIST_MainAuthors_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:SIST/b:MainAuthors/b:FM"/>
  </xsl:template>


  <xsl:template name="templ_prop_SIST_MainAuthors_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:SIST/b:MainAuthors/b:ML"/>
  </xsl:template>


  <xsl:template name="templ_prop_SIST_MainAuthors_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:SIST/b:MainAuthors/b:FL"/>
  </xsl:template>


  <xsl:template name="templ_prop_SIST_SecondaryAuthors_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:SIST/b:SecondaryAuthors/b:FML"/>
  </xsl:template>


  <xsl:template name="templ_prop_SIST_SecondaryAuthors_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:SIST/b:SecondaryAuthors/b:FM"/>
  </xsl:template>


  <xsl:template name="templ_prop_SIST_SecondaryAuthors_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:SIST/b:SecondaryAuthors/b:ML"/>
  </xsl:template>


  <xsl:template name="templ_prop_SIST_SecondaryAuthors_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:SIST/b:SecondaryAuthors/b:FL"/>
  </xsl:template>


  <xsl:template name="templ_prop_SIST_SameAuthor" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:SIST/b:SameAuthor"/>
  </xsl:template>


  <xsl:template name="templ_prop_SIST_GeneralOpen" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:SIST/b:GeneralOpen"/>
  </xsl:template>


  <xsl:template name="templ_prop_SIST_GeneralClose" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:SIST/b:GeneralClose"/>
  </xsl:template>


  <xsl:template name="templ_prop_SIST_Date_DMY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:SIST/b:Date/b:DMY"/>
  </xsl:template>


  <xsl:template name="templ_prop_SIST_Date_DM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:SIST/b:Date/b:DM"/>
  </xsl:template>


  <xsl:template name="templ_prop_SIST_Date_MY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:SIST/b:Date/b:MY"/>
  </xsl:template>


  <xsl:template name="templ_prop_SIST_Date_DY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:SIST/b:Date/b:DY"/>
  </xsl:template>


  <xsl:template name="templ_prop_SIST_DateAccessed_DMY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:SIST/b:DateAccessed/b:DMY"/>
  </xsl:template>


  <xsl:template name="templ_prop_SIST_DateAccessed_DM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:SIST/b:DateAccessed/b:DM"/>
  </xsl:template>


  <xsl:template name="templ_prop_SIST_DateAccessed_MY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:SIST/b:DateAccessed/b:MY"/>
  </xsl:template>


  <xsl:template name="templ_prop_SIST_DateAccessed_DY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:SIST/b:DateAccessed/b:DY"/>
  </xsl:template>






  <xsl:template match="/">
    <xsl:choose>





      <xsl:when test="b:Version">
        <xsl:text>2008.7.20</xsl:text>
      </xsl:when>
      <xsl:when test="b:StyleName">
        <xsl:text>ABNT</xsl:text>
      </xsl:when>



      <xsl:when test="b:GetImportantFields">
        <b:ImportantFields>
          <xsl:choose>
            <xsl:when test="b:GetImportantFields/b:SourceType='Book'">
              <b:ImportantField>
                <xsl:text>b:Author/b:Author/b:NameList</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Title</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Year</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:City</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Publisher</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:StandardNumber</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Edition</xsl:text>
              </b:ImportantField>
            </xsl:when>

            <xsl:when test="b:GetImportantFields/b:SourceType='BookSection'">
              <b:ImportantField>
                <xsl:text>b:Author/b:Author/b:NameList</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Title</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Author/b:BookAuthor/b:NameList</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:BookTitle</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Year</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:City</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Publisher</xsl:text>
              </b:ImportantField>
            </xsl:when>

            <xsl:when test="b:GetImportantFields/b:SourceType='JournalArticle'">
              <b:ImportantField>
                <xsl:text>b:Author/b:Author/b:NameList</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Title</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Year</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:City</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Publisher</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Volume</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Issue</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:StandardNumber</xsl:text>
              </b:ImportantField>
            </xsl:when>

            <xsl:when test="b:GetImportantFields/b:SourceType='ArticleInAPeriodical'">
              <b:ImportantField>
                <xsl:text>b:Author/b:Author/b:NameList</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Title</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:PeriodicalTitle</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Year</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Edition</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Volume</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Issue</xsl:text>
              </b:ImportantField>
            </xsl:when>

            <xsl:when test="b:GetImportantFields/b:SourceType='ConferenceProceedings'">
              <b:ImportantField>
                <xsl:text>b:Author/b:Author/b:NameList</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Title</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:ConferenceName</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Pages</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Volume</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Year</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:City</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Publisher</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:StandardNumber</xsl:text>
              </b:ImportantField>
            </xsl:when>

            <xsl:when test="b:GetImportantFields/b:SourceType='Report'">
              <b:ImportantField>
                <xsl:text>b:Author/b:Author/b:NameList</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Title</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Year</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:City</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Publisher</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:StandardNumber</xsl:text>
              </b:ImportantField>
            </xsl:when>

            <xsl:when test="b:GetImportantFields/b:SourceType='SoundRecording'">
              <b:ImportantField>
                <xsl:text>b:Author/b:Artist/b:NameList</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Title</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:AlbumTitle</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:ProductionCompany</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Year</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Medium</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:City</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:StandardNumber</xsl:text>
              </b:ImportantField>
            </xsl:when>

            <xsl:when test="b:GetImportantFields/b:SourceType='Performance'">
              <b:ImportantField>
                <xsl:text>b:Author/b:Writer/b:NameList</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Title</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:ProductionCompany</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Theater</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Year</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:City</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:StandardNumber</xsl:text>
              </b:ImportantField>
            </xsl:when>

            <xsl:when test="b:GetImportantFields/b:SourceType='Art'">
              <b:ImportantField>
                <xsl:text>b:Author/b:Artist/b:NameList</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Title</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Institution</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Year</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:City</xsl:text>
              </b:ImportantField>
            </xsl:when>

            <xsl:when test="b:GetImportantFields/b:SourceType='DocumentFromInternetSite'">
              <b:ImportantField>
                <xsl:text>b:Author/b:Author/b:NameList</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Title</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:InternetSiteTitle</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:ProductionCompany</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Year</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Month</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Day</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:YearAccessed</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:MonthAccessed</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:DayAccessed</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:URL</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:StandardNumber</xsl:text>
              </b:ImportantField>
            </xsl:when>

            <xsl:when test="b:GetImportantFields/b:SourceType='InternetSite'">
              <b:ImportantField>
                <xsl:text>b:Author/b:Author/b:NameList</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Title</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:InternetSiteTitle</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:ProductionCompany</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Year</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Month</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Day</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:YearAccessed</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:MonthAccessed</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:DayAccessed</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:URL</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:StandardNumber</xsl:text>
              </b:ImportantField>
            </xsl:when>

            <xsl:when test="b:GetImportantFields/b:SourceType='Film'">
              <b:ImportantField>
                <xsl:text>b:Author/b:Director/b:NameList</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Title</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:ProductionCompany</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Year</xsl:text>
              </b:ImportantField>
            </xsl:when>

            <xsl:when test="b:GetImportantFields/b:SourceType='Interview'">
              <b:ImportantField>
                <xsl:text>b:Author/b:Interviewee/b:NameList</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Title</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:BroadcastTitle</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Year</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Month</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Day</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Broadcaster</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Station</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:City</xsl:text>
              </b:ImportantField>
            </xsl:when>

            <xsl:when test="b:GetImportantFields/b:SourceType='Patent'">
              <b:ImportantField>
                <xsl:text>b:Author/b:Inventor/b:NameList</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Title</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Year</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Month</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Day</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:CountryRegion</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Type</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:PatentNumber</xsl:text>
              </b:ImportantField>
            </xsl:when>

            <xsl:when test="b:GetImportantFields/b:SourceType='ElectronicSource'">
              <b:ImportantField>
                <xsl:text>b:Author/b:Author/b:NameList</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Title</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:City</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:ProductionCompany</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Medium</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Year</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:StandardNumber</xsl:text>
              </b:ImportantField>
            </xsl:when>

            <xsl:when test="b:GetImportantFields/b:SourceType='Case'">
              <b:ImportantField>
                <xsl:text>b:Author/b:Author/b:NameList</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Title</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:CaseNumber</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:City</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Court</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Year</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:AbbreviatedCaseNumber</xsl:text>
              </b:ImportantField>
            </xsl:when>

            <xsl:when test="b:GetImportantFields/b:SourceType='Misc'">
              <b:ImportantField>
                <xsl:text>b:Author/b:Author/b:NameList</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Title</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:PublicationTitle</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Year</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:City</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Publisher</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Volume</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:Issue</xsl:text>
              </b:ImportantField>
              <b:ImportantField>
                <xsl:text>b:StandardNumber</xsl:text>
              </b:ImportantField>
            </xsl:when>

          </xsl:choose>
        </b:ImportantFields>
      </xsl:when>

      <xsl:when test="b:Citation">

        <xsl:variable name="ListPopulatedWithMain">
          <xsl:call-template name="populateMain">
            <xsl:with-param name="Type">b:Citation</xsl:with-param>
          </xsl:call-template>
        </xsl:variable>



        <html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:w="urn:schemas-microsoft-com:office:word" xmlns="http://www.w3.org/TR/REC-html40">
          <head>
          </head>
          <body>
            <xsl:variable name="LCID">
              <xsl:choose>
                <xsl:when test="b:LCID='0' or b:LCID='' or not(b:LCID)">
                  <xsl:value-of select="/*/b:Locals/b:DefaultLCID"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="b:LCID"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>

            <xsl:element name="p">

              <xsl:attribute name="lang">
                <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$LCID]/@Culture"/>
              </xsl:attribute>

              <xsl:attribute name="dir">
                <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$LCID]/b:Properties/b:Direction"/>
              </xsl:attribute>

              <xsl:variable name="type">
                <xsl:value-of select="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:Source/b:SourceType"/>
              </xsl:variable>

              <xsl:variable name="title">
              </xsl:variable>

              <xsl:variable name="year">
              </xsl:variable>

              <xsl:variable name="authorMain">
                <xsl:copy-of select="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:Source/b:Author/b:Main"/>
              </xsl:variable>

              <xsl:variable name="author">
                <xsl:value-of select="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:Source/b:RefOrder"/>
              </xsl:variable>

              <xsl:variable name="prop_APA_Hyphens">
                <xsl:call-template name="templ_prop_Hyphens"/>
              </xsl:variable>

              <xsl:variable name="volume" select="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:Volume"/>

              <xsl:variable name="volVolume">
                <xsl:if test="string-length($volume) > 0">
                  <xsl:call-template name="StringFormat">
                    <xsl:with-param name="format">
                      <xsl:choose>
                        <xsl:when test="not(string-length($volume)=string-length(translate($volume, ',', '')))">
                          <xsl:call-template name="templ_str_VolumesShortUnCap"/>
                        </xsl:when>
                        <xsl:when test="string-length($volume)=string-length(translate($volume, $prop_APA_Hyphens, ''))">
                          <xsl:call-template name="templ_str_VolumeShortUnCap"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:call-template name="templ_str_VolumesShortUnCap"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:with-param>
                    <xsl:with-param name="parameters">
                      <t:params>
                        <t:param>
                          <xsl:value-of select="$volume"/>
                        </t:param>
                      </t:params>
                    </xsl:with-param>
                  </xsl:call-template>
                </xsl:if>
              </xsl:variable>


              <xsl:variable name="pages" select="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:Pages"/>

              <xsl:variable name="ppPages">
                <xsl:if test="string-length($pages)>0">
                  <xsl:choose>
                    <xsl:when test="not(string-length($pages)=string-length(translate($pages, ',', '')))">
                      <xsl:call-template name="templ_str_PagesCountinousShort"/>
                    </xsl:when>
                    <xsl:when test="string-length($pages)=string-length(translate($pages, $prop_APA_Hyphens, ''))">
                      <xsl:call-template name="templ_str_PageShort"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:call-template name="templ_str_PagesCountinousShort"/>
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:call-template name="templ_prop_Space"/>
                  <xsl:value-of select="$pages"/>
                </xsl:if>
              </xsl:variable>

              <xsl:variable name="displayAuthor">
                <xsl:value-of select="$author" />
              </xsl:variable>

              <xsl:variable name="displayTitle">
              </xsl:variable>


              <xsl:if test="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:FirstAuthor">
                <!--<xsl:text>[</xsl:text>-->
              </xsl:if>

              <xsl:if test="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:PagePrefix">
                <xsl:value-of select="/b:Citation/b:PagePrefix"/>
              </xsl:if>

              <xsl:value-of select="$displayAuthor" />

              <xsl:if test="string-length($displayTitle) > 0">
                <xsl:if test="string-length($displayAuthor) > 0">
                  <xsl:call-template name="templ_prop_ListSeparator"/>
                </xsl:if>
                <xsl:choose>
                  <xsl:when test="string-length($displayTitle)>0 and ($type='DocumentFromInternetSite' or $type='InternetSite' or $type='ElectronicSource')">
                    <xsl:call-template name="templ_prop_OpenQuote"/>
                    <xsl:value-of select="$displayTitle"/>
                    <xsl:call-template name="templ_prop_CloseQuote"/>
                  </xsl:when>
                  <xsl:when test="string-length($displayTitle)>0 and ($type='Book' or $type='BookSection' or $type='JournalArticle' or $type='ArticleInAPeriodical' or $type='ConferenceProceedings' or $type='Report')">
                    <xsl:call-template name = "ApplyItalicTitleNS">
                      <xsl:with-param name = "data">
                        <xsl:value-of select="$displayTitle"/>
                      </xsl:with-param>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:when test="string-length($displayTitle)>0">
                    <xsl:value-of select="$displayTitle"/>
                  </xsl:when>
                </xsl:choose>
              </xsl:if>

              <xsl:if test="string-length($year) > 0">
                <xsl:if test="string-length($displayAuthor) > 0 or string-length($displayTitle) > 0">
                  <xsl:call-template name="templ_prop_ListSeparator"/>
                </xsl:if>
                <xsl:value-of select="$year"/>
              </xsl:if>

              <xsl:if test="string-length($volume) > 0 or string-length($pages) > 0">
                <xsl:if test="string-length($displayAuthor) > 0 or string-length($displayTitle) > 0 or string-length($year) > 0">
                  <xsl:call-template name="templ_prop_Space"/>
                </xsl:if>

                <xsl:choose>
                  <xsl:when test="string-length($volume) > 0 and string-length($pages) > 0">
                    <xsl:value-of select="$volume"/>
                    <xsl:call-template name="templ_prop_EnumSeparator"/>
                    <xsl:value-of select="$pages"/>
                  </xsl:when>
                  <xsl:when test="string-length($volVolume) > 0">
                    <xsl:value-of select="$volVolume"/>
                  </xsl:when>
                  <xsl:when test="string-length($ppPages) > 0">
                    <xsl:value-of select="$ppPages"/>
                  </xsl:when>
                </xsl:choose>
              </xsl:if>

              <xsl:if test="/b:Citation/b:PageSuffix">
                <xsl:value-of select="/b:Citation/b:PageSuffix"/>
              </xsl:if>

              <xsl:if test="/b:Citation/b:LastAuthor">
                <!--<xsl:text>]</xsl:text>-->
              </xsl:if>
              <xsl:if test="not(/b:Citation/b:LastAuthor)">
                <!--<xsl:call-template name="templ_prop_GroupSeparator"/>-->
		<xsl:text>,</xsl:text>
              </xsl:if>


            </xsl:element>
          </body>
        </html>
      </xsl:when>


      <xsl:when test="b:Bibliography">
        <html xmlns:o="urn:schemas-microsoft-com:office:office"
						xmlns:w="urn:schemas-microsoft-com:office:word"
						xmlns="http://www.w3.org/TR/REC-html40">
          <head>

            <style>
              p.MsoBibliography, li.MsoBibliography, div.MsoBibliography
            </style>
          </head>

          <body>
            <table width="100%">

              <xsl:variable name="ListPopulatedWithMain">
                <xsl:call-template name="populateMain">
                  <xsl:with-param name="Type">b:Bibliography</xsl:with-param>
                </xsl:call-template>
              </xsl:variable>



              <xsl:variable name="SortedList">
                <xsl:call-template name="sortedList">
                  <xsl:with-param name="sourceRoot">
                    <xsl:copy-of select="$ListPopulatedWithMain"/>
                  </xsl:with-param>

                </xsl:call-template>
              </xsl:variable>



              <xsl:for-each select="msxsl:node-set($SortedList)/b:Bibliography/b:Source">
                <tr>
                  <td valign="top" align="right">
                    <!--<p>-->
		    <sup class="MsoBibliography"> 
                      <xsl:variable name="LCID">
                        <xsl:choose>
                          <xsl:when test="b:LCID='0' or b:LCID='' or not(b:LCID)">
                            <xsl:value-of select="/*/b:Locals/b:DefaultLCID"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="b:LCID"/>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:variable>
                      <xsl:attribute name="lang">
                        <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$LCID]/@Culture"/>
                      </xsl:attribute>
                      <xsl:attribute name="dir">
                        <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$LCID]/b:Properties/b:Direction"/>
                      </xsl:attribute>
                      <xsl:attribute name="class">
                        <xsl:value-of select="'MsoBibliography'"/>
                      </xsl:attribute>

                      <!--<xsl:text>[</xsl:text>-->
                      <xsl:value-of select="./b:RefOrder"/>
                      <!--<xsl:text>]</xsl:text>-->
                    <!--</p>-->
		    </sup>
                  </td>

                  <td valign="top">
                    <xsl:element name="p">
                    <xsl:variable name="LCID">
                      <xsl:choose>
                        <xsl:when test="b:LCID='0' or b:LCID='' or not(b:LCID)">
                          <xsl:value-of select="/*/b:Locals/b:DefaultLCID"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="b:LCID"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:variable>
                    <xsl:attribute name="lang">
                      <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$LCID]/@Culture"/>
                    </xsl:attribute>
                    <xsl:attribute name="dir">
                      <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$LCID]/b:Properties/b:Direction"/>
                    </xsl:attribute>
                    <xsl:attribute name="class">
                      <xsl:value-of select="'MsoBibliography'"/>
                    </xsl:attribute>





                    <xsl:variable name="prevBook">
                      <xsl:value-of select="position()-1"/>
                    </xsl:variable>

                    <xsl:variable name="cMaxAllow">
                      <xsl:call-template name="maxAuthor"/>
                    </xsl:variable>

                    <xsl:variable name="Main">
                      <xsl:call-template name="formatMain"/>
                    </xsl:variable>

                    <xsl:variable name="MainDot">
                      <xsl:call-template name="appendField_Dot">
                        <xsl:with-param name="field" select="$Main"/>
                      </xsl:call-template>
                    </xsl:variable>

                    <xsl:variable name="Editors">
                      <xsl:if test="b:Author/b:Main != b:Author/b:Editor">
                        <xsl:call-template name="formatEditor"/>
                        <xsl:call-template name="templ_prop_Space"/>
                      </xsl:if>
                    </xsl:variable>

                    <xsl:variable name="Translators">
                      <xsl:if test="b:Author/b:Main != b:Author/b:Translator">
                        <xsl:call-template name="formatTranslator"/>
                        <xsl:call-template name="templ_prop_Space"/>
                      </xsl:if>
                    </xsl:variable>

                    <xsl:variable name="Authors">
                      <xsl:if test="b:Author/b:Main != b:Author/b:Author">
                        <xsl:call-template name="formatAuthor"/>
                        <xsl:call-template name="templ_prop_Space"/>
                      </xsl:if>
                    </xsl:variable>

                    <xsl:variable name="BookAuthors">
                      <xsl:if test="b:Author/b:Main != b:Author/b:BookAuthor">
                        <xsl:call-template name="formatBookAuthor"/>
                        <xsl:call-template name="templ_prop_Space"/>
                      </xsl:if>
                    </xsl:variable>

                    <xsl:variable name="Artists">
                      <xsl:if test="b:Author/b:Main != b:Author/b:Artist">
                        <xsl:call-template name="formatArtist"/>
                        <xsl:call-template name="templ_prop_Space"/>
                      </xsl:if>
                    </xsl:variable>

                    <xsl:variable name="Compilers">
                      <xsl:if test="b:Author/b:Main != b:Author/b:Compiler">
                        <xsl:call-template name="formatCompiler"/>
                        <xsl:call-template name="templ_prop_Space"/>
                      </xsl:if>
                    </xsl:variable>

                    <xsl:variable name="Composers">
                      <xsl:if test="b:Author/b:Main != b:Author/b:Composer">
                        <xsl:call-template name="formatComposer"/>
                        <xsl:call-template name="templ_prop_Space"/>
                      </xsl:if>
                    </xsl:variable>

                    <xsl:variable name="Conductors">
                      <xsl:if test="b:Author/b:Main != b:Author/b:Conductor">
                        <xsl:call-template name="formatConductor"/>
                        <xsl:call-template name="templ_prop_Space"/>
                      </xsl:if>
                    </xsl:variable>

                    <xsl:variable name="Counsels">
                      <xsl:if test="b:Author/b:Main != b:Author/b:Counsel">
                        <xsl:call-template name="formatCounsel"/>
                        <xsl:call-template name="templ_prop_Space"/>
                      </xsl:if>
                    </xsl:variable>

                    <xsl:variable name="Directors">
                      <xsl:if test="b:Author/b:Main != b:Author/b:Director">
                        <xsl:call-template name="formatDirector"/>
                        <xsl:call-template name="templ_prop_Space"/>
                      </xsl:if>
                    </xsl:variable>

                    <xsl:variable name="Interviewees">
                      <xsl:if test="b:Author/b:Main != b:Author/b:Interviewee">
                        <xsl:call-template name="formatInterviewee"/>
                        <xsl:call-template name="templ_prop_Space"/>
                      </xsl:if>
                    </xsl:variable>

                    <xsl:variable name="Interviewers">
                      <xsl:if test="b:Author/b:Main != b:Author/b:Interviewer">
                        <xsl:call-template name="formatInterviewer"/>
                        <xsl:call-template name="templ_prop_Space"/>
                      </xsl:if>
                    </xsl:variable>

                    <xsl:variable name="Inventors">
                      <xsl:if test="b:Author/b:Main != b:Author/b:Inventor">
                        <xsl:call-template name="formatInventor"/>
                        <xsl:call-template name="templ_prop_Space"/>
                      </xsl:if>
                    </xsl:variable>

                    <xsl:variable name="Performers">
                      <xsl:if test="b:Author/b:Main != b:Author/b:Performer">
                        <xsl:call-template name="formatPerformer"/>
                        <xsl:call-template name="templ_prop_Space"/>
                      </xsl:if>
                    </xsl:variable>

                    <xsl:variable name="ProducerNames">
                      <xsl:if test="b:Author/b:Main != b:Author/b:ProducerName">
                        <xsl:call-template name="formatProducerName"/>
                        <xsl:call-template name="templ_prop_Space"/>
                      </xsl:if>
                    </xsl:variable>

                    <xsl:variable name="Reporters">
                      <xsl:if test="string-length(b:Reporter)">
                        <xsl:call-template name="templ_prop_Space"/>
                        <xsl:value-of select ="b:Reporter"/>
                        <xsl:call-template name="templ_prop_Dot"/>
                      </xsl:if>
                    </xsl:variable>

                    <xsl:variable name="Writers">
                      <xsl:if test="b:Author/b:Main != b:Author/b:Writer">
                        <xsl:call-template name="formatWriter"/>
                      </xsl:if>
                    </xsl:variable>

                    <xsl:variable name="CityAndPublishers">
                      <xsl:call-template name ="formatLocation"/>
                    </xsl:variable>

                    <xsl:variable name ="DayMonthYear">
                      <xsl:call-template name ="formatDayMonthYear"/>
                    </xsl:variable>

                    <xsl:variable name ="DayMonthYearAccessed">
                      <xsl:call-template name ="formatDayMonthYearAccessed"/>
                    </xsl:variable>

                    <xsl:variable name ="Year">
                      <xsl:if test="string-length(b:Year)>0">
                        <xsl:value-of select ="b:Year"/>
                      </xsl:if>
                    </xsl:variable>

                    <xsl:variable name="prop_APA_Hyphens">
                      <xsl:call-template name="templ_prop_Hyphens"/>
                    </xsl:variable>

                    <xsl:variable name ="Volume">
                      <xsl:if test ="string-length(b:Volume)>0">
                        <xsl:variable name ="volume" select="b:Volume"/>
                        <xsl:call-template name="StringFormat">
                          <xsl:with-param name="format">
                            <xsl:choose>
                              <xsl:when test="not(string-length($volume)=string-length(translate($volume, ',', '')))">
                                <xsl:call-template name="templ_str_VolumesShortCap"/>
                              </xsl:when>
                              <xsl:when test="string-length($volume)=string-length(translate($volume, $prop_APA_Hyphens, ''))">
                                <xsl:call-template name="templ_str_VolumeShortCap"/>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:call-template name="templ_str_VolumesShortCap"/>
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:with-param>
                          <xsl:with-param name="parameters">
                            <t:params>
                              <t:param>
                                <xsl:value-of select="$volume"/>
                              </t:param>
                            </t:params>
                          </xsl:with-param>
                        </xsl:call-template>
                      </xsl:if>
                    </xsl:variable>

                    <xsl:variable name ="VolumeChunk">
                      <xsl:if test ="string-length($Volume)>0">
                        <xsl:call-template name="templ_prop_Space"/>
                        <xsl:call-template name="appendField_Dot">
                          <xsl:with-param name="field" select ="$Volume"/>
                        </xsl:call-template>
                      </xsl:if>
                    </xsl:variable>

                    <xsl:variable name ="VolumeAndNumberOfVolumes">
                      <xsl:value-of select="$Volume"/>
                    </xsl:variable>

                    <xsl:variable name ="SepPublicationTitle">
                      <xsl:if test ="string-length(b:PublicationTitle)>0">
                        <xsl:value-of select ="b:PublicationTitle"/>
                      </xsl:if>
                    </xsl:variable>


                    <xsl:variable name="pages" select="b:Pages"/>

                    <xsl:variable name ="Pages">
                      <xsl:if test="string-length($pages)>0">
                        <xsl:choose>
                          <xsl:when test="not(string-length($pages)=string-length(translate($pages, ',', '')))">
                            <xsl:call-template name="templ_str_PagesCountinousShort"/>
                          </xsl:when>
                          <xsl:when test="string-length($pages)=string-length(translate($pages, $prop_APA_Hyphens, ''))">
                            <xsl:call-template name="templ_str_PageShort"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:call-template name="templ_str_PagesCountinousShort"/>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:call-template name="templ_prop_Space"/>
                        <xsl:value-of select="$pages"/>
                      </xsl:if>
                    </xsl:variable>

                    <xsl:variable name ="SpacePagesDot">
                      <xsl:if test="string-length($pages)>0">
                        <xsl:call-template name="templ_prop_Space"/>
                        <xsl:call-template name="appendField_Dot">
                          <xsl:with-param name="field" select ="$pages"/>
                        </xsl:call-template>
                      </xsl:if>
                    </xsl:variable>

                    <xsl:variable name ="SpacePPagesDot">
                      <xsl:if test="string-length($Pages)>0">
                        <xsl:call-template name="templ_prop_Space"/>
                        <xsl:call-template name="appendField_Dot">
                          <xsl:with-param name="field" select ="$Pages"/>
                        </xsl:call-template>
                      </xsl:if>
                    </xsl:variable>

                    <xsl:variable name ="ChapterNumber">
                      <xsl:if test="string-length(b:ChapterNumber)>0">
                        <xsl:value-of select ="b:ChapterNumber"/>
                      </xsl:if>
                    </xsl:variable>

                    <xsl:variable name ="Issue">
                      <xsl:if test="string-length(b:Issue)>0">
                        <xsl:value-of select ="b:Issue"/>
                      </xsl:if>
                    </xsl:variable>

                    <xsl:variable name ="Issues2">
                      <xsl:if test="string-length(b:Issue)>0">
                        <xsl:value-of select ="b:Issue"/>
                        <xsl:call-template name="templ_prop_ListSeparator"/>

                      </xsl:if>
                    </xsl:variable>

                    <xsl:variable name ="ReportType">
                      <xsl:if test="string-length(b:ThesisType)>0">
                        <xsl:value-of select ="b:ThesisType"/>
                      </xsl:if>
                    </xsl:variable>

                    <xsl:variable name ="URL">
                      <xsl:if test="string-length(b:URL)>0">
                        <xsl:call-template name="templ_prop_Space"/>
                        <xsl:value-of select ="b:URL"/>
                        <xsl:call-template name="templ_prop_Dot"/>
                      </xsl:if>
                    </xsl:variable>

                    <xsl:variable name ="Type">
                      <xsl:if test="string-length(b:Type)>0">
                        <xsl:call-template name="templ_prop_Space"/>
                        <xsl:call-template name="appendField_Dot">
                          <xsl:with-param name="field" select ="b:Type"/>
                        </xsl:call-template>
                      </xsl:if>
                    </xsl:variable>

                    <xsl:variable name ="Comments">
                      <xsl:if test="string-length(b:Comments)>0">
                        <xsl:call-template name="templ_prop_Space"/>
                        <xsl:value-of select ="b:Comments"/>
                        <xsl:call-template name="templ_prop_Dot"/>
                      </xsl:if>
                    </xsl:variable>

                    <xsl:variable name ="StandardNumber">
                      <xsl:if test="string-length(b:StandardNumber)>0">
                        <xsl:call-template name="templ_prop_Space"/>
                        <xsl:value-of select ="b:StandardNumber"/>
                        <xsl:call-template name="templ_prop_Dot"/>
                      </xsl:if>
                    </xsl:variable>

                    <xsl:variable name ="InternetSiteTitle">
                      <xsl:if test ='string-length(b:InternetSiteTitle)>0'>
                        <xsl:call-template name = "ApplyItalicTitleNS">
                          <xsl:with-param name = "data">
                            <xsl:call-template name="appendField_Dot">
                              <xsl:with-param name="field" select="b:InternetSiteTitle"/>
                            </xsl:call-template>
                            <xsl:call-template name="templ_prop_Space"/>

                          </xsl:with-param>
                        </xsl:call-template>
                      </xsl:if>
                      <xsl:call-template name="templ_prop_ISO690_GeneralOpen"/>
                      <xsl:call-template name="templ_str_OnlineCap"/>
                      <xsl:call-template name="templ_prop_ISO690_GeneralClose"/>
                      <xsl:call-template name="templ_prop_Space"/>
                    </xsl:variable>

                    <xsl:variable name ='PublicationTitle'>
                      <xsl:if test ='string-length(b:PublicationTitle)>0'>
                        <xsl:call-template name = "ApplyItalicTitleNS">
                          <xsl:with-param name = "data">
                            <xsl:call-template name="appendField_Dot">
                              <xsl:with-param name="field" select="b:PublicationTitle"/>
                            </xsl:call-template>
                            <xsl:call-template name="templ_prop_Space"/>

                          </xsl:with-param>
                        </xsl:call-template>
                      </xsl:if>
                    </xsl:variable>

                    <xsl:variable name ='BookTitle'>
                      <xsl:if test="string-length(b:BookTitle)>0">
                        <xsl:call-template name = "ApplyItalicTitleNS">
                          <xsl:with-param name = "data">
                            <xsl:call-template name="appendField_Dot">
                              <xsl:with-param name="field" select="b:BookTitle"/>
                            </xsl:call-template>
                            <xsl:call-template name="templ_prop_Space"/>

                          </xsl:with-param>
                        </xsl:call-template>
                      </xsl:if>

                    </xsl:variable>

                    <xsl:variable name ='JournalName'>
                      <xsl:if test="string-length(b:JournalName)>0">
                        <xsl:value-of select="b:JournalName"/>
                      </xsl:if>

                    </xsl:variable>

                    <xsl:variable name ='PeriodicalTitle'>
                      <xsl:if test="string-length(b:PeriodicalTitle)>0">
                        <xsl:call-template name = "ApplyItalicTitleNS">
                          <xsl:with-param name = "data">
                            <xsl:call-template name="appendField_Dot">
                              <xsl:with-param name="field" select="b:PeriodicalTitle"/>
                            </xsl:call-template>
                            <xsl:call-template name="templ_prop_Space"/>

                          </xsl:with-param>
                        </xsl:call-template>
                      </xsl:if>

                    </xsl:variable>

                    <xsl:variable name ='Edition'>
                      <xsl:if test="string-length(b:Edition)>0">
                        <xsl:value-of select ="b:Edition"/>

                      </xsl:if>

                    </xsl:variable>

                    <xsl:variable name ='EditionItem'>
                      <xsl:if test="string-length(b:Edition)>0">
                        <xsl:call-template name="appendField_Dot">
                          <xsl:with-param name="field" select="b:Edition"/>
                        </xsl:call-template>
                        <xsl:call-template name="templ_prop_Space"/>
                      </xsl:if>
                    </xsl:variable>

                    <xsl:variable name ='ConferenceName'>
                      <xsl:if test="string-length(b:ConferenceName)>0">
                        <xsl:call-template name="templ_prop_Space"/>
                        <xsl:call-template name="appendField_Dot">
                          <xsl:with-param name="field" select="b:ConferenceName"/>
                        </xsl:call-template>
                      </xsl:if>

                    </xsl:variable>

                    <xsl:variable name ='AlbumTitle'>
                      <xsl:if test="string-length(b:AlbumTitle)>0">
                        <xsl:call-template name = "ApplyItalicTitleNS">
                          <xsl:with-param name = "data">
                            <xsl:call-template name="appendField_Dot">
                              <xsl:with-param name="field" select="b:AlbumTitle"/>
                            </xsl:call-template>
                            <xsl:call-template name="templ_prop_Space"/>

                          </xsl:with-param>
                        </xsl:call-template>
                      </xsl:if>

                    </xsl:variable>

                    <xsl:variable name ='BroadcastTitle'>
                      <xsl:if test="string-length(b:BroadcastTitle)>0">
                        <xsl:call-template name="appendField_Dot">
                          <xsl:with-param name="field" select="b:BroadcastTitle"/>
                        </xsl:call-template>
                        <xsl:call-template name="templ_prop_Space"/>
                      </xsl:if>
                    </xsl:variable>

                    <xsl:variable name ='Medium'>
                      <xsl:if test="string-length(b:Medium)>0">
                        <xsl:call-template name="templ_prop_ISO690_GeneralOpen"/>

                        <xsl:value-of select ="b:Medium"/>
                        <xsl:call-template name="templ_prop_ISO690_GeneralClose"/>
                        <xsl:call-template name="templ_prop_Space"/>


                      </xsl:if>

                    </xsl:variable>

                    <xsl:variable name ='MediumDot'>
                      <xsl:if test="string-length(b:Medium)>0">
                        <xsl:call-template name="templ_prop_ISO690_GeneralOpen"/>


                        <xsl:value-of select ="b:Medium"/>
                        <xsl:call-template name="templ_prop_ISO690_GeneralClose"/>
                        <xsl:call-template name="templ_prop_Dot"/>
                        <xsl:call-template name="templ_prop_Space"/>



                      </xsl:if>

                    </xsl:variable>

                    <xsl:variable name ='Version'>
                      <xsl:if test="string-length(b:Version)>0">
                        <xsl:value-of select ="b:Version"/>
                        <xsl:call-template name="templ_prop_Space"/>

                      </xsl:if>

                    </xsl:variable>

                    <xsl:variable name ="VersionAndDayMonthYear">
                      <xsl:call-template name="templateJ">
                        <xsl:with-param name="first" select="b:Version"/>
                        <xsl:with-param name="second">
                          <xsl:if test="b:SourceType='InternetSite'">
                            <xsl:value-of select ="b:ProductionCompany"/>
                          </xsl:if>
                        </xsl:with-param>
                        <xsl:with-param name="third" select="$DayMonthYear"/>
                      </xsl:call-template>
                      <xsl:if test="string-length(b:Version)>0 or string-length($DayMonthYear)>0 or string-length(b:ProductionCompany)>0 ">
                        <xsl:call-template name="templ_prop_Space"/>
                      </xsl:if>
                    </xsl:variable>

                    <xsl:variable name ="DepartmentAndInstitution">
                      <xsl:call-template name="templateC">
                        <xsl:with-param name="first" select="b:Department"/>
                        <xsl:with-param name="second" select="b:Institution"/>
                      </xsl:call-template>
                      <xsl:if test="string-length(b:Department)>0 or string-length(b:Institution)>0 ">
                        <xsl:call-template name="templ_prop_Space"/>
                      </xsl:if>
                    </xsl:variable>

                    <xsl:variable name ='PatentNumber'>
                      <xsl:if test="string-length(b:PatentNumber)>0">
                        <xsl:call-template name = "ApplyItalicFieldNS">
                          <xsl:with-param name = "data">
                            <xsl:value-of select="b:PatentNumber"/>
                            <xsl:call-template name="templ_prop_Space"/>

                          </xsl:with-param>
                        </xsl:call-template>
                      </xsl:if>

                    </xsl:variable>

                    <xsl:variable name ='CaseNumber'>
                      <xsl:if test="string-length(b:CaseNumber)">
                        <xsl:value-of select ="b:CaseNumber"/>
                        <xsl:call-template name="templ_prop_ListSeparator"/>

                      </xsl:if>

                    </xsl:variable>

                    <xsl:variable name ='AbbreviatedCaseNumber'>
                      <xsl:if test="string-length(b:AbbreviatedCaseNumber)">
                        <xsl:value-of select ="b:AbbreviatedCaseNumber"/>
                        <xsl:call-template name="templ_prop_Dot"/>
                        <xsl:call-template name="templ_prop_Space"/>

                      </xsl:if>

                    </xsl:variable>

                    <xsl:variable name ='Title'>

                      <xsl:choose>
                        <xsl:when test="string-length(b:Chapter) > 0">
                          <xsl:call-template name = "ApplyItalicFieldNS">
                            <xsl:with-param name = "data">
                              <xsl:call-template name="appendField_Dot">
                                <xsl:with-param name="field" select="b:Chapter"/>
                              </xsl:call-template>
                            </xsl:with-param>
                          </xsl:call-template>

                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:if test="string-length(b:TitlePrefix) > 0">
                            <xsl:call-template name = "ApplyItalicTitleNS">
                              <xsl:with-param name = "data">
                                <xsl:value-of select="b:TitlePrefix"/>
                                <xsl:call-template name="templ_prop_Space"/>

                              </xsl:with-param>
                            </xsl:call-template>
                          </xsl:if>
                          <xsl:if test="string-length(b:Title) >0">
                            <xsl:call-template name = "ApplyItalicTitleNS">
                              <xsl:with-param name = "data">
                                <xsl:call-template name="appendField_Dot">
                                  <xsl:with-param name="field" select="b:Title"/>
                                </xsl:call-template>
                                <xsl:call-template name="templ_prop_Space"/>


                              </xsl:with-param>
                            </xsl:call-template>


                          </xsl:if>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:variable>

                    <xsl:variable name ='TitleOfMonographParts'>


                      <xsl:choose>
                        <xsl:when test="string-length(b:Chapter) > 0">
                          <xsl:call-template name="appendField_Dot">
                            <xsl:with-param name="field" select="b:Chapter"/>
                          </xsl:call-template>

                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:if test="string-length(b:TitlePrefix) > 0">
                            <xsl:value-of select="b:TitlePrefix"/>
                            <xsl:call-template name="templ_prop_Space"/>

                          </xsl:if>
                          <xsl:if test="string-length(b:Title) >0">
                            <xsl:call-template name="appendField_Dot">
                              <xsl:with-param name="field" select="b:Title"/>
                            </xsl:call-template>
                            <xsl:call-template name="templ_prop_Space"/>


                          </xsl:if>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:variable>

                    <xsl:if test="b:SourceType='ConferenceProceedings' or b:SourceType='JournalArticle'">
                      <xsl:call-template name = "ApplyItalicTitleNS">
                        <xsl:with-param name = "data">
                          <xsl:choose>
                            <xsl:when test="(/b:Bibliography/b:Source[position()=$prevBook]/b:SourceType = 'JournalArticle' or /b:Bibliography/b:Source[position()=$prevBook]/b:SourceType = 'ConferenceProceedings') and /b:Bibliography/b:Source[position()=$prevBook]/b:Title = b:Title">
                              <xsl:call-template name="templ_prop_ISO690_SameAuthor"/>
                              <xsl:call-template name="templ_prop_Dot"/>
                            </xsl:when>
                            <xsl:when test="b:SourceType = 'JournalArticle' or b:SourceType = 'ConferenceProceedings'">
                              <xsl:copy-of select ='$TitleOfMonographParts'/>
                            </xsl:when>
                          </xsl:choose>
                        </xsl:with-param>
                      </xsl:call-template>
                    </xsl:if>


                    <xsl:choose>
                      <xsl:when test="/b:Bibliography/b:Source[position()=$prevBook]/b:SourceType = 'JournalArticle' or /b:Bibliography/b:Source[position()=$prevBook]/b:SourceType = 'ConferenceProceedings'">
                        <b>
                          <xsl:copy-of select="$Main"/>
                          <xsl:call-template name="need_Dot">
                            <xsl:with-param name="field" select ="$Main"/>
                          </xsl:call-template>
                        </b>
                        <xsl:call-template name="templ_prop_Space"/>
                      </xsl:when>
                      <xsl:when test="b:SourceType = 'JournalArticle' or b:SourceType = 'ConferenceProceedings'">
                        <b>
                          <xsl:copy-of select="$Main"/>
                          <xsl:call-template name="need_Dot">
                            <xsl:with-param name="field" select ="$Main"/>
                          </xsl:call-template>
                        </b>
                        <xsl:call-template name="templ_prop_Space"/>
                      </xsl:when>
                      <xsl:when test="/b:Bibliography/b:Source[position()=$prevBook]/b:Author/b:Main = b:Author/b:Main">
                        <xsl:if test ="string-length(b:Author/b:Main)>0">
                          <xsl:call-template name="templ_prop_ISO690_SameAuthor"/>
                          <xsl:call-template name="templ_prop_Dot"/>
                          <xsl:call-template name="templ_prop_Space"/>


                        </xsl:if>
                      </xsl:when>
                      <xsl:otherwise>
                        <b>
                          <xsl:copy-of select="$MainDot"/>
                        </b>
                        <xsl:call-template name="templ_prop_Space"/>

                      </xsl:otherwise>
                    </xsl:choose>


                    <xsl:choose>
                      <xsl:when test="b:SourceType='Book'">
                        <xsl:copy-of select ='$Title'/>
                        <xsl:value-of select="$Editors"/>
                        <xsl:value-of select="$Translators"/>
                        <xsl:value-of select="$EditionItem"/>
                        <xsl:call-template name='PrintList'>
                          <xsl:with-param name="list">
                            <Items>
                              <TextItem>
                                <xsl:value-of select ="$CityAndPublishers"/>
                              </TextItem>
                              <TextItem>
                                <xsl:value-of select ="$Year"/>
                              </TextItem>
                            </Items>
                          </xsl:with-param>
                        </xsl:call-template>

                        <xsl:value-of select ="$SpacePPagesDot"/>

                        <xsl:call-template name='PrintSpaceAndList'>
                          <xsl:with-param name="list">
                            <Items>
                              <TextItem>
                                <xsl:value-of select ="$VolumeAndNumberOfVolumes"/>
                              </TextItem>
                              <TextItem>
                                <xsl:value-of select ="$Comments"/>
                              </TextItem>
                            </Items>
                          </xsl:with-param>
                        </xsl:call-template>

                        <xsl:value-of select ="$StandardNumber"/>
                      </xsl:when>

                      <xsl:when test="b:SourceType='BookSection'">
                        <xsl:copy-of select ='$TitleOfMonographParts'/>
                        <xsl:value-of select="$BookAuthors"/>
                        <xsl:value-of select="$Editors"/>
                        <xsl:value-of select="$Translators"/>
                        <xsl:copy-of select="$BookTitle"/>
                        <xsl:value-of select="$EditionItem"/>
                        <xsl:call-template name='PrintList'>
                          <xsl:with-param name="list">
                            <Items>
                              <TextItem>
                                <xsl:value-of select ="$CityAndPublishers"/>
                              </TextItem>
                              <TextItem>
                                <xsl:value-of select ="$Year"/>
                              </TextItem>
                              <TextItem>
                                <xsl:value-of select ="$VolumeAndNumberOfVolumes"/>
                              </TextItem>
                              <TextItem>
                                <xsl:value-of select ="$ChapterNumber"/>
                              </TextItem>
                              <TextItem>
                                <xsl:value-of select ="$Pages"/>
                              </TextItem>
                            </Items>
                          </xsl:with-param>
                        </xsl:call-template>
                        <xsl:value-of select ="$Comments"/>
                      </xsl:when>

                      <xsl:when test="b:SourceType='JournalArticle'">
                        <xsl:value-of select ="$Editors"/>
                        <xsl:value-of select ="$Issues2"/>
                        <xsl:call-template name='PrintList'>
                          <xsl:with-param name="list">
                            <Items>
                              <TextItem>
                                <xsl:value-of select ="$CityAndPublishers"/>
                              </TextItem>
                              <TextItem>
                                <xsl:value-of select ="$DayMonthYear"/>
                              </TextItem>
                              <TextItem>
                                <xsl:value-of select ='$JournalName'/>
                              </TextItem>
                              <TextItem>
                                <xsl:value-of select ="$Volume"/>
                              </TextItem>
                              <TextItem>
                                <xsl:value-of select ="$Pages"/>
                              </TextItem>
                            </Items>
                          </xsl:with-param>
                        </xsl:call-template>
                        <xsl:value-of select ="$Comments"/>
                        <xsl:value-of select ="$StandardNumber"/>
                      </xsl:when>

                      <xsl:when test="b:SourceType='ArticleInAPeriodical'">
                        <xsl:copy-of select ='$TitleOfMonographParts'/>
                        <xsl:value-of select ="$Editors"/>
                        <xsl:copy-of select ='$PeriodicalTitle'/>
                        <xsl:call-template name='PrintList'>
                          <xsl:with-param name="list">
                            <Items>
                              <TextItem>
                                <xsl:value-of select ='$Edition'/>
                              </TextItem>
                              <TextItem>
                                <xsl:value-of select ="$DayMonthYear"/>
                              </TextItem>
                              <TextItem>
                                <xsl:value-of select ="$Volume"/>
                              </TextItem>
                              <TextItem>
                                <xsl:value-of select ="$Issue"/>
                              </TextItem>
                              <TextItem>
                                <xsl:value-of select ="$Pages"/>
                              </TextItem>
                            </Items>
                          </xsl:with-param>
                        </xsl:call-template>
                        <xsl:value-of select ="$Comments"/>
                      </xsl:when>

                      <xsl:when test="b:SourceType='ConferenceProceedings'">
                        <xsl:value-of select ="$Editors"/>
                        <xsl:call-template name='PrintList'>
                          <xsl:with-param name="list">
                            <Items>
                              <TextItem>
                                <xsl:value-of select ="$CityAndPublishers"/>
                              </TextItem>
                              <TextItem>
                                <xsl:value-of select ="$Year"/>
                              </TextItem>
                            </Items>
                          </xsl:with-param>
                        </xsl:call-template>
                        <xsl:copy-of select ='$ConferenceName'/>
                        <xsl:call-template name='PrintSpaceAndList'>
                          <xsl:with-param name="list">
                            <Items>
                              <TextItem>
                                <xsl:value-of select ="$Volume"/>
                              </TextItem>
                              <TextItem>
                                <xsl:value-of select ="$Pages"/>
                              </TextItem>
                            </Items>
                          </xsl:with-param>
                        </xsl:call-template>
                        <xsl:value-of select ="$Comments"/>
                        <xsl:value-of select ="$StandardNumber"/>
                      </xsl:when>

                      <xsl:when test="b:SourceType='Report'">
                        <xsl:copy-of select ='$Title'/>
                        <xsl:value-of select ="$DepartmentAndInstitution"/>
                        <xsl:call-template name='PrintList'>
                          <xsl:with-param name="list">
                            <Items>
                              <TextItem>
                                <xsl:value-of select ="$CityAndPublishers"/>
                              </TextItem>
                              <TextItem>
                                <xsl:value-of select ="$Year"/>
                              </TextItem>
                            </Items>
                          </xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name='PrintSpaceAndList'>
                          <xsl:with-param name="list">
                            <Items>
                              <TextItem>
                                <xsl:value-of select ="$Pages"/>
                              </TextItem>
                              <TextItem>
                                <xsl:value-of select ="$ReportType"/>
                              </TextItem>
                            </Items>
                          </xsl:with-param>
                        </xsl:call-template>
                        <xsl:value-of select ="$Comments"/>
                        <xsl:value-of select ="$StandardNumber"/>
                      </xsl:when>

                      <xsl:when test="b:SourceType='SoundRecording'">
                        <xsl:copy-of select ='$TitleOfMonographParts'/>
                        <xsl:value-of select ="$Performers"/>
                        <xsl:value-of select ="$Composers"/>
                        <xsl:value-of select ="$Conductors"/>
                        <xsl:value-of select ='$ProducerNames'/>
                        <xsl:copy-of select ='$AlbumTitle'/>
                        <xsl:copy-of select ='$Medium'/>
                        <xsl:call-template name='PrintList'>
                          <xsl:with-param name="list">
                            <Items>
                              <TextItem>
                                <xsl:value-of select ="$CityAndPublishers"/>
                              </TextItem>
                              <TextItem>
                                <xsl:value-of select ="$Year"/>
                              </TextItem>
                            </Items>
                          </xsl:with-param>
                        </xsl:call-template>
                        <xsl:value-of select ="$Comments"/>
                        <xsl:value-of select ="$StandardNumber"/>
                      </xsl:when>

                      <xsl:when test="b:SourceType='Performance'">
                        <xsl:copy-of select ='$Title'/>
                        <xsl:value-of select ="$Directors"/>
                        <xsl:value-of select="$Performers"/>
                        <xsl:value-of select ="$ProducerNames"/>
                        <xsl:call-template name='PrintList'>
                          <xsl:with-param name="list">
                            <Items>
                              <TextItem>
                                <xsl:value-of select ="$CityAndPublishers"/>
                              </TextItem>
                              <TextItem>
                                <xsl:value-of select ="$DayMonthYear"/>
                              </TextItem>
                            </Items>
                          </xsl:with-param>
                        </xsl:call-template>
                        <xsl:value-of select ="$Comments"/>
                        <xsl:value-of select ="$StandardNumber"/>
                      </xsl:when>

                      <xsl:when test="b:SourceType='Art'">
                        <xsl:copy-of select ='$Title'/>
                        <xsl:call-template name='PrintList'>
                          <xsl:with-param name="list">
                            <Items>
                              <TextItem>
                                <xsl:value-of select ="$CityAndPublishers"/>
                              </TextItem>
                            </Items>
                          </xsl:with-param>
                        </xsl:call-template>
                        <xsl:value-of select ="$Comments"/>
                      </xsl:when>

                      <xsl:when test="b:SourceType='DocumentFromInternetSite'">
                        <xsl:copy-of select ='$TitleOfMonographParts'/>
                        <xsl:copy-of select ="$InternetSiteTitle"/>
                        <xsl:value-of select ="$VersionAndDayMonthYear"/>
                        <xsl:value-of select ="$DayMonthYearAccessed"/>
                        <xsl:value-of select ="$Comments"/>
                        <xsl:value-of select ="$URL"/>
                        <xsl:value-of select ="$StandardNumber"/>
                      </xsl:when>

                      <xsl:when test="b:SourceType='InternetSite'">
                        <xsl:value-of select ='$Title'/>
                        <xsl:copy-of select ="$InternetSiteTitle"/>
                        <xsl:value-of select ="$VersionAndDayMonthYear"/>
                        <xsl:value-of select ="$DayMonthYearAccessed"/>
                        <xsl:value-of select ="$Comments"/>
                        <xsl:value-of select ="$URL"/>
                        <xsl:value-of select ="$StandardNumber"/>
                      </xsl:when>

                      <xsl:when test="b:SourceType='Film'">
                        <xsl:copy-of select ='$Title'/>
                        <xsl:value-of select ="$MediumDot"/>
                        <xsl:value-of select ="$Writers"/>
                        <xsl:value-of select ="$Performers"/>
                        <xsl:value-of select ="$ProducerNames"/>
                        <xsl:call-template name='PrintList'>
                          <xsl:with-param name="list">
                            <Items>
                              <TextItem>
                                <xsl:value-of select ="$CityAndPublishers"/>
                              </TextItem>
                              <TextItem>
                                <xsl:value-of select ="$Year"/>
                              </TextItem>
                            </Items>
                          </xsl:with-param>
                        </xsl:call-template>
                        <xsl:value-of select ="$Comments"/>
                        <xsl:value-of select ="$StandardNumber"/>
                      </xsl:when>


                      <xsl:when test="b:SourceType='Interview'">
                        <xsl:choose>
                          <xsl:when test = "string-length(b:Broadcaster) = 0 and string-length(b:BroadcastTitle) = 0">
                            <xsl:call-template name = "ApplyItalicTitleNS">
                              <xsl:with-param name = "data">
                                <xsl:value-of select ='$Title'/>
                              </xsl:with-param>
                            </xsl:call-template>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select ='$Title'/>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:value-of select ="$Interviewers"/>
                        <xsl:value-of select ="$Editors"/>
                        <xsl:value-of select ="$Translators"/>
                        <xsl:value-of select ="$Compilers"/>
                        <xsl:if test="string-length($BroadcastTitle) > 0">
                          <xsl:call-template name = "ApplyItalicTitleNS">
                            <xsl:with-param name = "data">
                              <xsl:value-of select ="$BroadcastTitle"/>
                            </xsl:with-param>
                          </xsl:call-template>
                        </xsl:if>
                        <xsl:call-template name='PrintList'>
                          <xsl:with-param name="list">
                            <Items>
                              <TextItem>
                                <xsl:value-of select ="$CityAndPublishers"/>
                              </TextItem>
                              <TextItem>
                                <xsl:value-of select ="$DayMonthYear"/>
                              </TextItem>
                            </Items>
                          </xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name='PrintSpaceAndList'>
                          <xsl:with-param name="list">
                            <Items>
                              <TextItem>
                                <xsl:value-of select ="$Pages"/>
                              </TextItem>
                            </Items>
                          </xsl:with-param>
                        </xsl:call-template>
                        <xsl:value-of select ="$Comments"/>
                        <xsl:value-of select ="$StandardNumber"/>
                      </xsl:when>

                      <xsl:when test="b:SourceType='Patent'">
                        <xsl:copy-of select ='$Title'/>
                        <xsl:copy-of select ='$PatentNumber'/>
                        <xsl:value-of select ="$Editors"/>
                        <xsl:value-of select ="$Translators"/>
                        <xsl:call-template name='PrintList'>
                          <xsl:with-param name="list">
                            <Items>
                              <TextItem>
                                <xsl:value-of select ="$CityAndPublishers"/>
                              </TextItem>
                              <TextItem>
                                <xsl:value-of select ="$DayMonthYear"/>
                              </TextItem>
                            </Items>
                          </xsl:with-param>
                        </xsl:call-template>
                        <xsl:value-of select ="$Type"/>
                        <xsl:value-of select ="$Comments"/>
                      </xsl:when>

                      <xsl:when test="b:SourceType='ElectronicSource'">
                        <xsl:copy-of select ='$Title'/>
                        <xsl:copy-of select ='$Medium'/>
                        <xsl:value-of select ="$Editors"/>
                        <xsl:value-of select ="$ProducerNames"/>
                        <xsl:value-of select ="$Translators"/>
                        <xsl:call-template name='PrintList'>
                          <xsl:with-param name="list">
                            <Items>
                              <TextItem>
                                <xsl:value-of select ="$CityAndPublishers"/>
                              </TextItem>
                              <TextItem>
                                <xsl:value-of select ="$DayMonthYear"/>
                              </TextItem>
                            </Items>
                          </xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name='PrintSpaceAndList'>
                          <xsl:with-param name="list">
                            <Items>
                              <TextItem>
                                <xsl:value-of select ="$SepPublicationTitle"/>
                              </TextItem>
                              <TextItem>
                                <xsl:value-of select ="$VolumeChunk"/>
                              </TextItem>
                            </Items>
                          </xsl:with-param>
                        </xsl:call-template>
                        <xsl:value-of select ="$Comments"/>
                        <xsl:value-of select ="$StandardNumber"/>
                      </xsl:when>

                      <xsl:when test="b:SourceType='Case'">
                        <xsl:copy-of select ='$Title'/>
                        <xsl:copy-of select ='$CaseNumber'/>
                        <xsl:copy-of select ='$AbbreviatedCaseNumber'/>
                        <xsl:value-of select ="$Counsels"/>
                        <xsl:call-template name='PrintList'>
                          <xsl:with-param name="list">
                            <Items>
                              <TextItem>
                                <xsl:value-of select ="$CityAndPublishers"/>
                              </TextItem>
                              <TextItem>
                                <xsl:value-of select ="$DayMonthYear"/>
                              </TextItem>
                            </Items>
                          </xsl:with-param>
                        </xsl:call-template>
                        <xsl:value-of select ="$Reporters"/>
                        <xsl:value-of select ="$Comments"/>
                      </xsl:when>

                      <xsl:when test="b:SourceType='Misc'">
                        <xsl:copy-of select ='$TitleOfMonographParts'/>
                        <xsl:value-of select ="$Edition"/>
                        <xsl:call-template name="templ_prop_Space"/>
                        <xsl:value-of select ="$Editors"/>
                        <xsl:value-of select ="$Compilers"/>
                        <xsl:value-of select ="$Translators"/>
                        <xsl:call-template name = "ApplyItalicTitleNS">
                          <xsl:with-param name = "data">
                            <xsl:value-of select ='$PublicationTitle'/>
                          </xsl:with-param>
                        </xsl:call-template>
                        <xsl:value-of select ="$MediumDot"/>
                        <xsl:call-template name='PrintList'>
                          <xsl:with-param name="list">
                            <Items>
                              <TextItem>
                                <xsl:value-of select ="$CityAndPublishers"/>
                              </TextItem>
                              <TextItem>
                                <xsl:value-of select ="$DayMonthYear"/>
                              </TextItem>
                            </Items>
                          </xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name='PrintSpaceAndList'>
                          <xsl:with-param name="list">
                            <Items>
                              <TextItem>
                                <xsl:value-of select ="$Volume"/>
                              </TextItem>
                              <TextItem>
                                <xsl:value-of select ="$Issue"/>
                              </TextItem>
                              <TextItem>
                                <xsl:value-of select ="$Pages"/>
                              </TextItem>
                            </Items>
                          </xsl:with-param>
                        </xsl:call-template>
                        <xsl:value-of select ="$Comments"/>
                        <xsl:value-of select ="$StandardNumber"/>
                      </xsl:when>
                    </xsl:choose>

                    </xsl:element>

                  </td>
                </tr>
              </xsl:for-each>
            </table>
          </body>
        </html>
      </xsl:when>
    </xsl:choose>
  </xsl:template>


  <xsl:template name="sortedList">
    <xsl:param name="sourceRoot"/>

    <xsl:apply-templates select="msxsl:node-set($sourceRoot)/*">

      <xsl:sort select="b:RefOrder" data-type="number"/>
      <xsl:sort select="b:Author/b:Main/b:NameList/b:Person[1]/b:Last" />

      <xsl:sort select="b:Author/b:Main/b:NameList/b:Person[1]/b:First" />

      <xsl:sort select="b:Author/b:Main/b:NameList/b:Person[1]/b:Middle"/>

      <xsl:sort select="b:Title"/>
    </xsl:apply-templates>

  </xsl:template>


  <xsl:template match="*">
    <xsl:element name="{name()}" namespace="{namespace-uri()}">

      <xsl:for-each select="@*">
        <xsl:attribute name="{name()}" namespace="{namespace-uri()}">

          <xsl:value-of select="." />
        </xsl:attribute>
      </xsl:for-each>
      <xsl:apply-templates>

        <xsl:sort select="b:RefOrder" data-type="number"/>
        <xsl:sort select="b:Author/b:Main/b:NameList/b:Person[1]/b:Last" />
        <xsl:sort select="b:Author/b:Main/b:NameList/b:Person[1]/b:First" />
        <xsl:sort select="b:Author/b:Main/b:NameList/b:Person[1]/b:Middle"/>
        <xsl:sort select="b:Title"/>
      </xsl:apply-templates>
    </xsl:element>
  </xsl:template>

  <xsl:template match="text()">
    <xsl:value-of select="." />
  </xsl:template>

  <xsl:template name="maxAuthor">
    <xsl:choose>
      <xsl:when test="count(b:NameList/b:Person) > _MaxAuthor">
        <xsl:value-of select="_MaxAuthor"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="count(b:NameList/b:Person)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="formatLastFirst">
    <xsl:call-template name="formatNameCore">
      <xsl:with-param name="FML">
        <xsl:call-template name="templ_prop_ISO690_MainAuthors_FML"/>
      </xsl:with-param>
      <xsl:with-param name="FM">
        <xsl:call-template name="templ_prop_ISO690_MainAuthors_FM"/>
      </xsl:with-param>
      <xsl:with-param name="ML">
        <xsl:call-template name="templ_prop_ISO690_MainAuthors_ML"/>
      </xsl:with-param>
      <xsl:with-param name="FL">
        <xsl:call-template name="templ_prop_ISO690_MainAuthors_FL"/>
      </xsl:with-param>
      <xsl:with-param name="upperLast">yes</xsl:with-param>
      <xsl:with-param name="withDot">yes</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="formatFirstLast">
    <xsl:call-template name="formatNameCore">
      <xsl:with-param name="FML">
        <xsl:call-template name="templ_prop_ISO690_SecondaryAuthors_FML"/>
      </xsl:with-param>
      <xsl:with-param name="FM">
        <xsl:call-template name="templ_prop_ISO690_SecondaryAuthors_FM"/>
      </xsl:with-param>
      <xsl:with-param name="ML">
        <xsl:call-template name="templ_prop_ISO690_SecondaryAuthors_ML"/>
      </xsl:with-param>
      <xsl:with-param name="FL">
        <xsl:call-template name="templ_prop_ISO690_SecondaryAuthors_FL"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="formatPersonSeparator">
    <xsl:variable name="cMaxAuthor">
      <xsl:value-of select="count(../b:Person)"/>
    </xsl:variable>

    <xsl:variable name="cMaxAllow">

      <xsl:choose>
        <xsl:when test="$cMaxAuthor > ../b:_MaxAuthor and ../b:_MaxAuthor > 0">
          <xsl:value-of select="../b:_MaxAuthor"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$cMaxAuthor"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$cMaxAuthor > 3">
        <xsl:call-template name="templ_prop_AuthorsSeparator"/>
        <xsl:call-template name="templ_str_AndOthersUnCap"/>


      </xsl:when>
      <xsl:when test="$cMaxAllow - 1 > position()">

        <xsl:call-template name="templ_prop_AuthorsSeparator"/>


      </xsl:when>
      <xsl:when test="position() = $cMaxAuthor - 1">
        <xsl:variable name="noAndBeforeLastAuthor">
          <xsl:call-template name="templ_prop_NoAndBeforeLastAuthor"/>
        </xsl:variable>

        <xsl:if test="$noAndBeforeLastAuthor != 'yes'">
          <xsl:call-template name="templ_prop_Space"/>
          <xsl:call-template name="templ_str_AndUnCap"/>
          <xsl:call-template name="templ_prop_Space"/>
        </xsl:if>
        <xsl:if test="$noAndBeforeLastAuthor = 'yes'">
          <xsl:call-template name="templ_prop_AuthorsSeparator"/>
        </xsl:if>


      </xsl:when>
    </xsl:choose>
  </xsl:template>


  <xsl:template name="formatPersons">
    <xsl:variable name="cMaxAllow">
      <xsl:call-template name="maxAuthor"/>
    </xsl:variable>

    <xsl:variable name ="cIsEtAl">
      <xsl:choose>
        <xsl:when test ="count(b:NameList/b:Person[4]) >0">
          <xsl:value-of select="1"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select = "0"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="cEtAlPosition">
      <xsl:value-of select ="1"/>
    </xsl:variable>

    <xsl:if test="string-length(b:Corporate)=0">
      <xsl:for-each select="b:NameList/b:Person">
        <xsl:variable name="cMaxAuthor">
          <xsl:value-of select="count(../b:NameList/b:Person)"/>
        </xsl:variable>

        <xsl:if test="($cIsEtAl = '0' and $cMaxAllow >= position()) or ($cIsEtAl = '1' and not (position()>$cEtAlPosition)) ">
          <xsl:choose>
            <xsl:when test="local-name(../..)='Main'">
              <xsl:call-template name="formatLastFirst"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="formatFirstLast"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:call-template name="formatPersonSeparator"/>
        </xsl:if>
      </xsl:for-each>
    </xsl:if>
    <xsl:if test="string-length(b:Corporate)>0">
      <xsl:value-of select="b:Corporate"/>
    </xsl:if>
  </xsl:template>



  <xsl:template name="formatMain">

    <xsl:if test="string-length(b:Author/b:Main/b:Corporate) > 0 or count(b:Author/b:Main/b:NameList/b:Person) > 0 ">

      <xsl:for-each select="b:Author/b:Main">
        <xsl:call-template name="formatPersons"/>
      </xsl:for-each>

      <xsl:variable name="temp">
        <xsl:for-each select="b:Author/b:Main">
          <xsl:call-template name="formatPersons"/>
        </xsl:for-each>
      </xsl:variable>

      <xsl:variable name="type">
        <xsl:call-template name="GetMainAuthorTitle">
          <xsl:with-param name="sourceType">
            <xsl:value-of select="b:SourceType"/>
          </xsl:with-param>
          <xsl:with-param name="authorType">
            <xsl:value-of select="b:MainAuthorType"/>
          </xsl:with-param>
          <xsl:with-param name="cAuthors">
            <xsl:value-of select="count(b:Author/b:Main/b:NameList/b:Person)"/>
          </xsl:with-param>
          <xsl:with-param name="isOrganisation">
            <xsl:value-of select="string-length(b:Author/b:Main/b:Corporate) > 0"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="string-length($type) > 0">
        <xsl:call-template name="templ_prop_ListSeparator"/>
        <xsl:call-template name="templ_prop_ISO690_GeneralOpen"/>
        <xsl:value-of select="$type"/>
        <xsl:call-template name="templ_prop_ISO690_GeneralClose"/>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template name="formatAuthor">
    <xsl:if test="string-length(b:Author/b:Author)>0">


      <xsl:for-each select="b:Author/b:Author">
        <xsl:call-template name="formatPersons"/>
      </xsl:for-each>

      <xsl:variable name="temp">
        <xsl:for-each select="b:Author/b:Author">
          <xsl:call-template name="formatPersons"/>
        </xsl:for-each>
      </xsl:variable>

      <xsl:call-template name="need_Dot">
        <xsl:with-param name="field" select="$temp"/>
      </xsl:call-template>




    </xsl:if>
  </xsl:template>

  <xsl:template name="formatEditor">
    <xsl:if test="string-length(b:Author/b:Editor)>0">
      <xsl:call-template name="templ_prop_ISO690_GeneralOpen"/>
      <xsl:call-template name="templ_str_EditorShortUnCap"/>
      <xsl:call-template name="templ_prop_ISO690_GeneralClose"/>
      <xsl:call-template name="templ_prop_Space"/>


      <xsl:for-each select="b:Author/b:Editor">
        <xsl:call-template name="formatPersons"/>
      </xsl:for-each>

      <xsl:variable name="temp">
        <xsl:for-each select="b:Author/b:Editor">
          <xsl:call-template name="formatPersons"/>
        </xsl:for-each>
      </xsl:variable>

      <xsl:call-template name="need_Dot">
        <xsl:with-param name="field" select="$temp"/>
      </xsl:call-template>




    </xsl:if>
  </xsl:template>

  <xsl:template name="formatTranslator">
    <xsl:if test="string-length(b:Author/b:Translator)>0">
      <xsl:call-template name="templ_prop_ISO690_GeneralOpen"/>
      <xsl:call-template name="templ_str_TranslatorShortUnCap"/>
      <xsl:call-template name="templ_prop_ISO690_GeneralClose"/>
      <xsl:call-template name="templ_prop_Space"/>


      <xsl:for-each select="b:Author/b:Translator">
        <xsl:call-template name="formatPersons"/>
      </xsl:for-each>

      <xsl:variable name="temp">
        <xsl:for-each select="b:Author/b:Translator">
          <xsl:call-template name="formatPersons"/>
        </xsl:for-each>
      </xsl:variable>

      <xsl:call-template name="need_Dot">
        <xsl:with-param name="field" select="$temp"/>
      </xsl:call-template>




    </xsl:if>
  </xsl:template>

  <xsl:template name="formatArtist">
    <xsl:if test="string-length(b:Author/b:Artist)>0">
      <xsl:call-template name="templ_prop_ISO690_GeneralOpen"/>
      <xsl:call-template name="templ_str_ArtistShortUnCap"/>
      <xsl:call-template name="templ_prop_ISO690_GeneralClose"/>
      <xsl:call-template name="templ_prop_Space"/>


      <xsl:for-each select="b:Author/b:Artist">
        <xsl:call-template name="formatPersons"/>
      </xsl:for-each>

      <xsl:variable name="temp">
        <xsl:for-each select="b:Author/b:Artist">
          <xsl:call-template name="formatPersons"/>
        </xsl:for-each>
      </xsl:variable>

      <xsl:call-template name="need_Dot">
        <xsl:with-param name="field" select="$temp"/>
      </xsl:call-template>




    </xsl:if>
  </xsl:template>

  <xsl:template name="formatBookAuthor">
    <xsl:if test="string-length(b:Author/b:BookAuthor)>0">
      <xsl:call-template name="templ_prop_ISO690_GeneralOpen"/>
      <xsl:call-template name="templ_str_BookAuthorShortUnCap"/>
      <xsl:call-template name="templ_prop_ISO690_GeneralClose"/>
      <xsl:call-template name="templ_prop_Space"/>

      <xsl:for-each select="b:Author/b:BookAuthor">
        <xsl:call-template name="formatPersons"/>
      </xsl:for-each>

      <xsl:variable name="temp">
        <xsl:for-each select="b:Author/b:BookAuthor">
          <xsl:call-template name="formatPersons"/>
        </xsl:for-each>
      </xsl:variable>

      <xsl:call-template name="need_Dot">
        <xsl:with-param name="field" select="$temp"/>
      </xsl:call-template>




    </xsl:if>
  </xsl:template>

  <xsl:template name="formatCompiler">
    <xsl:if test="string-length(b:Author/b:Compiler)>0">
      <xsl:call-template name="templ_prop_ISO690_GeneralOpen"/>
      <xsl:call-template name="templ_str_CompilerShortUnCapIso"/>
      <xsl:call-template name="templ_prop_ISO690_GeneralClose"/>
      <xsl:call-template name="templ_prop_Space"/>


      <xsl:for-each select="b:Author/b:Compiler">
        <xsl:call-template name="formatPersons"/>
      </xsl:for-each>

      <xsl:variable name="temp">
        <xsl:for-each select="b:Author/b:Compiler">
          <xsl:call-template name="formatPersons"/>
        </xsl:for-each>
      </xsl:variable>

      <xsl:call-template name="need_Dot">
        <xsl:with-param name="field" select="$temp"/>
      </xsl:call-template>




    </xsl:if>
  </xsl:template>


  <xsl:template name="formatComposer">
    <xsl:if test="string-length(b:Author/b:Composer)>0">
      <xsl:call-template name="templ_prop_ISO690_GeneralOpen"/>
      <xsl:call-template name="templ_str_ComposerShortUnCapIso"/>
      <xsl:call-template name="templ_prop_ISO690_GeneralClose"/>
      <xsl:call-template name="templ_prop_Space"/>


      <xsl:for-each select="b:Author/b:Composer">
        <xsl:call-template name="formatPersons"/>
      </xsl:for-each>

      <xsl:variable name="temp">
        <xsl:for-each select="b:Author/b:Composer">
          <xsl:call-template name="formatPersons"/>
        </xsl:for-each>
      </xsl:variable>

      <xsl:call-template name="need_Dot">
        <xsl:with-param name="field" select="$temp"/>
      </xsl:call-template>




    </xsl:if>
  </xsl:template>

  <xsl:template name="formatConductor">
    <xsl:if test="string-length(b:Author/b:Conductor)>0">
      <xsl:call-template name="templ_prop_ISO690_GeneralOpen"/>
      <xsl:call-template name="templ_str_ConductorShortUnCap"/>
      <xsl:call-template name="templ_prop_ISO690_GeneralClose"/>
      <xsl:call-template name="templ_prop_Space"/>


      <xsl:for-each select="b:Author/b:Conductor">
        <xsl:call-template name="formatPersons"/>
      </xsl:for-each>

      <xsl:variable name="temp">
        <xsl:for-each select="b:Author/b:Conductor">
          <xsl:call-template name="formatPersons"/>
        </xsl:for-each>
      </xsl:variable>

      <xsl:call-template name="need_Dot">
        <xsl:with-param name="field" select="$temp"/>
      </xsl:call-template>




    </xsl:if>
  </xsl:template>

  <xsl:template name="formatCounsel">
    <xsl:if test="string-length(b:Author/b:Counsel)>0">
      <xsl:call-template name="templ_prop_ISO690_GeneralOpen"/>
      <xsl:call-template name="templ_str_CounselShortUnCap"/>
      <xsl:call-template name="templ_prop_ISO690_GeneralClose"/>
      <xsl:call-template name="templ_prop_Space"/>


      <xsl:for-each select="b:Author/b:Counsel">
        <xsl:call-template name="formatPersons"/>
      </xsl:for-each>

      <xsl:variable name="temp">
        <xsl:for-each select="b:Author/b:Counsel">
          <xsl:call-template name="formatPersons"/>
        </xsl:for-each>
      </xsl:variable>

      <xsl:call-template name="need_Dot">
        <xsl:with-param name="field" select="$temp"/>
      </xsl:call-template>




    </xsl:if>
  </xsl:template>

  <xsl:template name="formatDirector">
    <xsl:if test="string-length(b:Author/b:Director)>0">
      <xsl:call-template name="templ_prop_ISO690_GeneralOpen"/>
      <xsl:call-template name="templ_str_DirectorShortUnCap"/>
      <xsl:call-template name="templ_prop_ISO690_GeneralClose"/>
      <xsl:call-template name="templ_prop_Space"/>


      <xsl:for-each select="b:Author/b:Director">
        <xsl:call-template name="formatPersons"/>
      </xsl:for-each>

      <xsl:variable name="temp">
        <xsl:for-each select="b:Author/b:Director">
          <xsl:call-template name="formatPersons"/>
        </xsl:for-each>
      </xsl:variable>

      <xsl:call-template name="need_Dot">
        <xsl:with-param name="field" select="$temp"/>
      </xsl:call-template>




    </xsl:if>
  </xsl:template>


  <xsl:template name="formatInterviewee">
    <xsl:if test="string-length(b:Author/b:Interviewee)>0">
      <xsl:call-template name="templ_prop_ISO690_GeneralOpen"/>
      <xsl:call-template name="templ_str_IntervieweeShortUnCap"/>
      <xsl:call-template name="templ_prop_ISO690_GeneralClose"/>
      <xsl:call-template name="templ_prop_Space"/>


      <xsl:for-each select="b:Author/b:Interviewee">
        <xsl:call-template name="formatPersons"/>
      </xsl:for-each>

      <xsl:variable name="temp">
        <xsl:for-each select="b:Author/b:Interviewee">
          <xsl:call-template name="formatPersons"/>
        </xsl:for-each>
      </xsl:variable>

      <xsl:call-template name="need_Dot">
        <xsl:with-param name="field" select="$temp"/>
      </xsl:call-template>




    </xsl:if>
  </xsl:template>

  <xsl:template name="formatInterviewer">
    <xsl:if test="string-length(b:Author/b:Interviewee)>0">
      <xsl:call-template name="templ_prop_ISO690_GeneralOpen"/>
      <xsl:call-template name="templ_str_IntervieweeShortUnCap"/>

      <xsl:call-template name="templ_prop_ISO690_GeneralClose"/>
      <xsl:call-template name="templ_prop_Space"/>


      <xsl:for-each select="b:Author/b:Interviewer">
        <xsl:call-template name="formatPersons"/>
      </xsl:for-each>

      <xsl:variable name="temp">
        <xsl:for-each select="b:Author/b:Interviewer">
          <xsl:call-template name="formatPersons"/>
        </xsl:for-each>
      </xsl:variable>

      <xsl:call-template name="need_Dot">
        <xsl:with-param name="field" select="$temp"/>
      </xsl:call-template>




    </xsl:if>
  </xsl:template>

  <xsl:template name="formatInventor">
    <xsl:if test="string-length(b:Author/b:Inventor)>0">
      <xsl:call-template name="templ_prop_ISO690_GeneralOpen"/>
      <xsl:call-template name="templ_str_InventorShortUnCap"/>
      <xsl:call-template name="templ_prop_ISO690_GeneralClose"/>
      <xsl:call-template name="templ_prop_Space"/>


      <xsl:for-each select="b:Author/b:Inventor">
        <xsl:call-template name="formatPersons"/>
      </xsl:for-each>

      <xsl:variable name="temp">
        <xsl:for-each select="b:Author/b:Inventor">
          <xsl:call-template name="formatPersons"/>
        </xsl:for-each>
      </xsl:variable>

      <xsl:call-template name="need_Dot">
        <xsl:with-param name="field" select="$temp"/>
      </xsl:call-template>




    </xsl:if>
  </xsl:template>

  <xsl:template name="formatPerformer">
    <xsl:if test="string-length(b:Author/b:Performer)>0">
      <xsl:call-template name="templ_prop_ISO690_GeneralOpen"/>
      <xsl:call-template name="templ_str_PerformerShortUnCap"/>
      <xsl:call-template name="templ_prop_ISO690_GeneralClose"/>
      <xsl:call-template name="templ_prop_Space"/>


      <xsl:for-each select="b:Author/b:Performer">
        <xsl:call-template name="formatPersons"/>
      </xsl:for-each>

      <xsl:variable name="temp">
        <xsl:for-each select="b:Author/b:Performer">
          <xsl:call-template name="formatPersons"/>
        </xsl:for-each>
      </xsl:variable>

      <xsl:call-template name="need_Dot">
        <xsl:with-param name="field" select="$temp"/>
      </xsl:call-template>




    </xsl:if>
  </xsl:template>

  <xsl:template name="formatProducerName">
    <xsl:if test="string-length(b:Author/b:ProducerName)>0">
      <xsl:call-template name="templ_prop_ISO690_GeneralOpen"/>
      <xsl:call-template name="templ_str_ProducerShortUnCap"/>
      <xsl:call-template name="templ_prop_ISO690_GeneralClose"/>
      <xsl:call-template name="templ_prop_Space"/>


      <xsl:for-each select="b:Author/b:ProducerName">
        <xsl:call-template name="formatPersons"/>
      </xsl:for-each>

      <xsl:variable name="temp">
        <xsl:for-each select="b:Author/b:ProducerName">
          <xsl:call-template name="formatPersons"/>
        </xsl:for-each>
      </xsl:variable>

      <xsl:call-template name="need_Dot">
        <xsl:with-param name="field" select="$temp"/>
      </xsl:call-template>




    </xsl:if>
  </xsl:template>

  <xsl:template name="formatWriter">
    <xsl:if test="string-length(b:Author/b:Writer)>0">
      <xsl:call-template name="templ_prop_ISO690_GeneralOpen"/>
      <xsl:call-template name="templ_str_WriterShortUnCap"/>
      <xsl:call-template name="templ_prop_ISO690_GeneralClose"/>
      <xsl:call-template name="templ_prop_Space"/>


      <xsl:for-each select="b:Author/b:Writer">
        <xsl:call-template name="formatPersons"/>
      </xsl:for-each>

      <xsl:variable name="temp">
        <xsl:for-each select="b:Author/b:Writer">
          <xsl:call-template name="formatPersons"/>
        </xsl:for-each>
      </xsl:variable>

      <xsl:call-template name="need_Dot">
        <xsl:with-param name="field" select="$temp"/>
      </xsl:call-template>




    </xsl:if>
  </xsl:template>

  <xsl:template name="formatLocation">


    <xsl:variable name = "nothing">
      <xsl:choose>

        <xsl:when test = "  b:SourceType='Book' or
									b:SourceType='BookSection' or
									b:SourceType='JournalArticle' or
									b:SourceType='ArticleInAPeriodical' or
									b:SourceType='ConferenceProceedings' or
									b:SourceType='Report' or
									b:SourceType='SoundRecording' or
									b:SourceType='Performance' or
									b:SourceType='Art' or
									b:SourceType='Interview' or
									b:SourceType='ElectronicSource' or
									b:SourceType='Case' or
									b:SourceType='Report' or
									b:SourceType='Misc'">
          <xsl:choose>
            <xsl:when test ="string-length(b:City)>0 or (string-length(b:Theater)>0 and b:SourceType='Performance')">
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test ="(string-length(b:Publisher)>0)and b:SourceType='Report'">
                </xsl:when>
                <xsl:when test ="string-length(b:Institution)>0 and b:SourceType='Art'">
                </xsl:when>
                <xsl:when test ="string-length(b:ProductionCompany)>0 and b:SourceType='SoundRecording'">
                </xsl:when>
                <xsl:when test ="string-length(b:ProductionCompany)>0 and b:SourceType='Performance'">
                </xsl:when>
                <xsl:when test ="(string-length(b:ProductionCompany)>0 or string-length(b:Publisher)>0) and b:SourceType='ElectronicSource'">
                </xsl:when>
                <xsl:when test ="string-length(b:Court)>0 and b:SourceType='Case'">
                </xsl:when>
                <xsl:when test ="(string-length(b:Publisher)>0 or (string-length(b:Broadcaster)>0 and b:SourceType='Interview')) and
												(	b:SourceType='Book' or
													b:SourceType='BookSection' or
													b:SourceType='JournalArticle' or
													b:SourceType='ArticleInAPeriodical' or
													b:SourceType='ConferenceProceedings' or
													b:SourceType='Interview' or
													b:SourceType='Report' or
													b:SourceType='Misc' or
													b:SourceType='Art'
													)">
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>1</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>

        </xsl:when>
      </xsl:choose>
    </xsl:variable>

    <xsl:if test = "$nothing != '1'">
      <xsl:choose>

        <xsl:when test = "  b:SourceType='Book' or
									b:SourceType='BookSection' or
									b:SourceType='JournalArticle' or
									b:SourceType='ArticleInAPeriodical' or
									b:SourceType='ConferenceProceedings' or
									b:SourceType='Report' or
									b:SourceType='SoundRecording' or
									b:SourceType='Performance' or
									b:SourceType='Art' or
									b:SourceType='Interview' or
									b:SourceType='ElectronicSource' or
									b:SourceType='Case' or
									b:SourceType='Report' or
									b:SourceType='Misc'">

          <xsl:if test="b:SourceType='Art'">
            <xsl:value-of select="b:Institution"/>
          </xsl:if>


          <xsl:choose>
            <xsl:when test ="string-length(b:City)>0 or (string-length(b:Theater)>0 and b:SourceType='Performance')">
              <xsl:if test="b:SourceType='Performance'">
                <xsl:value-of select ='b:Theater'/>
                <xsl:if test ='string-length(b:Theater)>0 and string-length(b:City)>0'>
                  <xsl:call-template name="templ_prop_ListSeparator"/>
                  <xsl:call-template name="templ_prop_Space"/>


                </xsl:if>
              </xsl:if>
              <xsl:if test="b:SourceType='ElectronicSource'">
                <xsl:value-of select ='b:Edition'/>
                <xsl:if test ='string-length(b:Edition)>0 and string-length(b:City)>0'>
                  <xsl:call-template name="templ_prop_ListSeparator"/>
                  <xsl:call-template name="templ_prop_Space"/>


                </xsl:if>
              </xsl:if>
              <xsl:if test="b:SourceType='Interview'">
                <xsl:value-of select ='b:Station'/>
                <xsl:if test ='string-length(b:Station)>0 and string-length(b:City)>0'>
                  <xsl:call-template name="templ_prop_ListSeparator"/>
                  <xsl:call-template name="templ_prop_Space"/>


                </xsl:if>
              </xsl:if>
              <xsl:if test="b:SourceType='Art' and string-length(b:Institution)>0 and string-length(b:City)>0">
                <xsl:call-template name="templ_prop_ListSeparator"/>
              </xsl:if>
              <xsl:value-of select="b:City"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:if test="b:SourceType='Art' and string-length(b:Institution)>0">
                <xsl:call-template name="templ_prop_ListSeparator"/>
              </xsl:if>
              <xsl:call-template name="templ_str_SineLocoShort"/>


            </xsl:otherwise>
          </xsl:choose>

          <xsl:if test ="b:SourceType='Performance' or b:SourceType='Art' or b:SourceType='Patent' or b:SourceType='ElectronicSource' or b:SourceType='Case' or b:SourceType='Misc'">
            <xsl:variable name="tempFirst">
              <xsl:call-template name="handleSpaces">
                <xsl:with-param name="field" select="b:StateProvince"/>
              </xsl:call-template>
            </xsl:variable>

            <xsl:variable name="tempSecond">
              <xsl:call-template name="handleSpaces">
                <xsl:with-param name="field" select="b:CountryRegion"/>
              </xsl:call-template>
            </xsl:variable>

            <xsl:if test="string-length($tempFirst)>0 or string-length($tempSecond)>0">
              <xsl:call-template name="templ_prop_ListSeparator"/>
            </xsl:if>

            <xsl:if test="string-length($tempFirst)>0">
              <xsl:value-of select="$tempFirst"/>
            </xsl:if>

            <xsl:if test="string-length($tempFirst)>0 and string-length($tempSecond)>0">
              <xsl:call-template name="templ_prop_ListSeparator"/>
            </xsl:if>

            <xsl:if test="string-length($tempSecond)>0">
              <xsl:value-of select="$tempSecond"/>
            </xsl:if>
          </xsl:if>


          <xsl:variable name="after">
            <xsl:choose>

              <xsl:when test ="(string-length(b:Publisher)>0)and b:SourceType='Report'">
                <xsl:value-of select="b:Publisher"/>
              </xsl:when>
              <xsl:when test ="string-length(b:ProductionCompany)>0 and b:SourceType='SoundRecording'">
                <xsl:value-of select="b:ProductionCompany"/>
              </xsl:when>
              <xsl:when test ="string-length(b:ProductionCompany)>0 and b:SourceType='Performance'">
                <xsl:value-of select="b:ProductionCompany"/>
              </xsl:when>
              <xsl:when test ="(string-length(b:ProductionCompany)>0 or string-length(b:Publisher)>0) and b:SourceType='ElectronicSource'">
                <xsl:value-of select="b:Publisher"/>
                <xsl:if test ="string-length(b:Publisher)>0 and string-length(b:ProductionCompany)>0">
                  <xsl:call-template name="templ_prop_ListSeparator"/>


                </xsl:if>
                <xsl:value-of select="b:ProductionCompany"/>
              </xsl:when>
              <xsl:when test ="string-length(b:Court)>0 and b:SourceType='Case'">
                <xsl:value-of select="b:Court"/>
              </xsl:when>
              <xsl:when test ="b:SourceType='Art' and (string-length(b:Publisher)>0 or string-length(b:Year)>0)">

                <xsl:if test ="string-length(b:Publisher)>0">
                  <xsl:value-of select="b:Publisher"/>
                </xsl:if>

                <xsl:if test ="string-length(b:Publisher)>0 and string-length(b:Year)>0">
                  <xsl:call-template name="templ_prop_ListSeparator"/>
                </xsl:if>

                <xsl:if test ="string-length(b:Year)>0">
                  <xsl:value-of select="b:Year"/>
                </xsl:if>

              </xsl:when>
              <xsl:when test ="(string-length(b:Publisher)>0 or (string-length(b:Broadcaster)>0 and b:SourceType='Interview')) and
										  (	b:SourceType='Book' or
											  b:SourceType='BookSection' or
											  b:SourceType='JournalArticle' or
											  b:SourceType='ArticleInAPeriodical' or
											  b:SourceType='ConferenceProceedings' or
											  b:SourceType='Interview' or
											  b:SourceType='Report' or
											  b:SourceType='Misc'
											  )">
                <xsl:if test ="string-length(b:Broadcaster)>0 and b:SourceType='Interview'">
                  <xsl:value-of select="b:Broadcaster"/>
                </xsl:if>
                <xsl:value-of select="b:Publisher"/>
              </xsl:when>
              <xsl:when test ="string-length(b:Broadcaster)=0 and b:SourceType='Interview'">
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="templ_str_SineNomineShort"/>


              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>

          <xsl:if test="string-length(normalize-space($after))>0">

            <xsl:call-template name="templ_prop_NonBreakingSpace"/>
            <xsl:call-template name="templ_prop_EnumSeparator"/>
            <xsl:value-of select="$after"/>


          </xsl:if>
        </xsl:when>

        <xsl:when test ="b:SourceType='Film'">
          <xsl:value-of select ="b:ProductionCompany"/>
          <xsl:if test ="string-length(b:ProductionCompany)>0 and string-length(b:Distributor)>0">
            <xsl:call-template name="templ_prop_GroupSeparator"/>


          </xsl:if>
          <xsl:value-of select ="b:Distributor"/>
          <xsl:if test ="string-length(b:ProductionCompany)>0 or string-length(b:Distributor)>0">
          </xsl:if>
        </xsl:when>

        <xsl:when test ="b:SourceType='Patent'">
          <xsl:if test ="string-length(b:CountryRegion)>0">
            <xsl:value-of select ="b:CountryRegion"/>
          </xsl:if>
        </xsl:when>


      </xsl:choose>

    </xsl:if>
  </xsl:template>

  <xsl:template name="formatDayMonthYear">
    <xsl:if test ='string-length(b:Day) >0 or string-length(b:Month) >0 or string-length(b:Year) >0'>
      <xsl:call-template name="formatDateCore">
        <xsl:with-param name="day">
          <xsl:call-template name="handleSpaces">
            <xsl:with-param name="field" select="b:Day"/>
          </xsl:call-template>
        </xsl:with-param>
        <xsl:with-param name="month">
          <xsl:call-template name="handleSpaces">
            <xsl:with-param name="field" select="b:Month"/>
          </xsl:call-template>
        </xsl:with-param>
        <xsl:with-param name="year">
          <xsl:call-template name="handleSpaces">
            <xsl:with-param name="field" select="b:Year"/>
          </xsl:call-template>
        </xsl:with-param>

        <xsl:with-param name="DMY">
          <xsl:call-template name="templ_prop_ISO690_Date_DMY"/>
        </xsl:with-param>
        <xsl:with-param name="DM">
          <xsl:call-template name="templ_prop_ISO690_Date_DM"/>
        </xsl:with-param>
        <xsl:with-param name="MY">
          <xsl:call-template name="templ_prop_ISO690_Date_MY"/>
        </xsl:with-param>
        <xsl:with-param name="DY">
          <xsl:call-template name="templ_prop_ISO690_Date_DY"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name ="formatDayMonthYearAccessed">
    <xsl:if test ='string-length(b:DayAccessed) >0 or string-length(b:DayAccessed) >0 or string-length(b:DayAccessed) >0'>
      <xsl:call-template name="templ_prop_ISO690_GeneralOpen"/>
      <xsl:variable name="date">
        <xsl:call-template name="formatDateCore">
          <xsl:with-param name="day">
            <xsl:call-template name="handleSpaces">
              <xsl:with-param name="field" select="b:DayAccessed"/>
            </xsl:call-template>
          </xsl:with-param>
          <xsl:with-param name="month">
            <xsl:call-template name="handleSpaces">
              <xsl:with-param name="field" select="b:MonthAccessed"/>
            </xsl:call-template>
          </xsl:with-param>
          <xsl:with-param name="year">
            <xsl:call-template name="handleSpaces">
              <xsl:with-param name="field" select="b:YearAccessed"/>
            </xsl:call-template>
          </xsl:with-param>

          <xsl:with-param name="DMY">
            <xsl:call-template name="templ_prop_ISO690_DateAccessed_DMY"/>
          </xsl:with-param>
          <xsl:with-param name="DM">
            <xsl:call-template name="templ_prop_ISO690_DateAccessed_DM"/>
          </xsl:with-param>
          <xsl:with-param name="MY">
            <xsl:call-template name="templ_prop_ISO690_DateAccessed_MY"/>
          </xsl:with-param>
          <xsl:with-param name="DY">
            <xsl:call-template name="templ_prop_ISO690_DateAccessed_DY"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="cited">
        <xsl:call-template name="templ_str_CitedCap"/>
      </xsl:variable>
      <xsl:call-template name="StringFormatDot">
        <xsl:with-param name="format" select="$cited"/>
        <xsl:with-param name="parameters">
          <t:params>
            <t:param>
              <xsl:value-of select="$date"/>
            </t:param>
          </t:params>
        </xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="templ_prop_ISO690_GeneralClose"/>
    </xsl:if>
  </xsl:template>


  <xsl:template name="populateMain">
    <xsl:param name="Type"/>

    <xsl:element name="{$Type}">

      <xsl:for-each select="/*[$Type]/b:Source">

        <xsl:variable name="MostImportantAuthorLocalName">

          <xsl:call-template name="MainContributors"/>
        </xsl:variable>
        <xsl:element name="{'b:Source'}">
          <b:MainAuthorType>
            <xsl:value-of select="$MostImportantAuthorLocalName"/>
          </b:MainAuthorType>

          <xsl:if test="$Type='b:Citation'">

            <b:Title>

              <xsl:if test="string-length(b:Title)>0">
                <xsl:value-of select="b:Title"/>
              </xsl:if>
            </b:Title>
          </xsl:if>
          <b:Author>

            <b:Main>
              <xsl:if test="string-length(./b:Author/*[local-name()=$MostImportantAuthorLocalName]/b:Corporate)=0">
                <b:NameList>
                  <xsl:for-each select="./b:Author/*[local-name()=$MostImportantAuthorLocalName]/b:NameList/b:Person">
                    <b:Person>

                      <b:Last>
                        <xsl:value-of select="./b:Last"/>
                      </b:Last>
                      <b:First>
                        <xsl:value-of select="./b:First"/>
                      </b:First>
                      <b:Middle>
                        <xsl:value-of select="./b:Middle"/>
                      </b:Middle>
                    </b:Person>
                  </xsl:for-each>
                </b:NameList>
              </xsl:if>
              <xsl:if test="string-length(./b:Author/*[local-name()=$MostImportantAuthorLocalName]/b:Corporate)>0">
                <b:Corporate>
                  <xsl:value-of select="./b:Author/*[local-name()=$MostImportantAuthorLocalName]/b:Corporate"/>
                </b:Corporate>
              </xsl:if>
            </b:Main>
            <xsl:for-each select="./b:Author/*">

              <xsl:if test="name()!='b:Main' and not(../../b:SourceType = 'Interview' and (string-length(../../b:Broadcaster) > 0 or string-length(../../b:BroadcastTitle) > 0) and (name() = 'b:Editor' or name() = 'b:Translator' or name() = 'b:Compiler'))">
                <xsl:element name="{name()}" namespace="{namespace-uri()}">
                  <xsl:call-template name="copyNameNodes"/>

                </xsl:element>
              </xsl:if>
            </xsl:for-each>
          </b:Author>
          <xsl:for-each select="*">

            <xsl:if test="name()!='b:Author' and not(name()='b:Title' and $Type='b:Citation') and not(../b:SourceType = 'Interview' and string-length(../b:Broadcaster) = 0 and string-length(../b:BroadcastTitle) = 0 and (name() = 'b:Station'))  and not(../b:SourceType = 'Interview' and (string-length(../b:Broadcaster) > 0 or string-length(../b:BroadcastTitle) > 0) and (name() = 'b:Publisher'))">
              <xsl:element name="{name()}" namespace="{namespace-uri()}">
                <xsl:call-template name="copyNodes"/>

              </xsl:element>
            </xsl:if>
          </xsl:for-each>
        </xsl:element>
      </xsl:for-each>
      <xsl:for-each select="/*[$Type]/*">

        <xsl:if test="local-name()!='Source'">
          <xsl:call-template name="copyTrees"/>
        </xsl:if>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>


  <xsl:template name="copyNameNodes">
    <xsl:if test="string-length(b:Corporate)=0">
      <b:NameList>
        <xsl:for-each select="b:NameList/b:Person">

          <b:Person>

            <xsl:if test="string-length(./b:Last)>0">

              <b:Last>
                <xsl:value-of select="./b:Last"/>
              </b:Last>
            </xsl:if>
            <xsl:if test="string-length(./b:First)>0">
              <b:First>
                <xsl:value-of select="./b:First"/>
              </b:First>
            </xsl:if>
            <xsl:if test="string-length(./b:Middle)>0">
              <b:Middle>
                <xsl:value-of select="./b:Middle"/>
              </b:Middle>
            </xsl:if>
          </b:Person>
        </xsl:for-each>
      </b:NameList>
    </xsl:if>
    <xsl:if test="string-length(b:Corporate)>0">
      <b:Corporate>
        <xsl:value-of select="b:Corporate"/>
      </b:Corporate>
    </xsl:if>
  </xsl:template>


  <xsl:template name="copyNodes">
    <xsl:value-of select="."/>
  </xsl:template>


  <xsl:template name="copyTrees">
    <xsl:copy-of select ='.'/>
  </xsl:template>





  <xsl:template name="MainContributors">
    <xsl:param name="SourceRoot"/>
    <xsl:choose>
      <xsl:when test="./b:SourceType='Book'">
        <xsl:choose>
          <xsl:when test="string-length(./b:Author/b:Author)>0">Author</xsl:when>
          <xsl:when test="string-length(./b:Author/b:Editor)>0">Editor</xsl:when>
          <xsl:when test="string-length(./b:Author/b:Translator)>0">Translator</xsl:when>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="./b:SourceType='BookSection'">
        <xsl:choose>
          <xsl:when test="string-length(./b:Author/b:Author)>0">Author</xsl:when>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="./b:SourceType='JournalArticle'">
        <xsl:choose>
          <xsl:when test="string-length(./b:Author/b:Author)>0">Author</xsl:when>
          <xsl:when test="string-length(./b:Author/b:Editor)>0">Editor</xsl:when>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="./b:SourceType='ArticleInAPeriodical'">
        <xsl:choose>
          <xsl:when test="string-length(./b:Author/b:Author)>0">Author</xsl:when>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="./b:SourceType='ConferenceProceedings'">
        <xsl:choose>
          <xsl:when test="string-length(./b:Author/b:Author)>0">Author</xsl:when>
          <xsl:when test="string-length(./b:Author/b:Editor)>0">Editor</xsl:when>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="./b:SourceType='Report'">
        <xsl:choose>
          <xsl:when test="string-length(./b:Author/b:Author)>0">Author</xsl:when>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="./b:SourceType='SoundRecording'">
        <xsl:choose>
          <xsl:when test="string-length(./b:Author/b:Artist)>0">Artist</xsl:when>
          <xsl:when test="string-length(./b:Author/b:Performer)>0">Performer</xsl:when>
          <xsl:when test="string-length(./b:Author/b:Composer)>0">Composer</xsl:when>
          <xsl:when test="string-length(./b:Author/b:Conductor)>0">Conductor</xsl:when>
          <xsl:when test="string-length(./b:Author/b:ProducerName)>0">ProducerName</xsl:when>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="./b:SourceType='Performance'">
        <xsl:choose>
          <xsl:when test="string-length(./b:Author/b:Writer)>0">Writer</xsl:when>
          <xsl:when test="string-length(./b:Author/b:Director)>0">Director</xsl:when>
          <xsl:when test="string-length(./b:Author/b:Performer)>0">Performer</xsl:when>
          <xsl:when test="string-length(./b:Author/b:ProducerName)>0">ProducerName</xsl:when>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="./b:SourceType='Art'">
        <xsl:choose>
          <xsl:when test="string-length(./b:Author/b:Artist)>0">Artist</xsl:when>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="./b:SourceType='DocumentFromInternetSite'">
        <xsl:choose>
          <xsl:when test="string-length(./b:Author/b:Author)>0">Author</xsl:when>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="./b:SourceType='InternetSite'">
        <xsl:choose>
          <xsl:when test="string-length(./b:Author/b:Author)>0">Author</xsl:when>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="./b:SourceType='Film'">
        <xsl:choose>
          <xsl:when test="string-length(./b:Author/b:Director)>0">Director</xsl:when>
          <xsl:when test="string-length(./b:Author/b:Writer)>0">Writer</xsl:when>
          <xsl:when test="string-length(./b:Author/b:Performer)>0">Performer</xsl:when>
          <xsl:when test="string-length(./b:Author/b:ProducerName)>0">ProducerName</xsl:when>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="./b:SourceType='Interview'">
        <xsl:choose>
          <xsl:when test="string-length(./b:Author/b:Interviewee)>0">Interviewee</xsl:when>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="./b:SourceType='Patent'">
        <xsl:choose>
          <xsl:when test="string-length(./b:Author/b:Inventor)>0">Inventor</xsl:when>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="./b:SourceType='ElectronicSource'">
        <xsl:choose>
          <xsl:when test="string-length(./b:Author/b:Author)>0">Author</xsl:when>
          <xsl:when test="string-length(./b:Author/b:Editor)>0">Editor</xsl:when>
          <xsl:when test="string-length(./b:Author/b:ProducerName)>0">ProducerName</xsl:when>
          <xsl:when test="string-length(./b:Author/b:Translator)>0">Translator</xsl:when>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="./b:SourceType='Case'">
        <xsl:choose>
          <xsl:when test="string-length(./b:Author/b:Author)>0">Author</xsl:when>
          <xsl:when test="string-length(./b:Author/b:Counsel)>0">Counsel</xsl:when>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="./b:SourceType='Misc'">
        <xsl:choose>
          <xsl:when test="string-length(./b:Author/b:Author)>0">Author</xsl:when>
          <xsl:when test="string-length(./b:Author/b:Editor)>0">Editor</xsl:when>
          <xsl:when test="string-length(./b:Author/b:Compiler)>0">Compiler</xsl:when>
          <xsl:when test="string-length(./b:Author/b:Translator)>0">Translator</xsl:when>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="handleSpaces">
    <xsl:param name="field"/>

    <xsl:variable name="prop_NormalizeSpace">
      <xsl:call-template name="templ_prop_NormalizeSpace"/>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$prop_NormalizeSpace='yes'">
        <xsl:value-of select="normalize-space($field)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$field"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="handleHyphens">
    <xsl:param name="name"/>

    <xsl:variable name="prop_APA_Hyphens">
      <xsl:call-template name="templ_prop_Hyphens"/>
    </xsl:variable>

    <xsl:if test="string-length($name)>=2">
      <xsl:choose>
        <xsl:when test="contains($prop_APA_Hyphens, substring($name, 1, 1))">
          <xsl:value-of select="substring($name, 1, 2)"/>
          <xsl:call-template name="templ_prop_DotInitial"/>

          <xsl:call-template name="handleHyphens">
            <xsl:with-param name="name" select="substring($name, 3)"/>
          </xsl:call-template>
        </xsl:when>

        <xsl:otherwise>
          <xsl:call-template name="handleHyphens">
            <xsl:with-param name="name" select="substring($name, 2)"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>

    </xsl:if>

  </xsl:template>

  <xsl:template name="formatNameInitial">
    <xsl:param name="name"/>
    <xsl:variable name="temp">
      <xsl:call-template name="handleSpaces">
        <xsl:with-param name="field" select="$name"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="prop_APA_Hyphens">
      <xsl:call-template name="templ_prop_Hyphens"/>
    </xsl:variable>

    <xsl:if test="string-length($temp)>0">

      <xsl:variable name="tempWithoutSpaces">
        <xsl:value-of select="translate($temp, '&#32;&#160;', '')"/>
      </xsl:variable>

      <xsl:if test="not(contains($prop_APA_Hyphens, substring($tempWithoutSpaces, 1, 1)))">
        <xsl:value-of select="substring($tempWithoutSpaces, 1, 1)"/>
        <xsl:call-template name="templ_prop_DotInitial"/>
      </xsl:if>

      <xsl:call-template name="handleHyphens">
        <xsl:with-param name="name" select="$tempWithoutSpaces"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>



  <xsl:template name="formatNameOneItem">
    <xsl:param name="format"/>

    <xsl:choose>
      <xsl:when test="$format = 'F'">
        <xsl:value-of select="b:First"/>
      </xsl:when>
      <xsl:when test="$format = 'L'">
        <xsl:value-of select="b:Last"/>
      </xsl:when>
      <xsl:when test="$format = 'M'">
        <xsl:value-of select="b:Middle"/>
      </xsl:when>
      <xsl:when test="$format = 'f'">
        <xsl:call-template name="formatNameInitial">
          <xsl:with-param name="name" select="b:First"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$format = 'm'">
        <xsl:call-template name="formatNameInitial">
          <xsl:with-param name="name" select="b:Middle"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$format = 'l'">
        <xsl:call-template name="formatNameInitial">
          <xsl:with-param name="name" select="b:Last"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>

  </xsl:template>

  <xsl:template name="StringFormatName">
    <xsl:param name="format" />
    <xsl:param name="withDot" />
    <xsl:param name="upperLast"/>

    <xsl:variable name="prop_EndChars">
      <xsl:call-template name="templ_prop_EndChars"/>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$format = ''"></xsl:when>
      <xsl:when test="substring($format, 1, 2) = '%%'">
        <xsl:text>%</xsl:text>
        <xsl:call-template name="StringFormatName">
          <xsl:with-param name="format" select="substring($format, 3)" />
          <xsl:with-param name="withDot" select="$withDot" />
          <xsl:with-param name="upperLast" select="$upperLast" />
        </xsl:call-template>
        <xsl:if test="string-length($format)=2 and withDot = 'yes' and not(contains($prop_EndChars, '%'))">
          <xsl:call-template name="templ_prop_Dot"/>
        </xsl:if>
      </xsl:when>
      <xsl:when test="substring($format, 1, 1) = '%'">
        <xsl:variable name="what" select="substring($format, 2, 1)" />

        <xsl:choose>
          <xsl:when test="(what = 'l' or what = 'L') and upperLast = 'yes'">
            <span style='text-transform: uppercase;'>
              <xsl:call-template name="formatNameOneItem">
                <xsl:with-param name="format" select="$what"/>
              </xsl:call-template>
            </span>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="formatNameOneItem">
              <xsl:with-param name="format" select="$what"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:call-template name="StringFormatName">
          <xsl:with-param name="format" select="substring($format, 3)" />
          <xsl:with-param name="withDot" select="$withDot" />
          <xsl:with-param name="upperLast" select="$upperLast" />
        </xsl:call-template>
        <xsl:if test="string-length($format)=2 and withDot='yes'">
          <xsl:variable name="temp2">
            <xsl:call-template name="handleSpaces">
              <xsl:with-param name="field">
                <xsl:call-template name="formatNameOneItem">
                  <xsl:with-param name="format" select="$what"/>
                </xsl:call-template>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:variable>
          <xsl:variable name="lastChar">
            <xsl:value-of select="substring($temp2, string-length($temp2))"/>
          </xsl:variable>
          <xsl:if test="not(contains($prop_EndChars, $lastChar))">
            <xsl:call-template name="templ_prop_Dot"/>
          </xsl:if>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="substring($format, 1, 1)" />
        <xsl:call-template name="StringFormatName">
          <xsl:with-param name="format" select="substring($format, 2)" />
          <xsl:with-param name="withDot" select="$withDot" />
          <xsl:with-param name="upperLast" select="$upperLast" />
        </xsl:call-template>
        <xsl:if test="string-length($format)=1">
          <xsl:if test="withDot = 'yes' and not(contains($prop_EndChars, $format))">
            <xsl:call-template name="templ_prop_Dot"/>
          </xsl:if>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="StringFormatDate">
    <xsl:param name="format" />

    <xsl:param name="day"/>
    <xsl:param name="month"/>
    <xsl:param name="year"/>

    <xsl:param name="withDot" />

    <xsl:variable name="prop_EndChars">
      <xsl:call-template name="templ_prop_EndChars"/>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$format = ''"></xsl:when>
      <xsl:when test="substring($format, 1, 2) = '%%'">
        <xsl:text>%</xsl:text>
        <xsl:call-template name="StringFormatDate">
          <xsl:with-param name="format" select="substring($format, 3)" />
          <xsl:with-param name="day" select="$day"/>
          <xsl:with-param name="month" select="$month"/>
          <xsl:with-param name="year" select="$year"/>
          <xsl:with-param name="withDot" select="$withDot" />
        </xsl:call-template>
        <xsl:if test="string-length($format)=2 and withDot = 'yes' and not(contains($prop_EndChars, '%'))">
          <xsl:call-template name="templ_prop_Dot"/>
        </xsl:if>
      </xsl:when>
      <xsl:when test="substring($format, 1, 1) = '%'">
        <xsl:variable name="what" select="substring($format, 2, 1)" />
        <xsl:choose>
          <xsl:when test="$what = 'D'">
            <xsl:value-of select="$day"/>
          </xsl:when>
          <xsl:when test="$what = 'M'">
            <xsl:value-of select="$month"/>
          </xsl:when>
          <xsl:when test="$what = 'Y'">
            <xsl:value-of select="$year"/>
          </xsl:when>
        </xsl:choose>
        <xsl:call-template name="StringFormatDate">
          <xsl:with-param name="format" select="substring($format, 3)" />
          <xsl:with-param name="day" select="$day"/>
          <xsl:with-param name="month" select="$month"/>
          <xsl:with-param name="year" select="$year"/>
          <xsl:with-param name="withDot" select="$withDot" />
        </xsl:call-template>
        <xsl:if test="string-length($format)=2 and withDot='yes'">
          <xsl:variable name="temp2">
            <xsl:call-template name="handleSpaces">
              <xsl:with-param name="field">
                <xsl:call-template name="formatNameOneItem">
                  <xsl:with-param name="format" select="$what"/>
                </xsl:call-template>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:variable>
          <xsl:variable name="lastChar">
            <xsl:value-of select="substring($temp2, string-length($temp2))"/>
          </xsl:variable>
          <xsl:if test="not(contains($prop_EndChars, $lastChar))">
            <xsl:call-template name="templ_prop_Dot"/>
          </xsl:if>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="substring($format, 1, 1)" />
        <xsl:call-template name="StringFormatDate">
          <xsl:with-param name="format" select="substring($format, 2)" />
          <xsl:with-param name="day" select="$day"/>
          <xsl:with-param name="month" select="$month"/>
          <xsl:with-param name="year" select="$year"/>
          <xsl:with-param name="withDot" select="$withDot" />
        </xsl:call-template>
        <xsl:if test="string-length($format)=1">
          <xsl:if test="withDot = 'yes' and not(contains($prop_EndChars, $format))">
            <xsl:call-template name="templ_prop_Dot"/>
          </xsl:if>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="formatNameCore">
    <xsl:param name="FML"/>
    <xsl:param name="FM"/>
    <xsl:param name="ML"/>
    <xsl:param name="FL"/>
    <xsl:param name="upperLast"/>
    <xsl:param name="withDot"/>

    <xsl:variable name="first">
      <xsl:call-template name="handleSpaces">
        <xsl:with-param name="field" select="b:First"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="middle">
      <xsl:call-template name="handleSpaces">
        <xsl:with-param name="field" select="b:Middle"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="last">
      <xsl:call-template name="handleSpaces">
        <xsl:with-param name="field" select="b:Last"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="format">
      <xsl:choose>
        <xsl:when test="string-length($first) = 0 and string-length($middle) = 0 and string-length($last) = 0 ">
        </xsl:when>
        <xsl:when test="string-length($first) = 0 and string-length($middle) = 0 and string-length($last) != 0 ">
          <xsl:call-template name="templ_prop_SimpleAuthor_L" />
        </xsl:when>
        <xsl:when test="string-length($first) = 0 and string-length($middle) != 0 and string-length($last) = 0 ">
          <xsl:call-template name="templ_prop_SimpleAuthor_M" />
        </xsl:when>
        <xsl:when test="string-length($first) = 0 and string-length($middle) != 0 and string-length($last) != 0 ">
          <xsl:value-of select="$ML"/>
        </xsl:when>
        <xsl:when test="string-length($first) != 0 and string-length($middle) = 0 and string-length($last) = 0 ">
          <xsl:call-template name="templ_prop_SimpleAuthor_F" />
        </xsl:when>
        <xsl:when test="string-length($first) != 0 and string-length($middle) = 0 and string-length($last) != 0 ">
          <xsl:value-of select="$FL"/>
        </xsl:when>
        <xsl:when test="string-length($first) != 0 and string-length($middle) != 0 and string-length($last) = 0 ">
          <xsl:value-of select="$FM"/>
        </xsl:when>
        <xsl:when test="string-length($first) != 0 and string-length($middle) != 0 and string-length($last) != 0 ">
          <xsl:value-of select="$FML"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>

    <xsl:call-template name="StringFormatName">
      <xsl:with-param name="format" select="$format"/>
      <xsl:with-param name="upperLast" select="$upperLast"/>
      <xsl:with-param name="withDot" select="$withDot"/>
    </xsl:call-template>

  </xsl:template>

  <xsl:template name="formatDateCore">
    <xsl:param name="DMY"/>
    <xsl:param name="DM"/>
    <xsl:param name="MY"/>
    <xsl:param name="DY"/>

    <xsl:param name="day"/>
    <xsl:param name="month"/>
    <xsl:param name="year"/>

    <xsl:param name="withDot"/>

    <xsl:variable name="format">
      <xsl:choose>
        <xsl:when test="string-length($day) = 0 and string-length($month) = 0 and string-length($year) = 0 ">
        </xsl:when>
        <xsl:when test="string-length($day) = 0 and string-length($month) = 0 and string-length($year) != 0 ">
          <xsl:call-template name="templ_prop_SimpleDate_Y" />
        </xsl:when>
        <xsl:when test="string-length($day) = 0 and string-length($month) != 0 and string-length($year) = 0 ">
        </xsl:when>
        <xsl:when test="string-length($day) = 0 and string-length($month) != 0 and string-length($year) != 0 ">
          <xsl:value-of select="$MY"/>
        </xsl:when>
        <xsl:when test="string-length($day) != 0 and string-length($month) = 0 and string-length($year) = 0 ">
        </xsl:when>
        <xsl:when test="string-length($day) != 0 and string-length($month) = 0 and string-length($year) != 0 ">
          <xsl:call-template name="templ_prop_SimpleDate_Y" />
        </xsl:when>
        <xsl:when test="string-length($day) != 0 and string-length($month) != 0 and string-length($year) = 0 ">
        </xsl:when>
        <xsl:when test="string-length($day) != 0 and string-length($month) != 0 and string-length($year) != 0 ">
          <xsl:value-of select="$DMY"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>

    <xsl:call-template name="StringFormatDate">
      <xsl:with-param name="format" select="$format"/>

      <xsl:with-param name="day" select="$day"/>
      <xsl:with-param name="month" select="$month"/>
      <xsl:with-param name="year" select="$year"/>

      <xsl:with-param name="withDot" select="$withDot"/>
    </xsl:call-template>

  </xsl:template>



  <xsl:template name="need_Dot">
    <xsl:param name="field"/>

    <xsl:variable name="temp">
      <xsl:call-template name="handleSpaces">
        <xsl:with-param name="field" select="$field"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="lastChar">
      <xsl:value-of select="substring($temp, string-length($temp))"/>
    </xsl:variable>
    <xsl:variable name="prop_EndChars">
      <xsl:call-template name="templ_prop_EndChars"/>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="string-length($temp) = 0">
      </xsl:when>
      <xsl:when test="contains($prop_EndChars, $lastChar)">
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="templ_prop_Dot"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template name="appendField_Dot">
    <xsl:param name="field"/>

    <xsl:variable name="temp">
      <xsl:call-template name="handleSpaces">
        <xsl:with-param name="field" select="$field"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="lastChar">
      <xsl:value-of select="substring($temp, string-length($temp))"/>
    </xsl:variable>
    <xsl:variable name="prop_EndChars">
      <xsl:call-template name="templ_prop_EndChars"/>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="string-length($temp) = 0">
      </xsl:when>
      <xsl:when test="contains($prop_EndChars, $lastChar)">
        <xsl:value-of select="$temp"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$temp"/>
        <xsl:call-template name="templ_prop_Dot"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>


  <xsl:template name="templateJ">
    <xsl:param name="first"/>
    <xsl:param name="second"/>
    <xsl:param name="third"/>

    <xsl:variable name="tempFirst">
      <xsl:call-template name="handleSpaces">
        <xsl:with-param name="field" select="$first"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="tempSecond">
      <xsl:call-template name="handleSpaces">
        <xsl:with-param name="field" select="$second"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="tempThird">
      <xsl:call-template name="handleSpaces">
        <xsl:with-param name="field" select="$third"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="temp">
      <xsl:if test="string-length($tempFirst)>0">
        <xsl:value-of select="$tempFirst"/>
      </xsl:if>

      <xsl:if test="string-length($tempFirst)>0 and (string-length($tempSecond)>0 or string-length($tempThird)>0)">
        <xsl:call-template name="templ_prop_ListSeparator"/>
      </xsl:if>

      <xsl:if test="string-length($tempSecond)>0">
        <xsl:value-of select="$tempSecond"/>
      </xsl:if>

      <xsl:if test="string-length($tempSecond)>0 and string-length($tempThird)>0">
        <xsl:call-template name="templ_prop_ListSeparator"/>
      </xsl:if>

      <xsl:if test="string-length($tempThird)>0">
        <xsl:value-of select="$tempThird"/>
      </xsl:if>
    </xsl:variable>

    <xsl:call-template name="appendFieldNoHandleSpaces_Dot">
      <xsl:with-param name="field" select="$temp"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="templateC">
    <xsl:param name="first"/>
    <xsl:param name="second"/>

    <xsl:variable name="tempFirst">
      <xsl:call-template name="handleSpaces">
        <xsl:with-param name="field" select="$first"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="tempSecond">
      <xsl:call-template name="handleSpaces">
        <xsl:with-param name="field" select="$second"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="temp">
      <xsl:if test="string-length($tempFirst)>0">
        <xsl:value-of select="$tempFirst"/>
      </xsl:if>

      <xsl:if test="string-length($tempFirst)>0 and string-length($tempSecond)>0">
        <xsl:call-template name="templ_prop_ListSeparator"/>
      </xsl:if>

      <xsl:if test="string-length($tempSecond)>0">
        <xsl:value-of select="$tempSecond"/>
      </xsl:if>

    </xsl:variable>

    <xsl:call-template name="appendFieldNoHandleSpaces_Dot">
      <xsl:with-param name="field" select="$temp"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="appendFieldNoHandleSpaces_Dot">
    <xsl:param name="field"/>

    <xsl:variable name="lastChar">
      <xsl:value-of select="substring($field, string-length($field))"/>
    </xsl:variable>
    <xsl:variable name="prop_EndChars">
      <xsl:call-template name="templ_prop_EndChars"/>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="string-length($field) = 0">
      </xsl:when>
      <xsl:when test="contains($prop_EndChars, $lastChar)">
        <xsl:value-of select="$field"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$field"/>
        <xsl:call-template name="templ_prop_Dot"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template name="GetMainAuthorTitle">
    <xsl:param name="sourceType"/>
    <xsl:param name="authorType"/>
    <xsl:param name="cAuthors" />
    <xsl:param name="isOrganisation" />

    <xsl:choose>
      <xsl:when test="$authorType='Author'">

      </xsl:when>

      <xsl:when test="$authorType='Editor'">
        <xsl:choose>
          <xsl:when test="$isOrganisation=true()">
            <xsl:call-template name="templ_str_EditorShortUnCap"/>
          </xsl:when>
          <xsl:when test="$cAuthors=0">
          </xsl:when>
          <xsl:when test="$cAuthors=1">
            <xsl:call-template name="templ_str_EditorShortUnCap"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="templ_str_EditorsShortUnCap"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$authorType='Translator'">
        <xsl:choose>
          <xsl:when test="$isOrganisation=true()">
            <xsl:call-template name="templ_str_TranslatorShortUnCap"/>
          </xsl:when>
          <xsl:when test="$cAuthors=0">
          </xsl:when>
          <xsl:when test="$cAuthors=1">
            <xsl:call-template name="templ_str_TranslatorShortUnCap"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="templ_str_TranslatorsShortUnCap"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$authorType='Artist'">

      </xsl:when>

      <xsl:when test="$authorType='Performer'">
        <xsl:choose>
          <xsl:when test="$isOrganisation=true()">
            <xsl:call-template name="templ_str_PerformerShortUnCap"/>
          </xsl:when>
          <xsl:when test="$cAuthors=0">
          </xsl:when>
          <xsl:when test="$cAuthors=1">
            <xsl:call-template name="templ_str_PerformerShortUnCap"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="templ_str_PerformersShortUnCap"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$authorType='Composer'">
        <xsl:choose>
          <xsl:when test="$isOrganisation=true()">
            <xsl:call-template name="templ_str_ComposerShortUnCapIso"/>
          </xsl:when>
          <xsl:when test="$cAuthors=0">
          </xsl:when>
          <xsl:when test="$cAuthors=1">
            <xsl:call-template name="templ_str_ComposerShortUnCapIso"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="templ_str_ComposerShortUnCapIso"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$authorType='Conductor'">
        <xsl:choose>
          <xsl:when test="$isOrganisation=true()">
            <xsl:call-template name="templ_str_ConductorShortUnCap"/>
          </xsl:when>
          <xsl:when test="$cAuthors=0">
          </xsl:when>
          <xsl:when test="$cAuthors=1">
            <xsl:call-template name="templ_str_ConductorShortUnCap"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="templ_str_ConductorsShortUnCap"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$authorType='ProducerName'">
        <xsl:choose>
          <xsl:when test="$isOrganisation=true()">
            <xsl:call-template name="templ_str_ProducerShortUnCap"/>
          </xsl:when>
          <xsl:when test="$cAuthors=0">
          </xsl:when>
          <xsl:when test="$cAuthors=1">
            <xsl:call-template name="templ_str_ProducerShortUnCap"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="templ_str_ProducerShortUnCap"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$authorType='Writer'">
        <xsl:choose>
          <xsl:when test = "not($sourceType = 'Film')">
          </xsl:when>
          <xsl:when test="$isOrganisation=true()">
            <xsl:call-template name="templ_str_WriterShortUnCap"/>
          </xsl:when>
          <xsl:when test="$cAuthors=0">
          </xsl:when>
          <xsl:when test="$cAuthors=1">
            <xsl:call-template name="templ_str_WriterShortUnCap"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="templ_str_WriterShortUnCap"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$authorType='Director'">

      </xsl:when>

      <xsl:when test="$authorType='Interviewee'">

      </xsl:when>

      <xsl:when test="$authorType='Inventor'">

      </xsl:when>

      <xsl:when test="$authorType='Counsel'">
        <xsl:choose>
          <xsl:when test="$isOrganisation=true()">
            <xsl:call-template name="templ_str_CounselShortUnCap"/>
          </xsl:when>
          <xsl:when test="$cAuthors=0">
          </xsl:when>
          <xsl:when test="$cAuthors=1">
            <xsl:call-template name="templ_str_CounselShortUnCap"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="templ_str_CounselShortUnCap"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$authorType='Compiler'">
        <xsl:choose>
          <xsl:when test="$isOrganisation=true()">
            <xsl:call-template name="templ_str_CompilerShortUnCap"/>
          </xsl:when>
          <xsl:when test="$cAuthors=0">
          </xsl:when>
          <xsl:when test="$cAuthors=1">
            <xsl:call-template name="templ_str_CompilerShortUnCap"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="templ_str_CompilersShortUnCap"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="PrintSpaceAndList">
    <xsl:param name="list"/>

    <xsl:variable name="result">
      <xsl:call-template name="PrintList">
        <xsl:with-param name="list" select="$list" />
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="string-length($result) > 0">
      <xsl:call-template name="templ_prop_Space" />
      <xsl:copy-of select="$result" />
    </xsl:if>
  </xsl:template>

  <xsl:template name="PrintList">
    <xsl:param name="list"/>

    <xsl:call-template name="PrintList2">
      <xsl:with-param name="list" select="$list" />
      <xsl:with-param name="index" select="'1'" />
      <xsl:with-param name="nextSeparator">
        <xsl:call-template name="templ_prop_ListSeparator"/>
      </xsl:with-param>
      <xsl:with-param name="textDisplayed" select="''" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="PrintList2">
    <xsl:param name="list"/>
    <xsl:param name="index"/>
    <xsl:param name="nextSeparator"/>
    <xsl:param name="lastTextDisplayed"/>



    <xsl:choose>
      <xsl:when test="$index > count(msxsl:node-set($list)/*/*)">
        <xsl:call-template name="need_Dot">
          <xsl:with-param name="field" select ="$lastTextDisplayed"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="local-name(msxsl:node-set($list)/*/*[$index]) = 'TextItem'">
        <xsl:variable name="item">
          <xsl:value-of select="msxsl:node-set($list)/*/*[$index]" />
        </xsl:variable>

        <xsl:if test="string-length($item) > 0 and string-length($lastTextDisplayed) > 0">
          <xsl:value-of select = "$nextSeparator" />
        </xsl:if>

        <xsl:if test="string-length($item) > 0">
          <xsl:value-of select = "$item" />
        </xsl:if>

        <xsl:call-template name="PrintList2">
          <xsl:with-param name="list" select="$list" />
          <xsl:with-param name="index" select="$index + 1" />
          <xsl:with-param name="nextSeparator">
            <xsl:choose>
              <xsl:when test="string-length($item) > 0 and string-length($lastTextDisplayed) > 0">
                <xsl:call-template name="templ_prop_ListSeparator"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$nextSeparator" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
          <xsl:with-param name="lastTextDisplayed">
            <xsl:choose>
              <xsl:when test="string-length($item) > 0">
                <xsl:value-of select="$item" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$lastTextDisplayed" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="local-name(msxsl:node-set($list)/*/*[$index]) = 'GroupSeparator'">
        <xsl:call-template name="PrintList2">
          <xsl:with-param name="list" select="$list" />
          <xsl:with-param name="index" select="$index + 1" />
          <xsl:with-param name="nextSeparator">
            <xsl:call-template name="templ_prop_GroupSeparator"/>
          </xsl:with-param>
          <xsl:with-param name="lastTextDisplayed" select="$lastTextDisplayed" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="local-name(msxsl:node-set($list)/*/*[$index]) = 'CopyItem'">
        <xsl:variable name="item">
          <xsl:copy-of select="msxsl:node-set($list)/*/*[$index]" />
        </xsl:variable>

        <xsl:if test="string-length($item) > 0 and string-length($lastTextDisplayed) > 0">
          <xsl:value-of select = "$nextSeparator" />
        </xsl:if>

        <xsl:if test="string-length($item) > 0">
          <xsl:copy-of select = "msxsl:node-set($item)/*[1]" />
        </xsl:if>

        <xsl:call-template name="PrintList2">
          <xsl:with-param name="list" select="$list" />
          <xsl:with-param name="index" select="$index + 1" />
          <xsl:with-param name="nextSeparator">
            <xsl:choose>
              <xsl:when test="string-length($item) > 0 and string-length($lastTextDisplayed) > 0">
                <xsl:call-template name="templ_prop_ListSeparator"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$nextSeparator" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
          <xsl:with-param name="lastTextDisplayed">
            <xsl:choose>
              <xsl:when test="string-length(msxsl:node-set($item)/*[1]) > 0">
                <xsl:value-of select="msxsl:node-set($item)/*[1]" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$lastTextDisplayed" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>

  </xsl:template>

  <xsl:template name="ApplyItalicTitleNS">
    <xsl:param name="data" />

    <xsl:variable name="prop_NoItalics">
      <xsl:call-template name="templ_prop_NoItalics"/>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test = "$prop_NoItalics = 'yes'">
        <xsl:variable name = "prop_TitleOpen">
          <xsl:call-template name="templ_prop_TitleOpen"/>
        </xsl:variable>
        <xsl:variable name = "prop_TitleClose">
          <xsl:call-template name="templ_prop_TitleClose"/>
        </xsl:variable>
        <xsl:variable name = "prop_OpenQuote">
          <xsl:call-template name="templ_prop_OpenQuote"/>
        </xsl:variable>
        <xsl:variable name = "prop_CloseQuote">
          <xsl:call-template name="templ_prop_CloseQuote"/>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test = "string-length($prop_TitleOpen) > 0 and string-length($prop_TitleClose) > 0 and string-length($prop_OpenQuote) > 0 and string-length($prop_CloseQuote) > 0 and 
					              not(starts-with($data, $prop_TitleOpen) or (substring($data, string-length($data) - string-length($prop_TitleClose)) = $prop_TitleClose) or starts-with($data, $prop_OpenQuote) or (substring($data, string-length($data) - string-length($prop_CloseQuote)) = $prop_CloseQuote))">
            <xsl:call-template name="templ_prop_TitleOpen"/>
            <xsl:copy-of select="msxsl:node-set($data)" />
            <xsl:call-template name="templ_prop_TitleClose"/>
          </xsl:when>
          <xsl:when test = "string-length($prop_TitleOpen) > 0 and string-length($prop_TitleClose) > 0 and 
					              not(starts-with($data, $prop_TitleOpen) or (substring($data, string-length($data) - string-length($prop_TitleClose)) = $prop_TitleClose))">
            <xsl:call-template name="templ_prop_TitleOpen"/>
            <xsl:copy-of select="msxsl:node-set($data)" />
            <xsl:call-template name="templ_prop_TitleClose"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy-of select="msxsl:node-set($data)" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <i xmlns="http://www.w3.org/TR/REC-html40">
          <xsl:copy-of select="msxsl:node-set($data)" />
        </i>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="ApplyItalicFieldNS">
    <xsl:param name="data" />

    <xsl:variable name="prop_NoItalics">
      <xsl:call-template name="templ_prop_NoItalics"/>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test = "$prop_NoItalics = 'yes'">
        <xsl:copy-of select="msxsl:node-set($data)" />
      </xsl:when>
      <xsl:otherwise>
        <i xmlns="http://www.w3.org/TR/REC-html40">
          <xsl:copy-of select="msxsl:node-set($data)" />
        </i>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>


