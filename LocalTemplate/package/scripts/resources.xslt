﻿<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:fhir="http://hl7.org/fhir" version="1.0">
    <xsl:output method="html" />
    <xsl:param name="pref" select="pref" />
    <xsl:template match="/">

	<div id="resources">
		<xsl:for-each-group select="/fhir:ExampleScenario/fhir:instance/fhir:structureType" group-by="fhir:code/@value">
			<xsl:apply-templates select="../fhir:structureType" />
		</xsl:for-each-group>
	</div>


	</xsl:template>


<xsl:template name="break">
  <xsl:param name="text" select="string(.)"/>
  <xsl:choose>
    <xsl:when test="contains($text, '\n')">
      <xsl:value-of select="substring-before($text, '\n')"/>
      <br/>
      <xsl:call-template name="break">
        <xsl:with-param 
          name="text" 
          select="substring-after($text, '\n')"
        />
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$text"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>



	<xsl:template match="fhir:structureType">
		<p />
		<xsl:variable name="thisResourceType" select="./fhir:code/@value" />
		<h3>
			<xsl:value-of select="$thisResourceType" />
		</h3>
		<div style="min-width:400px">
		<table class="grid table-bordered" style="width:100%">
			<tbody>
				<tr>
					<th>Artifact</th>
					<th>Version</th>
					<th>Description</th>
				</tr>
				<xsl:apply-templates select="../../fhir:instance[fhir:structureType/fhir:code/@value=$thisResourceType]" />
			</tbody>
		</table>
		</div>
	</xsl:template>





	<xsl:template match="fhir:instance">
		<xsl:variable name="thisResourceId" select="./fhir:key/@value" />
		<xsl:variable name="versions" select="count(./fhir:version)" />
		<tr >
			<td rowspan="{$versions+1}">
				<a name="./{fhir:key/@value}" href="./{fhir:structureType/fhir:code/@value}-{./fhir:key/@value}.html">
					<b>
<!--						<xsl:value-of select="fhir:name/@value" />
-->
						<xsl:call-template name="break">
							<xsl:with-param name="text" select="fhir:title/@value" />
						</xsl:call-template>							
					</b>
				</a>
			</td>

			<td>(<xsl:value-of select="$versions"/>)</td>
			<td>
				<b><xsl:value-of select="fhir:description/@value" /></b>
			</td>
		</tr>		
	        <xsl:apply-templates select="./fhir:version" />		
	</xsl:template>

	<xsl:template match="fhir:version">
		<tr>
			<td><xsl:value-of select="fhir:key/@value" /></td>
			<td><xsl:value-of select="fhir:description/@value" /></td>
		</tr>
	</xsl:template>

</xsl:stylesheet>
