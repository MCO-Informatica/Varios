//------------------------------------------------------------------
// Rotina | CSFA140   | Autor | Robson Luiz - Rleg | Data | 27/04/13
//------------------------------------------------------------------
// Descr. | Rotina de direcionamento de funcionalidade.
//        | 
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
#Include 'Protheus.ch'

User Function CSFA140(nFunc)
	If GdFieldPos('UB_PRODUTO') > 0 .And. GdFieldPos('UB_COD_GAR') > 0 .And. GdFieldPos('UB_QUANT') > 0 .And. GdFieldPos('UB_ITEM') > 0
		If nFunc == 1
			A140Param()
		Elseif nFunc == 2
			A140ProdGAR()
		Endif
	Else
		MsgInfo('Funcionalidade não disponível.')
	Endif
Return

//------------------------------------------------------------------
// Rotina | A140Param | Autor | Robson Luiz - Rleg | Data | 27/04/13
//------------------------------------------------------------------
// Descr. | Rotina p/usuário informar o código do produto GAR e 
//        | descarregar o código dos produtos KIT no item do atendimento.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
Static Function A140Param()
	Local aPar := {}
	Local aRet := {}
	Local aButton := {}
	Local cBkp := ''
	
	If SUB->(FieldPos('UB_COD_GAR'))>0
		cBkp := cCadastro 
		cCadastro := 'Informe os dados'
		
		AAdd(aPar,{1,'Código GAR',Space(Len(PA8->PA8_CODBPG)),'@!',"ExistCpo('PA8')",'PA8','',80,.T.})
		AAdd(aPar,{1,'Quantidade',0.00,'@E 9,999.99','mv_par02>0','','',50,.T.})
		
		If ParamBox(aPar,'Código/Quantidade do kit',@aRet,,,,,,,,.F.,.F.)
			MsgRun("Descarregando os dados, aguarde...","",{|| A140Struct(aRet) })
		Endif
		cCadastro := cBkp
	Else
		MsgInfo('Estrutura da tabela Itens do Televendas (SUB) incompatível, verifique o campo UB_COD_GAR.')
	Endif
Return

//------------------------------------------------------------------
// Rotina | A140Struct | Autor | Robson Luiz -Rleg | Data | 27/04/13
//------------------------------------------------------------------
// Descr. | Rotina com o mecanismo de buscar o código dos componentes.
//        | 
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
Static Function A140Struct(aRet)
	Local aArea     := GetArea()
	Local aBOM      := {}

	Local nPProduto := AScan(aHeader,{|x| RTrim(x[2]) == "UB_PRODUTO"})
	Local nPProdKIT := AScan(aHeader,{|x| RTrim(x[2]) == "UB_COD_GAR"})
	Local nPQtdVen  := AScan(aHeader,{|x| RTrim(x[2]) == "UB_QUANT"})
	Local nPItem    := AScan(aHeader,{|x| RTrim(x[2]) == "UB_ITEM"})
	Local nX := 0
	Local nY := 0
	Local cItem := ""
	
	PA8->(dbSetOrder(1))
	If PA8->(dbSeek(xFilial('PA8')+aRet[1]))
		SG1->(dbSetOrder(1))
		If SG1->(dbSeek(xFilial('SG1')+PA8->PA8_CODMP8))
			While !SG1->(EOF()) .And. xFilial("SG1") == SG1->G1_FILIAL .And. SG1->G1_COD == PA8->PA8_CODMP8
				SB1->(dbSetOrder(1))
				SB1->(MsSeek(xFilial("SB1")+SG1->G1_COMP))
				If SB1->B1_FANTASM<>"S"
					AAdd(aBOM,{SG1->G1_COMP,ExplEstr(aRet[2],dDataBase,"",SB1->B1_REVATU),SB1->B1_DESC})
				Endif					
				SG1->(dbSkip())
			End
		Else
			AAdd(aBOM,{PA8->PA8_CODMP8,1,PA8->PA8_DESMP8})
		Endif
		If Len(aBOM)>0
			For nX := 1 To Len(aBOM)
				nItem := Len(aCOLS)
				cItem := aCOLS[nItem,nPItem]
				If !Empty(aCOLS[nItem,nPProduto])
					cItem := Soma1(cItem)
					AAdd(aCOLS,Array(Len(aHeader)+1))
					nItem := Len(aCOLS)
				Endif
				For nY := 1 To Len(aHeader)
					If ( AllTrim(aHeader[nY][2]) == "UB_ITEM" )
						aCOLS[Len(aCOLS)][nY] := cItem
					Else
						If (aHeader[nY,2] <> "UB_REC_WT") .And. (aHeader[nY,2] <> "UB_ALI_WT")				
							aCOLS[Len(aCOLS)][nY] := CriaVar(aHeader[nY][2])
						Endif
					Endif
				Next nY
				
				RegToMemory("SUB")
				M->UB_PRODUTO := aBom[nX][1]
				M->UB_QUANT   := aBom[nX][2]
				M->UB_COD_GAR := aRet[1]
				
				N := Len(aCOLS)
				aCOLS[N][Len(aHeader)+1] := .F.
				aCOLS[N][nPProduto] := aBom[nX][1]
				aCOLS[N][nPQtdVen]  := aBom[nX][2]
				aCOLS[N][nPProdKIT] := aRet[1]
				
				TK273Calcula("UB_PRODUTO")
				
				If ExistTrigger("UB_PRODUTO")
					RunTrigger(2,N,Nil,,"UB_PRODUTO")
				Endif
				
				If ExistTrigger("UB_QUANT  ")
					RunTrigger(2,N,Nil,,"UB_QUANT  ")
				Endif
			Next nX
			If ValType(oGetTlv) <> NIL
				oGetTlv:ForceRefresh()
			Endif
		Else
			MsgInfo('Não foi possível carregar componentes.')
		Endif
	Else
		MsgInfo('Código informado não localizado.')
	Endif
Return

//------------------------------------------------------------------
// Rotina | A140ProdGar | Autor | Robson Luiz - Rleg | DT | 27/04/13
//------------------------------------------------------------------
// Descr. | Rotina para localizar o produto GAR e o operador copiar
//        | o link do produto no site.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
Static Function A140ProdGar()
	Local nUB_COD_GAR := 0	
	If SUB->(FieldPos('UB_COD_GAR'))>0
		nUB_COD_GAR := GdFieldPos('UB_COD_GAR')
		If nUB_COD_GAR > 0
			If ValType(aCOLS) == 'A' .And. ValType(N) == 'N'
				PA8->(dbSetOrder(1))
				If PA8->(dbSeek(xFilial('PA8')+aCOLS[N,nUB_COD_GAR]))
					AxVisual('PA8',PA8->(RecNo()),2)
				Else
					MsgAlert('Produto GAR não localizado, verifique se o campo está preenchido.')
				Endif
			Else
				MsgAlert('Não localizei o vetor aCOLS e/ou a variável N para buscar.')
			Endif
		Else
			MsgAlert('Não localizei o campo UB_COD_GAR.')
		Endif
	Else
		MsgAlert('Não existe o campo UB_COD_GAR, execute o UpDate UPD140.')
	Endif
Return

//------------------------------------------------------------------
// Rotina | UPD140()   | Autor | Robson Luiz -Rleg | Data | 27/04/13
//------------------------------------------------------------------
// Descr. | Rotina de update para criar as estruturas no dicionário
//        | de dados.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
User Function UPD140()
	Local cModulo := "TMK"
	Local bPrepar := {|| U_U140Ini() }
	Local nVersao := 01

	NGCriaUpd(cModulo,bPrepar,nVersao)
Return

//------------------------------------------------------------------
// Rotina | U140Ini    | Autor | Robson Luiz -Rleg | Data | 27/04/13
//------------------------------------------------------------------
// Descr. | Estrutura de dados para criar o dicionário de dados.
//        | 
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
User Function U140Ini()
	aSX3 := {}
	AAdd(aSX3,{	'SUB',NIL,'UB_COD_GAR','C',32,0,;                                             //Alias,Ordem,Campo,Tipo,Tamanho,Decimais
					'Codigo GAR','Codigo GAR','Codigo GAR',;                                      //Tit. Port.,Tit.Esp.,Tit.Ing.
					'Codigo do produto GAR','Codigo do produto GAR','Codigo do produto GAR',;     //Desc. Port.,Desc.Esp.,Desc.Ing.
					'@!',;                                                                        //Picture
					'',;                                                                          //Valid
					'€‚€€€€€€€€€€€€€',;                                                           //Usado
					'',;                                                                          //Relacao
					'',1,'þA','','',;                                                             //F3,Nivel,Reserv,Check,Trigger
					'U','N','V','R',' ',;                                                         //Propri,Browse,Visual,Context,Obrigat
					'',;	                                                                        //VldUser
					'','','',;                                                                    //Box Port.,Box Esp.,Box Ing.
					'','','','','',;                                                              //PictVar,When,Ini BRW,GRP SXG,Folder
					'N','','','',' ',' '})                                                        //Pyme,CondSQL,ChkSQL,IdxSrv,Ortogra

	AAdd(aSX3,{	'PA8',NIL,'PA8_LINKPR','C',250,0,;                                            //Alias,Ordem,Campo,Tipo,Tamanho,Decimais
					'Link prod.','Link prod.','Link prod.',;                                      //Tit. Port.,Tit.Esp.,Tit.Ing.
					'Link do produto','Link do produto','Link do produto',;   							//Desc. Port.,Desc.Esp.,Desc.Ing.
					'@!',;                                                                        //Picture
					'',;                                                                          //Valid
					'€€€€€€€€€€€€€€ ',;                                                           //Usado
					'',;                                                                          //Relacao
					'',1,'þA','','',;                                                             //F3,Nivel,Reserv,Check,Trigger
					'U','N','A','R',' ',;                                                         //Propri,Browse,Visual,Context,Obrigat
					'',;	                                                                        //VldUser
					'','','',;                                                                    //Box Port.,Box Esp.,Box Ing.
					'','','','','',;                                                              //PictVar,When,Ini BRW,GRP SXG,Folder
					'N','','','',' ',' '})                                                        //Pyme,CondSQL,ChkSQL,IdxSrv,Ortogra
	aSIX := {}
	AAdd(aSIX,{	'PA8','3','PA8_FILIAL+PA8_DESMP8', ;
					'Descricao do produto Protheus',;
					'Descricao do produto Protheus',;
					'Descricao do produto Protheus','U',"S"})

	AAdd(aSIX,{	'PA8','4','PA8_FILIAL+PA8_DESBPG', ;
					'Descricao do produto GAR',;
					'Descricao do produto GAR',;
					'Descricao do produto GAR','U',"S"})
   aSXB := {}
   AAdd(aSXB,{	'PA8','2','03','03','Descri Totvs','Descri Totvs','Descri Totvs',''})
   AAdd(aSXB,{	'PA8','4','03','01','Descri Totvs','Descri Totvs','Descri Totvs','PA8_DESMP8'})
   AAdd(aSXB,{	'PA8','4','03','02','Codigo Totvs','Codigo Totvs','Codigo Totvs','PA8_CODMP8'})
   AAdd(aSXB,{	'PA8','4','03','03','Descri GAR'  ,'Descri GAR'  ,'Descri GAR'  ,'PA8_CODBPG'})
   
   AAdd(aSXB,{	'PA8','2','04','04','Descri GAR'  ,'Descri GAR'  ,'Descri GAR'  ,''})
   AAdd(aSXB,{	'PA8','4','04','01','Descri GAR'  ,'Descri GAR'  ,'Descri GAR'  ,'PA8_DESBPG'})
   AAdd(aSXB,{	'PA8','4','04','02','Codigo GAR'  ,'Codigo GAr'  ,'Codigo GAR'  ,'PA8_CODBPG'})
   AAdd(aSXB,{	'PA8','4','04','03','Codigo TOTVS','Codigo TOTVS','Codigo TOTVS','PA8_CODMP8'})
   AAdd(aSXB,{	'PA8','4','04','04','Descri TOTVS','Descri TOTVS','Descri TOTVS','PA8_DESMP8'})

	aHelp := {}
	aAdd(aHelp,{'UB_COD_GAR', 'Código do produto GAR associado com o código do produto Protheus.'})
	aAdd(aHelp,{'PA8_LINKPR', 'Link da web relativo ao código do produto GAR.'})
Return(.T.)