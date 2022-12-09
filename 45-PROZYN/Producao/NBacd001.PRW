/*
Padrao ELTRON
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³img01     ºAutor  ³Sandro Valex        º Data ³  19/06/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada referente a imagem de identificacao do     º±±
±±º          ³produto. Padrao Microsiga                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Img01() //dispositivo de identificacao de produto
Local cCodigo, sConteudo,cTipoBar, nX

Local nqtde 	:= If(len(paramixb) >= 1,paramixb[ 1],NIL)
Local cCodSep 	:= If(len(paramixb) >= 2,paramixb[ 2],NIL)
Local cCodID 	:= If(len(paramixb) >= 3,paramixb[ 3],NIL)
Local nCopias	:= If(len(paramixb) >= 4,paramixb[ 4],0)
Local cNFEnt  	:= If(len(paramixb) >= 5,paramixb[ 5],NIL)
Local cSeriee  := If(len(paramixb) >= 6,paramixb[ 6],NIL)
Local cFornec  := If(len(paramixb) >= 7,paramixb[ 7],NIL)
Local cLojafo  := If(len(paramixb) >= 8,paramixb[ 8],NIL)
Local cArmazem := If(len(paramixb) >= 9,paramixb[ 9],NIL)
Local cOP      := If(len(paramixb) >=10,paramixb[10],NIL)
Local cNumSeq  := If(len(paramixb) >=11,paramixb[11],NIL)
Local cLote    := If(len(paramixb) >=12,paramixb[12],NIL)
Local cSLote   := If(len(paramixb) >=13,paramixb[13],NIL)
Local dValid   := If(len(paramixb) >=14,paramixb[14],NIL)
Local cCC  		:= If(len(paramixb) >=15,paramixb[15],NIL)
Local cLocOri  := If(len(paramixb) >=16,paramixb[16],NIL)
Local cOPREQ   := If(len(paramixb) >=17,paramixb[17],NIL)
Local cNumSerie:= If(len(paramixb) >=18,paramixb[18],NIL)
Local cOrigem  := If(len(paramixb) >=19,paramixb[19],NIL)
Local cEndereco:= If(len(paramixb) >=20,paramixb[20],NIL)
Local cPedido  := If(len(paramixb) >=21,paramixb[21],NIL)
Local nResto   := If(len(paramixb) >=22,paramixb[22],0)
Local cItNFE   := If(len(paramixb) >=23,paramixb[23],NIL)

Local _NTIPO
Local _nI		:= 0

If cCodID#NIL
	CBRetEti(cCodID)
	nqtde    := CB0->CB0_QTDE
	cCodSep  := CB0->CB0_USUARIO
	cNFEnt   := CB0->CB0_NFENT
	cSeriee  := CB0->CB0_SERIEE
	cFornec  := CB0->CB0_FORNEC
	cLojafo  := CB0->CB0_LOJAFO
	cArmazem := CB0->CB0_LOCAL
	cOP      := CB0->CB0_OP
	cNumSeq  := CB0->CB0_NUMSEQ
	cLote    := CB0->CB0_LOTE
	cSLote   := CB0->CB0_SLOTE
	cCC      := CB0->CB0_CC
	cLocOri  := CB0->CB0_LOCORI
	cOPReq	 := CB0->CB0_OPREQ
	cNumserie:= CB0->CB0_NUMSER
	cOrigem  := CB0->CB0_ORIGEM
	cEndereco:= CB0->CB0_LOCALI
	cPedido  := CB0->CB0_PEDCOM
EndIf


_nVolumes := 0
If Type('aLbx') == 'A'
	For _nI := 1 to Len(aLbx)
		If !aLbx[_nI,1]
			Loop
		EndIf
		_nVolumes += Val(aLbx[_nI,6])
	Next
EndIf

//Deve atualizar a Validade dos lotes para todos os produtos lidos
//dValid := CtoD('')
SB8->(DbSetOrder(5))
If SB8->(DbSeek(xFilial('SB8')+SB1->B1_COD+cLote))
	Do While SB8->B8_PRODUTO == SB1->B1_COD .And. AllTrim(SB8->B8_LOTECTL) == AllTrim(cLote) .And. SB8->(!EoF())
		If SB8->B8_QTDORI > 0 //.and. SB8->B8_LOCAL == SB1->B1_LOCPAD //SB8->B8_DTVALID > dValid
			dValid   := SB8->B8_DTVALID
			If cArmazem == '98'
			   cArmazem := SB1->B1_LOCPAD
			EndIf   
		endif
		SB8->(DbSkip())
	EndDo
EndIf

//If Empty(cArmazem)
//cArmazem := SB1->B1_LOCPAD
//EndIf

//cLocOri := If(cLocOri==cArmazem,' ',cLocOri)
//nQtde   := If(nQtde==NIL,SB1->B1_QE,nQtde)
//cCodSep := If(cCodSep==NIL,'',cCodSep)


If  nCopias = 0
	nCopias:=1
EndIf

If nResto > 0
	nCopias++
EndIf

// Define o tipo de Etiqueta
If SB1->B1_TIPO = 'MP'
	_nTipo := 1
else
	If TerProtocolo() # "PROTHEUS"
		If IsTelnet() .and. VtModelo() == "RF"
			_nTipo := 1
		endif
	else
		_nTipo := 1
	endif
EndIf

_lZera := .F.
If Type('_nVAtual') <> 'N'
	Public _nVAtual := 0
Else
	_lZera := .T.
EndIf

For nX := 1 to nCopias
	If Usacb0("01")
		If Empty(cFornec)
			_cQuery := "Select Top 1 D1_TIPO, D1_COD, D1_FORNECE, D1_LOJA, D1_FABRIC,D1_DOC From "+RetSqlName('SD1')+ " Where D1_COD = '"+SB1->B1_COD+"' And D1_LOTECTL = '"+cLote+"' And D_E_L_E_T_ = ' '"
			dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQuery),'TMPSD1',.T.,.T.) //"Seleccionado registros"
			If TMPSD1->D1_TIPO $ 'D/N'
				DbSelectArea('SA5')
				DbSetOrder(2)
				If DbSeek(xFilial('SA5')+TMPSD1->D1_COD)
					cFornec := SA5->A5_FORNECE
					cLojaFo := SA5->A5_LOJA
					
				Else
					cFornec := TMPSD1->D1_FORNECE
					cLojaFo := TMPSD1->D1_LOJA
					
				EndIf
			Else
				cFornec := TMPSD1->D1_FORNECE
				cLojaFo := TMPSD1->D1_LOJA
				
			EndIf
			
			TMPSD1->(DbCloseArea())
		EndIf
		
		If cCodID ==NIL
			CBGrvEti('01',{SB1->B1_COD,nQtde,cCodSep,cNFEnt,cSeriee,cFornec,cLojafo,cPedido,cEndereco,cArmazem,cOp,cNumSeq,NIL,NIL,NIL,cLote,cSLote,dValid,cCC,cLocOri,NIL,cOPReq,cNumserie,cOrigem})
			If _nVATual+nX > _nVolumes
				_nVAtual := 0
			EndIf
			RecLock('CB0',.F.)
			Replace CB0->CB0_CODET2 With allTrim(Str(_nVAtual+nX)) + '/' + allTrim(Str(_nVolumes))
			Replace CB0->CB0_DTVLD  With dValid
			Conout('Atualizando Data')
			Conout(dValid)
			MsUnlock()
			cCodigo := CB0->CB0_CODETI
		Else
			cCodigo := cCodID
		EndIf
		
	Else
		cCodigo := SB1->B1_CODBAR
	EndIf
	
	
	/*
	If cCodID#NIL
	CBRetEti(cCodID)
	nqtde 	 := CB0->CB0_QTDE
	cCodSep  := CB0->CB0_USUARIO
	cNFEnt   := CB0->CB0_NFENT
	cSeriee  := CB0->CB0_SERIEE
	cFornec  := CB0->CB0_FORNEC
	cLojafo  := CB0->CB0_LOJAFO
	cArmazem := CB0->CB0_LOCAL
	cOP      := CB0->CB0_OP
	cNumSeq  := CB0->CB0_NUMSEQ
	cLote    := CB0->CB0_LOTE
	cSLote   := CB0->CB0_SLOTE
	cCC      := CB0->CB0_CC
	cLocOri  := CB0->CB0_LOCORI
	cOPReq	:= CB0->CB0_OPREQ
	cNumserie:= CB0->CB0_NUMSER
	cOrigem  := CB0->CB0_ORIGEM
	cEndereco:= CB0->CB0_LOCALI
	cPedido  := CB0->CB0_PEDCOM
	cItNFE 	 := CB0->CB0_ITNFE
	EndIf
	If nResto > 0 .and. nX==nCopias
	nQtde  := nResto
	EndIf
	If Usacb0("01")
	cCodigo := If(cCodID ==NIL,CBGrvEti('01',{SB1->B1_COD,nQtde,cCodSep,cNFEnt,cSeriee,cFornec,cLojafo,cPedido,cEndereco,cArmazem,cOp,cNumSeq,NIL,NIL,NIL,cLote,cSLote,dValid,cCC,cLocOri,NIL,cOPReq,cNumserie,cOrigem,cItNFE}),cCodID)
	Else
	cCodigo := SB1->B1_CODBAR
	EndIf
	*/
	
	cCodigo  := Alltrim(cCodigo)
	cTipoBar := 'MB07' //128
	If ! Usacb0("01")
		If Len(cCodigo) == 8
			cTipoBar := 'MB03'
		ElseIf Len(cCodigo) == 13
			cTipoBar := 'MB04'
		EndIf
	EndIf
	
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial('SB1')+CB0->CB0_CODPRO))
	SA2->(DbSeek(xFilial('SA2')+cFornec+cLojaFo))
	
	
	If Type('cProgImp')=="C" .and. cProgImp=="ACDV120"
		GravaCBE(CB0->CB0_CODETI,SB1->B1_COD,nQtde,cLote,dValid)
	EndIf
	
	_cSeq := AllTrim(CB0->CB0_CODET2)
	
	If SB1->B1_TRANSGE = "1"
		cTrasg := "*T*"
	Else
		cTrasg := ""
	endif
	
	If SB1->B1_SNALERG = "1"
		cAlerg := "*A*"
	Else
		cAlerg := ""
	Endif
	
	IF EMPTY(CB0->CB0_NFENT)
		dFabric := CtoD('')
	else
		dFabric := SD1->D1_FABRIC
	Endif
	
	// Etiqueta media de MP
	If _nTipo = 1
		
		MSCBBEGIN(1,6)
		//b,d,c,e
		MSCBBOX(12,02,95,108,5)
		MSCBLineV(80,02,108,3)
		MSCBLineV(70,02,108,3)
		MSCBLineV(45,02,108,3)
		MSCBSAY(84,45,"PROZYN","R","C","40")
		
		If FUNNAME() == "ACDV210" .OR. FUNNAME() == "ACDV166"
			
			MSCBSAY(78,05,"OP: ","R","C","10")
			MSCBSAY(78,30,CB0->CB0_OP, "R", "C", "13")
			MSCBSAY(76,05,"Operador: ","R","C","10")
			MSCBSAY(76,30,CB1->CB1_NOME, "R", "C", "10")
			MSCBSAY(74,05,"Dt: ","R","C","10")
			MSCBSAY(74,30,DtoC(DDATABASE), "R", "C", "10")
			MSCBSAY(72,05,"HR: ","R","C","10")
			MSCBSAY(72,30,TINICIO, "R", "C", "10")
			
		Else
			MSCBSAY(72,05,"FAB: ","R","C","30")
			MSCBSAY(72,30,DtoC(dFabric), "R", "C", "30")
			
		Endif
		
		
		MSCBSAY(72,60,"VAL:", "R", "C", "30")
		MSCBSAY(72,76,DtoC(CB0->CB0_DTVLD), "R", "C", "30")
		
		MSCBSAY(62,05,"CODIGO:", "R", "C", "40")
		MSCBSAY(59,30,AllTrim(CB0->CB0_CODPRO), "R", "C", "70")
		MSCBSAY(50,05,"LOTE: ", "R", "C", "30")
		MSCBSAY(47,30,cLote, "R", "C", "70")
		
		MSCBSAY(38,05,"PESO LIQ: ", "R", "C", "30")
		MSCBSAY(35,40,AllTrim(Transform(CB0->CB0_QTDE ,"@E 999,999.999"))+Space(01)+SB1->B1_UM, "R", "C", "60")
		MSCBSAYBAR(16,40,cCodigo,"R","MB07",15,.F.,.T.,.F.,,3,1,.F.,.F.,"1",.T.)
		//MSCBSAY(08,40, cCodigo	,'R', "C" , "5" )
		MSCBInfoEti("Produto","100X30")
		sConteudo:=MSCBEND()
		
	EndIf
	
Next

_nVAtual += nX-1

If _lZera
	_nVAtual := 0
EndIf

Return sConteudo

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³img01cx   ºAutor  ³Sandro Valex        º Data ³  19/06/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada referente a imagem de identificacao do     º±±
±±º          ³produto para caixa a agranel                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Img01CX //dispositivo de identificacao de produto
Local cCodigo,sConteudo,cTipoBar, nX
Local nqtde 	:= If(len(paramixb) >= 1,paramixb[ 1],NIL)
Local cCodSep 	:= If(len(paramixb) >= 2,paramixb[ 2],NIL)
Local cCodID 	:= If(len(paramixb) >= 3,paramixb[ 3],NIL)
Local nCopias	:= If(len(paramixb) >= 4,paramixb[ 4],NIL)
Local cArmazem := If(len(paramixb) >= 5,paramixb[ 5],NIL)
Local cEndereco:= If(len(paramixb) >= 6,paramixb[ 6],NIL)

nQtde   := If(nQtde==NIL,SB1->B1_QE,nQtde)
cCodSep := If(cCodSep==NIL,'',cCodSep)
For nX := 1 to nCopias
	If Usacb0("01")
		cCodigo := If(cCodID ==NIL,CBGrvEti('01',{SB1->B1_COD,nQtde,cCodSep,NIL,NIL,NIL,NIL,NIL,cEndereco,cArmazem,,,,,,,,}),cCodID)
	Else
		cCodigo := SB1->B1_CODBAR
	EndIf
	cCodigo := Alltrim(cCodigo)
	cTipoBar := 'MB07' //128
	If ! Usacb0("01")
		If Len(cCodigo) == 8
			cTipoBar := 'MB03'
		ElseIf Len(cCodigo) == 13
			cTipoBar := 'MB04'
		EndIf
	EndIf
	MSCBLOADGRF("SIGA.PCX")
	MSCBBEGIN(1,6)
	MSCBGRAFIC(04,02,"SIGA")
	MSCBBOX(05,01,76,30,2)
	MSCBLineH(30,06,71,2)
	MSCBLineH(05,12,71,2)
	MSCBLineH(05,18,71,2)
	MSCBLineV(30,1,12,2) //Monta Linha Vertical
	MSCBSAY(33,02,'CAIXA',"N","2","1,2")
	MSCBSAY(33,07,"CODIGO", "N", "1", "1,1")
	MSCBSAY(33,09,AllTrim(SB1->B1_COD), "N", "1", "1,2")
	MSCBSAY(07,13,"DESCRICAO","N","1","1,1")
	MSCBSAY(07,15,SB1->B1_DESC,"N", "1", "1,2")
	MSCBSAYBAR(28,19,cCodigo,'N',cTipoBar,06,.T.,,,,2,2,,,,)
	MSCBInfoEti("Produto Granel","30X100")
	sConteudo:=MSCBEND()
Next
Return sConteudo

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³img01De   ºAutor  ³Sandro Valex        º Data ³  19/06/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada referente a imagem de identificacao da     º±±
±±º          ³Unidade de despacho                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Img01DE //dispositivo de identificacao de unidade de despacho produto
Local nCopias 	:= If(len(paramixb) >= 1,paramixb[ 1],NIL)
Local cCodigo 	:= If(len(paramixb) >= 2,AllTrim(paramixb[ 2]),NIL)

MSCBLOADGRF("SIGA.PCX")
MSCBBEGIN(nCopias,6)
MSCBGRAFIC(04,02,"SIGA")
MSCBBOX(05,01,76,30,2)
MSCBLineH(30,06,71,2)
MSCBLineH(05,12,71,2)
MSCBLineH(05,18,71,2)
MSCBLineV(30,1,12,2) //Monta Linha Vertical
MSCBSAY(33,02,'UNID. DE DESPACHO',"N","2","1,2")
MSCBSAY(33,07,"CODIGO", "N", "1", "1,1")
MSCBSAY(33,09,AllTrim(SB1->B1_COD), "N", "1", "1,2")
MSCBSAY(07,13,"DESCRICAO","N","1","1,1")
MSCBSAY(07,15,SB1->B1_DESC,"N", "1", "1,2")
MSCBSAYBAR(28,19,cCodigo,'N',"MB01",06,.T.,,,,2,2,,,,)
MSCBInfoEti("Unid.Despacho","30X100")
sConteudo:=MSCBEND()

Return sConteudo

/*
Padrao Zebra
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMG05     ºAutor  ³Sandro Valex        º Data ³  19/06/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada referente a imagem de identificacao do     º±±
±±º          ³volume temporario                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Img05   // imagem de etiqueta de volume temporaria

Local cVolume := paramixb[1]
Local cPedido := paramixb[2]
Local cNota   := IF(len(paramixb)>=3,paramixb[3],nil)
Local cSerie  := IF(len(paramixb)>=4,paramixb[4],nil)
Local cID := CBGrvEti('05',{cVolume,cPedido,cNota,cSerie})
Local sConteudo

DbSelectArea("SF2")
SF2->(DbSetOrder(1))
SF2->(DbSeek(xFilial("SF2")+cNota+cSerie))

DbSelectArea("SA1")
cCliente := POSICIONE("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_NREDUZ")
cCodigo := CB0->CB0_VOLUME



MSCBBEGIN(1,6)

//MSCBBOX(04,04,90,112,5)
//MSCBLineV(82,04,112,3)
//MSCBLineV(65,04,112,3)
MSCBBOX(12,02,95,108,5)
MSCBLineV(82,02,108,3)
MSCBLineV(65,02,108,3)
MSCBSAY(84,20,"PROZYN - Volume Provisório","R","C","34")
MSCBSAY(74,05,"NF:", "R", "C", "40")
MSCBSAY(74,16,AllTrim(cNota)+"/"+AllTrim(cSerie), "R", "C", "40")
//	MSCBSAY(74,65,"DATA: ", "R", "C", "40")
//	MSCBSAY(74,80,DtoC(SF2->F2_EMISSAO), "R", "C", "40")
MSCBSAY(74,60,"DATA: ", "R", "C", "40")
MSCBSAY(74,77,DtoC(SF2->F2_EMISSAO), "R", "C", "40")
MSCBSAY(67,05,"CLIENTE: ", "R", "C", "40")
MSCBSAY(67,30,cCliente, "R", "C", "40")

MSCBSAYBAR(23,33,cCodigo,"R","MB07",15,.F.,.F.,.F.,,3,1,.F.,.F.,"1",.T.)
MSCBSAY(15,37,cCodigo, "R", "C", "60")
MSCBInfoEti("Vol.Provis","100X30")
sConteudo:=MSCBEND()




/*
MSCBLOADGRF("SIGA.GRF")
MSCBBEGIN(1,6)
MSCBBOX(30,05,76,05)
MSCBBOX(02,12.7,76,12.7)
MSCBBOX(02,21,76,21)
MSCBBOX(30,01,30,12.7,3)
MSCBGRAFIC(2,3,"SIGA")
MSCBSAY(33,02,"VOLUME","N","0","025,035")
MSCBSAY(33,06,"CODIGO","N","A","012,008")
MSCBSAY(33,08, cVolume, "N", "0", "032,035")
If cNota==NIL
MSCBSAY(05,14,"PEDIDO","N","A","012,008")
MSCBSAY(05,17,cPedido,"N", "0", "020,030")
Else
MSCBSAY(05,14,"NOTA","N","A","012,008")
MSCBSAY(05,17,cNota+' '+cSerie,"N", "0", "020,030")
EndIf
MSCBSAYBAR(23,22,cId,"N","MB07",8.36,.F.,.T.,.F.,,2,1,.F.,.F.,"1",.T.)
MSCBInfoEti("Volume Temp.","100X30")
sConteudo:=MSCBEND()
*/
Return sConteudo

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMG05OFI  ºAutor  ³Sandro Valex        º Data ³  19/06/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada referente a imagem de identificacao do     º±±
±±º          ³volume permanente."Oficial"                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Img05OFI // imagem de etiqueta de volume permanente (OFICIAL)
Local cId     := CBGrvEti('05',{CB6->CB6_VOLUME,CB6->CB6_PEDIDO})
Local nTotEti := paramixb[1]
Local nAtu    := paramixb[2]
Local cNota   := CB6->CB6_NOTA
Local cSerie  := CB6->CB6_SERIE
Local sConteudo

DbSelectArea("SF2")
SF2->(DbSetOrder(1))
SF2->(DbSeek(xFilial("SF2")+cNota+cSerie))

DbSelectArea("SA1")
cCliente := POSICIONE("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_NREDUZ")
cCodigo := CB6->CB6_VOLUME



MSCBBEGIN(1,6)
//MSCBBOX(04,04,90,112,5)
//MSCBLineV(82,04,112,3)
//MSCBLineV(65,04,112,3)
MSCBBOX(12,02,95,108,5)
MSCBLineV(82,02,108,3)
MSCBLineV(65,02,108,3)
MSCBSAY(84,23,"PROZYN - Volume Oficial","R","C","34")
MSCBSAY(74,08,"NF:", "R", "C", "40")
MSCBSAY(74,19,AllTrim(cNota)+"/"+AllTrim(cSerie), "R", "C", "40")
MSCBSAY(74,60,"DATA: ", "R", "C", "40")
MSCBSAY(74,77,DtoC(SF2->F2_EMISSAO), "R", "C", "40")
MSCBSAY(67,08,"CLIENTE: ", "R", "C", "40")
MSCBSAY(67,33,cCliente, "R", "C", "40")

cQry := " SELECT SUM(CB9_QTESEP)CB9_QTESEP,CB9_PROD,B1_DESC,CB9_LOTECT FROM CB9010 CB9
cQry += " INNER JOIN SB1010 B1 ON B1_COD = CB9_PROD AND B1.D_E_L_E_T_ = '' "
cQry += " where CB9_ORDSEP = '"+CB7->CB7_ORDSEP+"' and CB9.D_E_L_E_T_ = '' and CB9_VOLUME= '"+CB6->CB6_VOLUME+"' "
cQry += " Group BY CB9_PROD,CB9_LOTECT,B1_DESC "
cQry := ChangeQuery(cQry)

IF SELECT("TMY") >0
	TMY->(DBCloseArea())
EndIF
DBUSEAREA(.T.,"TOPCONN",TcGenQry(,,cQry), "TMY", .F., .T.)
nH := 61

MSCBSAY(nH,08,"Código", "R", "C", "20")
MSCBSAY(nH,21,"Descrição", "R", "C", "20")
MSCBSAY(nH,70,"Qtd", "R", "C", "20")
MSCBSAY(nH,87,"Lote", "R", "C", "20")
nH -= 2
//	MSCBLineV(nH,04,112,3)
MSCBLineV(nH,02,108,3)

While !TMY->(EOF())
	nH -= 3
	MSCBSAY(nH,08,TMY->CB9_PROD, "R", "C", "15")
	MSCBSAY(nH,21,TMY->B1_DESC, "R", "C", "15")
	MSCBSAY(nH,70,TRANSFORM(TMY->CB9_QTESEP, "@E 999.999,999"), "R", "C", "15")
	MSCBSAY(nH,87,TMY->CB9_LOTECT, "R", "C", "15")
	nH -= 1
	//MSCBLineV(nH,04,112,3)
	MSCBLineV(nH,02,108,3)
	TMY->(DbSkip())
EndDo

MSCBSAY(18,17,cValtoChar(nAtu)+" / "+cValtoChar(nTotEti), "R", "C", "30")
MSCBSAYBAR(18,42,cCodigo,"R","MB07",8,.F.,.F.,.F.,,3,1,.F.,.F.,"1",.T.)
MSCBSAY(13,53,cCodigo, "R", "C", "30")
MSCBInfoEti("Vol.Oficial","100X30")
sConteudo:=MSCBEND()

/*
MSCBBEGIN(1,6)
MSCBBOX(06,00,06,76)
MSCBBOX(19,00,19,76)
MSCBBOX(27,00,27,76)
MSCBBOX(35,00,35,76)
MSCBSAY(03,24,"VOLUME","B","0","025,035")
MSCBSAYBAR(07,02,AllTrim(cId),"B","MB07",8.36,.F.,.T.,.F.,,2,1,.F.,.F.,"1",.T.)
MSCBSAY(20,30,"PEDIDO","B","A","012,008")
MSCBSAY(23,25,CB6->CB6_PEDIDO,"B", "0", "032,035")
MSCBSAY(28,30,"CODIGO","B","A","012,008")
MSCBSAY(31,17,CB6->CB6_VOLUME,"B", "0", "032,035")
MSCBSAY(55,07,StrZero(nAtu,2)+"/"+StrZero(nTotEti,2),"B","0","040,055")
MSCBInfoEti("Volume Oficial","100x30")
MSCBEND()

*/
Return .f.
/*
Padrao Zebra
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMG10     ºAutor  ³Anderson Rodrigues  º Data ³  25/02/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Ponto de entrada referente a imagem de identificacao do     º±±
±±º          ³Pallet                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³AP6                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function IMG10  // imagem do Pallet

cCodigo:= Paramixb[1] // Codigo da etiqueta do Pallet
Conout(cCodigo)

cProgr:=FUNNAME()

MSCBBEGIN(1,6)

MSCBBOX(12,02,95,108,5)
MSCBLineV(82,02,108,3)

If Len(Paramixb) > 1 .and. Paramixb[2] == 'EMBARQUE'
   MSCBSAY(84,34,"E M B A R Q U E","R","C","34")
Else
   MSCBSAY(84,34,"PROZYN - PALLET","R","C","34")
EndIf

IF cProgr == 'PZCVR003' // para pallets criados no momento da geração da etiqueta do PA deverão imprimir a op lote e cod do produto na etiqueta de pallet
	/*
	MSCBSAY(62,05,"CODIGO:", "R", "C", "40")
	MSCBSAY(59,35,AllTrim(CB0->CB0_CODPRO), "R", "C", "70")
	MSCBSAY(50,05,"LOTE: ", "R", "C", "30")
	MSCBSAY(47,35,CB0->CB0_LOTE, "R", "C", "70")
	MSCBSAY(38,05,"OP: ", "R", "C", "30")
	MSCBSAY(35,35,CB0->CB0_OP, "R", "C", "70")
	*/
	
	
	MSCBSAY(72,05,"CODIGO:", "R", "C", "40")
	MSCBSAY(69,35,AllTrim(CB0->CB0_CODPRO), "R", "C", "70")
	MSCBSAY(60,05,"LOTE: ", "R", "C", "30")
	MSCBSAY(57,35,CB0->CB0_LOTE, "R", "C", "70")
	MSCBSAY(48,05,"OP: ", "R", "C", "30")
	MSCBSAY(45,35,CB0->CB0_OP, "R", "C", "70")
	
	
	MSCBSAYBAR(23,30,cCodigo,"R","MB07",15,.F.,.F.,.F.,,3,1,.F.,.F.,"1",.T.)
	MSCBSAY(15,34,cCodigo, "R", "C", "60")
	
	MSCBInfoEti("Pallet","100X30")
	sConteudo:=MSCBEND()
	Conout(sConteudo)
else
	
	MSCBSAYBAR(53,30,cCodigo,"R","MB07",15,.F.,.F.,.F.,,3,1,.F.,.F.,"1",.T.)
	MSCBSAY(45,34,cCodigo, "R", "C", "60")
	
	MSCBInfoEti("Pallet","100X30")
	sConteudo:=MSCBEND()
	Conout(sConteudo)
	
endif

Return .F.


