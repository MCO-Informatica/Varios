#include "PROTHEUS.CH"
#INCLUDE "topconn.ch"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMEST001   บAutor  ณ  Daniel   Gondran  บ Data ณ  31/08/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para gerar o codigo do produto com base no Tipo,    บฑฑ
ฑฑบ          ณ Familia, Grupo, Nacionalidade e Embalagem                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Makeni                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function MEST001( cTipo , cFam, cGrupo, cNacion, cEmb )
Local cAlias := Alias()
Local cCodigo:= Space(15)
Local cRet   := Space(15)

	if !(isincallstack("U_IMPCADVQ"))

		if CEMPANT $ '01|03'
			If !Empty( cTipo + cFam + cGrupo + cNacion + cEmb )
		DbSelectArea("SZ3")
		DbSetOrder(1)
		DbGoTop()
				If DbSeek( xFilial("SZ3") + cTipo + cFam + cGrupo + cNacion + cEmb )
			//		If cTipo <> "PA"
			cCodigo := Soma1( AllTrim(SZ3->Z3_NUMSEQ), 3 )
			//		Else                                                                         ?
			//			cCodigo := "000"
			//		Endif
			RecLock( "SZ3", .F. )
			SZ3->Z3_NUMSEQ := cCodigo
			MsUnLock()
			cRet := cTipo + cFam + cGrupo + cNacion + cEmb + cCodigo
				Else
			RecLock( "SZ3", .T. )
			SZ3->Z3_FILIAL 	:= xFilial("SZ3")
			SZ3->Z3_COD 	:= cTipo + cFam + cGrupo + cNacion + cEmb
			SZ3->Z3_NUMSEQ 	:= "000"
			MsUnLock()
			cRet := cTipo + cFam + cGrupo + cNacion + cEmb + "000"
				EndIf
			EndIf
		ELSEIF CEMPANT $ '02|04'
	
			If !Empty( cFam )
		cRet := BscProximo(cFam)
		/*  Carla informou que nใo havera mais regra
				If cTipo = 'VE'
		cRet := BscProximo(cTipo)
				Elseif cTipo = 'FO'
		cRet := BscProximo(cTipo)
				Elseif cTipo = '12'
		cRet := BscProximo(cTipo)
				Elseif cTipo = 'AM'
		cRet := BscProximo(cTipo)
		//		Elseif cTipo $ 'SV|MC'
		//			cRet := BscProximo(cTipo+cGrupo)
				Elseif !Empty( cTipo + cFam + cGrupo + cNacion + cEmb )
		cRet := cTipo + cFam + cGrupo + cNacion + cEmb
		cRet := BscProximo(cRet)
				Endif
		*/
			ENDIF

		ENDIF
	ENDIF

	DbSelectArea( cAlias )
Return( cRet )


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  ณFILHO     บAutor  ณ  Daniel   Gondran  บ Data ณ  15/04/11                              บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para dado um produto pai, volta o c๓digo do granel                             บฑฑ
ฑฑบ          ณ filho com base na estrutura.                                                          บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ U_FILHO(SC2->C2_PRODUTO,POSICIONE("SC2",1,XFILIAL("SC2") + M->D3_OP,"C2_LOTECTL"),1)  บฑฑ
ฑฑบ          ณ nCampo = 1, volta a data fabricacao, 2, volta a data de validade                      บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function Filho (cCod,cLote,nCampo)
Local aArea 	:= GetArea()
Local _nReg1	:= SG1->( recno() )
Local _nReg2	:= SB8->( recno() )
Local _nReg3	:= SB1->( recno() )

Local cRet 		:= ""
Local dDataRet 	:= Ctod("  /  /  ")

dbSelectArea("SG1")
dbSetOrder(1)
dbSeek(xFilial("SG1") + cCod)
	do While !Eof() .and. SG1->G1_FILIAL == xFilial("SG1") .and. SG1->G1_COD == cCod
		If "GRANEL" $ Posicione("SB1",1,xFilial("SB1") + SG1->G1_COMP,"B1_DESC")
		cRet := SG1->G1_COMP
		Exit
		Endif
	dbSkip()
	Enddo

dbSelectArea("SB8")
dbSetOrder(5)
dbSeek(xFilial("SB8") + cRet + cLote)
	do While !Eof() .and. SB8->B8_FILIAL == xFilial("SB8") .and. SB8->B8_PRODUTO == cRet .and. SB8->B8_LOTECTL == cLote
		If Empty(dDataRet)
			If nCampo == 1
			dDataRet := SB8->B8_DFABRIC
			ElseIf nCampo == 2
			dDataRet := SB8->B8_DTVALID
			Endif
		Endif
	dbSkip()
	Enddo

SG1->( dbgoto( _nReg1 ) )
SB8->( dbgoto( _nReg2 ) )
SB1->( dbgoto( _nReg3 ) )
RestArea(aArea)
Return(dDataRet)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ PRITEMP  บAutor  ณ  Daniel   Gondran  บ Data ณ  25/04/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Pega a primeira temperatura digitada nas medicoes do dia   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Inicializador padrao do LB3_TEMP1                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function PRITEMP
Local cQuery
Local nTemp1 := 0

cQuery := "SELECT LB3_TEMP1 TEMP1 FROM  "+RetSQLName("LB3")
cQuery += " WHERE R_E_C_N_O_ IN ( SELECT MIN(R_E_C_N_O_) FROM "+RetSQLName("LB3")
cQuery += " WHERE LB3_FILIAL = '"+xFilial("LB3")+"'"
cQuery += "  AND  LB3_DATA = '" + DTOS(dDataBase) + "'"
cQuery += "  AND D_E_L_E_T_ = ' ')"

cQuery := ChangeQuery(cQuery)

	If Select("XTMP") > 0
	("XTMP")->( dbCloseArea() )
	EndIf
TcQuery cQuery ALIAS "XTMP" NEW

nTemp1 := XTMP->TEMP1
XTMP->( dbCloseArea() )

Return (nTemp1)


Static Function BscProximo(cTipo)

Local cQuery :=""
Local cAlias := GetNextAlias()
cQuery :=" SELECT MAX(B1_COD) MAIOR "
cQuery +=" FROM  "+RetSQLName("SB1")
cQuery +=" WHERE B1_FAM = '"+cTipo+"' "
cQuery +=" AND B1_FILIAL = '"+xFilial("SB1")+"' "
cQuery +=" AND D_E_L_E_T_ <> '*'

cQuery := ChangeQuery(cQuery)

	If Select(cAlias) > 0
	(cAlias)->( dbCloseArea() )
	EndIf

TcQuery cQuery ALIAS (cAlias) NEW

cCod := ALLTRIM((cAlias)->MAIOR)

(cAlias)->( dbCloseArea() )

	If EMPTY(cCod)
	
	cSeq := cTipo+StrZero( 0, 8-LEN(cTipo) )
	
	else
	
		if cTipo = "VE"
		nPos := 3
		nTam := LEN(cCod) - nPos
		cTipo := SUBSTR( cCod, 1,nPos)
		elseif cTipo = "FO"
		nPos := 4
		nTam := LEN(cCod) - nPos
		cTipo := SUBSTR( cCod, 1,nPos)
		ELSE
		nPos := 2
		nTam := LEN(cCod) - nPos
		endif
	
	cSeq := cTipo+Strzero(val(Substr(cCod,nPos+1,nTam))+1,nTam)
	
	//cSeq 	:= Soma1( cCod, nTam )
	endif
Return (cSeq)
