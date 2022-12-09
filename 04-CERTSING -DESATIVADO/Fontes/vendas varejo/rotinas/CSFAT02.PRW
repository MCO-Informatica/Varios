#INCLUDE "XMLXFUN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"   
#INCLUDE "FILEIO.CH" 
#INCLUDE "APWIZARD.CH" 
#INCLUDE "spednfe.ch"
#INCLUDE "PARMTYPE.CH"
#DEFINE MAXJOBNOAR 20

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSFAT02   º Autor ³ Totvs              º Data ³  20/02/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Job de envio para NFSe.	                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/ 
//			U_CSFAT02("01"	  ,"02"	   ,"60" ,""  ,"RP2" ,"002768299","002768299","1" ,1	  ,1	    ,"3550308")//Transmissão
//			U_CSFAT02("01"	  ,"02"	   ,"60" ,""  ,"RP2" ,"002768264","002768264","3" ,1	  ,1	    ,"3550308")//Cancelamento
User Function CSFAT02(cEmpresa,cFilProc,cWait,cOpc,cSerie,cNotaIni   ,cNotaFim   ,cJob,nMaxMon,nMaxtrans,cCodMun  )

	Local aArea			:= {}
	Local aPerg			:= {}
	Local aParam		:= {}	
	Local cParNfseRem	:= ""
	Local cMensRet		:= ""
	Local cNotasOk		:= ""
	Local aRet			:= {}
	Private cIdEnt		:= "" 
	Private cEntSai		:= "1"
	Private cURL		:= ""	
	Private cAliasSF3Rec:= ""

	Default cEmpresa	:= "01"
	Default cFilProc	:= "02"
	Default cWait		:= "60"
	Default cOpc		:= ""
	Default cSerie		:= "RP2"
	Default cNotaIni	:= "002768266"
	Default cNotaFim	:= "002768268"
	Default cJob		:= "1"
	Default nMaxMon		:= 50
	Default nMaxtrans	:= 100
	Default cCodMun		:= "3550308"	

	PARAMTYPE 1 VAR cEmpresa	AS CHARACTER
	PARAMTYPE 2 VAR cFilProc	AS CHARACTER 
	PARAMTYPE 3 VAR cWait		AS CHARACTER	OPTIONAL DEFAULT ""		 
	PARAMTYPE 4 VAR cOpc		AS CHARACTER	OPTIONAL DEFAULT ""		 
	PARAMTYPE 5 VAR cSerie		AS CHARACTER 
	PARAMTYPE 6 VAR cNotaIni	AS CHARACTER 
	PARAMTYPE 7 VAR cNotaFim	AS CHARACTER 
        
	aArea			:= GetArea()
	aParam			:= {Space(TamSX3("F2_SERIE")[1]),Space(TamSX3("F2_DOC")[1]),Space(TamSX3("F2_DOC")[1])}  
	cParNfseRem		:= SM0->M0_CODIGO+SM0->M0_CODFIL+"AUTONFSEREM" 
	cIdEnt	  		:= "000002"  
	cURL	   		:= PadR(GetNewPar("MV_SPEDURL","http://"),250)  
	cAliasSF3Rec	:= GetNextAlias()

	If cSerie == Nil
		MV_PAR01 := aParam[01] := PadR(ParamLoad(cParNfseRem,aPerg,1,aParam[01]),TamX3("F2_SERIE"	)[1])
		MV_PAR02 := aParam[02] := PadR(ParamLoad(cParNfseRem,aPerg,2,aParam[02]),TamX3("F2_DOC"		)[1])
		MV_PAR03 := aParam[03] := PadR(ParamLoad(cParNfseRem,aPerg,3,aParam[03]),TamX3("F2_DOC"		)[1])
	Else
		MV_PAR01 := aParam[01] := cSerie
		MV_PAR02 := aParam[02] := cNotaIni
		MV_PAR03 := aParam[03] := cNotaFim
	EndIf
		
	If !Empty(cIdEnt)	        
		
		cUrl:= AllTrim(cURL)+"/SPEDCFGNFe.apw"

		If cJob == "1"//transmissao
			Conout("[JOB  ]["+cIdEnt+"] - Iniciando transmissao NFS-e!")	    	
			Fisa022Trs(cCodMun,aParam[1],aParam[2],aParam[3],     ,"SF2" ,@cNotasOk,     ,0       ,@cMensRet,CtoD("01/01/01"),dDataBase,.T.,,dDataBase)
			// Conout("[JOB  ]["+cIdEnt+"] Transmissoes: "+Char(13)+Char(10)+Alltrim(cNotasOk))
			If Len(cNotasOk) > 0
				Aadd( aRet, .T. )
   				Aadd( aRet, "" )
				Aadd( aRet, cNotaIni )
				Aadd( aRet, "As notas foram transmitidas:"+ CHR(13)+CHR(10) + cNotasOk )
				ConOut("As notas foram transmitidas:" + cNotasOk )
				cNotasOk := ""
			Else
				Aadd( aRet, .F. )
   				Aadd( aRet, "" )
				Aadd( aRet, cNotaIni )
				Aadd( aRet, "A nota não foi transmitida:" + cNotasOk ) 
			EndIf			
		EndIf
				
		If cJob	$ "3"//Cancelamento		
			Conout("[JOB  ]["+cIdEnt+"] - Iniciando Cancelamento NFS-e!")
			Fisa022Canc(.T.,@cNotasOk)			
			Conout("[JOB  ]["+cIdEnt+"] Cancelamentos: "+Char(13)+Char(10)+Alltrim(cNotasOk))
			cNotasOk:=""			
		EndIF

	EndIf
	
RestArea(aArea)

Return(aRet)