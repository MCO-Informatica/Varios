#Include "PROTHEUS.Ch"

User Function MTA410()
Local _aArea := GetArea()
Local nx, ny, cCampo
Local nReg := SC6->(Recno())
Local aSC5 := {}
Local nPProd,vPoslib
Local _lAltera := .f.
Local cAtual, cNovo
/* Local _nTotPed := 0
Local _lExercito := .f.
Local _lPolFed := .f.
Local _lPolCiv := .f.
Local _lExibeMsg := .T.
Local _lProdAc := .f. */
Local cMotivo := ""
Local cAlias := "SC5"
Local nDic := 0

//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MTA410" , __cUserID )

If AlTERA
	
	//abrir tela para digitar motivo das altera็๕es, se desejar
	cMotivo := U_fMotivoP("A")
	
	//grava log de altera็๕es:
	//==================================================================
	//Verifica alteracoes no cabecalho do pedido SC5:
	//==================================================================
//	dbSelectArea("SX3")
//	nRegSx3 := SX3->(Recno())

	aSX3 := Fwsx3util():GetAllFields(cAlias , .F.)

	dbSetOrder(1)
	MsSeek("SC5")
	
//	While ( !Eof() .And. SX3->X3_ARQUIVO == "SC5" )
//		
//		If ( X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL )
//			Aadd(aSC5, {TRIM(X3Titulo()),TRIM(SX3->X3_CAMPO),SX3->X3_CONTEXT} )
//		EndIf
//		dbSelectArea("SX3")
//		dbSkip()
//	EndDo

	For nDic := 1 to len(aSX3)		
		If ( X3USO(GetSX3Cache(aSX3[nDic],"X3_USADO")) .And. cNivel >= GetSX3Cache(aSX3[nDic],"X3_NIVEL") )
			Aadd(aSC5, {TRIM(X3Titulo()),TRIM(GetSX3Cache(aSX3[nDic],"X3_CAMPO")),GetSX3Cache(aSX3[nDic],"X3_CONTEXT")} )
		EndIf
	Next nDic
		
	
	//SX3->(DbGoto(nRegSx3))
	
	DbSelectArea("SC5")
	
	cAltera := ""
	For nx := 1 to len(aSC5)
		If ( aSC5[nX][3] != "V" )  //se nao for campo virtual
			cCampo  := alltrim(aSC5[nx,2])
			cTitulo := alltrim(aSC5[nx,1])
			
			if SC5->(&cCampo) != M->(&cCampo)
				cAtual := SC5->(&cCampo)
				cNovo  := M->(&cCampo)
				VerTipo(@cAtual,@cNovo )
				cAltera += cTitulo + ": " + cAtual + " - ALTERADO: " + cNovo + chr(13)+chr(10)
			endif
		Endif
	Next
	
	if !empty(cAltera)  //grava o log de alteracao do cabecalho do pedido
		U_GrvLogPd(SC5->C5_NUM,SC5->C5_CLIENTE,SC5->C5_LOJACLI,'Alteracao',cMotivo , ,cAltera)
	endif
	
	
	//==================================================================
	//Verifica alteracoes nos itens do pedido SC6:
	//==================================================================
	
	nPProd := Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO"})
	vPoslib := Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDLIB"})
	
	DbSelectArea("SC6")
	
	For nx := 1 to len (aCols)
		
		_lAltera := .f.
		cAltera := ""
		
		For ny := 1 to (len(aCols[nx]) -1 )
			
			if ny == 1 // se for o primeiro campo do item
				
				if DbSeek(xFilial("SC6") + SC5->C5_NUM + aCols[nx ,ny] )
					
					If aCols[nx,len(aCols[nx])] //Se o item foi deletado do Acols
						cAltera := 'Item ' + aCols[nx,ny] + ', Produto: ' + alltrim(aCols[nx,nPProd])  +' FOI EXCLUIDO.'
						U_GrvLogPd(SC5->C5_NUM,SC5->C5_CLIENTE,SC5->C5_LOJACLI,'Alteracao',cMotivo,aCols[nx,ny], cAltera)
						exit
					Else
						_lAltera := .t.
						cAltera := ""
						loop
					Endif
					
				Else
					If !aCols[nx,len(aCols[nx])] //Se o item nao esta deletado do Acols
						cAltera := 'Item ' + aCols[nx,ny] + ', Produto: ' + alltrim(aCols[nx,nPProd])  +' FOI INCLUIDO.'
						U_GrvLogPd(SC5->C5_NUM,SC5->C5_CLIENTE,SC5->C5_LOJACLI,'Alteracao',cMotivo,aCols[nx,ny], cAltera)
						exit
					Endif
					
				Endif // dbseek
				
			Endif // ny == 1
			
			//verificar se os campos do item foram alterados e gravar o log
			If _lAltera
				
				If aHeader[ny,10] != "V"   //se nao for campo virtual
					cCampo := ALLTRIM(aHeader[ny,2])
					cTitulo := alltrim(aHeader[ny,1])
					IF !(Alltrim(cCampo) == "C6_MOPC")
						if aCols[nx,ny] != SC6->(&cCampo)
							cAtual := SC6->(&cCampo)
							cNovo  := aCols[nx,ny]
							VerTipo(@cAtual,@cNovo )
							cAltera += cTitulo + ": " + cAtual + " - ALTERADO: " + cNovo + chr(13)+chr(10)
						endif
					endif
				endif
				
			Endif

		Next
		
		//grava o log do item do pedido que teve campos alterados
		if _lAltera .and. !empty(cAltera)
			U_GrvLogPd(SC5->C5_NUM,SC5->C5_CLIENTE,SC5->C5_LOJACLI,'Alteracao',cMotivo ,SC6->C6_ITEM,cAltera)
			
			If aCols[nx ,vPoslib] != SC6->C6_QTDLIB .AND. aCols[nx ,vPoslib] = 0
				
				dbselectarea("SB2")
				dbSetOrder(1)
				dbGoTop()
				IF MsSeek(xFilial()+SC6->C6_PRODUTO+SC6->C6_LOCAL)
					Reclock("SB2",.F.)
					SB2->B2_RESERVA := SB2->B2_RESERVA - aCols[nx ,16]
					MSUNLOCK()
				ENDIF
				
				dbselectarea("SB8")
				dbSetOrder(1)
				dbGoTop()
				IF MsSeek(xFilial()+SC6->C6_PRODUTO+SC6->C6_LOCAL)
					Reclock("SB8",.F.)
					SB8->B8_EMPENHO:= SB8->B8_EMPENHO - aCols[nx ,16]
					MSUNLOCK()
				ENDIF
				
				dbselectarea("SBF")
				dbSetOrder(2)
				dbGoTop()
				IF MsSeek(xFilial()+SC6->C6_PRODUTO+SC6->C6_LOCAL)
					Reclock("SBF",.F.)
					SBF->BF_EMPENHO:= SBF->BF_EMPENHO - aCols[nx ,16]
					MSUNLOCK()
				ENDIF
			Endif
			
		endif
		
	Next
	
Endif


SC6->(DbGoto(nReg))
RestArea(_aArea)
Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VERTIPO  บ Autor ณ Giane - ADV Brasil บ Data ณ  28/11/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ funcao converte tipo dos campos para caracter, para gravar บฑฑ
ฑฑบ          ณ no campo Z4_ALTERA da tabela de log de pedido.             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especํfico MAKENI  - faturamento/pedido de vendas          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function VerTipo(cAtual,cNovo)


if valtype(cAtual) == 'D'
	cAtual := DTOC(cAtual)
	cNovo := IIF( valtype(cNovo) <> "U",DTOC(cNovo)," ")
elseif valtype(cAtual) == 'N'
	cAtual := alltrim(str(cAtual))
	cNovo := IIF( valtype(cNovo) <> "U",alltrim(STR(cNovo))," ")
ELSE
	cAtual := IIF( valtype(cAtual) <> "U",alltrim(cAtual)," ")
	cNovo  := IIF( valtype(cNovo ) <> "U",alltrim(cNovo )," ")
Endif

Return