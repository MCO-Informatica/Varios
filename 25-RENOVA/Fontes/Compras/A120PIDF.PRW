#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  A120PIDF   ºAutor  ³Pedro Augusto      º Data ³  12/08/14    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ P.E. para filtrar filial destino no browse do F4 do PC      ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Workflow RENOVA                                            º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function A120PIDF()

	Local cQryDbf := '', cQrySql := ''
	
	cQryDbf += " C1_QUANT>C1_QUJE.And.C1_APROV$'L'.And.C1_COTACAO$'      /XXXXXX' .And. "
	cQryDbf += " C1_FILIAL = '"+xFilial('SC1')+"' .And. C1_RESIDUO = ' ' .and. "    
	cQryDbf += " C1_FILDEST = '"+cFilAnt+"' .And. Empty(C1_XNUMANT) "
	
	cQrySql += " C1_QUANT > C1_QUJE AND C1_APROV = 'L' AND C1_COTACAO IN('      ','XXXXXX') AND "
	cQrySql += " C1_FILIAL = '"+xFilial('SC1')+"' AND C1_RESIDUO = ' '  AND"
	cQrySql += " C1_FILDEST = '"+cFilAnt+"' AND C1_XNUMANT = ' ' "
	
	Return( { cQryDbf, cQrySql } )
	
	
	