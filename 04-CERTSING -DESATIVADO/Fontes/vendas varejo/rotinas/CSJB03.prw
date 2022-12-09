#Include "rwmake.ch"
#Include "topconn.ch"
#Include "Protheus.ch"
#include "fileio.ch"
#INCLUDE "TBICONN.CH"
#Include "Fisa022.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSJB03    ºAutor  ³Microsiga           º Data ³  19/02/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ROTINA PARA TRATAR A TRANSMISSÃO DE NFSe.		              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Certisign                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION CSJB03()

LOCAL 	nContrab := 0
LOCAL 	nContfol := 0
Local 	cMod004  := ""
Local	aParam	 := {}

Public	cFilAnt  := "02"
Public 	cIdEnt	 := "000002"
Public 	cEntSai	 := "1"
Public 	cVerTss	 := "2.61"

conout("=========================================================================")
conout("#=====       Rotina para transmissão de notas automáticas.    ===========")
conout("=========================================================================")

RpcClearEnv()
RpcSetType(3)
Prepare Environment Empresa '01' Filial '02' TABLES "SF2","SD2","SFT","SF3"

cMod004  := Fisa022Cod("004")

Private aAreaP := getArea()
Private dDataP := dDataBase
Private lUsacolab := .F.

BeginSql Alias "TMPNFS"
	
	SELECT 	F3_FILIAL,
	F3_NFISCAL,
	F3_SERIE
	FROM PROTHEUS.SF3010 SF3
	WHERE
	F3_SERIE = 'RP2' AND
	F3_EMISSAO In (%Exp:dDataBase%,%Exp:dDataBase-1%) AND
	F3_CODRSEF IN (' ','N') AND
	F3_NFELETR = ' ' AND
	SF3.%NOTDEL%
	
EndSql

DbSelectArea("TMPNFS")
DbGoTop()

While !Eof("TMPNFS")
	
	U_CSFAT02("01"	  ,"02"	   ,"60" ,""  ,"RP2" ,TMPNFS->F3_NFISCAL,TMPNFS->F3_NFISCAL,"1" ,1	  ,1	    ,"3550308")
	
	conout("A nota " + TMPNFS->F3_NFISCAL + " foi transmitida.")
	TMPNFS->(dbSkip())
	
EndDo



BeginSql Alias "TMPNFC"
	
	SELECT 	F3_FILIAL,
	F3_NFISCAL,
	F3_SERIE,
	F3_CLIENT,
	F3_LOJA,
	F3_EMISSAO,
	SF2.R_E_C_N_O_ F2_RECNO
	FROM %Table:SF3% SF3
	LEFT JOIN %Table:SF2% SF2
	ON F2_FILIAL = F3_FILIAL AND F2_DOC = F3_NFISCAL AND F2_SERIE = F3_SERIE AND SF2.%NOTDEL%
	WHERE
	F3_SERIE = 'RP2' AND
	F3_EMISSAO In (%Exp:dDataBase%,%Exp:dDataBase-1%) AND
	F3_CODRSEF = 'T' AND
	SF3.%NOTDEL%
	
EndSql

DbSelectArea("TMPNFC")
DbGoTop()

While !Eof("TMPNFC")
	
	//conout("Filial: "+ xFilial("SF2")     )
	//conout("Nota: "  + TMPNFC->F3_NFISCAL )
	//conout("Serie: " + TMPNFC->F3_SERIE   )
	aParam := {}
	
	Aadd(aParam,"RP2")
	Aadd(aParam,TMPNFC->F3_NFISCAL)
	Aadd(aParam,TMPNFC->F3_NFISCAL)
	
	DbSelectArea("SF3")
	DbSetOrder(5)
	If DbSeek( xFilial("SF3") + "RP2" + TMPNFC->F3_NFISCAL )
		
		DbSelectArea("SFT")
		DbSetOrder(6)
		If DbSeek( xFilial("SF3") + "S" + TMPNFC->F3_NFISCAL + "RP2" )
			
			DbSelectArea("SF2")
			DbSetOrder(1)
			If DbSeek( xFilial("SF2") + TMPNFC->F3_NFISCAL + "RP2" )
				
				WsNFSeMnt( "000002", aParam )
				
				conout("A nota " + TMPNFC->F3_NFISCAL + " foi executada na rotina monitor.")  
				
				If RecLock("SF2",.F.) 
					SF2->F2_HORNFE := time()
					SF2->F2_EMINFE := date()
				
				SF2->(MsUnlock())	
				EndIf
				
				If RecLock("SF3",.F.) 
					SF3->F3_HORNFE := time()
					SF3->F3_EMINFE := date()
				
				SF3->(MsUnlock())	
				EndIf
				
				//Reprocessa o RPS para informar o Link de consulta da NFSe
				//U_GARR020( {.T.}, .T. )
				
			EndIf
		EndIf
	EndIf
	DbSelectArea("TMPNFC")
	TMPNFC->(dbSkip())
	
EndDo


RestArea(aAreaP)

RpcClearEnv()

RETURN

//Monitor de notas - Totvs

Static Function WsNFSeMnt( cIdEnt, aParam )

Local nMaxLote		:= 20	// Numero maximo de NFS-e por Lote

Local nX			:= 0
Local nY			:= 0
Local aListBox 		:= { .F., "", {} }
Local aRetListBox	:= {}
Local cSerie		:= ""
Local cIdInicial	:= ""
Local cIdFinal		:= ""
Local cCNPJIni		:= ""
Local cCNPJFim		:= ""
Local aLote			:= {}
Local nLote			:= 0
Local aIdNotas		:= {}
Local lProcessou		:= .F.
Local cMod004			:= Fisa022Cod("004")

Default cIdEnt		:= ""
Default aParam		:= {}

If Len( aParam ) > 0
	
	cSerie 		:= aParam[ 1 ]
	cIdInicial	:= aParam[ 2 ]
	cIdFinal	:= aParam[ 3 ]
	
	If cEntSai == "0"
		cCNPJIni := aParam[ 4 ]
		cCNPJFim := aParam[ 5 ]
	Endif
	
	For nX := Val( cIdInicial ) To Val( cIdFinal )
		AADD( aIdNotas, StrZero( nX, Len( AllTrim(cIdInicial) ) ) )
	Next
	
	For nX := 1 To Len( aIdNotas )
		
		nLote++
		
		AADD( aLote, aIdNotas[nX] )
		
		If nLote == nMaxLote
			
			lProcessou := .T.
			
			aRetListBox := MonitorNFSE( cIdEnt, cSerie, aLote, cCNPJIni, cCNPJFim, cMod004 )
			
			For nY := 1 To Len( aRetListBox[3] )
				AADD( aListBox[3], aRetListBox[3,nY] )
			Next
			
			aListBox[1] := ( Len( aListBox[3] ) > 0 )
			aListBox[2] := IIf( !Empty( aRetListBox[2] ), aRetListBox[2], "" )
			
			lProcessou	:= .F.
			nLote		:= 0
			aLote		:= {}
			
		Endif
		
	Next
	
	If !lProcessou .And. Len( aLote ) > 0
		
		aRetListBox := MonitorNFSE( cIdEnt, cSerie, aLote, cCNPJIni, cCNPJFim, cMod004 )
		
		For nY := 1 To Len( aRetListBox[3] )
			AADD( aListBox[3], aRetListBox[3,nY] )
		Next
		
		aListBox[1] := ( Len( aListBox[3] ) > 0 )
		aListBox[2] := IIf( !Empty( aRetListBox[2] ), aRetListBox[2], "" )
		
	Endif
	
	If !aListBox[1]
		
		If !Empty( aListBox[ 2 ] )
			
			Aviso( "NFS-e", aListBox[ 2 ], { STR0114 }, 3 )
			
		ElseIf ( Empty( aListBox[ 3 ] ) )
			
			Aviso( "NFS-e", STR0106, { STR0114 } )
			
		Endif
		
	Endif
	
Endif

If Len( aListBox[3] ) > 0
	aListBox[3] := aSort( aListBox[3],,,{|x,y| x[2] > y[2]} )
Endif

Return( aListBox[ 3 ] )