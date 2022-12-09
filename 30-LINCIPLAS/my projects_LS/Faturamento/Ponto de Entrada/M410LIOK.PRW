#INCLUDE "PROTHEUS.CH"

/*
+==========================================================+
|Programa: M410LIOK |Autor: Antonio Carlos |Data: 15/02/10 |
+==========================================================+
|Descricao: PE utilizado para realizar validações na digi- |
|tação dos itens/gravação do Pedido de Venda.              |
+==========================================================+
|                                                          |
+==========================================================+
*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function M410LIOK()
////////////////////////

Local nPosItem			:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_ITEM"})
Local nPosCod			:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
Local nPosQtd			:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})
Local nPosTes			:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})
Local nQtdPT			:= 0
Local nQtdSZ			:= 0
Local nQtdPed			:= 0
Local _lRet				:= .T.
Local nPosDel			:= Len(aHeader)+1
Local aRetUsu			:= {}
Private cCTGrpUser		:= ""
Private lProdJaUsado	:= .F.


If !__CINTERNET=="AUTOMATICO" // Rotina está sendo processada via ExecAuto
	
	If cNumEmp  == "0101" .And. !INCLUI
		
		PswOrder(2)
		If PSWSEEK(cUserName,.T.)
			PswOrder(3)
			aRetUsu := PswRet()
			For nX := 1 to Len(aRetUsu[1][10])
				cCTGrpUser += "/" + CTGrpUser(aRetUsu[1][10][nX]) + "/"
			Next nX
			/*
			If !("PCP" $ cCTGrpUser) .and. !(__cUserId $ GetMv('LA_PODER'))
			MsgStop("Usuario sem permissao para efetuar alteracao!")
			_lRet := .F.
			EndIf
			*/
		EndIf
		
	EndIf
	
	cCodProd		:= aCols[n][nPosCod]
	nLinha			:= N
	
	// SE O TIPO FOR DIFERENTE DE UTILIZA FORNECEDOR / DEVOLUÇÃO DE COMPRAS
	// IMPEDE QUE O MESMO PRODUTO SEJA DIGITADO MAIS DE UMA VEZ NO PEDIDO DE VENDAS
	IF !aCols[nLinha][nPosDel] // SE A LINHA ESTIVER DELETADA NÃO VALIDA DUPLICIDADE
		IF !M->C5_TIPO $ "B/D" .AND. ( cNumEmp != '01C0' .AND. M->C5_CLIENTE+M->C5_LOJACLI != '00000101')
			FOR NX := 1 TO LEN(ACOLS)
				IF nLinha != NX // SE FOR A LINHA ATUAL NÃO VALIDA DUPLICIDADE
					IF cCodProd == aCols[nx][nPosCod] .AND. !aCols[nx][nPosDel] // SE A LINHA ESTIVER DELETADA NÃO VALIDA DUPLICIDADE
						MSGINFO("O produto " + alltrim(cCodProd) + " já foi utilizado neste PV no item: "+aCols[nX][nPosItem],"Produto já utilizado")
						lProdJaUsado := .T.
					ENDIF
				ENDIF
			NEXT
		ENDIF				
	ENDIF

EndIf

IF lProdJaUsado
	_lRet := .F.
ENDIF

Return(_lRet)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function CTGrpUser(cCodGrup)
///////////////////////////////////

Local cName   := Space(15)
Local aGrupo  := {}

PswOrder(1)
IF	PswSeek(cCodGrup,.F.)
	aGrupo   := PswRet()
	cNameGrp := Upper(Alltrim(aGrupo[1,2]))
EndIF

IF cCodGrup == "******"
	cNameGrp := "Todos"
EndIF

Return(cNameGrp)
