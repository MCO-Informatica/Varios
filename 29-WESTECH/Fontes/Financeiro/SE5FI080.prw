#Include 'Protheus.ch'
#include "rwmake.ch"
#include "topconn.ch"
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function SE5FI080()

	Local cPrefixo   	:= SE2->E2_PREFIXO
	Local cNumero 		:= SE2->E2_NUM
	Local cParcela    	:= SE2->E2_PARCELA
	Local cTipo			:= SE2->E2_TIPO
	Local cCliFor		:= SE2->E2_FORNECE
	Local cBenef		:= Posicione("SA2",1,xFilial("SA2") + cCliFor,"A2_NREDUZ")
	Local cLoja			:= SE2->E2_LOJA
	
	Local cItemCC		:= SE2->E2_XXIC	
	Local dData			:= dDatabase
	Local cTPDESC		:= "I"

	
	Local cCamposE5 := PARAMIXB[1]
	Local oSubModel := PARAMIXB[2]
	
	
If oSubModel:cID == "FK2DETAIL"


               cCamposE5 := "{{ 'E5_XXIC', '" + cItemCC + "'},{ 'E5_TPDESC', '" + cTPDESC + "'},{ 'E5_NUMERO', '" + cNumero + "'},{ 'E5_PREFIXO', '" + cPrefixo + "'},{ 'E5_TIPO', '" + cTipo + "'},{ 'E5_CLIFOR', '" + cCliFor + "'},{ 'E5_FORNECE', '" + cCliFor + "'},{ 'E5_BENEF', '" + cBenef + "'},{ 'E5_LOJA', '" + cLoja + "'},{ 'E5_DTDIGIT', '" + dtos(dData) + "'}"
              

EndIf

Return cCamposE5 
