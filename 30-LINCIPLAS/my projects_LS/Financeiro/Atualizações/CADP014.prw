#include "Protheus.ch"

User Function CADP014( _cCodigo, cGrup, cBloq )

Local 	aArea		:= GetArea()
Local 	_aItemSBZ	:= {}
Local 	aFilial		:= {}
Local	cStrFilia	:= ""
Local	cStrFil		:= ""
Local   cTe 		:= ""
Local 	cTs 		:= ""
Local 	cTeC 		:= ""
Local 	cTsC 		:= ""
Local 	cTeF 		:= ""
Local 	cTsF 		:= ""
Local   cGrup		:= ""
Local 	lOk			:= .F.
Local 	cCodFil 	:= ""
Local 	cCodEmp     := ""

AEval(aFilial, {|x| cStrFilia+="'"+Alltrim(x[1])+"'"+"/"})
cStrFil := Substr(cStrFilia,1,Len(cstrFilia)-1)

ChkFile("SM0")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleciona filiais.   					       		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DbSelectArea("SM0")
SM0->( DbSetOrder(1) )
SM0->( DbGoTop() )

cCodEmp := SM0->M0_CODIGO
lInclui := .T.

Do While SM0->( !Eof() ) .And. cCodEmp == "01"
	
	cCodFil := SM0->M0_CODFIL
	
	dbSelectArea("SBZ")
	dbSetOrder(1)
	If DbSeek(cCodFil + _cCodigo,.f.)
		lInclui := .F.
	ELSE
		lInclui := .T.
	ENDIF

	RecLock("SBZ",lInclui) // THIAGO SBZ

	SBZ->BZ_FILIAL	:= cCodFil
	SBZ->BZ_COD		:= _cCodigo
	SBZ->BZ_DESC	:= SB1->B1_DESC
	SBZ->BZ_LOCPAD	:= SB1->B1_LOCPAD
	
	If cCodFil == "01" .OR. cCodFil == "55"
		_cTipEmp := "M"
	ElseIf Substr(SM0->M0_CGC,1,8) $ GetMv("MV_LSVCNPJ")
		_cTipEmp := "F"
	Else
		_cTipEmp := "C"
	EndIf
	
	DbSelectArea("SZQ")
	SZQ->( DbSetOrder(1) )
	If SZQ->( DbSeek(cGrup+_cTipEmp) )
		
		If 	_cTipEmp == "M"
			
			cTe  := SZQ->ZQ_TE
			cTs  := SZQ->ZQ_TS
			
			cTeC := SZQ->ZQ_TEC
			cTsC := SZQ->ZQ_TSC
			
			cTeF := SZQ->ZQ_TE_FORN
			cTsF := SZQ->ZQ_TS_FORN
			
		ElseIf _cTipEmp == "F"
			
			cTe  := SZQ->ZQ_TE
			cTs  := SZQ->ZQ_TS
			
			cTeF := SZQ->ZQ_TE_FORN
			cTsF := SZQ->ZQ_TS_FORN
			
		Else
			
			cTeC := SZQ->ZQ_TEC
			cTsC := SZQ->ZQ_TSC
			
			cTeF := SZQ->ZQ_TE_FORN
			cTsF := SZQ->ZQ_TS_FORN
			
		EndIf
	Else
		cTe := SB1->B1_TE //"002"
		//			cTs := "611"
		cTs := SB1->B1_TS //"706"
	EndIf
	
	/*
	########################################
	#                                      #
	#    Grava os TES na tabela SBZ        #
	#                                      #
	########################################
	*/
	If _cTipEmp == "M"
		
		SBZ->BZ_TE := cTe
		SBZ->BZ_TS := cTs
		
		SBZ->BZ_TEC := cTeC
		SBZ->BZ_TSC := cTsC
		
		SBZ->BZ_TE_FORN := cTeF
		SBZ->BZ_TS_FORN := cTsF
		
	ElseIf _cTipEmp = "F"
		
		SBZ->BZ_TE := cTe
		SBZ->BZ_TS := cTs
		
		SBZ->BZ_TE_FORN := cTeF
		SBZ->BZ_TS_FORN := cTsF
		
	Else
		
		SBZ->BZ_TEC := cTeC
		SBZ->BZ_TSC := cTsC
		
		SBZ->BZ_TE_FORN := cTeF
		SBZ->BZ_TS_FORN := cTsF
		
	EndIf
	
	SBZ->( MsUnlock() )
	
	If !cGrup $ "0010/0100"
		
		If !SB2->(DbSeek(SM0->M0_CODFIL + _cCodigo,.f.))
			RecLock("SB2",.T.)
			SB2->B2_FILIAL	:= SM0->M0_CODFIL
			SB2->B2_COD		:= _cCodigo
			SB2->B2_LOCAL	:= "01"
			SB2->( MsUnlock() )
		EndIf
		
	EndIf
	
	//Endif
	SM0->( DbSkip() )
	
EndDo

//Else

//	lOk := 	.F.

//Endif

RestArea(aArea)
/*
If lOk
	MSGAlert(" Indicador gerado com sucesso!")
Else
	MSGAlert(" Verique se este produto possui Indicador (SBZ) " + char(13)+;
	"ou está bloqueado!")
EndIf
*/
Return
