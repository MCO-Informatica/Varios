#include "rwmake.ch"
#include "TOPCONN.CH"

User Function relshelf()

	SetPrvt("cQuery,CALIAS,_NREG")
	SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,CTITULOA,CTITULOS,CTITULO,_cTitulob")
	SetPrvt("cCancel,limite,lerro,lend")
	SetPrvt("ARETURN,NOMEPROG,NLASTKEY,CPERG,cCABEC1,cCABECA,cCABECS,cCabecG,")
	SetPrvt("nTotal,nTotVolumes")
	private oTmpTable as object
	Private cAliasTmp as character

	oTmpTable := nil
	cAliasTmp := getNextAlias()

	cString     := "SF1"
	cTitulo     := "Relatorio de clientes Shelf Life x Pedidos Liberados "
	cDesc1     	:= "Este programa tem como objetivo, imprimir uma Relacao"
	cDesc2     	:= "Clientes x Pedidos x Shelf Life conforme cadastro."
	wnrel           := ""
	tipo              := 15
	tamanho    	:= "p"
	aReturn        := { "Zebrado", 1,"Administracao", 4, 2, 1, "",1 }
	nomeprog  	:= "Relshelf"
	cPerg       := "RelShelf"
	nTotal           := 0
	nlin := 08
	nLastKey 	:= 0
	cCabeca  	:= "Pedido    Cliente   Nome                        Loja  Cod.Prod.         Descrição                               Quantidade   Shelf-Life   Dt.Entrega       Status
	cCabec1  	:= " " //    VIA "
	//              0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	//              0         1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20
	//	             999999 999999 99999 999999999999999 999999999999999 SP 9999 9999.99 9999,999.99


	cCancel   	:= "***** CANCELADO PELO OPERADOR *****"
	limite      := 80
	lErro       := .f.    
	_cSit       := "ini"
	_cStatus  := "ini"
	_cImp     := "S"
	_cNomeAnt := " "
	_cNFiscal := " "
	_cNomeTra := " "   
	nDiaShelf := 0 
	nDiasVenc := 0
	nPerShelf := 0
	atende := 0 

	vMsG := " "

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	//ValidPerg()

	Pergunte(cPerg,.F.)

	cTitulo	:= cTitulo 
	Private m_pag  := 1
	Private li     := 61

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia controle para a funcao SETPRINT ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	wnrel :=   nomeprog            //Nome Default do relatorio em Disco

	wnrel := SetPrint(cString,wnrel,cPerg,@cTitulo,cDesc1,cDesc2,cDesc3,.F.,,,"G")

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString,.F.)

	If nLastKey == 27
		Return
	Endif

	RptStatus({|| RptDetail()})

Return

Static Function RptDetail()

	local cAliasQry as character

	cAliasQry := getNextAlias()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicia Processamento ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nLastKey == 27
		Return
	Endif     

	ACPOSmap := {}
	aAdd(aCposmap,{"PEDIDOS   " ,"C", 10,0})
	aAdd(aCposMAP,{"CODCLI"  ,"C", 10,0})
	aAdd(aCposMAP,{"NOMECLI"  ,"C", 30,0})
	aAdd(aCposmap,{"LOJA" ,"C", 3,0})
	aAdd(aCposMAP,{"CODPROD" ,"C", 20,0})
	aAdd(aCposMAP,{"DESCPROD"      ,"C", 30,2})
	aAdd(aCposMAP,{"QTDLIB"    ,"N", 17,2})
	aAdd(aCposMAP,{"SHELFLIFE"   ,"N", 17,2})
	aAdd(aCposmap,{"ENTREGA"    ,"D", 08,0})  
	aAdd(aCposmap,{"STATUSP"    ,"C", 50,0})


	oTmpTable := FWTemporaryTable():New( cAliasTmp )  
	oTmpTable:SetFields(aCposmap) 


	//------------------
	//Criacao da tabela temporaria
	//------------------
	oTmpTable:Create()  


	//query
	_cQuery := " SELECT SC6.C6_LOTECTL, SA1.A1_FATVALI, SA1.A1_LOTEUNI, SC5.C5_XENTREG, SA1.A1_COD, SB1.B1_DESC, SB1.B1_COD, C9_LOCAL AS CLOCAL, C9_FILIAL ,SA1.A1_NOME, SA1.A1_LOJA, SA1.A1_FATVALI,C9_PEDIDO PEDIDO, C9_CLIENTE CLIENTE, C9_PRODUTO PRODUTO, C9_QTDLIB QTDLIB, C9_DATALIB DTLIB "
	_cQuery += " FROM SC9010 SC9 "
	_cQuery += " INNER JOIN SA1010 SA1 ON A1_COD = C9_CLIENTE AND A1_LOJA = C9_LOJA AND SA1.D_E_L_E_T_ <> '*' AND SC9.D_E_L_E_T_ <> '*' "     
	_cQuery += " INNER JOIN SB1010 SB1 ON B1_COD = C9_PRODUTO AND SB1.D_E_L_E_T_ <> '*'  "     
	_cQuery += " INNER JOIN SC5010 SC5 ON C9_PEDIDO = C5_NUM AND SC5.D_E_L_E_T_ <> '*' AND C5_FILIAL = C9_FILIAL "    
	_cQuery += " INNER JOIN SC6010 SC6 ON C9_PRODUTO = C6_PRODUTO AND SC6.D_E_L_E_T_ <> '*' AND C6_LOJA = C9_LOJA AND C6_FILIAL = C9_FILIAL AND C6_NUM = C9_PEDIDO "     
	_cQuery += " WHERE C9_NFISCAL = '         ' AND C9_BLCRED = '  ' AND C5_EMISSAO <= '"+DTOS(MV_PAR01)+"' " 
	_cQuery += " AND B1_TIPO = 'MR' AND  SC6.C6_NOTA = '         '   "  
	If Select(cAliasQry)>0
		DbSelectArea(cAliasQry)
		DbCloseArea()
	Endif
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),cAliasQry,.T.,.T.)


	(cAliasQry)->(DbGoTop())
	SetRegua(RecCount(cAliasQry))

	impcab      := .F.

	While (cAliasQry)->(!eof())
		incregua()    
		If nlin = 08
			Cabec(cTitulo,cCabeca,cCabec1,wNRel,"G",Tipo )    
			nlin := 09
		Endif	
		If nlin > 58//60
			Cabec(cTitulo,cCabeca,cCabec1,wNRel,"G",Tipo )    
			nlin := 09
		Endif	

		Achou := .F.

		IF EMPTY((cAliasQry)->C6_LOTECTL)

			IF (cAliasQry)->A1_LOTEUNI == "2"   //lote unico 

				DBSelectArea("SB8")
				SB8->(DBSetOrder(3)) //B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)                                                                                            
				SB8->(DBSeek(xFilial("SB8")+(cAliasQry)->PRODUTO+(cAliasQry)->CLOCAL))
				while SB8->(!EOF()) .and. (cAliasQry)->PRODUTO == SB8->B8_PRODUTO


					IF SB8->B8_SALDO >0 .AND. SB8->B8_SALDO >= (cAliasQry)->QTDLIB

						nDiaShelf := SB8->B8_DTVALID - SB8->B8_DFABRIC
						nDiasVenc := SB8->B8_DTVALID - MsDate()
						nPerShelf := Round((nDiasVenc/nDiaShelf)*100,0)  
						nPerShelf := 100 - nPerShelf


						IF nPerShelf < (cAliasQry)->A1_FATVALI  
							Achou := .T.
						ENDIF

					ENDIF

					SB8->(dbskip() )
				end
				If Achou = .F.
					vMsG := "Este cliente exige LOTE UNICO, e não existe lote disponivel."
				Endif

			Endif                    


			IF (cAliasQry)->A1_LOTEUNI == "1" .or. empty((cAliasQry)->A1_LOTEUNI)
				vSaldoTot := 0

				DBSelectArea("SB8")
				DBSetOrder(3) //B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)                                                                                            
				DBSeek(xFilial("SB8")+(cAliasQry)->PRODUTO+(cAliasQry)->CLOCAL)   
				while SB8->(!EOF()) .and. (cAliasQry)->PRODUTO == SB8->B8_PRODUTO


					IF SB8->B8_SALDO >0 

						nDiaShelf := SB8->B8_DTVALID - SB8->B8_DFABRIC
						nDiasVenc := SB8->B8_DTVALID - MsDate()
						nPerShelf := Round((nDiasVenc/nDiaShelf)*100,0)  
						nPerShelf := 100 - nPerShelf


						IF nPerShelf < (cAliasQry)->A1_FATVALI      
							vSaldoTot := vSaldoTot + SB8->B8_SALDO	
						ENDIF

						IF vSaldoTot >= (cAliasQry)->QTDLIB
							Achou := .T.
						eNDIF

					ENDIF

					SB8->(dbskip() )
				end



				If Achou = .F.
					vMsG := "Não foi encontrada quantidade válida ou disponível para o produto."
				Endif
			Endif                    


			if Achou = .f.

				@ nlin,000 psay (cAliasQry)->PEDIDO
				@ nlin,010 psay (cAliasQry)->A1_COD
				@ nlin,020 psay SUBSTR((cAliasQry)->A1_NOME,1,26)
				@ nlin,048 psay (cAliasQry)->A1_LOJA    
				@ nlin,054 psay (cAliasQry)->B1_COD
				@ nlin,072 psay SUBSTR((cAliasQry)->B1_DESC,1,26)
				@ nlin,112 psay (cAliasQry)->QTDLIB 
				@ nlin,125 psay (cAliasQry)->A1_FATVALI 
				@ nLin,138 psay STOD((cAliasQry)->C5_XENTREG)
				@ nLin,155 psay vMsG

				nlin ++ 
				atende := 0

				RECLOCK(cAliasTmp,.T.)
				(cAliasTmp)->PEDIDOS := (cAliasQry)->PEDIDO
				(cAliasTmp)->CODCLI := (cAliasQry)->A1_COD
				(cAliasTmp)->NOMECLI := SUBSTR((cAliasQry)->A1_NOME,1,26)
				(cAliasTmp)->LOJA := (cAliasQry)->A1_LOJA
				(cAliasTmp)->CODPROD := (cAliasQry)->B1_COD
				(cAliasTmp)->DESCPROD := SUBSTR((cAliasQry)->B1_DESC,1,26)
				(cAliasTmp)->QTDLIB := (cAliasQry)->QTDLIB
				(cAliasTmp)->SHELFLIFE := (cAliasQry)->A1_FATVALI
				(cAliasTmp)->ENTREGA := STOD((cAliasQry)->C5_XENTREG) 
				(cAliasTmp)->STATUSP := vMsg
				(cAliasTmp)->(msunlock())
			endif

		ENDIF 

		(cAliasQry)->(DbSkip())
	Enddo    


	
	(cAliasTmp)->(dbCloseArea())

	If oTmpTable <> Nil
		oTmpTable:Delete()
		oTmpTable := Nil
	Endif

	Set Device To Screen
	If aReturn[5] == 1
		Set Printer To
		dbCommitAll()
		ourspool(wnrel)
	Endif  

Return()