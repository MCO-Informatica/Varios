#include "protheus.ch"
#INCLUDE "TOPCONN.CH"
#include "RWMAKE.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ACOM002   �Autor  �Giane               � Data �  24/06/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para envio de email ao fornecedor dos pedidos de     ���
���          �compra ja liberados.                                        ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Makeni                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ACOM002()

	Local aAreaAnt := GetArea()

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "ACOM002" , __cUserID )

	Private aCores     := {}
	Private cFiltro
	Private _aIndexSC7 := {}
	Private aCampos := {}

	Private aRotina := {}
	Private cCadastro := "Pedido de Compra - Email ao Fornecedor"
	Private cMarca := GetMark()
	Private cAlias := 'SC7'
	Private bFilBrow   := {|| }
	Private nTipoPed   := 1
	Private l120Auto   := NIL
	Private aAutoCab   := NIL
	Private aAutoItens := NIL
	Private lPedido    := .T.
	Private nFuncao    := 3
	Private inclui     := .f.
	Private abacksc7   := {}

	Private cString := "SC7"
	DbSelectArea("SC7")
	SC7->(DbSetOrder(1))

	AADD(aRotina,{"Pesquisar"   ,"AxPesqui"    ,0,1})
	aadd(aRotina,{"Visualizar"  ,"U_AComVisual",0,2})
	AADD(aRotina,{"Envia Email" ,"U_AComEnvia" ,0,2})
	AADD(aRotina,{"N�o Envia"   ,"U_AComNaoEnv",0,2})
	&&AADD(aRotina,{"Filtro"      ,"U_FilPedCom" ,0,11})

	aCampos := { {"C7_OK"     ,,""},;
		{"C7_NUM"    ,,"Numero"},;
		{"C7_EMISSAO",,"Emiss�o"},;
		{"C7_FORNECE",,"Fornecedor"},;
		{"C7_ITEM"   ,,"Item"},;
		{"C7_PRODUTO",,"Produto"},;
		{"C7_DESCRI" ,,"Descri��o"},;
		{"C7_UM"     ,,"Und"},;
		{"C7_SEGUM"  ,,"Seg.Und"},;
		{"C7_QUANT"  ,,"Qtdade"},;
		{"C7_DATPRF" ,,"Dt.Entrega"}}

	//deixar o filtro do browse somente com os "aguardando envio", se a usu�ria quiser ver todos, usar o botao filtro
	&&cFiltro := "SC7->C7_ENVMAIL == '1'  .AND. SC7->C7_CONAPRO == 'L' "  //VERIFICAR QUAL CAMPO DEFINE SE O PEDIDO AINDA NAO FOI ATENDIDO PELO FORNECEDOR

	&&bFilBrow := { || FilBrowse( "SC7", @_aIndexSC7, @cFiltro, .T. ) }
	&&Eval( bFilBrow )

	U_FilPedCom()

	MARKBROW("SC7","C7_OK",,aCampos,,cMarca,,,,,'U_markPed()')

EndFilBrw( "SC7", _aIndexSC7 )
RestArea(aAreaAnt)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ACOMVISUAL�Autor  �Giane               � Data �  30/06/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina chama a funcao da microsiga que visualiza todos os   ���
���          �dados/detalhes do pedido de compra.                         ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Makeni                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/        
User function ACOMVISUAL()

	A120Pedido('SC7',SC7->(recno()),2 )

EndFilBrw( "SC7", _aIndexSC7 )
_aIndexSC7 := {}

bFilBrow := { || FilBrowse( "SC7", @_aIndexSC7, @cFiltro,.T. ) }
Eval( bFilBrow )
//dbgotop()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FILPEDCOM �Autor  �Giane               � Data �  24/06/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para filtrar o browse de acordo com a situacao do    ���
���          �envio de email ao fornecedor.                               ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Makeni                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FilPedCom()
	Local cPerg := "ACOM002"


	Pergunte(cPerg)

	If MV_PAR01 = 1  // todos
		cFiltro := "SC7->C7_ENVMAIL <> ' '  .AND. SC7->C7_CONAPRO == 'L' "
	Elseif MV_PAR01 = 2  // enviados
		cFiltro := "SC7->C7_ENVMAIL == '3'  .AND. SC7->C7_CONAPRO == 'L' "
	Elseif MV_PAR01 = 3  //nao enviados
		cFiltro := "SC7->C7_ENVMAIL == '2'  .AND. SC7->C7_CONAPRO == 'L' "
	Else //aguardando envio
		cFiltro := "SC7->C7_ENVMAIL == '1'  .AND. SC7->C7_CONAPRO == 'L' "
	Endif

	cFiltro += " .AND. (SC7->C7_QUANT > SC7->C7_QUJE .OR. SC7->C7_RESIDUO = ' ')"

EndFilBrw( "SC7", _aIndexSC7 )
_aIndexSC7 := {}

bFilBrow := { || FilBrowse( "SC7", @_aIndexSC7, @cFiltro,.T. ) }
Eval( bFilBrow )

dbgotop()

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �ACOMNAOENV � Autor � Giane                � Data �30.06.2010���
�����������������������
��������������������������������������������������Ĵ��
���Descri��o �Funcao que marca os pedidos de compras que n�o ser�o        ���
��            enviados email aos fornecedores.                            ���
�������������������������������������������������������������������������Ĵ��
���   USO    �Especifico Makeni                                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function AComNaoEnv
	Local nRecno := Recno()
	Local nCont := 0

	If MsgYesNo(OemToAnsi("Confirma opera��o de N�O enviar email aos fornecedores de todos os pedidos marcados?"))

		dbSelectArea('SC7')
		dbGotop()
		While !Eof()
			If IsMark( 'C7_OK', cMarca )
				If SC7->C7_ENVMAIL == '1'
					RecLock( 'SC7', .F. )
					SC7->C7_ENVMAIL := '2'
					SC7->C7_OK := ""
					MsUnLock()
				Endif
				nCont++
			EndIf

			SC7->(dbSkip())
		Enddo
		SC7->(dbGoto( nRecno ) )

		If nCont == 0
			MsgAlert('Aten��o! Nenhum pedido foi marcado para esta opera��o.')
		Endif

	Endif

Return

/*                                                         
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �MarkPed   � Autor � Giane              � Data �  07/04/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Ao marcar um item do pedido, marcar automaticamente todos  ���
���          � os itens do pedido.                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MarkPed()
	Local nReg, cPed

	nReg := SC7->(Recno())
	cPed := SC7->C7_FILIAL + SC7->C7_NUM
	SC7->(dbseek(cPed))
	Do while !SC7->(eof()) .and. SC7->C7_FILIAL+SC7->C7_NUM == cPed

		Reclock("SC7",.f.)
		if empty(SC7->C7_OK)
			SC7->C7_OK := cMarca
		else
			SC7->C7_OK := space(02)
		endif
		MsUnlock()

		SC7->(DbSkip())
	Enddo
	SC7->(DbGoto(nReg))

	MARKBREFRESH()

Return .t.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ACOMENVIA �Autor  �Giane               � Data �  30/06/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina envia email ao fornecedor do pedido de compra posi   ���
���          �cionado no browse.                                          ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Makeni                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 
User Function ACOMENVIA()
	Local lEnvia := .t.
	Local lEnviado := .t.
	Local nReg
	Local cPed

	Private aEmail := {}
	Private cCopia := space(150)
	Private cRemetente := space(100)

	If SC7->C7_ENVMAIL  == '3'
		If !MsgYesNo("Pedido  " + SC7->C7_NUM + "  j� enviado anteriormente ao fornecedor. Deseja reenviar email? ")
			lEnvia := .f.
		Endif
	Elseif SC7->C7_ENVMAIL  == '2'
		If !MsgYesNo('Pedido  ' + SC7->C7_NUM + '  est� marcado como "NAO enviado".  Confirma envio do email? ')
			lEnvia := .f.
		Endif
		//Else
		// If !MsgYesNo('Pedido  ' + SC7->C7_NUM + '.  Confirma envio do email ao fornecedor? ')
		//    lEnvia := .f.
		// Endif
	Endif

	If !lEnvia
		Return
	Endif

	ACOMTLCON("SA2", SC7->C7_FORNECE, SC7->C7_LOJA)

	if ( len(aEmail) > 0 .or. !empty(cCopia) ) .and. !empty(cRemetente)

		if MsgYesNo( "Deseja abrir o Servi�o de Email ?" )
			If .not. EMAILPED(SC7->C7_NUM, .F. )
				lEnviado := .f.
			endif
		else
			if .not. EMAILPED( SC7->C7_NUM, .T. )
				lEnviado := .f.
				MSGBOX( "O Sistema n�o conseguiu enviar o email. Verifique as configura��es ou utilize o Servi�o de Email." )
			endif
		endif

		If lEnviado //se email foi enviado com sucesso, marca o pedido como "enviado"
			nReg := SC7->(Recno())
			cPed := SC7->C7_FILIAL + SC7->C7_NUM
			SC7->(dbseek(cPed))
			Do while !SC7->(eof()) .and. SC7->C7_FILIAL+SC7->C7_NUM == cPed

				Reclock("SC7")
				SC7->C7_ENVMAIL := '3'
				SC7->C7_OK := ""
				MsUnlock()

				SC7->(DbSkip())
			Enddo
			SC7->(DbGoto(nReg))

		Endif


	Endif

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EMAILPED  �Autor  �Giane               � Data �  30/06/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina envia email ao fornecedor do pedido de compra posi   ���
���          �cionado no browse.                                          ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Makeni                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 

Static Function EmailPed( cNumPed, lAutomatico )
	Local aArea     := GetArea()
	Local lRet      := .T.
	Local cPara     := ""
	Local nI        := 0
	Local cDirDoc   := "c:\temp\"
	Local cFile     := "pedido_de_compra_" + cNumPed + ".pdf"
	Local aAttach   := {}
    Local cFolder := ""

	Private lBlind := .f.

	if lAutomatico == NIL
		lAutomatico := .F.
	endif

	MsgRun("Processando montagem do email, aguarde...","",{|| U_RCOM002(cNumPed,.t.) })

	If .not. (File (cDirDoc+cFile))
		MSGBOX( "Erro na geracao do documento word! Email n�o enviado." )
		return .f.
	Endif

	if len(aEmail) > 0

		For nI:= 1 to len(aEmail)
			cPara += alltrim(aEmail[nI]) + chr(59) //';'
		Next
	Endif

	cCopia := alltrim(cCopia)
	if !empty(cCopia)
		cCopia += chr(59) 
	endif

	if lAutomatico //S� envia a mensagem
		cAssunto := 'Envio do Pedido de Compra Nr. ' + cNumPed + ' '+SM0->M0_NOMECOM
		cTextoEmail := 'Segue anexo o Pedido de Compra Nr. ' + cNumPed
		cFolder := 'word\temp'
		
        CpyT2S( cDirDoc+cFile, cFolder )
        
        cFolder +="\"+cFile

		Aadd(aAttach,cFolder)

		lRet := U_ENVMAILIMCD(cPara,cCopia," ",cAssunto,cTextoEmail,aAttach)

		if file(cFolder)
			FErase(cFolder)
		endif

	Else //utiliza-se do outlook
        cFile := cDirDoc+cFile
		U_ABRENOTES( cPara, {cFile}, cCopia, 'Envio%20Pedido%20Nr.' + cNumPed + '%20'+SM0->M0_NOMECOM )

	endif

	RestArea(aArea)
Return( lRet )


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ACOMTLCON �Autor  �Giane               � Data �  30/06/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina monta tela com os emails dos contatos do fornecedor  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Makeni                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 
Static Function ACOMTLCON(cEnt, cFornec, cLoja)
	Local cTitulo    := ""
	Local cSql       := ""
	Local aHeaderCnt := {}
	//Local nGDOpc     := GD_UPDATE
	Local nOpcA      := 0
	Local oDlg1
	Local nI

	cTitulo := "Pedido de Compras Nr. " + SC7->C7_NUM

	oDlg1                := tDialog():New()
	oDlg1:cName          := "oDlg1"
	oDlg1:cCaption       := cTitulo
	oDlg1:nLeft          := 001
	oDlg1:nTop           := 001
	oDlg1:nWidth         := 550
	oDlg1:nHeight        := 400 //320
	oDlg1:nClrPane       := 16777215
	oDlg1:nStyle         := -2134376320
	oDlg1:bInit          := {|| EnchoiceBar(oDlg1, {|| nOpcA := 1, aAux := aClone(oGdCnt:aCols), oDlg1:End() }, {|| nOpcA := 0, oDlg1:End()}) }
	oDlg1:lCentered      := .T.

	cRemetente := UsrRetMail(__cUserID)

	@ 150, 015 Say "Remetente:" Pixel of oDlg1 //FONT oFnt1
	@ 145, 053 MsGet cRemetente SIZE 200, 10 Pixel of oDlg1 when .f.

	@ 165, 015 Say "C/C:" Pixel of oDlg1 //FONT oFnt1
	@ 160, 053 MSGet cCopia SIZE 200, 10 Pixel of oDlg1

	aCampoSU5N := {"U5_CODCONT","U5_CONTAT","U5_EMAIL"}
	aHeaderCnt := CriaHeader("SU5",aCampoSU5N , , {{" ","_CHK01"}})

	oGDCnt := MsNewGetDados():New(0, 0, 1, 1,/*nGDOpc*/,,,,,,,,,, oDlg1, aHeaderCnt, {})
	oGDCnt:aCols := {}
	oGDCnt:oBrowse:nTop       := 25
	oGDCnt:oBrowse:nLeft      := 02
	oGDCnt:oBrowse:nHeight    := 250
	oGDCnt:oBrowse:nWidth     := 545
	oGDCnt:oBrowse:bLDblClick := {|| }
	oGDCnt:oBrowse:lAdjustColSize := .T.

	nPosChk := GdFieldPos("_CHK01", oGDCnt:aHeader)
	nPosCod := GdFieldPos("U5_CODCONT", oGDCnt:aHeader)
	nPosMail := GdFieldPos("U5_EMAIL", oGDCnt:aHeader)

	cSql := "SELECT " + CpoGrid(oGDCnt) + " "
	cSql += "FROM "
	cSql += "  " + RetSqlName("SU5") + " SU5 JOIN " + RetSqlName("AC8") + " AC8 ON "
	cSql += "    SU5.U5_FILIAL  = '" + xFilial("SU5") + "'    AND "
	cSql += "    SU5.D_E_L_E_T_ = ' '    AND "
	cSql += "    AC8.AC8_FILIAL = '" + xFilial("SU5") + "'    AND "
	cSql += "    AC8.D_E_L_E_T_ = ' '    AND "
	cSql += "    SU5.U5_CODCONT = AC8.AC8_CODCON "
	cSql += "WHERE "
	cSql += "	 AC8.AC8_ENTIDA = '" + cEnt + "' "
	cSql += "  AND AC8.AC8_CODENT = '" + cFornec + cLoja + "' "

	Load_Grid(cSql, oGDCnt, {{"_CHK01", "'LBNO'", .T.}})

	oDlg1:Activate()

	If nOpcA == 1

		If empty(cRemetente)
			MsgAlert('Aten��o! Email do remetente est� em branco no cadastro de usu�rios.')
		Else

			For nI:= 1 to len(oGDCnt:aCols)

				if oGDCnt:aCols[nI,nPosChk] == "LBTIK"
					aadd(aEmail, oGDCnt:aCols[nI,nPosMail] )
				endif
			Next

			If len(aEmail) == 0
				MsgAlert('Aten��o! Nenhum contato do fornecedor foi selecionado para envio do email.')
			Endif
		Endif
	EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Procedure �Load_Grid �Autor  �Fabricio E. da Costa� Data �  11/03/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Carrega o grid passado em oGetDados, com os registros       ���
���          �retornados pela query passada em cSql.                      ���
���          �                                                            ���
���          �Parametros:                                                 ���
���          �  cSql.....: Query que retorna os registros para o grid     ���
���          �  oGetDados: Objeto NewGetDados que ira receber os resgitros���
���          �                                                            ���
���          �Retorno:                                                    ���
���          �   Nil                                                      ���
���          �                                                            ���
���          �Observacao:                                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GERAL                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
	Static Procedure Load_Grid(cSql, oGetDados, aCheck, aLegenda)
	Local cAction   := ""
	Local cMultSel  := ""
	Local cSingSel  := ""
	Local cCont     := ""
	Local bAddDados := "{|| AAdd(oGetDados:aCols, {"
	Local nPosChk   := 0
	Local i

	Default aCheck   := {}
	Default aLegenda := {}

	TCQuery cSql NEW ALIAS "TMP1"
	For i := 1 To Len(oGetDados:aHeader)
		If "_CHK" $ oGetDados:aHeader[i,2]
			nPosChk   := aScan(aCheck, {|aItem| AllTrim(aItem[1]) == oGetDados:aHeader[i,2]})
			bAddDados += aCheck[nPosChk, 2] + ", "
		ElseIf "_LEG" $ oGetDados:aHeader[i,2]
			nPosChk   := aScan(aLegenda, {|aItem| AllTrim(aItem[1]) == oGetDados:aHeader[i,2]})
			bAddDados += aLegenda[nPosChk, 2] + ", "
		Else
			If oGetDados:aHeader[i,8] $ "N/D" //Acerta campos numericos e datas na query
				TCSetField("TMP1", oGetDados:aHeader[i,2], oGetDados:aHeader[i,8], oGetDados:aHeader[i,4],oGetDados:aHeader[i,5])
			EndIf
			bAddDados += oGetDados:aHeader[i,2] + ", "
		EndIf
	Next
	bAddDados += ".F.})}"

	bAddDados := &bAddDados.
	oGetDados:aCols := {}
	TMP1->(DbEval(bAddDados))
	TMP1->(DbCloseArea())
	// Define a a��o lDblClick da getdados para marcar e desmarcar os checkboxs

	For i := 1 To Len(aCheck)
		nPosChk  := aScan(aCheck, {|aItem| AllTrim(aItem[1]) == oGetDados:aHeader[i,2]})
		cMultSel += Iif(aCheck[i,3], "/" + StrZero(nPosChk,3) + "/", "")
		cSingSel += Iif(!aCheck[i,3], "/" + StrZero(nPosChk,3) + "/", "")
	Next
	cMultSel := Iif(Empty(cMultSel), "*", cMultSel)
	cSingSel := Iif(Empty(cSingSel), "*", cSingSel)

	cBloco  := "{|aItem| oGetDados:aCols[nItem,oGetDados:oBrowse:nColPos] := Iif(nItem == oGetDados:nAt, Iif(aItem[oGetDados:oBrowse:nColPos] == 'LBNO', 'LBTIK', 'LBNO'), 'LBNO'), nItem++}"
	cInicio := "Iif(StrZero(oGetDados:oBrowse:nColPos,3) $ '" + cMultSel + "', oGetDados:nAt, 1)"
	cCont   := "Iif(StrZero(oGetDados:oBrowse:nColPos,3) $ '" + cMultSel + "', 1, Iif(StrZero(oGetDados:oBrowse:nColPos,3) $ '" + cSingSel + "', Len(oGetDados:aCols), 0))"
	cAction := "nItem := Iif(StrZero(oGetDados:oBrowse:nColPos,3) $ '" + cMultSel + "', oGetDados:nAt, 1), aEval(oGetDados:aCols, " + cBloco + ", " + cInicio + ", " + cCont + "), oGetDados:oBrowse:Refresh()"

	//cAction := "oGetDados:aCols[oGetDados:nAt,oGetDados:oBrowse:nColPos] := Iif('_CHK' $ oGetDados:aHeader[oGetDados:oBrowse:nColPos,2], Iif(oGetDados:aCols[oGetDados:nAt,oGetDados:oBrowse:nColPos] == 'LBNO', 'LBTIK', 'LBNO'),oGetDados:aCols[oGetDados:nAt,oGetDados:oBrowse:nColPos])"
	If Len(aCheck) > 0 .And. Len(oGetDados:aCols) > 0 .And. At(Upper(cAction), GetCbSource(oGetDados:oBrowse:bLDblClick)) == 0
		oGetDados:oBrowse:bLDblClick := &(BAddExp(oGetDados:oBrowse:bLDblClick, cAction))
	EndIf
	oGetDados:oBrowse:Refresh()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �CpoGrid   �Autor  �Fabricio E. da Costa� Data �  18/03/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Cria a lista de campos de um aHeader.                       ���
���          �                                                            ���
���          �Parametros:                                                 ���
���          �  oGetDados: Objeto NewGetDados que ser� gerada a lista de  ���
���          �  campos.                                                   ���
���          �                                                            ���
���          �Retorno:                                                    ���
���          �   Nil                                                      ���
���          �                                                            ���
���          �Observacao:                                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GERAL                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CpoGrid(oGetDados)
	Local cCampos := ""

	aEval(oGetDados:aHeader, {|aItem| cCampos += Iif(Left(aItem[2], 4) $ "_CHK/_LEG", "", aItem[2] + ", ")}, 1, Len(oGetDados:aHeader) - 1) // gera a lista de campos da select
	cCampos += Iif(Left(aTail(oGetDados:aHeader)[2], 4) $ "_CHK/_LEG", "", aTail(oGetDados:aHeader)[2])

Return cCampos

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �CriaHeader�Autor  �Fabricio E. da Costa� Data �  12/03/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Cria o aHeader que ser� utilizado pela NewGetDados.         ���
���          �                                                            ���
���          �Parametros:                                                 ���
���          �  cAlias...: Alias que sera criado o aHeader                ���
���          �  aCamposS.: Array contendo os campos do Alias a serem      ���
���          �             exibidos.                                      ���
���          �  aCamposN.: Array contendo os campos do Alias a serem      ���
���          �             suprimidos do Alias.                           ���
���          �  lCheck...: Indica se o grid ter� checkbox (.T.Sim/.F.N�o).���
���          �  lRecno...: Indica se o grid ter� Recno dos registros      ���
���          �                                                            ���
���          �Retorno:                                                    ���
���          �  aHeader..: aHeader contendo os campos do Alias            ���
���          �             especificado.                                  ���
���          �                                                            ���
���          �Observacao:                                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GERAL                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CriaHeader(cAlias, aCamposS, aCamposN, aCheck, lRecno)
	Local aHeader := {}
	Local nI 	  := 0
	local nX as numeric
	Local aSx3 := {}

	Default aCamposS := {}
	Default aCamposN := {}
	Default aCheck   := {}
	Default lRecno   := .F.

	For nI := 1 To Len(aCheck)
		Aadd(aHeader, Nil)
		aHeader[Len(aHeader)] := Array(17)
		aFill(aHeader[Len(aHeader)], " ")
		aHeader[Len(aHeader), 01] := AllTrim(aCheck[nI,1])
		aHeader[Len(aHeader), 02] := AllTrim(aCheck[nI,2])
		aHeader[Len(aHeader), 03] := "@BMP"
		aHeader[Len(aHeader), 04] := 03
		aHeader[Len(aHeader), 05] := 00
		aHeader[Len(aHeader), 08] := "C"
		aHeader[Len(aHeader), 10] := "V"
		aHeader[Len(aHeader), 14] := "V"
	Next

	nX := 0

	aSX3 := FWSX3Util():GetAllFields(cAlias, .F.)

	for nX := 1 to len(aSx3)
		If X3Uso(GetSx3Cache(aSx3[nX],"X3_USADO")) .And. GetSx3Cache(aSx3[nX],"X3_TIPO") <> "M" .And. GetSx3Cache(aSx3[nX],"X3_CONTEXT") <> "V" .And. cNivel >= GetSx3Cache(aSx3[nX],"X3_NIVEL") .And.;
				(aScan(aCamposS, AllTrim(GetSx3Cache(aSx3[nX],"X3_CAMPO"))) > 0 .Or. Len(aCamposS) == 0) .And. (aScan(aCamposN, AllTrim(GetSx3Cache(aSx3[nX],"X3_CAMPO"))) == 0 .Or. Len(aCamposN) == 0)
			Aadd(aHeader, {})
			Aadd(aHeader[Len(aHeader)], AllTrim(GetSx3Cache(aSx3[nX],"X3_TITULO")))
			Aadd(aHeader[Len(aHeader)], AllTrim(GetSx3Cache(aSx3[nX],"X3_CAMPO")))
			Aadd(aHeader[Len(aHeader)], GetSx3Cache(aSx3[nX],"X3_PICTURE"))
			Aadd(aHeader[Len(aHeader)], GetSx3Cache(aSx3[nX],"X3_TAMANHO"))
			Aadd(aHeader[Len(aHeader)], GetSx3Cache(aSx3[nX],"X3_DECIMAL"))
			Aadd(aHeader[Len(aHeader)], GetSx3Cache(aSx3[nX],"X3_VALID"))
			Aadd(aHeader[Len(aHeader)], GetSx3Cache(aSx3[nX],"X3_USADO"))
			Aadd(aHeader[Len(aHeader)], GetSx3Cache(aSx3[nX],"X3_TIPO"))
			Aadd(aHeader[Len(aHeader)], GetSx3Cache(aSx3[nX],"X3_F3"))
			Aadd(aHeader[Len(aHeader)], GetSx3Cache(aSx3[nX],"X3_CONTEXT"))
			Aadd(aHeader[Len(aHeader)], GetSx3Cache(aSx3[nX],"X3_CBOX"))
			Aadd(aHeader[Len(aHeader)], GetSx3Cache(aSx3[nX],"X3_RELACAO"))
			Aadd(aHeader[Len(aHeader)], GetSx3Cache(aSx3[nX],"X3_WHEN"))
			Aadd(aHeader[Len(aHeader)], GetSx3Cache(aSx3[nX],"X3_VISUAL"))
			Aadd(aHeader[Len(aHeader)], GetSx3Cache(aSx3[nX],"X3_VLDUSER"))
			Aadd(aHeader[Len(aHeader)], GetSx3Cache(aSx3[nX],"X3_PICTVAR"))
			Aadd(aHeader[Len(aHeader)], X3Obrigat(GetSx3Cache(aSx3[nX],"X3_CAMPO")))
		EndIf

	next nX

	If lRecno
		Aadd(aHeader, Nil)
		aHeader[Len(aHeader)] := Array(17)
		aFill(aHeader[Len(aHeader)], " ")
		aHeader[Len(aHeader),01] := "RECNO"
		aHeader[Len(aHeader),02] := "R_E_C_N_O_"
		aHeader[Len(aHeader),03] := "99999999999"
		aHeader[Len(aHeader),04] := 10
		aHeader[Len(aHeader),05] := 00
		aHeader[Len(aHeader),08] := "N"
		aHeader[Len(aHeader),10] := "V"
		aHeader[Len(aHeader),14] := "V"
	EndIf

Return aClone(aHeader)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �BAddExp   �Autor  �Fabricio E. da Costa� Data �  17/03/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Adiciona uma express�o a lista de um codeblock.             ���
���          �                                                            ���
���          �Parametros:                                                 ���
���          �  bVal.....: Codeblock que ser� inserida a expressao.       ���
���          �  cExp.....: Express�o a ser inserida no codeblock.         ���
���          �  nLocal...: Local em que ser� inserida a expressao         ���
���          �             0-Inicio 1-Final                               ���
���          �                                                            ���
���          �Retorno:                                                    ���
���          �  cRet.....: Indica se a lista de express�es do codeblock   ���
���          �             esta vazia(.T.) ou n�o (.F.)                   ���
���          �                                                            ���
���          �Observacao:                                                 ���
���          �  O valor retornado � uma string, pois codeblocks n�o podem ���
���          �ser utilizados como retorno de fun��o.                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GERAL                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function BAddExp(bVal, cExp, nLocal)
	Local cBlock  := ""
	Local nPos    := 0

	Default nLocal := 1

	cBlock := GetCbSource(bVal)
	nPos   := Iif(nLocal = 0, Rat("|", cBlock) + 1, Rat("}", cBlock))
	If !BEmpty(bVal)
		cBlock := Stuff(cBlock, nPos, 0, Iif(nLocal = 0, cExpA + ", ", ", " + cExp))
	Else
		cBlock := Stuff(cBlock, nPos, 0, cExp)
	EndIf

Return cBlock

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �BEmpty    �Autor  �Fabricio E. da Costa� Data �  17/03/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Avalia se a lista de express�es de um code block esta vazia ���
���          �ou n�o.                                                     ���
���          �                                                            ���
���          �Parametros:                                                 ���
���          �  bVal.....: Codeblock a ser avaliado.                      ���
���          �                                                            ���
���          �Retorno:                                                    ���
���          �  lRet.....: Indica se a lista de express�es do codeblock   ���
���          �             esta vazia(.T.) ou n�o (.F.)                   ���
���          �                                                            ���
���          �Observacao:                                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GERAL                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function BEmpty(bVal)
	Local cLista  := ""
	Local nInicio := 0
	Local nFinal  := 0

	cLista  := GetCbSource(bVal)
	If !Empty(cLista)
		nInicio := Rat("|", cLista) + 1
		nFinal  := Rat("}", cLista) - 1
		cLista  := SubStr(cLista, nInicio, Len(cLista) - nFinal)
	EndIf

Return Empty(cLista)
