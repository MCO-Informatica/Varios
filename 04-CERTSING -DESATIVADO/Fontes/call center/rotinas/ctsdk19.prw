#include "protheus.ch"

//-----------------------------------------------------------
// Rotina | ctsdk19 | Totvs - David       | Data | 31.10.13
// ----------------------------------------------------------
// Descr. | Rotina personalizada para tratamento especifico
//        | de execução de campanhas e seus respectivos
//        | scripts
//-----------------------------------------------------------
User Function CTSDK19()
Local lRet			:= .T.
Local cQuery		:= ""
Local cCodCamp		:= ""
Local cOperacao	:= ""
Local cContato		:= ""
Local cEntidade	:= ""
Local cCliente		:= ""
Local cLoja			:= ""
Local cAte			:= ""
Local cCodAte		:= ""
Local cRetAte		:= ""
Local aScript		:= {}
Local bOk			:= {|| .T.}
Local oDlgScri		:= nil
Local oLbx1			:= nil
Local oBmp1			:= nil
Local cScript		:= ""
Local cOperador	:= ""
Local cRotina		:= ""
Local cAtend 		:= ""
Local cCampCod 	:= ""
Local nPos			:= 0
Local nAuxFor		:= 0
Local nControl		:= 0
Local aControl		:= {}
Local lFirst		:= .T.
Local nAuxPer		:= 0
Local aPerguntas	:= {}
Local nX				:= 0
Local cMemoFim		:= 0
Local nCol			:= 0
Local nPosaControl:= 0
Local nPosADF_OBS	:= 0
Local nColR			:= 20
Local cDesCamp		:= ""
Local cDesPerg		:= ""
Local cMotivo		:= ''
Local nLen := 0
Local nY := 0
Private nFolder	:= 4
Private aParScript	:= {}
//valida se rotina esta sendo chamada do servicedesk através
// do botão da tela de atendimento ou validação do campo ocorrencia
If FunName() $ "TMKA503A,TMKA510A" .and.  Type("ParamIXB") == "U"
	cCodCamp	:= M->ADE_CODCAM
	cOperacao:= M->ADE_OPERAC
	cContato	:= M->ADE_CODCON
	cEntidade:= M->ADE_ENTIDA
	cCliente	:= Left(Alltrim(M->ADE_CHAVE),6)
	cLoja		:= Right(Alltrim(M->ADE_CHAVE),2)
	cAte		:= "4"
	cCodAte	:= M->ADE_CODIGO
	cOperador:= TkOperador()

//valida se rotina esta sendo chamada na confirmação da tela de atendimento e grava
//script´s preenchidos se existir
ElseIf Type("ParamIXB") <> "U" .and. Len(aParScript) > 0

	cRotina:= "4"
	cAtend := M->ADE_CODIGO

	If (Len(aParScript)>0)
		Tk380Grava( aParScript[1][1], aParScript[1][2] , aParScript[1][3] , aParScript[1][4] ,;
						aParScript[1][5], aParScript[1][6] , aParScript[1][7] , aParScript[1][8] ,;
					 	aParScript[1][9], aParScript[1][10], aParScript[1][11], aParScript[1][12],;
						cAtend,@cCampCod, .F. )
	Endif

	//Grava a rotina e o numero do atendimento de onde
	//foi executado a campanha.                       
	DbSelectArea("ACI")
	DbSetOrder(1)
	If DbSeek(xFilial("ACI") + cCampCod )
		RecLock("ACI",.F.)
		Replace ACI_ROTINA With cRotina
		Replace ACI_ATEND  With cAtend
		MsUnLock()
		DbCommit()
	Endif

	aParScript:= {}

EndIf

//caso exista código de campanha mostra telas de scripts da campanhas informada
If !Empty(cCodCamp)
	If INCLUI
		nOpc := 3
	EndIf

	If ALTERA
		nOpc := 4
	EndIf

	BeginSql Alias "TMPSUW"
		SELECT
		  UW_CODEVE,
		  UW_DESCEVE,
		  UW_CODCAMP,
		  UW_CODSCRI,
		  UW_PRODUTO,
		  UW_MIDIA,
		  UZ_CODSCRI,
		  UZ_DESC,
		  UZ_TEMPO,
		  UZ_TIPO,
		  UZ_FORMATO,
		  UZ_ARMRESP,
		  UZ_SCORMIN,
		  UZ_PROCMIN,
		  UZ_SCORMAX,
		  UZ_PROCMAX,
		  UW_XGRPATE
		FROM
		  %Table:SUW% SUW,
		  %Table:SUZ% SUZ
		WHERE
		  SUW.UW_FILIAL = %Exp:xFilial("SUW")% AND
		  SUW.%NotDel% AND
		  SUZ.UZ_FILIAL = %Exp:xFilial("SUZ")% AND
		  SUZ.%NotDel% AND
		  SUW.UW_CODCAMP = %Exp:cCodCamp% AND
		  SUZ.UZ_CODSCRI = SUW.UW_CODSCRI AND
		  (SUZ.UZ_TIPO = %Exp:cOperacao% OR SUZ.UZ_TIPO = '3')
	EndSql

	dbSelectArea("TMPSUW")

	While !Eof()
		AAdd(aScript,{	StaticCall(TMKA271A,TK271EXESCR,cCodCamp,TMPSUW->UZ_CODSCRI,cContato,cEntidade,cCliente+cLoja,cAte,cCodAte, @cRetAte,@aParScript),;
							TMPSUW->UZ_CODSCRI,;								//Codigo do Script
							TMPSUW->UZ_DESC,;									//Descricao
							IIF(TMPSUW->UZ_FORMATO == "1","Atendimento","Pesquisa"),;   //"Atendimento"/"Pesquisa"
							TMPSUW->UZ_FORMATO,;                               //Campo Tipo
							cRetAte,;
							TMPSUW->UW_XGRPATE})
		DbSkip()
	EndDo

	TMPSUW->(dbCloseArea())

	//Verifica se existe algum script que atende as condicoes
	If (Len(aScript) > 0)

		//Define acao comum ao botao OK e ao duplo clique do listbox
		bOk	:= {|| lRet:= CSD19OK(Alltrim(aScript[oLbx1:nAt,7])), nPos:= oLbx1:nAt ,iif(!lRet, MsgStop("Grupo não tem permissao para preencher formulário somente visualizar."), oDlgScri:End() ) }

		//Monta a tela para a escolha do script a ser executado
		DEFINE MSDIALOG oDlgScri FROM  50,0 TO 260,700 TITLE "Formulário Dinamico Certisign" PIXEL

			@02,03 TO 87,337 LABEL "" OF oDlgScri PIXEL
			@05,05 LISTBOX oLbx1 FIELDS HEADER ;
				"",;
				"Script",;
				"Titulo",;
				"Formato",;
				"Atendimento";
				SIZE 330,80 OF oDlgScri PIXEL NOSCROLL

			oLbx1:SetArray(aScript)
			oLbx1:bLine:={||{	StaticCall(TMKA271A,TK271LEGSCRI,aScript[oLbx1:nAt,1]),;
									aScript[oLbx1:nAt,2],;
									aScript[oLbx1:nAt,3],;
									aScript[oLbx1:nAt,4],;
									aScript[oLbx1:nAt,6]}}
			oLbx1:bLDblClick := bOk
			oLbx1:Refresh()

			@90,03 TO 103,200 LABEL "Legenda" OF oDlgScri PIXEL

			@ 95,05  BitMap oBmp1 ResName "ENABLE"  OF oDlgScri Size 10,10 NoBorder When .F. Pixel
			@ 95,52  BitMap oBmp1 ResName "DISABLE" OF oDlgScri Size 10,10 NoBorder When .F. Pixel
			@ 95,105 BitMap oBmp1 ResName "BR_AZUL" OF oDlgScri Size 10,10 NoBorder When .F. Pixel

			@ 95,015 SAY  "Respondida"	OF oDlgScri COLOR CLR_GREEN PIXEL
			@ 95,062 SAY  "Sem Responder"			OF oDlgScri COLOR CLR_RED   PIXEL
			@ 95,115 SAY  "Respondida em outro Atendimento"		OF oDlgScri COLOR CLR_BLUE  PIXEL

			DEFINE SBUTTON FROM 90,260	TYPE 15 ENABLE OF oDlgScri ACTION (lRet:= .T.,StaticCall(TMKA271A,TK271VISSCR,cCodCamp,aScript[oLbx1:nAt,2],cContato,cEntidade,cCliente+cLoja,cAte,cCodAte, @cRetAte))
			DEFINE SBUTTON FROM 90,290  TYPE 1 ENABLE OF oDlgScri ACTION (Eval(bOk))
			DEFINE SBUTTON FROM 90,320	TYPE 2 ENABLE OF oDlgScri ACTION (lRet:= .F.,oDlgScri:End())

		ACTIVATE MSDIALOG oDlgScri CENTERED

		If lRet .and. nPos > 0
			//Executa o script que foi selecionado.
			cScript:= aScript[nPos][2]

			Tk380Script(nOpc		,cCodCamp		,cScript	,cContato,;
						cEntidade	,cCliente+cLoja	,NIL		,NIL,;
						cOperador	,"&*%*%%"	    ,NIL        ,cCodAte,;
						@aParScript)

       	M->ADE_CODSCR := cScript
		Endif
	Endif
EndIf

//valida se rotina foi chamada na validação do campo ocorrencia e se existe
//script a ser gravado no campo de observação
If ReadVar() == "M->ADF_CODSU9" .and. Len(aParScript) > 0

	cMemoFim		:= ""
	aControl		:= aClone(aParScript[1,1])
	aPerguntas	:= aClone(aParScript[1,2])
	nAuxFor		:= Len(aControl)

	For nControl:= 1 TO nAuxFor
		If	(aControl[nControl][7] == "C" .AND. lFirst) .OR. (aControl[nControl][7] <> "C")
			//³Percorre as perguntas do SCRIPT³
			nAuxPer  := Len(aPerguntas)
			For nX := 1 TO nAuxPer
				If aPerguntas[nX][1][2] == aControl[nControl][1]
					cMemoFim += Space(nCol) + aPerguntas[nX][1][4] + CRLF+CRLF
					Exit
				Endif
			Next nX

			If aControl[nControl][7] <> "C"
				lFirst := .T.
			Else
				lFirst := .F.
			Endif
		Endif

		If aPerguntas[nX][1][7] == "1"  	// Unica Escolha
			nPosaControl:= aControl[nControl][4]
			If nPosaControl > 0
				cMemoFim += Space(nColR)+ aPerguntas[nX][2][aControl[nControl][4]][4]+CRLF+CRLF
				If AllTrim(aPerguntas[nX][2][aControl[nControl][4]][4]) == "RESPOSTA ABERTA"
					cMemoFim += Space(nColR)+ aControl[nControl][5] +CRLF+CRLF
				EndIf
			Endif
		ElseiF aPerguntas[nX][1][7] == "2"	// Multipla Escolha

			If aControl[nControl][3]   		// Posicao logica do array que indica se a alternativa foi selecionada

				For nY := 1 To Len(aPerguntas[nX][2])
					If ( aPerguntas[nX][2][nY][2] == aControl[nControl][2] )
						cMemoFim += Space(nColR)+ aPerguntas[nX][2][nY][4]+CRLF+CRLF
					Endif
				Next nY

			Endif

		ElseiF aPerguntas[nX][1][7] == "3"
			cMemoFim += Space(nColR)+ aControl[nControl][5]+CRLF+CRLF
		Endif
	Next nAuxFor

	If !Empty(cMemoFim) .and. Type("aHeader") <> "U" .and. Type("aCols") <> "U" .and. Type("n") <> "U"
		nPosADF_OBS := Ascan(aHeader, {|x| Alltrim(x[2]) == "ADF_OBS" })
		cDesCamp		:= Alltrim(Posicione("SUO",1,xFilial("SUO")+aParScript[1,6],"UO_DESC"))
		cDesPerg		:= Alltrim(Posicione("SUZ",1,xFilial("SUZ")+aParScript[1,7],"UZ_DESC"))

		If nPosADF_OBS > 0 .and. n > 0 .and. Len(aCols) >= n
			aCols[n,nPosADF_OBS] := "Processo: "+cDesCamp+CRLF+CRLF+"Questionário: "+cDesPerg+CRLF+CRLF+"Data: "+DtoC(Date())+" "+Time()+CRLF+CRLF+cMemoFim
	  	EndIf
	Endif
EndIf

//Customizacao para validar preenchimento de campos referente ao reembolso.
If M->ADE_ASSUNT $ GetMv("MV_XTMK01")

	If Empty(M->ADE_XBANCO)
		lRet := .F.
		MsgInfo("O campo Banco deve ser preenchido para reembolso.")
	ElseIf Empty(M->ADE_XAGENC)
		lRet := .F.
		MsgInfo("O campo Agencia deve ser preenchido para reembolso.")
	ElseIf Empty(M->ADE_XNUMCO)
		lRet := .F.
		MsgInfo("O campo Numero da Conta deve ser preenchido para reembolso.")
	ElseIf Empty(M->ADE_XDCONT)
		lRet := .F.
		MsgInfo("O campo Digito da Conta deve ser preenchido para reembolso.")
	EndIf

EndIf

//+-------------------------------------------------------------------+
//| Autor | Rafael Beghini | Data | 20.04.2016 
//+-------------------------------------------------------------------+
//| Rotina para Cancelamento do Pedido Site
//+-------------------------------------------------------------------+
IF FunName() $ "TMKA503A,TMKA510A" .and.  Type("ParamIXB") == "A"
	nLen := Len( oGetD:ACOLS )
	IF .NOT. Empty( M->ADE_XPSITE ) .And. M->ADE_ASSUNT $ GetMv( 'VNDA700A' )  .And. oGetD:ACOLS[nLen,2] $ GetMv( 'VNDA700B' )
		cMotivo := Alltrim( StrTran( Posicione( 'SX5', 1, xFilial('SX5') + 'T1' + M->ADE_ASSUNT, 'X5_DESCRI'), 'BK', '' ) )
		U_VNDA710( M->ADE_XPSITE, FunName(), cMotivo )
	EndIF
EndIF

Return(lRet)

//-----------------------------------------------------------
// Rotina | csd190k | Totvs - David       | Data | 31.10.13
// ----------------------------------------------------------
// Descr. | Rotina para validar se grupo do usuario pode
//        | alterar ou responder script especifico. A regra
//        | esta cadastra na campanha
//-----------------------------------------------------------
Static Function CSD19OK(cGrpRes)
Local _lRet	:= .T.
Local _cOper		:= TkOperador()// Código do Operador de Call Center
Local _cGrp			:= ""

//posiciona no operador e obtem o grupo padrão de atendimento do mesmo
DbSelectArea("SU7")
SU7->(DbSetOrder(1))

If SU7->(DbSeek(xFilial("SU7")+_cOper))
	_cGrp := SU7->U7_POSTO
EndIf

//valida se grupo do usuário esta cadastrado na campanha para
//permitindo alterar ou responder script
_lRet :=  Empty(cGrpRes) .or. _cGrp $ cGrpRes

Return(_lRet)