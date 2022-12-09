#Include "RwMake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TELACOMBO ºAutor  ³Gabriel Ribdeiro    º Data ³  08/31/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CadCombo()
Local cCadastro := "Cadastro de Combo"
Private aRotina := MenuDef()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta mBrowse padrao Protheus     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
mBrowse( 6,1,22,75,"SZI")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TELACOMBO ºAutor  ³Gabriel Ribdeiro    º Data ³  08/31/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TelaComb(cAlias,nReg,nOpc)
Local cTitulo		:=""
Local nOpcE			:= nOpc
Local nOpcG  		:= nOpc
Local _ni			:= 0
LOCAL aCpoEnChoice:= {}
Local cCampo		:= ""
Local cQryDA1		:= ""
Local lCpAtivo	:= .T.
Local lXdsSit		:= .T.
Local nColReno	:= 0
Local nColManu	:= 0
Local nColParc	:= 0
Local nPreReno	:= 0
Local nTxManu 	:= 0
Local nTxParc  	:= 0
Local dDataVig	:= dDatabase
Local cAtivo		:= "1"
Local nI := 0
Local nJ := 0
Private oMsGet
Private oGetDados

DbSelectArea("SX3")
DbSetOrder(2)
//If !DbSeek("ZI_ATIVO")
//	lCpAtivo := .F.
//EndIf

If !DbSeek("DA1_XDSSIT")
	lXdsSit := .F.
EndIf

DbSelectArea("SZI")
DbSetOrder(1)

//+--------------------------------------------------------------+
//| Cria variaveis M->????? da Enchoice                          |
//+--------------------------------------------------------------+
RegToMemory("SZI",(nOpc==3))

If nOpc == 6
	M->ZI_COMBO := GetSxeNum('SZI','ZI_COMBO')
	M->ZI_ATIVO := "2"
EndIf

//+--------------------------------------------------------------+
//| Cria aHeader e aCols da GetDados                             |
//+--------------------------------------------------------------+
nUsado:=0
dbSelectArea("SX3")
DbSetOrder(1)
DbSeek("SZJ")
aHeader:={}
While !Eof().And.(x3_arquivo=="SZJ")
	If Alltrim(x3_campo)=="ZJ_COMBO"
		dbSkip()
		Loop
	Endif
	If X3USO(x3_usado) .And. cNivel >= x3_nivel
		nUsado := nUsado+1
		Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
		x3_tamanho, x3_decimal,"AllwaysTrue()",;
		x3_usado, x3_tipo, x3_arquivo, x3_context } )
	Endif
	dbSkip()
End

If nOpc==3
	aCols:={Array(nUsado+1)}
	aCols[1,nUsado+1]:=.F.
	For _ni:=1 to nUsado
		aCols[1,_ni]:=CriaVar(aHeader[_ni,2])
	Next
Else
	aCols:={}
	dbSelectArea("SZJ")
	dbSetOrder(1)
	SZJ->(dbSeek((xFilial("SZJ")+SZI->ZI_COMBO)))
	While !eof().and. SZJ->ZJ_COMBO == SZI->ZI_COMBO
		AADD(aCols,Array(nUsado+1))
		For _ni := 1 to nUsado
			aCols[Len(aCols),_ni]:=FieldGet(FieldPos(aHeader[_ni,2]))
		Next _ni
		aCols[Len(aCols),nUsado+1]:=.F.
		dbSkip()
	End
Endif

If Len(aCols)>0
	
	//+--------------------------------------------------------------+
	//| Executa a Modelo 3                                           |
	//+--------------------------------------------------------------+
	cTitulo			:= "Tela de Cadastro de Combos"
	cAliasEnchoice	:= "SZI"
	cAliasGetD		:= "SZJ"
	cLinOk			:= "AllwaysTrue()"
	cTudOk			:= "U_VlTudoOK()"
	cFieldOk		:= "U_ValidCalc()"
	
	If nOpc == 6
		_lRet := CertMod3(cTitulo,cAliasEnchoice,cAliasGetD,{},cLinOk,cTudOk,,,cFieldOk,,Len(aCols),{},,,,,{"ZJ_PRETAB"})
	Else
		_lRet := CertMod3(cTitulo,cAliasEnchoice,cAliasGetD,{},cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk,,Len(aCols))
	EndIf
	
	//+--------------------------------------------------------------+
	//| Executar processamento                                       |
	//+--------------------------------------------------------------+
	
	If _lRet
		//Renato Ruy - 06/04/2017
		//Pacote de melhorias na tabela de preço.
		//Busca preco de renovacao e grava na DA1.
		nColReno := aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_PRERENO"})
		nColManu := aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_TXMANU"})
		nColParc := aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_TXPARC"})
		
		For nI := 1 To Len(aCols)
			nPreReno += aCols[nI,nColReno]
			nTxManu  := Iif(Empty(aCols[nI,nColManu]),nTxManu,aCols[nI,nColManu])
			nTxParc  := Iif(Empty(aCols[nI,nColParc]),nTxParc,aCols[nI,nColParc])
		Next
		
		If nOpc == 3 .Or. nOpc == 6    // Inclusão
			//Grava Enchoice
			RecLock("SZI",.T.)
			SZI->ZI_COMBO	:= M->ZI_COMBO
			SZI->ZI_TABPRE	:= M->ZI_TABPRE
			SZI->ZI_DESCPRE	:= M->ZI_DESCPRE
			SZI->ZI_OBSERV	:= M->ZI_OBSERV
			SZI->ZI_PROKIT	:= M->ZI_PROKIT
			SZI->ZI_DESCKIT	:= M->ZI_DESCKIT
			SZI->ZI_PROGAR	:= M->ZI_PROGAR
			SZI->ZI_DESCGAR	:= M->ZI_DESCGAR
//			If lCpAtivo
				SZI->ZI_ATIVO	:= Iif( nOpc == 6, "2", M->ZI_ATIVO )
//			Else
				SZI->ZI_BLOQUE	:= M->ZI_BLOQUE
//			EndIf
			SZI->ZI_PREVEN	:= M->ZI_PREVEN
			SZI->ZI_NUMPAR	:= M->ZI_NUMPAR
			SZI->ZI_KITCOMB := M->ZI_KITCOMB
			If M->ZI_KITCOMB = "S"
				SZI->ZI_XTIPINT := "I"
			EndIf
			SZI->ZI_XDTINT  := ""
			SZI->(MSUnlock())
			//Grava Acols
			For nI := 1 to Len(aCols)
				RecLock("SZJ",.T.)
				SZJ->ZJ_COMBO  := M->ZI_COMBO
				For nJ := 1 to Len(aHeader)
					cCampo := aHeader[nJ,2]
					SZJ->&cCampo := aCols[nI,nJ]
				Next nJ
				SZJ->(MSUnlock())
			Next nI
			
			DbSelectArea("DA1")
			DbSetOrder(3)
			
			cQryDA1 := "SELECT MAX(DA1_ITEM) DA1_ITEM "
			cQryDA1 += "FROM " + RetSqlName("DA1") + " "
			cQryDA1 += "WHERE DA1_FILIAL = '" + xFilial("DA1") + "' "
			cQryDA1 += "  AND DA1_CODTAB = '" + SZI->ZI_TABPRE + "' "
			cQryDA1 += "  AND D_E_L_E_T_ = ' ' "
			
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryDA1),"QRYDA1",.F.,.T.)
			DbSelectArea("QRYDA1")
			
			//Renato Ruy - 27/12/2017
			//Gera data de vigencia diferente para combo com mesmo produto Protheus.
			//Se não existe produto Gar igual e ativo
			DA1->(DbSetOrder(1))
			If DA1->(DbSeek(xFilial("DA1")+SZI->ZI_TABPRE+SZI->ZI_PROKIT))
				
				While SZI->ZI_TABPRE == DA1->DA1_CODTAB .And. AllTrim(DA1->DA1_CODPRO) == AllTrim(SZI->ZI_PROKIT)
					
					If AllTrim(DA1->DA1_CODGAR)	== AllTrim(SZI->ZI_PROGAR) .And. DA1->DA1_ATIVO == "1"
						cAtivo := "2"
					Endif
					
					If DA1->DA1_DATVIG	== dDataVig
						dDataVig := dDataVig - 1
						DA1->(DbGoTop())
						DA1->(DbSeek(xFilial("DA1")+SZI->ZI_TABPRE+SZI->ZI_PROKIT))
					Endif
					
					DA1->(DbSkip())
				Enddo
				
			Endif
			
			RecLock("DA1", .T.)                       
			DA1->DA1_CODTAB	:= SZI->ZI_TABPRE
			DA1->DA1_ITEM	:= Soma1(QRYDA1->DA1_ITEM)
			DA1->DA1_CODPRO	:= SZI->ZI_PROKIT
			DA1->DA1_CODCOB	:= SZI->ZI_COMBO
			DA1->DA1_CODGAR	:= SZI->ZI_PROGAR
			DA1->DA1_DESGAR	:= SZI->ZI_DESCGAR
			DA1->DA1_PRCVEN	:= SZI->ZI_PREVEN
			//Renato Ruy - 25/07/2018
			//Grava as parcelas através do combo
			DA1->DA1_NUMPAR	:= SZI->ZI_NUMPAR
			DA1->DA1_ATIVO	:= cAtivo
			DA1->DA1_DATVIG	:= dDataVig
			If lXdsSit
				DA1->DA1_XDSSIT	:= Posicione("SB1", 1, xFilial("SB1") + SZI->ZI_PROKIT, "B1_DESC")
			EndIf
			DA1->DA1_TPOPER	:= "4"
			DA1->DA1_QTDLOT	:= 999999.99
			DA1->DA1_XPRCRE	:= nPreReno
			DA1->DA1_TXMANU	:= nTxManu
			DA1->DA1_TXPARC	:= nTxParc
			DA1->DA1_MOEDA	:= 1
			DA1->(MsUnLock())
			
			DbSelectArea("QRYDA1")
			QRYDA1->(DbCloseArea())
		
		ElseIf nOpc == 4  //Alterar
			
			oGetDados:nMax := Len(aCols)
			
			cQuery := " DELETE FROM " + RetSqlName("SZI")
			cQuery += " WHERE ZI_COMBO = '" + M->ZI_COMBO+"'"
			
			TcSqlExec( cQuery )
			
			cQuery := " DELETE FROM " + RetSqlName("SZJ")
			cQuery += " WHERE ZJ_COMBO = '" + M->ZI_COMBO+"'"
			
			TcSqlExec( cQuery )
			
			//Grava Enchoice
			RecLock("SZI",.T.)
			SZI->ZI_COMBO	:= M->ZI_COMBO
			SZI->ZI_TABPRE	:= M->ZI_TABPRE
			SZI->ZI_DESCPRE	:= M->ZI_DESCPRE
			SZI->ZI_OBSERV	:= M->ZI_OBSERV
			SZI->ZI_PROKIT	:= M->ZI_PROKIT
			SZI->ZI_DESCKIT	:= M->ZI_DESCKIT
			SZI->ZI_PROGAR	:= M->ZI_PROGAR
			SZI->ZI_DESCGAR	:= M->ZI_DESCGAR
//			If lCpAtivo
				SZI->ZI_ATIVO	:= M->ZI_ATIVO
//			Else
				SZI->ZI_BLOQUE	:= M->ZI_BLOQUE
//			EndIf
			SZI->ZI_PREVEN	:= M->ZI_PREVEN
			SZI->ZI_NUMPAR	:= M->ZI_NUMPAR
			SZI->ZI_KITCOMB := M->ZI_KITCOMB
			If M->ZI_KITCOMB = "S"
				SZI->ZI_XTIPINT := "A"
			Endif
			SZI->ZI_XDTINT  := ""
			SZI->(MSUnlock())
			//Grava Acols
			For nI := 1 to Len(aCols)
				RecLock("SZJ",.T.)
				SZJ->ZJ_COMBO  := M->ZI_COMBO
				For nJ := 1 to Len(aHeader)
					cCampo := aHeader[nJ,2]
					SZJ->&cCampo := aCols[nI,nJ]
				Next nJ
				SZJ->(MSUnlock())
			Next nI
			
			
		ElseIf  nOpc == 5 // Excluir
			If Iif(lCpAtivo, M->ZI_ATIVO == "1", M->ZI_BLOQUE == "S") // Estiver como 'Sim'
				MsgStop("Este Combo esta ativo, e não poderá ser excluído!")
			Else
				cQuery := " UPDATE " + RetSqlName("SZI")
				cQuery += " SET " + cCampo
				cQuery += " D_E_L_E_T_ = '*', "
				If M->ZI_KITCOMB = "S"
					cQuery += " ZI_XTIPINT = 'E', "
				Endif
				cQuery += " ZI_XDTINT = ' ' "
				cQuery += " WHERE ZI_COMBO = '" + M->ZI_COMBO+"'"
				
				TcSqlExec( cQuery )
				
				cQuery := " UPDATE " + RetSqlName("SZJ")
				cQuery += " SET " + cCampo
				cQuery += " D_E_L_E_T_ = '*' "
				cQuery += " WHERE ZJ_COMBO = '" + M->ZI_COMBO+"'"
				
				TcSqlExec( cQuery )

				If Select("QRYDA1") > 0
					DbSelectArea("QRYDA1")
					QRYDA1->(DbCloseArea())
				EndIf

				cQuery := "SELECT R_E_C_N_O_ RECDA1 "
				cQuery += "FROM " + RetSqlName("DA1") + " "
				cQuery += "WHERE DA1_FILIAL = '" + xFilial("DA1") + "' "
				cQuery += "  AND DA1_CODTAB = '" + M->ZI_TABPRE + "' "
				cQuery += "  AND DA1_CODPRO = '" + M->ZI_PROKIT + "' "
				cQuery += "  AND DA1_CODCOB = '" + M->ZI_COMBO + "' "
				cQuery += "  AND DA1_CODGAR = '" + M->ZI_PROGAR + "' "
				cQuery += "  AND D_E_L_E_T_ = ' ' "
				
				dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"QRYDA1",.F.,.T.)

				DbSelectArea("QRYDA1")
					
				If QRYDA1->(!Eof())

					DbSelectArea("DA1")
					DbGoTo(QRYDA1->RECDA1)
					DA1->( RecLock("DA1",.F.) )
					DA1->(DbDelete())
					DA1->( MsUnLock() )
					
				EndIf
				DbSelectArea("QRYDA1")
				QRYDA1->(DbCloseArea())
			Endif
		EndIF
	Endif
Endif             

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ConsKit   ºAutor  ³Gabriel Ribdeiro    º Data ³  08/31/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao criada para popular o aCols com os itens do combo e  º±±
±±º          ³carregar as descricoes dos produtos informados na enchoice  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Opvs x Certisign                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ConsKit()
Local nI		:= 0
Local nPosPrT	:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_PRETAB"})
Local nPosItem	:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_ITEM"})
Local nPosOri	:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_ITEMORI"})
Local nPosProd	:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_CODPROD"})
Local cCodKit	:= M->ZI_PROKIT
Local cItemOri	:= ""
//carrega SG1 para acols de combo
g12acols(M->ZI_PROKIT,@aCols)

If Empty(M->ZI_DESCKIT)
	M->ZI_DESCKIT := Posicione("SB1", 1, xFilial("SB1") + M->ZI_PROKIT, "B1_DESC")
EndIf

If Empty(M->ZI_DESCGAR)
	M->ZI_DESCGAR := Posicione('PA8',1,xFilial('PA8')+M->ZI_PROGAR ,'PA8_DESBPG')
EndIf


M->ZI_PREVEN := 0
If Len(aCols) > 0
	SG1->(dbSetOrder(1))
	For nI := 1 To Len(aCols)
		If !SG1->(dbSeek(xFilial("SG1") + aCols[nI, nPosProd]))
			M->ZI_PREVEN += aCols[nI, nPosPrT]
		Else
			aCols[nI, nPosPrT] := 0
		Endif
		
		If Alltrim(aCols[nI, nPosItem]) <> Alltrim(aCols[nI, nPosOri]) 
			aCols[Val(aCols[nI, nPosOri]), nPosPrT] += aCols[nI, nPosPrT]
		EndIf
	Next nI
EndIf
oGetDados:nMax := Len(aCols)
oGetDados:Refresh()

Return(cCodKit)

Static Function g12acols(cProdKit,aCols,nItem,nItemOri,nQtdOri,cCodGarOri)
Local cCodGar		:= ""
Local nPreReno		:= 0
Local nTxManu		:= 0
Local nTxParc		:= 0
Local cCodComp		:= ""
Local nRecZ1Atu 	:= 0
Local nQuant		:= 0

Default nItem		:= 0
Default nItemOri	:= 0
Default cCodGarOri 	:= ""
Default nQtdOri		:= 0

//Posiciona no Produto KIT
dbSelectArea("SG1")
SG1->(dbSetOrder(1))
SG1->(dbSeek(xFilial("SG1") + cProdKit))
// Carregar o aCols
While !eof().and. SG1->G1_COD == cProdKit
	nItem++
	
	nRecZ1Atu := SG1->(Recno())
	
	//Posiciona no Cadastro de Produtos
	SB1->(dbSetOrder(1))
	SB1->(dbSeek((xFilial("SB1") + SG1->G1_COMP)))
	
	//Renato Ruy - 06/04/2017
	//Somente e cobrado o Software na renovação
	nPreReno := Iif(SB1->B1_CATEGO == "2",SB1->B1_PRV1,0)
	cCodGar	 := IIf(Empty(cCodGarOri),SG1->G1_PROGAR,cCodGarOri)
	cCodComp := SG1->G1_COMP
	nQuant	 := IIf(nQtdOri == 0,SG1->G1_QUANT,nQtdOri)
	//Preencher acols com produtos do kit
	If nItem > 1
		nItemOri := iif(nItemOri == 0,nItem,nItemOri)
		AADD(aCols,{StrZero(nItem,3),cCodComp,SB1->B1_DESC,StrZero(nItemOri,3),nQuant,SB1->B1_PRV1,1,SB1->B1_PRV1 * nQuant,nPreReno,nTxManu,nTxParc,cCodGar,.F.})
	Else
		aCols := {{StrZero(nItem,3),cCodComp,SB1->B1_DESC,StrZero(nItem,3),nQuant,SB1->B1_PRV1,1,SB1->B1_PRV1 * nQuant,nPreReno,nTxManu,nTxParc,cCodGar,.F.}}
	EndIf
	
	//Executa recursivamente a carga do acols de acordo subestruras existentes
	If SG1->(dbSeek(xFilial("SG1") + cCodComp))
		g12acols(cCodComp,@aCols,@nItem,nItem,nQuant,cCodGar)
		nItemOri := 0
	EndIf
	
	SG1->(DbGoTo(nRecZ1Atu))
	
	SG1->(dbSkip())
End
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ValidCalc ºAutor  ³ Darcio R. Sporl    º Data ³  02/09/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao criada para validar o calculo do preco de tabela, e  º±±
±±º          ³carregar o valor total do combo na enchoice.                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Opvs x Certisign                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ValidCalc()
Local nPosQtD	:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_QTDBAS"})
Local nPosPrB	:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_PREBASE"})
Local nPosFaT	:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_FATOR"})
Local nPosPrT	:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_PRETAB"})
Local nPosProd  := aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_CODPROD"})
Local nPosItem	:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_ITEM"})
Local nPosOri	:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_ITEMORI"})
Local cCampo	:= ReadVar()
Local nI		:= 0

If cCampo == "M->ZJ_QTDBAS"
	aCols[oGetDados:oBrowse:nAt, nPosPrT] := (aCols[oGetDados:oBrowse:nAt, nPosPrB] * aCols[oGetDados:oBrowse:nAt, nPosFaT]) * M->ZJ_QTDBAS
ElseIf cCampo == "M->ZJ_PREBASE"
	aCols[oGetDados:oBrowse:nAt, nPosPrT] := (M->ZJ_PREBASE * aCols[oGetDados:oBrowse:nAt, nPosFaT]) * aCols[oGetDados:oBrowse:nAt, nPosQtD]
ElseIf cCampo == "M->ZJ_FATOR"
	aCols[oGetDados:oBrowse:nAt, nPosPrT] := (aCols[oGetDados:oBrowse:nAt, nPosPrB] * M->ZJ_FATOR) * aCols[oGetDados:oBrowse:nAt, nPosQtD]
ElseIf cCampo == "M->ZJ_PRETAB"
	aCols[oGetDados:oBrowse:nAt, nPosFaT] := (M->ZJ_PRETAB / aCols[oGetDados:oBrowse:nAt, nPosPrB])
	aCols[oGetDados:oBrowse:nAt, nPosPrT] := M->ZJ_PRETAB * aCols[oGetDados:oBrowse:nAt, nPosQtD]
EndIf

M->ZI_PREVEN := 0

If Len(aCols) > 0
	SG1->(dbSetOrder(1))
	For nI := 1 To Len(aCols)
		If !SG1->(dbSeek(xFilial("SG1") + aCols[nI, nPosProd]))
			M->ZI_PREVEN += aCols[nI, nPosPrT]
		Else
			aCols[nI, nPosPrT] := 0
		Endif
		
		/*
		If Alltrim(aCols[nI, nPosItem]) <> Alltrim(aCols[nI, nPosOri]) 
			aCols[Val(aCols[nI, nPosOri]), nPosPrT] += aCols[nI, nPosPrT]
		EndIf
		*/
	Next nI
EndIf

oMsGet:Refresh()
oGetDados:Refresh()

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VlTudoOK  ºAutor  ³ Darcio R. Sporl    º Data ³  02/09/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao criada para validar as informacoes da tela ao pressioº±±
±±º          ³nar o botao OK.                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Opvs x Certisign                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function VlTudoOK()
Local lRet 		:= .T.
Local nPreReno	:= 0
Local nTxManu		:= 0
Local nTxParc		:= 0
Local nColReno	:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_PRERENO"})
Local nColManu	:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_TXMANU"})
Local nColParc	:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_TXPARC"})
Local nI := 0

If Empty(M->ZI_COMBO) .Or. Empty(M->ZI_TABPRE) .Or. Empty(M->ZI_OBSERV) .Or. Empty(M->ZI_PROKIT)
	MsgStop('Favor verificar o preenchimento dos campos COMBO, TABELA DE PREÇO, OBSERVAÇÃO e PRODUTO KIT.')
	lRet := .F.	
EndIf

//Renato Ruy - 06/04/2017
//Pacote de melhorias na tabela de preço.
//Busca preco de renovacao e grava na DA1.
For nI := 1 To Len(aCols)
	nPreReno += aCols[nI,nColReno]
	nTxManu  := Iif(Empty(aCols[nI,nColManu]),nTxManu,aCols[nI,nColManu])
	nTxParc  := Iif(Empty(aCols[nI,nColParc]),nTxParc,aCols[nI,nColParc])
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Faz a atualizacao do preco do kit na tabela de preco³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
GrvDA1(M->ZI_TABPRE, M->ZI_PROKIT, M->ZI_COMBO, M->ZI_PROGAR, M->ZI_PREVEN, nPreReno,nTxManu,nTxParc)

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³CertMod3  ³ Autor ³ Darcio R. Sporl 		³ Data ³ 02/09/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Enchoice e GetDados										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³lRet:=Modelo3(cTitulo,cAlias1,cAlias2,aMyEncho,cLinOk, 	  ³±±
±±³			 ³ cTudoOk,nOpcE,nOpcG,cFieldOk,lVirtual,nLinhas,aAltEnchoice)³±±
±±³			 ³lRet=Retorno .T. Confirma / .F. Abandona					  ³±±
±±³			 ³cTitulo=Titulo da Janela 									  ³±±
±±³			 ³cAlias1=Alias da Enchoice									  ³±±
±±³			 ³cAlias2=Alias da GetDados									  ³±±
±±³			 ³aMyEncho=Array com campos da Enchoice						  ³±±
±±³			 ³cLinOk=LinOk 												  ³±±
±±³			 ³cTudOk=TudOk 												  ³±±
±±³			 ³nOpcE=nOpc da Enchoice									  ³±±
±±³			 ³nOpcG=nOpc da GetDados									  ³±±
±±³			 ³cFieldOk=validacao para todos os campos da GetDados 		  ³±±
±±³			 ³lVirtual=Permite visualizar campos virtuais na enchoice	  ³±±
±±³			 ³nLinhas=Numero Maximo de linhas na getdados			  	  ³±±
±±³			 ³aAltEnchoice=Array com campos da Enchoice Alteraveis		  ³±±
±±³			 ³nFreeze=Congelamento das colunas.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³RdMake 													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CertMod3(cTitulo,cAlias1,cAlias2,aMyEncho,cLinOk,cTudoOk,nOpcE,nOpcG,cFieldOk,lVirtual,nLinhas,aAltEnchoice,nFreeze,aButtons,aCordW,nSizeHeader,aAltGetD)
Local lRet, nOpca := 0,cSaveMenuh,nReg:=(cAlias1)->(Recno()),oDlg
Local nDlgHeight
Local nDlgWidth
Local nDiffWidth := 0
Local lMDI := .F.

Private Altera:=.t.,Inclui:=.t.,lRefresh:=.t.,aTELA:=Array(0,0),aGets:=Array(0),;
bCampo:={|nCPO|Field(nCPO)},nPosAnt:=9999,nColAnt:=9999
Private cSavScrVT,cSavScrVP,cSavScrHT,cSavScrHP,CurLen,nPosAtu:=0

nOpcE := If(nOpcE==Nil,3,nOpcE)
nOpcG := If(nOpcG==Nil,3,nOpcG)
lVirtual := Iif(lVirtual==Nil,.F.,lVirtual)
nLinhas:=Iif(nLinhas==Nil,99,nLinhas)

If SetMDIChild()
	oMainWnd:ReadClientCoors()
	nDlgHeight := oMainWnd:nHeight
	nDlgWidth := oMainWnd:nWidth
	lMdi := .T.
	nDiffWidth := 0
Else
	nDlgHeight := 420
	nDlgWidth	:= 632
	nDiffWidth := 1
EndIf

Default aCordW := {000,000,nDlgHeight,nDlgWidth}
Default nSizeHeader := 220


DEFINE MSDIALOG oDlg TITLE cTitulo From aCordW[1],aCordW[2] to aCordW[3],aCordW[4] Pixel of oMainWnd
If lMdi
	oDlg:lMaximized := .T.
EndIf

oMsGet := Msmget():New(cAlias1,nReg,nOpcE,,,,aMyEncho,{30,1,(nSizeHeader/2)+13,If(lMdi, (oMainWnd:nWidth/2)-2,__DlgWidth(oDlg)-nDiffWidth)},aAltEnchoice,3,,,,oDlg,,lVirtual,,,,,,,,.T.)

oGetDados := MsGetDados():New((nSizeHeader/2)+13+2,1,If(lMdi, (oMainWnd:nHeight/2)-26,__DlgHeight(oDlg)),If(lMdi, (oMainWnd:nWidth/2)-2,__DlgWidth(oDlg)-nDiffWidth),nOpcG,cLinOk,cTudoOk,"",.T.,aAltGetD,nFreeze,,nLinhas,cFieldOk,,,,oDlg)

ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,{||nOpca:=1,If(oGetDados:TudoOk(),If(!obrigatorio(aGets,aTela),nOpca := 0,oDlg:End()),nOpca := 0)},{||oDlg:End()},,aButtons))

lRet:=(nOpca==1)
                             
If lRet
	If nOpcE == 3
		While __lSx8
			ConfirmSx8()
		End
	EndIf
Else
	While __lSx8
		RollBackSXe()
	End
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CADCOMBO  ºAutor  ³Microsiga           º Data ³  09/12/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ProKit()
Local cProKit := Posicione('PA8',1,xFilial('PA8')+M->ZI_PROGAR ,'PA8_CODMP8')
/*
If ExistTrigger('ZI_PROKIT')
RunTrigger(1, Nil, Nil, , 'ZI_PROKIT')
EndIf
*/
U_ConsKit()

Return(cProKit)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MenuDef   ºAutor  ³Darcio R. Sporl     º Data ³  13/09/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao criada para gerar o menu no browse principal do      º±±
±±º          ³Protheus                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Opvs x Certisign                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MenuDef()
	Local cMV_CSCBIMP	:= 'MV_CSCBIMP'
	Private aRotina 	:= {{ "Pesquisar"	,"AxPesqui"		, 0 , 1},;
							{ "Visualizar"	,"u_TelaComb"	, 0 , 2},;
							{ "Incluir"		,"u_TelaComb"	, 0 , 3},;
							{ "Alterar"		,"u_TelaComb"	, 0 , 4, 20 },;
							{ "Excluir"		,"u_TelaComb"	, 0 , 5, 21 },;
							{ "Copiar" 		,"u_TelaComb"	, 0 , 2}}	// Opcao 2 para fechar janela ao confirmar a copia

	If .NOT. GetMv( cMV_CSCBIMP, .T. )
		CriarSX6( cMV_CSCBIMP, 'L', 'Habilita no browse a opção de Importação - CadCombo.prw', '.F.' )
	Endif

	IF GetMv( cMV_CSCBIMP, .F. )
		aAdd( aRotina, { 'Importar', 'U_ImportCB', 0, 2} )
	EndIF

Return(aRotina)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GrvDA1    ºAutor  ³Darcio R. Sporl     º Data ³  13/09/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao criada para atualizar o preco do kit na tabela de    º±±
±±º          ³preco.                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Opvs x Certisign                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GrvDA1(cCodTab, cCodKit, cCodCom, cCodGar, nPrVen, nPrRen, nTxManu, nTxParc)
Local aArea := GetArea()
Local cQryDA1 := ""

cQryDA1 := "SELECT R_E_C_N_O_ RECDA1 "
cQryDA1 += "FROM " + RetSqlName("DA1") + " "
cQryDA1 += "WHERE DA1_FILIAL = '" + xFilial("DA1") + "' "
cQryDA1 += "  AND DA1_CODTAB = '" + cCodTab + "' "
cQryDA1 += "  AND DA1_CODPRO = '" + cCodKit + "' "
cQryDA1 += "  AND DA1_CODCOB = '" + cCodCom + "' "
cQryDA1 += "  AND DA1_CODGAR = '" + cCodGar + "' "
cQryDA1 += "  AND D_E_L_E_T_ = ' ' "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryDA1),"QRYDA1",.F.,.T.)
DbSelectArea("QRYDA1")

If QRYDA1->(!Eof())
	DbSelectArea("DA1")
	DbGoTo(QRYDA1->RECDA1)
	
	RecLock("DA1", .F.)
		Replace DA1->DA1_PRCVEN With nPrVen
		Replace DA1->DA1_XPRCRE With nPrRen
		Replace DA1->DA1_TXMANU With nTXMANU
		Replace DA1->DA1_TXPARC With nTXPARC
	DA1->(MsUnLock())
EndIf

DbSelectArea("QRYDA1")
QRYDA1->(DbCloseArea())

RestArea(aArea)
Return

User Function ImportCB()
	Private nOpc      := 0
	Private cCadastro := "Importar CadCombo"
	Private aSay      := {}
	Private aButton   := {}

	aAdd( aSay, "O objetivo desta rotina é importar via CSV o cadastro de Combo" )

	aAdd( aButton, { 1,.T.,{|| nOpc := 1,FechaBatch()}})
	aAdd( aButton, { 2,.T.,{|| FechaBatch() }} )

	FormBatch( cCadastro, aSay, aButton )

	If nOpc == 1
		Processa( {|| Import() }, "Processando..." )
	Endif
Return

Static Function Import()
	Local nUsado 	:= 0
	
	Local cBuffer   := ""
	Local cFileOpen := ""
	Local cTitulo1  := "Selecione o arquivo"
	Local cExtens   := "Arquivo CSV | *.csv"

	Local cLinha  := ""
	Local lPrim   := .T.
	Local aCampos := {}
	Local aDados  := {}
	Local aTRB	  := {}
	
	Local cCODGAR	:= ''
	Local cTabela	:= ''
	Local nElem		:= 0
	Local nPos		:= 0
	Private aHeader	:= {}
	Private aCols	:= {}
	Private aErro 	:= {}

	/***
	* _________________________________________________________
	* cGetFile(<ExpC1>,<ExpC2>,<ExpN1>,<ExpC3>,<ExpL1>,<ExpN2>)
	* ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
	* <ExpC1> - Expressao de filtro
	* <ExpC2> - Titulo da janela
	* <ExpN1> - Numero de mascara default 1 para *.Exe
	* <ExpC3> - Diretório inicial se necessário
	* <ExpL1> - .F. botão salvar - .T. botão abrir
	* <ExpN2> - Mascara de bits para escolher as opções de visualização do objeto (prconst.ch)
	*/
	cFileOpen := cGetFile(cExtens,cTitulo1,1,'C:\',.T.)
	//cGetFile('Arquivo XML|*.XML|Arquivo *|*.*','Selecione Diretório',1,'C:\',.T.,GETF_LOCALHARD + GETF_LOCALFLOPPY + GETF_NETWORKDRIVE + GETF_RETDIRECTORY,.F.)

	If !File(cFileOpen)
		MsgAlert("Arquivo texto: "+cFileOpen+" não localizado",cCadastro)
		Return
	Endif

	//+--------------------------------------------------------------+
	//| Cria aHeader e aCols da GetDados                             |
	//+--------------------------------------------------------------+
	dbSelectArea("SX3")
	DbSetOrder(1)
	DbSeek("SZJ")
	aHeader := {}
	While !Eof().And.(x3_arquivo=="SZJ")
		If Alltrim(x3_campo)=="ZJ_COMBO"
			dbSkip()
			Loop
		Endif
		If X3USO(x3_usado) .And. cNivel >= x3_nivel
			nUsado := nUsado+1
			Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
			x3_tamanho, x3_decimal,"AllwaysTrue()",;
			x3_usado, x3_tipo, x3_arquivo, x3_context } )
		Endif
		dbSkip()
	End

	FT_FUSE(cFileOpen)
	ProcRegua(FT_FLASTREC())
	FT_FGOTOP()
	While !FT_FEOF()
	
		IncProc("Lendo arquivo texto...")
	
		cLinha := FT_FREADLN()
	
		If lPrim
			aCampos := Separa(cLinha,";",.T.)
			lPrim := .F.
		Else
			AADD(aDados,Separa(cLinha,";",.T.))			
		EndIf
	
		FT_FSKIP()
	EndDo

	For nL := 1 To Len( aDados )
		IF (cTabela + cCODGAR) <> (aDados[nL,1] + aDados[nL,3])
			CarregaAcols( @nUsado )
			Begin Transaction
				ImportGRV( aDados[nL,1], PadR( aDados[nL,3], 15 ), aDados, nL )
			End Transaction
		EndIF
		cTabela	:= aDados[nL,1]
		cCODGAR := aDados[nL,3]		
	Next nL

Return

Static Function CarregaAcols( nUsado )
	aCols := {}
	aCols := { Array(nUsado+1) }
	aCols[1,nUsado+1] := .F.
	For _ni:=1 to nUsado
		aCols[1,_ni] := CriaVar( aHeader[_ni,2] )
	Next
Return

Static Function ImportGRV(cTabela, cCODGAR, aDados, nLin)
	Local nI		:= 0
	Local nPos		:= 0
	Local nPosPrT	:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_PRETAB"})
	Local nPosItem	:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_ITEM"})
	Local nPosOri	:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_ITEMORI"})
	Local nPosProd	:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_CODPROD"})
	Local nColReno	:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_PRERENO"})
	Local nColManu	:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_TXMANU"})
	Local nColParc	:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_TXPARC"})
	Local nPreReno	:= 0
	Local nTxManu	:= 0
	Local nTxParc	:= 0
	Local nRECNO_ZI	:= 0
	
	Local cCodKit	:= cCODGAR
	Local cItemOri	:= ""
	Local cQryDA1		:= ""
	Local nZI_PREVEN	:= 0
	Local nPreco		:= 0
	Local nRenov		:= 0
	Local dDataVig	:= dDatabase
	Local cAtivo		:= "1"

	//carrega SG1 para acols de combo
	g12acols(cCODGAR,@aCols)

	nZI_PREVEN := 0
	/*If Len(aCols) > 0
		SG1->(dbSetOrder(1))
		For nI := 1 To Len(aCols)
			If !SG1->(dbSeek(xFilial("SG1") + aCols[nI, nPosProd]))
				nZI_PREVEN += aCols[nI, nPosPrT]
			Else
				aCols[nI, nPosPrT] := 0
			Endif
			
			If Alltrim(aCols[nI, nPosItem]) <> Alltrim(aCols[nI, nPosOri]) 
				aCols[Val(aCols[nI, nPosOri]), nPosPrT] += aCols[nI, nPosPrT]
			EndIf
		Next nI
	EndIf
	*/

	RecLock("SZI",.T.)
	SZI->ZI_COMBO	:= GetSxeNum('SZI','ZI_COMBO')
	SZI->ZI_TABPRE	:= aDados[nLin,1]
	SZI->ZI_DESCPRE	:= Posicione('DA0', 1, xFilial('DA0') + aDados[nLin,1],'DA0_DESCRI')
	SZI->ZI_OBSERV	:= aDados[nLin,2]
	SZI->ZI_PROKIT	:= cCODGAR
	SZI->ZI_DESCKIT	:= Posicione("SB1", 1, xFilial("SB1") + cCODGAR, "B1_DESC")
	SZI->ZI_PROGAR	:= cCODGAR
	SZI->ZI_DESCGAR	:= Posicione('PA8', 1, xFilial('PA8') + cCODGAR, "PA8_DESBPG")
	SZI->ZI_ATIVO	:= "2"
	SZI->ZI_BLOQUE	:= "S"
	SZI->ZI_PREVEN	:= nZI_PREVEN
	SZI->ZI_NUMPAR	:= Val( aDados[nLin,4] )
	SZI->ZI_KITCOMB := aDados[nLin,5]
	If aDados[nLin,5] == "S"
		SZI->ZI_XTIPINT := "I"
	EndIf
	SZI->ZI_XDTINT  := ""
	SZI->(MSUnlock())
	nRECNO_ZI := SZI->( RecNo() )

	nPos := aScan( aDados, {|r| r[1] == cTabela .And. r[3] == Alltrim(cCODGAR) })

	//Grava Acols
	For nI := 1 to Len(aCols)
		nPreco := Val( aDados[ nPos, 6 ] )
		nRenov := Val( aDados[ nPos, 7 ] )
		RecLock("SZJ",.T.)
		SZJ->ZJ_COMBO  := SZI->ZI_COMBO
		For nJ := 1 to Len(aHeader)
			cCampo := aHeader[nJ,2]
			IF cCampo == 'ZJ_PRETAB '
				SZJ->&cCampo := nPreco
			ElseIF cCampo == 'ZJ_PRERENO'
				SZJ->&cCampo := nRenov
			Else
				SZJ->&cCampo := aCols[nI,nJ]
			EndIF
		Next nJ
		SZJ->(MSUnlock())
		nPos++
		nPreReno += nRenov
		nTxManu  := Iif(Empty(aCols[nI,nColManu]),nTxManu,aCols[nI,nColManu])
		nTxParc  := Iif(Empty(aCols[nI,nColParc]),nTxParc,aCols[nI,nColParc])
		nZI_PREVEN += nPreco
	Next nI

	//--Volto no cabeçalho para atualizar o Preço conforme itens
	SZI->( dbGoto(nRECNO_ZI) )
	SZI->( RecLock("SZI",.F.) )
		SZI->ZI_PREVEN	:= nZI_PREVEN
	SZI->(MSUnlock())

	DbSelectArea("DA1")
	DbSetOrder(3)
	
	cQryDA1 := "SELECT MAX(DA1_ITEM) DA1_ITEM "
	cQryDA1 += "FROM " + RetSqlName("DA1") + " "
	cQryDA1 += "WHERE DA1_FILIAL = '" + xFilial("DA1") + "' "
	cQryDA1 += "  AND DA1_CODTAB = '" + SZI->ZI_TABPRE + "' "
	cQryDA1 += "  AND D_E_L_E_T_ = ' ' "
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryDA1),"QRYDA1",.F.,.T.)
	DbSelectArea("QRYDA1")
	
	//Renato Ruy - 27/12/2017
	//Gera data de vigencia diferente para combo com mesmo produto Protheus.
	//Se não existe produto Gar igual e ativo
	DA1->(DbSetOrder(1))
	If DA1->(DbSeek(xFilial("DA1")+SZI->ZI_TABPRE+SZI->ZI_PROKIT))
		
		While SZI->ZI_TABPRE == DA1->DA1_CODTAB .And. AllTrim(DA1->DA1_CODPRO) == AllTrim(SZI->ZI_PROKIT)
			
			If AllTrim(DA1->DA1_CODGAR)	== AllTrim(SZI->ZI_PROGAR) .And. DA1->DA1_ATIVO == "1"
				cAtivo := "2"
			Endif
			
			If DA1->DA1_DATVIG	== dDataVig
				dDataVig := dDataVig - 1
				DA1->(DbGoTop())
				DA1->(DbSeek(xFilial("DA1")+SZI->ZI_TABPRE+SZI->ZI_PROKIT))
			Endif
			
			DA1->(DbSkip())
		Enddo
		
	Endif
	RecLock("DA1", .T.)                       
	DA1->DA1_CODTAB	:= SZI->ZI_TABPRE
	DA1->DA1_ITEM	:= Soma1(QRYDA1->DA1_ITEM)
	DA1->DA1_CODPRO	:= SZI->ZI_PROKIT
	DA1->DA1_CODCOB	:= SZI->ZI_COMBO
	DA1->DA1_CODGAR	:= SZI->ZI_PROGAR
	DA1->DA1_DESGAR	:= SZI->ZI_DESCGAR
	DA1->DA1_PRCVEN	:= SZI->ZI_PREVEN
	DA1->DA1_NUMPAR	:= SZI->ZI_NUMPAR
	DA1->DA1_ATIVO	:= cAtivo
	DA1->DA1_DATVIG	:= dDataVig
	DA1->DA1_XDSSIT	:= Posicione("SB1", 1, xFilial("SB1") + SZI->ZI_PROKIT, "B1_DESC")
	DA1->DA1_TPOPER	:= "4"
	DA1->DA1_QTDLOT	:= 999999.99
	DA1->DA1_XPRCRE	:= nPreReno
	DA1->DA1_TXMANU	:= nTxManu
	DA1->DA1_TXPARC	:= nTxParc
	DA1->DA1_MOEDA	:= 1
	DA1->(MsUnLock())
	
	DbSelectArea("QRYDA1")
	QRYDA1->(DbCloseArea())
Return