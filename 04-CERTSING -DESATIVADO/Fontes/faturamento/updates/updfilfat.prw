#include 'protheus.ch'
#include 'parmtype.ch'

user function updfilfat()
cArqEmp 					:= "SigaMat.Emp"
__cInterNet 	:= Nil

PRIVATE cMessage
PRIVATE aArqUpd	 := {}
PRIVATE aREOPEN	 := {}
PRIVATE oMainWnd
Private nModulo 	:= 05

Set Dele On

lEmpenho				:= .F.
lAtuMnu					:= .F.

Processa({|| ProcATU()},"Processando [UPDFILFAT]","Aguarde , processando preparação dos arquivos")

Return()

Static Function ProcATU()
Local cTexto    	:= ""
Local cFile     	:= ""
Local cMask     	:= "Arquivos Texto (*.TXT) |*.txt|"
Local nRecno    	:= 0
Local nI        	:= 0
Local nX        	:= 0
Local aRecnoSM0 	:= {}
Local lOpen     	:= .F.

ProcRegua(1)
IncProc("Verificando integridade dos dicionários....")
If (lOpen := IIF(Alias() <> "SM0", MyOpenSm0Ex(), .T. ))

	dbSelectArea("SM0")
	dbGotop()
	While !Eof()
  		If M0_CODIGO = '01' .and. Ascan(aRecnoSM0,{ |x| x[2] == M0_CODIGO}) == 0
			Aadd(aRecnoSM0,{Recno(),M0_CODIGO})
		EndIf			
		dbSkip()
	EndDo	

	If lOpen
		For nI := 1 To Len(aRecnoSM0)
			SM0->(dbGoto(aRecnoSM0[nI,1]))
			RpcSetType(2)
			RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)
			nModulo := 05 
			lMsFinalAuto := .F.
			cTexto += Replicate("-",128)+CHR(13)+CHR(10)
			cTexto += "Empresa : "+SM0->M0_CODIGO+SM0->M0_NOME+CHR(13)+CHR(10)

			ProcRegua(5)

			Begin Transaction

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza o dicionario de arquivos.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando Dicionario de Arquivos...")
			cTexto += GeraSX2()
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza o dicionario de dados.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando Dicionario de Dados...")
			cTexto += GeraSX3()

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza Tabelas Genericas.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando Tabelas Genericas...")
			cTexto += GeraSX5()
			
			IncProc("Analisando Paramêtros...")
			cTexto += GeraSX6()

			End Transaction
	
			__SetX31Mode(.F.)
			For nX := 1 To Len(aArqUpd)
				IncProc("Atualiszando estruturas. Aguarde... ["+aArqUpd[nx]+"]")
				If Select(aArqUpd[nx])>0
					dbSelecTArea(aArqUpd[nx])
					dbCloseArea()
				EndIf
				X31UpdTable(aArqUpd[nx])
				If __GetX31Error()
					Alert(__GetX31Trace())
					Aviso("Atencao!","Ocorreu um erro desconhecido durante a atualizacao da tabela : "+ aArqUpd[nx] + ". Verifique a integridade do dicionario e da tabela.",{"Continuar"},2)
					cTexto += "Ocorreu um erro desconhecido durante a atualizacao da estrutura da tabela : "+aArqUpd[nx] +CHR(13)+CHR(10)
				EndIf
				dbSelectArea(aArqUpd[nx])
			Next nX		

			RpcClearEnv()
			If !( lOpen := MyOpenSm0Ex() )
				Exit
		 EndIf
		Next nI
		
		If lOpen
			
			cTexto 				:= "Log da atualizacao " + CHR(13) + CHR(10) + cTexto
			__cFileLog := MemoWrite(Criatrab(,.f.) + ".LOG", cTexto)
			
			DEFINE FONT oFont NAME "Mono AS" SIZE 5,12
			DEFINE MSDIALOG oDlg TITLE "Atualizador [UPDFILFAT] - Atualizacao concluida." From 3,0 to 340,417 PIXEL
				@ 5,5 GET oMemo  VAR cTexto MEMO SIZE 200,145 OF oDlg PIXEL
				oMemo:bRClicked := {||AllwaysTrue()}
				oMemo:oFont:=oFont
				DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
				DEFINE SBUTTON  FROM 153,145 TYPE 13 ACTION (cFile:=cGetFile(cMask,""),If(cFile="",.t.,MemoWrite(cFile,cTexto))) ENABLE OF oDlg PIXEL //Salva e Apaga //"Salvar Como..."
			ACTIVATE MSDIALOG oDlg CENTER
	
		EndIf
		
	EndIf
		
EndIf 	

Return(Nil)

Static Function MyOpenSM0Ex()

Local lOpen := .F.
Local nLoop := 0

For nLoop := 1 To 20
	dbUseArea( .T.,, "SIGAMAT.EMP", "SM0", .F., .F. )
	If !Empty( Select( "SM0" ) )
		lOpen := .T.
		dbSetIndex("SIGAMAT.IND")
		Exit	
	EndIf
	Sleep( 500 )
Next nLoop

If !lOpen
	Aviso( "Atencao !", "Nao foi possivel a abertura da tabela de empresas de forma exclusiva !", { "Ok" }, 2 )
EndIf

Return( lOpen )

Static Function GeraSX2()
Local aArea 			:= GetArea()
Local i      		:= 0
Local j      		:= 0
Local aRegs  		:= {}
Local cTexto 		:= ''
Local lInclui		:= .F.

aRegs  := {}
AADD(aRegs,{"SC5","                                        ","SC5010  ","Pedidos de Venda              ","Pedidos de Venta              ","Sales Orders                  ","                                        ","C","C","C",00," ","C5_FILIAL+C5_NUM                                                                                                                                                                                                                                          ","S",05,"C5_NUM+C5_CLIENTE+C5_LOJACLI+C5_CONDPAG                                                                                                                                                                                                                       ","                              ","                              "," "," "," ",00,00,00})

dbSelectArea("SX2")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX2", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SC6","                                        ","SC6010  ","Itens dos Pedidos de Venda    ","Ítems de los Pedidos de Venta ","Sales Orders Items            ","                                        ","C","C","C",00," ","C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO                                                                                                                                                                                                                       ","S",05,"C6_NUM+C6_ITEM+C6_PRODUTO                                                                                                                                                                                                                                     ","                              ","                              "," "," "," ",00,00,00})

dbSelectArea("SX2")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX2", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i


RestArea(aArea)
Return('SX2 : ' + cTexto  + CHR(13) + CHR(10))

Static Function GeraSX3()
Local aArea 			:= GetArea()
Local i      		:= 0
Local j      		:= 0
Local aRegs  		:= {}
Local cTexto 		:= ''
Local lInclui		:= .F.

aRegs  := {}
AADD(aRegs,{"SZB","01","ZB_FILIAL","C",02,00,"Filial","Sucursal","Branch","FilialdoSistema","Sucursal","BranchoftheSystem","@!","","€€€€€€€€€€€€€€€","","",01,"þÀ","","","U","N","","","","","","","","","","","033","","","","","","","","","","","","N","N","N"})
AADD(aRegs,{"SZB","02","ZB_TIPOMOV","C",01,00,"TipoMov.","TipoMov.","TipoMov.","TipoMovimento","TipoMovimento","TipoMovimento","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","S","A","R","€","","E=Entrada;S=Saida","","","","","","","","","","","","N","N","","","","","N","N","N"})
AADD(aRegs,{"SZB","03","ZB_FILNF","C",02,00,"FIlialNF","FIlialNF","FIlialNF","FIlialNF","FIlialNF","FIlialNF","@!","","€€€€€€€€€€€€€€ ","","",00,"þA","","","U","S","","","","","","","","","","","033","","","","","","","","","","","","N","N","N"})
AADD(aRegs,{"SZB","04","ZB_DOC","C",09,00,"Nota","Nota","Nota","NotaFiscal","NotaFiscal","NotaFiscal","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","S","","R","","","","","","","","","018","","","","","","N","N","","","","","N","N","N"})
AADD(aRegs,{"SZB","05","ZB_SERIE","C",03,00,"Serie","Serie","Serie","Serie","Serie","Serie","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","S","","R","","","","","","","","","","","","","","","N","N","","","","","N","N","N"})
AADD(aRegs,{"SZB","06","ZB_FORMUL","C",01,00,"Form.Prop.","Form.Prop.","Form.Prop.","Form.Prop.","Form.Prop.","Form.Prop.","!","","€€€€€€€€€€€€€€ ","","",00,"þA","","","U","S","","R","","","","","","","","","","","","","","","N","N","","","","","N","N","N"})
AADD(aRegs,{"SZB","07","ZB_EMISSAO","D",08,00,"Emissao","Emissao","Emissao","Emissao","Emissao","Emissao","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","S","A","R","€","","","","","","","","","","","","","","N","N","","","","","N","N","N"})
AADD(aRegs,{"SZB","08","ZB_CLIFOR","C",06,00,"Cli/For","Cli/For","Cli/For","Cli/For","Cli/For","Cli/For","@!","","€€€€€€€€€€€€€€ ","","",00,"þA","","","U","S","A","R","","","","","","","","","001","","","","","","N","N","","","","","N","N","N"})
AADD(aRegs,{"SZB","09","ZB_LOJA","C",02,00,"Loja","Loja","Loja","Loja","Loja","Loja","@!","","€€€€€€€€€€€€€€ ","","",00,"þA","","","U","S","A","R","","","","","","","","","002","","","","","","N","N","","","","","N","N","N"})
AADD(aRegs,{"SZB","10","ZB_TIPO","C",01,00,"TipodaNota","TipodaNota","TipodaNota","TipodaNota","TipodaNota","TipodaNota","@!","pertence('NDIPBC')","€€€€€€€€€€€€€€ ","","",00,"þA","","","U","S","A","R","","","","","","","","","","","","","","","N","N","","","","","N","N","N"})
AADD(aRegs,{"SZB","11","ZB_ESPECIE","C",05,00,"Espec.Docum.","Espec.Docum.","Espec.Docum.","Espec.Docum.","Espec.Docum.","Espec.Docum.","@!","Vazio().or.ExistCpo('SX5','42'+M->F1_ESPECIE)","€€€€€€€€€€€€€€ ","","42",00,"þA","","","U","S","A","R","","","","","","","","","","","","","","","N","N","","","","","N","N","N"})
AADD(aRegs,{"SZB","12","ZB_PRODUTO","C",15,00,"Produto","Produto","Produto","Produto","Produto","Produto","","","€€€€€€€€€€€€€€ ","","SB1",00,"þÀ","","S","U","S","A","R","€","","","","","","","","","","","","","","N","N","","","","","N","N","N"})
AADD(aRegs,{"SZB","13","ZB_DESC","C",50,00,"Descricao","Descricao","Descricao","Descricao","Descricao","Descricao","@!","","€€€€€€€€€€€€€€ ","IIF(!INCLUI,POSICIONE('SB1',1,XFILIAL('SB1')+SZB->ZB_PRODUTO,'B1_DESC'),'')","",00,"þÀ","","","U","S","V","V","","","","","","","","","","","","","","","N","N","","","","","N","N","N"})
AADD(aRegs,{"SZB","14","ZB_TES","C",03,00,"TipoEnt/Sai","TipoEnt/Sai","TipoEnt/Sai","TipoEnt/Sai","TipoEnt/Sai","TipoEnt/Sai","@9","","€€€€€€€€€€€€€€ ","","SF4",00,"þA","","","U","S","A","R","","","","","","","","","","","","","","","N","N","","","","","N","N","N"})
AADD(aRegs,{"SZB","15","ZB_IDENTB6","C",06,00,"Ident.PD3","Ident.PD3","Ident.PD3","Ident.PD3","Ident.PD3","Ident.PD3","","","€€€€€€€€€€€€€€ ","","",00,"þA","","","U","S","A","R","","","","","","","","","","","","","","","N","N","","","","","N","N","N"})
AADD(aRegs,{"SZB","16","ZB_SERIORI","C",03,00,"SerieOrigem","SerieOrigem","SerieOrigem","SerieOrigem","SerieOrigem","SerieOrigem","","","€€€€€€€€€€€€€€ ","","",00,"þA","","","U","S","","R","","","","","","","","","","","","","","","N","N","","","","","N","N","N"})
AADD(aRegs,{"SZB","17","ZB_NFORI","C",09,00,"NotaOrigem","NotaOrigem","NotaOrigem","NotaOrigem","NotaOrigem","NotaOrigem","","","€€€€€€€€€€€€€€ ","","",00,"þA","","","U","S","","R","","","","","","","","","018","","","","","","N","N","","","","","N","N","N"})
AADD(aRegs,{"SZB","18","ZB_ITEMORI","C",04,00,"ItemOrigem","ItemOrigem","ItemOrigem","ItemOrigem","ItemOrigem","ItemOrigem","","","€€€€€€€€€€€€€€ ","","",00,"þA","","","U","S","","R","","","","","","","","","","","","","","","N","N","","","","","N","N","N"})
AADD(aRegs,{"SZB","19","ZB_QUANT","N",12,00,"Quantidade","Quantidade","Quantidade","Quantidade","Quantidade","Quantidade","999999999999","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","S","A","R","€","","","","","","","","","","","","","","N","N","","","","","N","N","N"})
AADD(aRegs,{"SZB","20","ZB_VUNIT","N",12,02,"ValorUnit.","ValorUnit.","ValorUnit.","ValorUnit.","ValorUnit.","ValorUnit.","9999999999.99","","€€€€€€€€€€€€€€ ","","",00,"þA","","","U","S","A","R","","","","","","","","","","","","","","","N","N","","","","","N","N","N"})
AADD(aRegs,{"SZB","21","ZB_TOTAL","N",12,02,"Total","Total","Total","Total","Total","Total","Total","","€€€€€€€€€€€€€€ ","","",00,"þA","","","U","S","A","R","","","","","","","","","","","","","","","N","N","","","","","N","N","N"})
AADD(aRegs,{"SZB","22","ZB_PD","C",06,00,"PD","PD","PD","PD","PD","PD","","","€€€€€€€€€€€€€€ ","","SZ8_01",00,"þÀ","","S","U","S","A","R","€","","","","","","","","","","","","","","N","N","","","","","N","N","N"})
AADD(aRegs,{"SZB","23","ZB_NOMPD","C",30,00,"NomePosto","NomePosto","NomePosto","NomePosto","NomePosto","NomePosto","@!","","€€€€€€€€€€€€€€ ","IIF(!INCLUI,POSICIONE('SZ8',1,XFILIAL('SZ8')+SZB->ZB_PD,'Z8_DESC'),'')","",00,"þÀ","","","U","N","V","V","","","","","","","","","","","","","","","N","N","","","","","N","N","N"})
AADD(aRegs,{"SZB","24","ZB_PODTER","C",06,00,"Terceiros","Terceiros","Terceiros","PoderdeTerceiros","PoderdeTerceiros","PoderdeTerceiros","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","","","","N","N","N"})
AADD(aRegs,{"SZB","25","ZB_SALDO","N",12,00,"Saldo","Saldo","Saldo","SaldoaRetornar","SaldoaRetornar","SaldoaRetornar","999999999999","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","","","","N","N","N"})
AADD(aRegs,{"SZB","26","ZB_VALOR","N",12,02,"Valor","Valor","Valor","ValordaMovimentacao","ValordaMovimentacao","ValordaMovimentacao","9999999999.99","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","","","","N","N","N"})
AADD(aRegs,{"SZB","27","ZB_POSTOFI","C",08,00,"PostoFisico","PostoFisico","PostoFisico","PostoFisico","PostoFisico","PostoFisico","","","€€€€€€€€€€€€€€ ","","PAS_01",00,"þA","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","N","N","N","N","N"})
AADD(aRegs,{"SZB","28","ZB_PEDGAR","C",10,00,"PedidoGAR","PedidoGAR","PedidoGAR","PedidoGAR","PedidoGAR","PedidoGAR","","","€€€€€€€€€€€€€€ ","","",00,"þA","","","U","S","A","R","","","","","","","","","","","","","","","N","N","","","","","N","N","N"})
AADD(aRegs,{"SZB","29","ZB_PEDSITE","C",10,00,"PedidoSite","PedidoSite","PedidoSite","PedidoSite","PedidoSite","PedidoSite","","","€€€€€€€€€€€€€€ ","","",00,"þA","","","U","S","A","R","","","","","","","","","","","","","","","N","N","","","","","N","N","N"})
AADD(aRegs,{"SZB","30","ZB_PENTREG","C",06,00,"PostoEntreg","PostoEntreg","PostoEntreg","PostoEntreg","PostoEntreg","PostoEntreg","","","€€€€€€€€€€€€€€ ","","",00,"þA","","","U","S","A","R","","","","","","","","","","","","","","","N","N","","","","","N","N","N"})
AADD(aRegs,{"SZB","31","ZB_UFENTRE","C",02,00,"UFentrega","UFentrega","UFentrega","UFentrega","UFentrega","UFentrega","","","€€€€€€€€€€€€€€ ","","",00,"þA","","","U","S","A","R","","","","","","","","","","","","","","","N","N","","","","","N","N","N"})
AADD(aRegs,{"SZB","32","ZB_RECSZ5","N",09,00,"RecnoSZ5","RecnoSZ5","RecnoSZ5","RecnoSZ5","RecnoSZ5","RecnoSZ5","999999999","","€€€€€€€€€€€€€€ ","","",00,"þA","","","U","S","A","R","","","","","","","","","","","","","","","N","N","","","","","N","N","N"})

dbSelectArea("SX3")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(2)
 lInclui := !DbSeek(aRegs[i, 3])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX3", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i


RestArea(aArea)
Return('SX3 : ' + cTexto  + CHR(13) + CHR(10))

Static Function GeraSX6()
Local aArea 			:= GetArea()
Local i      		:= 0
Local j      		:= 0
Local aRegs  		:= {}
Local cTexto 		:= ''
Local lInclui		:= .F.

aRegs  := {}
AADD(aRegs,{"","MV_XFILFAT","C","IndiqueoEstado-CodigodaFilialquedevemser","","","separadospor','paraindicarfaturamentofaturam","","","entodiferenciadoporEstado-Filial","","","RJ-01","","","","","","","","",""})
AADD(aRegs,{"01","MV_GARSHRD","C","IndicaoCódigodasériedeNotasquedeveser","","","utilizadoparanotasfiscaisdehardware","","","","","","3","","","","","","","","",""})
AADD(aRegs,{"02","MV_GARSHRD","C","IndicaoCódigodasériedeNotasquedeveser","","","utilizadoparanotasfiscaisdehardware","","","","","","2","","","","","","","","",""})

dbSelectArea("SX6")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 cTexto += IIf( aRegs[i,1] + aRegs[i,2] $ cTexto, "", aRegs[i,1] + aRegs[i,2] + "\")

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX6", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i


RestArea(aArea)
Return('SX6 : ' + cTexto  + CHR(13) + CHR(10))

Static Function GeraSX5()
Local aSavArea := GetArea()
Local aSX5 	   := {}
Local nCount   := 1                                
Local lSX5     := .F.
Local cTexto   := ""
Local cAlias   := "SX5"

	AADD(aSX5,{"61","VENDA DE SOFTWARE"})
	AADD(aSX5,{"62","VENDA DE HARDWARE"})
	
	SX5->(dbGoTop())
	SX5->(dbSetOrder(1))
	For nCount := 1 To Len(aSX5)
		If ! SX5->(DbSeek("01"+"DJ"+aSX5[nCount][1]))
			RecLock("SX5",.T.)
			X5_FILIAL  := "01"
			X5_TABELA  := "DJ"
			X5_CHAVE   := aSX5[nCount][1]
			X5_DESCRI  := Upper(aSX5[nCount][2])
			X5_DESCSPA := Upper(aSX5[nCount][2])
			X5_DESCENG := Upper(aSX5[nCount][2])				
			lSX5 := .T.
			MsUnLock()
		EndIf
	Next nCount        
	If lSX5 
		cTexto := 'SX5 : Carregada Tabela DJ'+CHR(13)+CHR(10)
	EndIf

RestArea(aSavArea)
Return(cTexto)