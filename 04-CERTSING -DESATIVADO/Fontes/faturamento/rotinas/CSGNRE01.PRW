#Include 'rwmake.ch'
#include "topconn.ch"
#Include "Totvs.ch"
#Include 'Protheus.ch'
 /**
 * @ Ajuste na tabela SF6 - Projeto Prox
 * @author Gesse Santos
 * @Aug 15 2014
 */
*************************************************************************************************************
&& Main Function - Chamar no fim do PE M460FIM apos os RestArea do PE- SF2 esta posicionado
*************************************************************************************************************
User function CSGNRE01()
Local __aArea 	:= GetArea() 
Local __aSF6    := sf6->(GetArea())
Local __cProt   := ""
//Local __cPar    := ""
//Local __dVenc   := DataValida(sf2->f2_emissao + getMv("MV_XDTGNR") , .T.)
Local dData     := SF2->F2_EMISSAO
Local dNew      := ''
Local nDias     := GetMv("MV_XDTGNR")
local nPos			:= 0
local nAt			:= 0
local cMVGNRECod	:= Alltrim( SuperGetMv("MV_XGNREPR", .F. ,"" ) ) 
local aUf 			:= {}
local aGnre			:= {}
local aGnreUF		:= {}	
Local nCont 		:= 1
Local nx

//[SIS-5141] - GNRE MT
If Alltrim(sf2->f2_est) == "MT"
	nDias := SuperGetMv("MV_XDGNRMT",.f.,3)
Endif

//Inclusão deste Ponto - Rafael Beghini 25/03/2015
For nCont:=1 to nDias
	dData += 1
	If dow(dData)== 1 //domingo
		dData += 1
	ElseIf dow(dData)== 7 //sabado
		dData += 2
	EndIf
Next

dNew := DataValida( dData, .T.)

sf6->(dbsetorder(4)) //F6_FILIAL+F6_OPERNF+F6_TIPODOC+F6_DOC+F6_SERIE+F6_CLIFOR+F6_LOJA
if sf6->(dbseek(xfilial("SF6") + "2"+ PADR(sf2->f2_tipo,TAMSX3("F6_TIPODOC")[1]) + sf2->f2_doc + sf2->f2_serie + sf2->f2_cliente + sf2->f2_loja)) 
	
	Conout("GNRE - Nota/Serie: ("+sf2->f2_doc+"/"+sf2->f2_serie+")" )
	
	__cProt := alltrim(getMv("MV_XPROT"+alltrim(sf2->f2_est)))
    if !empty(__cProt)
            Conout("GNRE - Data/Protocolo: ("+dtoc(dNew)+"/"+__cProt+")" )
    		
    		dbselectarea("SF6") 
    		sf6->(RecLock("SF6",.F.))
			sf6->f6_dtvenc  := dNew
			sf6->f6_dtpagto := dNew
			sf6->f6_numconv := __cProt
			//MHS - 2015-07-06 - conforme necessidade de alguns estados
				If SF6->F6_EST$"AC/AM/AP/BA/CE/MA/MS/PE/PR/RO/RR/RS/SE/DF/RJ" 
					sf6->f6_Ref		:= "1"

				EndIf

			//MHS - 2015-07-06 - FIM
			
			//---------------------------------------------------------------------
			// GNRE via Web Service
			// @autor: Douglas Parreja 		Data: 05/10/2016
			//
			// Para a transmissao via Web Service, eh necessario para o Estado do 
			// Rio de Janeiro informar o codigo do Produto.
			// O parametro MV_GNREPRO da TOTVS ao ser informado, ele levara para  
			// todos os estados e com isso eh preciso validar por estado. 
			//
			// Criado o parametro MV_XGNREPR para informar qual estado e codigo.
			// Ex.: MV_XGNREPR := "RJ=698;SP=123;MG=456"
			//--------------------------------------------------------------------
			aUf := { alltrim(sf2->f2_est) }
			if ( !empty(cMVGNRECod) ) .and. ( len(aUf) > 0 )
				nAt := At( ";", cMVGNRECod )
				if nAt > 0 
					aGnre := StrTokArr( cMVGNRECod, ";" )								
				else
					aGnre := { cMVGNRECod }
				endif
				if len( aGnre ) > 0 
					for nx:=1 to len(aGnre)
						aAdd(aGnreUF, SubStr(aGnre[nX],1,2) )
					next
					nPos := ascan( aGnreUF, { |x| x == aUf[1] } )						
					if ( nPos > 0 )
						if SF6->(FieldPos("F6_CODPROD")) > 0
							SF6->F6_CODPROD := val(SubStr(aGnre[nPos],4,3))
						endif
					endif
				endif
			endif					
			
    		sf6->(MsUnlock()) 
    		
    		cdt->(RecLock("CDT",.F.))
			cdt->cdt_filial  := xfilial("CDT")
			cdt->cdt_tpmov   := "S"
			cdt->cdt_doc     := sf2->f2_doc
			cdt->cdt_serie   := sf2->f2_serie
			cdt->cdt_clifor  := sf2->f2_cliente
			cdt->cdt_loja    := sf2->f2_loja    
			cdt->cdt_ifcomp  := "000001" 
			cdt->cdt_dccomp  := "DIFERENCIAL DE ALIQUOTA - COD. RECEITA 10099"
    		cdt->(MsUnlock()) 
    endif
endif 

sf6->(RestArea(__aSF6))
RestArea(__aArea)
return()
