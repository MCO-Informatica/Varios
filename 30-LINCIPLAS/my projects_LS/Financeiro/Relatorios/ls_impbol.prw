#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	LS_IMPBOL
// Autor 		Alexandre Dalpiaz
// Data 		08/11/10
// Descricao  	Impressão dos boletos dos PDVs
// Uso         	LaSelva
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 03/10/2012 - alexandre - criação de parâmetros para seleção de banco/ag/conta corrente que será utilizado no boleto
//							criação de parâmetros para seleção do cedente (fornecedor) utilizado no boleto
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_IMPBOL()
/////////////////////////
Local 	aCampos 		:= {}
Private	_lVisualiza  	:= .T.

U_LAFECCX()

DbSelectArea('SX3')
DbSetOrder(2)
	
aAdd(aCampos,{ 'E1_OK', '', '', '' } )
DbSeek('E1_PREFIXO',.F.); Aadd(aCampos,{ TRIM( SX3->X3_CAMPO ), SX3->X3_TITULO, TRIM( SX3->X3_TITULO ), SX3->X3_PICTURE } )
DbSeek('E1_NUM'    ,.F.); Aadd(aCampos,{ TRIM( SX3->X3_CAMPO ), SX3->X3_TITULO, TRIM( SX3->X3_TITULO ), SX3->X3_PICTURE } )
DbSeek('E1_PARCELA',.F.); Aadd(aCampos,{ TRIM( SX3->X3_CAMPO ), SX3->X3_TITULO, TRIM( SX3->X3_TITULO ), SX3->X3_PICTURE } )
DbSeek('E1_EMISSAO',.F.); Aadd(aCampos,{ TRIM( SX3->X3_CAMPO ), SX3->X3_TITULO, TRIM( SX3->X3_TITULO ), SX3->X3_PICTURE } )
DbSeek('E1_VENCTO' ,.F.); Aadd(aCampos,{ TRIM( SX3->X3_CAMPO ), SX3->X3_TITULO, TRIM( SX3->X3_TITULO ), SX3->X3_PICTURE } )
DbSeek('E1_VALOR'  ,.F.); Aadd(aCampos,{ TRIM( SX3->X3_CAMPO ), SX3->X3_TITULO, TRIM( SX3->X3_TITULO ), SX3->X3_PICTURE } )
DbSeek('E1_SALDO'  ,.F.); Aadd(aCampos,{ TRIM( SX3->X3_CAMPO ), SX3->X3_TITULO, TRIM( SX3->X3_TITULO ), SX3->X3_PICTURE } )
DbSeek('E1_NUMBCO' ,.F.); Aadd(aCampos,{ TRIM( SX3->X3_CAMPO ), SX3->X3_TITULO, TRIM( SX3->X3_TITULO ), SX3->X3_PICTURE } )
DbSeek('E1_NUMBOR' ,.F.); Aadd(aCampos,{ TRIM( SX3->X3_CAMPO ), SX3->X3_TITULO, TRIM( SX3->X3_TITULO ), SX3->X3_PICTURE } )

DbSelectArea("SE1")
cIndexName := Criatrab(Nil,.F.)                
cIndexKey  := "E1_CONTRAT+E1_PREFIXO + E1_NUM + E1_PARCELA"

cFilter    := "E1_FILIAL == '" 	+ xFilial("SE1") + "' .and. "
cFilter    += "E1_SALDO > 0 .and. "
cFilter    += "E1_TIPO == 'PDV' .and. "
cFilter    += "E1_CLIENTE < '000009' .and. "    

_cQueryOK := "UPDATE SE1"
_cQueryOK += " SET E1_OK = ''"
_cQueryOK += " FROM " + RetSqlName('SE1')
_cQueryOK += " WHERE E1_TIPO = 'PDV'"
_cQueryOK += " AND D_E_L_E_T_ = ''"
	
If cFilAnt <> '01'
	_cQueryOK+= " AND E1_PREFIXO = 'Z" + cFilAnt + "'"

	cFilter    += "E1_LOJA = '" + cFilAnt + "'"
	//cFilter    += "E1_LOJA = '" + cFilAnt + "' .or. E1_MATRIZ = '" + cFilAnt + "')"
	/*
	_cQuery := "UPDATE SE1"
	_cQuery += " SET SE1.E1_CONTRAT = RIGHT('000000' + CONVERT(VARCHAR,ORDEM),6)"
	_cQuery += " FROM " + 	RetSqlName('SE1') + " SE1 (NOLOCK)"
	_cQuery += " INNER JOIN ("
	_cQuery += " SELECT R_E_C_N_O_ RECNO, ROW_NUMBER() OVER (ORDER BY E1_EMISSAO DESC) ORDEM"
	_cQuery += " FROM " + 	RetSqlName('SE1') + " (NOLOCK)"
	_cQuery += " WHERE E1_PREFIXO = 'Z" + cFilAnt + "'"
	_cQuery += " AND E1_TIPO = 'PDV') A"
	_cQuery += " ON SE1.R_E_C_N_O_ = RECNO"
	TcSqlExec(_cQuery)
	*/
EndIf              

TcSqlExec(_cQueryOK)

IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Aguarde. Selecionando Registros....")
DbGoTop()

_aCores := {}
Aadd(_aCores, {"empty(E1_CONTRAT)","BR_VERDE"})
Aadd(_aCores, {"!empty(E1_CONTRAT)","BR_VERMELHO"})

_aLegenda := {}
Aadd(_aLegenda, {"BR_VERDE"      , "Não impresso" 		})
Aadd(_aLegenda, {"BR_VERMELHO"  , "Boleto já impresso"	})

cMarca    := GetMark()
linverte  := .f.
cCadastro := "Emissão de Títulos"
aRotina   := {}
Aadd( aRotina, { "Pesquisar"  , "AxPesqui"    , 0, 1})
Aadd( aRotina, { "Visualizar" , "U_VISTIT2()" , 0, 2})
Aadd( aRotina, { "Imprimir"   , "U_IMPTIT2()" , 0, 6})
Aadd( aRotina, { "Legenda"      , 'BrwLegenda("Status Nota Fiscal Eletronica","Legenda",_aLegenda)'  , 0, 2 })

DbGoTop()

Markbrow("SE1","E1_OK",,aCampos,@linverte,@cMarca,,,,,,,,,_aCores)

DbSelectArea("SE1")
DbCloseArea()
ChkFile('SE1')

Return()

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function VISTIT2()
///////////////////////

_lVisualiza 	:= 	.T.
MontaRel()

If MsgBox('O(s) boleto(s) foi(ram) impresso(s) corretamente?','ATENÇÃO!!!!','YESNO')
	_cQuery := "UPDATE " + 	RetSqlName('SE1')
	_cQuery += " SET E1_CONTRAT = '" + dtos(date()) + left(time(),5) + "'"
	_cQuery += " WHERE E1_TIPO = 'PDV'"
	_cQuery += " AND D_E_L_E_T_ = ''"
	_cQuery += " AND E1_OK = '" + cMarca + "'"
	TcSqlExec(_cQuery)		
EndIf
Return()

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function IMPTIT2()
///////////////////////
_lVisualiza := .f.
MontaRel()

If MsgBox('O(s) boleto(s) foi(ram) impresso(s) corretamente?','ATENÇÃO!!!!','YESNO')
	_cQuery := "UPDATE " + 	RetSqlName('SE1')
	_cQuery += " SET E1_CONTRAT = '" + dtos(date()) + left(time(),5) + "'"
	_cQuery += " WHERE E1_TIPO = 'PDV'"
	_cQuery += " AND D_E_L_E_T_ = ''"
	_cQuery += " AND E1_OK = '" + cMarca + "'"
	TcSqlExec(_cQuery)		
EndIf

Return()

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function MontaRel()
//////////////////////////
Local _aBitmap
Local aBolText

//Objetos para tamanho e tipo das fontes
oFont8   := TFont():New("Times New Roman",,8 ,,.F.,,,,,.F.)
oFont10CN:= TFont():New("Courier New"    ,,10,,.T.,,,,,.F.)
oFont12CN:= TFont():New("Courier New"    ,,12,,.T.,,,,,.F.)
oFont14CN:= TFont():New("Courier New"    ,,14,,.T.,,,,,.F.)
oFont10  := TFont():New("Times New Roman",,10,,.T.,,,,,.F.)
oFont12  := TFont():New("Times New Roman",,12,,.T.,,,,,.F.)
oFont16  := TFont():New("Times New Roman",,16,,.T.,,,,,.F.)
oFont16n := TFont():New("Times New Roman",,16,,.T.,,,,,.F.)
oFont24  := TFont():New("Times New Roman",,20,,.T.,,,,,.F.)

oPrn:=TmsPrinter():New("Boleto Laser")
oPrn:Setup()           // Impressora Padrão
oPrn:SetPortrait()     // ou SetLanscape()

DbSelectArea("SE1")
DbGoTop()
Do While !Eof()
	
	If !Marked("E1_OK")
		DbSkip()
		Loop
	EndIf
	
	_Instr1 := 'Preencha o campo VALOR DO DOCUMENTO com o montante que está sendo pago.'
	_Instr2 := ''	//'Valor de Outros Acréscimos: valor da diferença a maior (se houver)'
	_Instr3 := ''	//'Valor Cobrado: Valor do documento - desconto + acréscimos'
	_Instr4 := ''
	_Instr5 := ''	//'Desconto ou acrécimo definidos pelo sacado.'

	_aBitmap := {}
	Aadd(_aBitmap, "\system\banco" + SE1->E1_PORTADO + ".bmp")	        	// Logo do Banco
	
	aBolText    := {}
	If !Empty(_Instr1)
		Aadd(aBolText, _Instr1)				// 1a. Linha da Instrução Bancária
	EndIf
	If !Empty(_Instr2)
		Aadd(aBolText, _Instr2)				// 2a. Linha da Instrução Bancária
	EndIf
	If !Empty(_Instr3)
		Aadd(aBolText, _Instr3)				// 3a. Linha da Instrução Bancária
	EndIf
	If !Empty(_Instr4)
		Aadd(aBolText, _Instr4)				// 4a. Linha da Instrução Bancária
	EndIf
	If !Empty(_Instr5)
		Aadd(aBolText, _Instr5)				// 5a. Linha da Instrução Bancária
	EndIf
	
	U_LS_GeraCodBar()  

	If Empty(SE1->E1_NUMBCO)
		MsgBox("Titulo " + SE1->E1_NUM + " Cliente " + SE1->E1_CLIENTE + "-" + SE1->E1_LOJA + " não gravado. Não será impresso Boleto!", "ATENÇÃO!!!","STOP")
		DbSelectArea("SE1")
		DbSkip()
		Loop
	Endif
	
	Impress(oPrn,_aBitmap,aBolText)
	
	DbSelectArea('SE1')
	dbSkip()
Enddo

If _lVisualizar
	oPrn:Preview()       // Visualiza antes de imprimir
Else
	oPrn:Print()         // imprimir sem Visualizar
EndIf

oPrn:End()         

Return()

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Impress(oPrn,_aBitmap,aBolText)
///////////////////////////////////////////////

n := 0
_xwLin   := 150

oPrn:StartPage()       // Inicia uma Nova Página
SEE->(DbSetOrder(1))
SEE->(DbSeek(xFilial('SEE') + SE1->E1_PORTADO + SE1->E1_AGEDEP + SE1->E1_CONTA + SE1->E1_BCOCLI,.f.))

SA1->(DbSetOrder(1))
SA1->(DbSeek(xFilial('SA1') + SE1->E1_CLIENTE + SE1->E1_LOJA,.F.))

If cFilAnt >= '01' .and. cFilAnt <= '99'
	_cDadCed := GetMv('LS_PDVCD01')
ElseIf cFilAnt >= 'A0' .and. cFilAnt <= 'AZ'
	_cDadCed := GetMv('LS_PDVCDA0')
ElseIf cFilAnt >= 'C0' .and. cFilAnt <= 'EZ'
	_cDadCed := GetMv('LS_PDVCDC0')
ElseIf cFilAnt >= 'R0' .and. cFilAnt <= 'RZ'
	_cDadCed := GetMv('LS_PDVCDR0')
ElseIf cFilAnt >= 'T0' .and. cFilAnt <= 'TZ'
	_cDadCed := GetMv('LS_PDVCDT0')
ElseIf cFilAnt >= 'G0' .and. cFilAnt <= 'GZ'
	_cDadCed := GetMv('LS_PDVCDG0')
Else
	_cDadCed := GetMv('LS_PDVCDBH')
EndIf

SA2->(DbSetOrder(1))
SA2->(DbSeek(xFilial('SA2') + _cDadCed,.F.))
Aadd(_aBitmap, "\system\lgrl01" + SA2->A2_LOJA + ".bmp")  									// Logo da Empresa

_xCGCCPF := Trans(SA1->A1_CGC,iif(Len(alltrim(SA1->A1_CGC)) <> 14, "@R 999.999.999-99", "@R 99.999.999/9999-99"))
_nLin 	 := -100
oPrn:SayBitmap(_xwLin+_nLin , 100 ,_aBitmap[2] ,300 ,300)

oPrn:Say(0050+_xwLin-100 ,500  ,SA2->A2_NOME     																,oFont10)
oPrn:Say(0085+_xwLin-100 ,500  ,SA2->A2_NREDUZ   																,oFont10)
oPrn:Say(0050+_xwLin-100 ,1600 ,SA2->A2_END    															   		,oFont10)
oPrn:Say(0085+_xwLin-100 ,1600 ,alltrim(SA2->A2_BAIRRO)+",  "+alltrim(SA2->A2_MUN)+", "+SA2->A2_EST      		,oFont10)
oPrn:Say(0120+_xwLin-100 ,1600 ,"CEP: "  + tran(SA2->A2_CEP,'@R 99999-999')                   					,oFont10)
oPrn:Say(0155+_xwLin-100 ,1600 ,"FONE: " + SA2->A2_TEL		 										   			,oFont10)
oPrn:Say(0190+_xwLin-100 ,1600 ,"CNPJ: " + tran(SA2->A2_CGC, '@R 99.999.999/9999-99') 					 		,oFont10)
oPrn:Say(0225+_xwLin-100 ,1600 ,"I.E.: " + alltrim(SA2->A2_INSCR) 												,oFont10)

oPrn:Box (0300+_xwLin-100 ,0100 ,0600+_xwLin-100 ,2300)
oPrn:Line(0400+_xwLin-100 ,0100 ,0400+_xwLin-100 ,2300)
oPrn:Line(0300+_xwLin-100 ,0400 ,0400+_xwLin-100 ,0400)
oPrn:Line(0300+_xwLin-100 ,0800 ,0400+_xwLin-100 ,0800)
oPrn:Line(0300+_xwLin-100 ,1150 ,0400+_xwLin-100 ,1150)
oPrn:Line(0300+_xwLin-100 ,1500 ,0400+_xwLin-100 ,1500)
oPrn:Line(0300+_xwLin-100 ,1850 ,0400+_xwLin-100 ,1850)

oPrn:Say(430+_xwLin-100 ,0115 ,"Dados do Sacado"                												,oFont8 )
oPrn:Say(470+_xwLin-100 ,0115 ,alltrim(SA1->A1_NOME) + ' (' + SA1->A1_LOJA + ' - ' + alltrim(SA1->A1_NREDUZ) + ')'	,oFont10)
oPrn:Say(505+_xwLin-100 ,0115 ,alltrim(SA1->A1_END) + ' ' + SA1->A1_BAIRRO    									,oFont10)
oPrn:Say(540+_xwLin-100 ,0115 ,alltrim(SA1->A1_MUN)                   											,oFont10)

oPrn:Say(470+_xwLin-100 ,1800 ,_xCGCCPF		                                 									,oFont10)
oPrn:Say(540+_xwLin-100 ,1800 ,SA1->A1_EST + "   " + tran(SA1->A1_CEP,'@R 99999-999')			            	,oFont10)

oPrn:Say(315+_xwLin-100 ,0115 ,"Vencimento"                     												,oFont8 )

oPrn:Say(345+_xwLin-100 ,0115 ,Dtoc(SE1->E1_VENCTO)               												,oFont10)

oPrn:Say(315+_xwLin-100 ,0415 ,"Valor R$"                               										,oFont8 )
oPrn:Say(345+_xwLin-100 ,0415 ,Transform(SE1->E1_SALDO,"@E 9,999,999.99")										,oFont10)

oPrn:Say(315+_xwLin-100 ,0815 ,"Data da Operação"               												,oFont8 )
oPrn:Say(345+_xwLin-100 ,0815 ,dtoc(SE1->E1_EMISSAO)           													,oFont10)

oPrn:Say(315+_xwLin-100 ,1165 ,"Nro.do Documento"               												,oFont8 )
oPrn:Say(345+_xwLin-100 ,1165 ,SE1->E1_PREFIXO + ' / ' + SE1->E1_NUM  + " - " + SE1->E1_PARCELA 				,oFont10)

oPrn:Say(315+_xwLin-100 ,1515 ,"Agência/Código Cedente"         												,oFont8 )

oPrn:Say(345+_xwLin-100 ,1515 ,alltrim(SEE->EE_AGENCIA) + SEE->EE_CODEMP										,oFont10)

oPrn:Say(315+_xwLin-100 ,1865 ,"Nosso Número"                   												,oFont8 )
oPrn:Say(345+_xwLin-100 ,1865 ,SE1->E1_NUMBCO                													,oFont10)
                               
_lRedZ := PAI->(DbSeek(SE1->E1_MSFIL + dtos(SE1->E1_EMISSAO) + padl(SE1->E1_PARCELA,10,'0'),.f.))

oPrn:Box (0620+_xwLin-100 ,0100 ,1000+_xwLin-100 ,2300)
oPrn:Say(650+_xwLin-100 ,0150 ,'Data do movimento'	 	    													,oFont16n)
oPrn:Say(700+_xwLin-100 ,0200 ,dtoc(SE1->E1_EMISSAO)     	 	    											,oFont16n)
oPrn:Say(760+_xwLin-100 ,0150 ,'Número de Série do ECF'     													,oFont16n)
oPrn:Say(810+_xwLin-100 ,0200 ,	iif(_lRedZ, PAI->PAI_SERPDV,'Red Z não localizada')								,oFont16n)
oPrn:Say(870+_xwLin-100 ,0150 ,'Número da Redução Z' 	    													,oFont16n)
oPrn:Say(920+_xwLin-100 ,0200 ,iif(_lRedZ, PAI->PAI_NUMRED,'Red Z não localizada')								,oFont16n)

oPrn:Say(650+_xwLin-100 ,1100 ,'COO'              	 	    													,oFont16n)
oPrn:Say(700+_xwLin-100 ,1150 ,iif(_lRedZ,PAI->PAI_NUMFIM,'Red Z não localizada')								,oFont16n)
oPrn:Say(760+_xwLin-100 ,1100 ,'Número do PDV'    	 	    													,oFont16n)
oPrn:Say(810+_xwLin-100 ,1150 ,padl(SE1->E1_PARCELA,10,'0')				 	    								,oFont16n)
oPrn:Say(870+_xwLin-100 ,1100 ,'Valor do documento'	 	    													,oFont16n)
oPrn:Say(920+_xwLin-100 ,1150 ,Transform(SE1->E1_SALDO,"@E 9,999,999.99")										,oFont16n)

oPrn:Box (1050+_xwLin-100 ,0100 ,1600+_xwLin-100 ,2300)
oPrn:Say(1150+_xwLin-100 ,0150 ,'Instruções de preenchimento'                             						,oFont16n)
oPrn:Say(1290+_xwLin-100 ,0150 ,'Valor do Desconto/Abatimento: valor da diferença a menor (se houver)'			,oFont16n)
oPrn:Say(1360+_xwLin-100 ,0150 ,'Valor de Outros Acréscimos: valor da diferença a maior (se houver)'			,oFont16n)
oPrn:Say(1440+_xwLin-100 ,0150 ,'Valor Cobrado: Valor do documento - desconto + acréscimos'          			,oFont16n)

oPrn:Line(1700+_xwLin ,0100 ,1700+_xwLin ,2300)
oPrn:Say(1720+_xwLin , 1970 ," Via do Sacado"																	,oFont10)
oPrn:Say(1720+_xwLin  ,1000 ,"Autenticação Mecânica"              					    						,oFont8 )

oPrn:Say(1730+_xwLin  ,600, SE1->E1_PORTADO + '-9'   															,oFont16n)
_xwlin -= 270

For i := 100 to 2300 step 50
	oPrn:Line(1850+_xwLin ,i ,1850+_xwLin ,i+30)
Next i

oPrn:SayBitMap(1995+_xwLin  , 100 ,_aBitmap[1] ,400 ,100)

oPrn:Line(2100+_xwLin ,100 ,2100+_xwLin ,2300)
oPrn:Line(2100+_xwLin ,550 ,2000+_xwLin ,0550)
oPrn:Line(2100+_xwLin ,800 ,2000+_xwLin ,0800)

oPrn:Say(2012+_xwLin ,850 ,transform(SE1->E1_CODDIG,'@R 99999.99999 99999.999999 99999.999999 9 99999999999999'),oFont12cn)

oPrn:Line(2200+_xwLin ,0100 ,2200+_xwLin ,2300)
oPrn:Line(2300+_xwLin ,0100 ,2300+_xwLin ,2300)
oPrn:Line(2370+_xwLin ,0100 ,2370+_xwLin ,2300)
oPrn:Line(2440+_xwLin ,0100 ,2440+_xwLin ,2300)

oPrn:Line(2300+_xwLin ,0500 ,2440+_xwLin ,0500)
oPrn:Line(2370+_xwLin ,0750 ,2440+_xwLin ,0750)
oPrn:Line(2300+_xwLin ,1000 ,2440+_xwLin ,1000)
oPrn:Line(2300+_xwLin ,1350 ,2370+_xwLin ,1350)
oPrn:Line(2300+_xwLin ,1550 ,2440+_xwLin ,1550)

oPrn:Say(2100+_xwLin ,100 ,"Local de Pagamento"                         										,oFont8 )
oPrn:Say(2140+_xwLin ,100 ,"PAGAR PREFERENCIALMENTE EM AGÊNCIAS HSBC"    										,oFont10)

oPrn:Say(2100+_xwLin ,1910 ,"Vencimento"                                										,oFont8 )
oPrn:Say(2140+_xwLin ,2010 ,'CONTRA APRESENTAÇÃO'                    											,oFont10)

oPrn:Say(2200+_xwLin ,0100 ,"Cedente"                                   										,oFont8 )
oPrn:Say(2240+_xwLin ,0100 ,SA2->A2_NOME + space(15) + "CNPJ: " + tran(SA2->A2_CGC, '@R 99.999.999/9999-99') 	,oFont10)

oPrn:Say(2200+_xwLin ,1910 ,"Agência/Código Cedente"                    										,oFont8)

oPrn:Say(2240+_xwLin ,2010 ,alltrim(SEE->EE_AGENCIA)+alltrim(SEE->EE_CODEMP)									,oFont10)

oPrn:Say(2300+_xwLin ,0100 ,"Data do Documento"                         										,oFont8 )
oPrn:Say(2330+_xwLin ,0100 ,dtoc(SE1->E1_EMISSAO)                      											,oFont10)

oPrn:Say(2300+_xwLin ,0505 ,"Nro.Documento"                             										,oFont8 )
oPrn:Say(2330+_xwLin ,0605 ,SE1->E1_PREFIXO + ' / ' + SE1->E1_NUM  + " - " + SE1->E1_PARCELA	   				,oFont10)

oPrn:Say(2300+_xwLin ,1005 ,"Espécie Doc."                              										,oFont8 )
oPrn:Say(2330+_xwLin ,1105 ,''     	                            												,oFont10)

oPrn:Say(2300+_xwLin ,1355 ,"Aceite"                                    										,oFont8 )
oPrn:Say(2330+_xwLin ,1455 ,"NÃO"                                  		  										,oFont10)

oPrn:Say(2300+_xwLin ,1555 ,"Data do Processamento"                     										,oFont8 )
oPrn:Say(2330+_xwLin ,1655 ,dtoc(dDataBase)                    													,oFont10)

oPrn:Say(2300+_xwLin ,1910 ,"Nosso Número"                              										,oFont8 )
oPrn:Say(2330+_xwLin ,2010 ,SE1->E1_NUMBCO                              										,oFont10)

oPrn:Say(2370+_xwLin ,0100 ,"Uso do Banco"                              										,oFont8 )

oPrn:Say(2370+_xwLin ,0505 ,"Carteira"                                  										,oFont8 )
oPrn:Say(2400+_xwLin ,0555 ,'CNR'		                            											,oFont10)

oPrn:Say(2370+_xwLin ,0755 ,"Espécie"                                   										,oFont8 )
oPrn:Say(2400+_xwLin ,0805 ,"Real"                                        										,oFont10)

oPrn:Say(2370+_xwLin ,1005 ,"Quantidade"                                										,oFont8 )
oPrn:Say(2370+_xwLin ,1555 ,"Valor"                               		      									,oFont8 )

oPrn:Say(2370+_xwLin ,1910 ,"(=)Valor do Documento"                     										,oFont8 )
//oPrn:Say(2400+_xwLin ,2010 ,Transform(SE1->E1_SALDO,"@E 9,999,999.99")											,oFont10)

oPrn:Say(2440+_xwLin ,0100 ,"Instruções/Texto de responsabilidade do cedente" 									,oFont8 )

_nxLin := 2510
For _nI := 1 to len(aBolText)
	oPrn:Say(_nxlin+_xwLin ,0100 ,aBolText[_nI]                              									,oFont10)
	_nxlin += 40
Next

oPrn:Say(2440+_xwLin ,1910 ,"(-)Desconto/Abatimento"                    										,oFont8 )
oPrn:Say(2510+_xwLin ,1910 ,"(-)Outras Deduções"                        										,oFont8 )
oPrn:Say(2580+_xwLin ,1910 ,"(+)Mora/Multa"                             										,oFont8 )
oPrn:Say(2650+_xwLin ,1910 ,"(+)Outros Acréscimos"                      										,oFont8 )
oPrn:Say(2720+_xwLin ,1910 ,"(-)Valor Cobrado"                    			   									,oFont8 )

oPrn:Say(2730+_xwLin ,0100 ,"Unidade Cedente: " + SEE->EE_AGENCIA + ' ' + Posicione('SA6',1,xfilial('SA6') + SEE->EE_CODIGO + SEE->EE_AGENCIA,'A6_BAIRRO'), oFont8 )
oPrn:Say(2790+_xwLin ,0100 ,"Sacado"                                     			                			,oFont8 )
oPrn:Say(2830+_xwLin ,0350 ,alltrim(SA1->A1_NOME) + " (" + alltrim(SA1->A1_NREDUZ) + ' ' + SA1->A1_COD + '/' + SA1->A1_LOJA + ")" + space(15)+_xCGCCPF 	,oFont10)
oPrn:Say(2866+_xwLin ,0350 ,alltrim(SA1->A1_END) + " "   + SA1->A1_BAIRRO 		                           		,oFont10)
oPrn:Say(2902+_xwLin ,0350 ,alltrim(SA1->A1_MUN)   + " - " + SA1->A1_EST                            			,oFont10)
oPrn:Say(2935+_xwLin ,0350 ,tran(SA1->A1_CEP,'@R 99999-999') 						                   			,oFont10)

oPrn:Say(2965+_xwLin ,0100 ,"Sacador/Avalista"                         		 									,oFont8 )
oPrn:Say(3015+_xwLin ,1580 ,"Autenticação Mecânica"                     										,oFont8 )
oPrn:Say(3010+_xwLin ,1910 ,"Ficha de Compensação"                      										,oFont10)

oPrn:Line(2100+_xwLin ,1900 ,2790+_xwLin ,1900)
oPrn:Line(2510+_xwLin ,1900 ,2510+_xwLin ,2300)
oPrn:Line(2580+_xwLin ,1900 ,2580+_xwLin ,2300)
oPrn:Line(2650+_xwLin ,1900 ,2650+_xwLin ,2300)
oPrn:Line(2720+_xwLin ,1900 ,2720+_xwLin ,2300)
oPrn:Line(2790+_xwLin ,0100 ,2790+_xwLin ,2300)

oPrn:Line(3010+_xwLin ,0100 ,3010+_xwLin ,2300)

MSBAR("INT25",25.25,1.00,SE1->E1_CODBAR,oPrn,.F.,,,0.02300,1.2,,,,.F.)
//MSBAR("INT25",27.75,1.00,SE1->E1_CODBAR,oPrn,.F.,,,0.02300,1.2,,,,.F.)

/*/
Parametros:
01 cTypeBar String com o tipo do codigo de barras ("EAN13","EAN8","UPCA" ,"SUP5"   ,"CODE128" INT25","MAT25,"IND25","CODABAR" ,"CODE3_9")
02 nRow    Numero da Linha em centimentros
03 nCol    Numero da coluna em centimentros
04 cCode    String com o conteudo do codigo
05 oPr    Objeto Printer
06 lcheck   Se calcula o digito de controle
07 Cor     Numero  da Cor, utilize a "common.ch"
08 lHort    Se imprime na Horizontal
09 nWidth   Numero do Tamanho da barra em centimetros
10 nHeigth  Numero da Altura da barra em milimetros
11 lBanner  Se imprime o linha em baixo do codigo
12 cFont    String com o tipo de fonte
13 cMode    String com o modo do codigo de barras CODE128

exemplos

MSBAR("EAN13"  , 10  , 16 ,"123456789012",oPr,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL)
MSBAR("EAN13"  , 2   , 08 ,"123456789012",oPr,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL)
MSBAR("EAN8"   , 5   ,  8 ,"1234567"     ,oPr,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL)
MSBAR("EAN8"   , 19  ,  1 ,"1234567"     ,oPr,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL)
MSBAR("UPCA"   , 15  ,  1 ,"07000002198" ,oPr,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL)
MSBAR("UPCA"   , 15  ,  6 ,"07000002198" ,oPr,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL)
MSBAR("EAN13"  , 20  , 13 ,"123456789012",oPr,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL)
MSBAR("EAN13"  , 16  , 13 ,"123456789012",oPr,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL)
MSBAR("SUP5"   , 12  ,  1 ,"100441"      ,oPr,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL)
MSBAR("SUP5"   , 12  ,  3 ,"100441"      ,oPr,NIL,NIL,.F.,NIL,NIL,NIL,NIL,NIL)
MSBAR("CODE128",  1  ,  1 ,"123456789011010" ,oPr,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL)
MSBAR("CODE128",  3  ,  1 ,"12345678901" ,oPr,NIL,NIL,NIL,NIL,NIL,NIL,NIL,"A")
MSBAR("CODE128",  5  ,  1 ,"12345678901" ,oPr,NIL,NIL,NIL,NIL,NIL,NIL,NIL,"B")
MSBAR("CODE3_9",  7.5,  1 ,"12345678901" ,oPr,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL)
MSBAR("CODABAR",  8  ,  7 ,"A12-34T"     ,oPr,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL)
MSBAR("CODE128", 10  , 11 ,"12345678901" ,oPr,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL)
MSBAR("CODE3_9", 17  ,  9 ,"123456789012",oPr,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL)
MSBAR("MAT25"  , 23  ,  3 ,"123456789012",oPr,,,.t.)
MSBAR("IND25"  , 23  , 15 ,"123456789012",oPr,,,.t.)

/*/


oPrn:EndPage()       // Finaliza a página

Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_GeraCodBar()
//////////////////////////

DbSelectArea("SEE")
DbSetOrder(1)           

If DbSeek(xFilial("SEE") + SE1->E1_PORTADO + SE1->E1_AGEDEP + SE1->E1_CONTA + SE1->E1_BCOCLI,.f.)
	_lNovoNro := .t.
	If empty(SE1->E1_NUMBCO)
		_cNumBco   := Soma1(SEE->EE_FAXATU)
	Else 
		_lNovoNro := .f.
		_cNumBco	  := left(SE1->E1_NUMBCO,12)
	EndIf
Else
	MsgBox("Não encontrados dados Parâmetros Banco / Agência / Conta / Sub-Conta CNAB " + chr(13) + _aBanco[1] + '/' + _aBanco[2] + '/' + _aBanco[3] + '/' + _aBanco[4], "ATENÇÃO!!!","STOP")
	DbSelectArea("SE1")
	Return()
EndIf

If _cNumBco < SEE->EE_FAXINI .or. _cNumBco > SEE->EE_FAXFIM
	MsgBox("Intervalo Seq. Boleto Inválido Banco " + SEE->EE_CODIGO,"ATENÇÃO!!!","STOP")
	Return()
EndIf                                                                  
/*
GRAVADATA(ExpD1,ExpL1,ExpN1) 
Formata uma determinada data para utilizacao no arquivo texto. Onde: ExpD1 -> Data a ser convertida
ExpL1 -> Se .T. com Barra Se .F. sem Barra
ExpN1 -> Formato (1,2,3,4...8) 
1 - ddmmaa 
2 - mmddaa 
3 - aaddmm 
4 - aammdd
5 - ddmmaaaa 
6 - mmddaaaa 
7 - aaaaddmm 
8 - aaaammdd
*/
                                         
// número do banco + DV + tipo identificador (vincula codigo cedente + codigo do documento   
_cNumBco := strzero(val(_cNumBco),12)
_cNumBco := _cNumBco + DV_11_29(_cNumBco) +  '5'
_cNumBco := alltrim(_cNumBco) + DV_11_92(str(val(_cNumBco) + val(SEE->EE_CODEMP),15))

_cFatVcto := '0000'  //Str( max(date(),SE1->E1_VENCREA) - CtoD("07/10/1997") ,4 )

_cCodBar := SEE->EE_CODIGO + "9" + _cFatVcto + strzero(0,10) + strzero(val(SEE->EE_CODEMP),7) + '0' + left(_cNumBco,12) + '00002'
_cDv     := DV_11_29(_cCodBar)
_cCodBar := left(_cCodBar,4) + DV_11_29(_cCodBar) + substr(_cCodBar,5)
              
_cPedaco1 := SEE->EE_CODIGO + "9" + left(strzero(val(SEE->EE_CODEMP),7),5)    // BANCO + MOEDA + INICIO COD CEDENTE
_cPedaco1 += Dv_10_21(_cPedaco1)

_cPedaco2 := right(strzero(val(SEE->EE_CODEMP),7) ,2) + '0' + left(alltrim(_cNumBco),7)		// FINAL COD CEDENTE + INICIO NRO BANCO
_cPedaco2 += Dv_10_21(_cPedaco2)

_cPedaco3 := substr(_cNumBco,8,5) + '00002'             // FINAL NRO BANCO + VENCIMENTO JULIANO + PRODUTO
_cPedaco3 += Dv_10_21(_cPedaco3)				

_cPedaco4 := substr(_cCodBar,5,1)						// digito verificador do código de barras

//_cPedaco5 := _cFatVcto + strzero(SE1->E1_SALDO*100,10)		// FATOR DE VENCIMENTO + VALOR
_cPedaco5 := _cFatVcto + strzero(0,10)		// FATOR DE VENCIMENTO + VALOR

_cCodDig := tran(_cPedaco1,'@R 99999.99999')  + " "
_cCodDig += tran(_cPedaco2,'@R 99999.999999') + " "                   
_cCodDig += tran(_cPedaco3,'@R 99999.999999') + " "

_cCodDig := _cPedaco1
_cCodDig += _cPedaco2
_cCodDig += _cPedaco3
_cCodDig += _cPedaco4
_cCodDig += _cPedaco5
           
/*           
RecLock("SEA",.T.)
SEA->EA_FILIAL  := xFilial('SEA')
SEA->EA_NUMBOR  := cNumBor
SEA->EA_DATABOR := dDataBase
SEA->EA_PORTADO := cPort060
SEA->EA_AGEDEP  := cAgen060
SEA->EA_NUMCON  := cConta060
SEA->EA_NUM 	 := SE1->E1_NUM
SEA->EA_PARCELA := SE1->E1_PARCELA
SEA->EA_PREFIXO := SE1->E1_PREFIXO
SEA->EA_TIPO	 := SE1->E1_TIPO
SEA->EA_CART	 := "R"
SEA->EA_SITUACA := cSituacao
SEA->EA_SITUANT := cSituant
SEA->EA_FILORIG := SE1->E1_FILIAL
SEA->EA_PORTANT := cPortAnt
SEA->EA_AGEANT  := cAgAnt
SEA->EA_CONTANT := cContAnt
If lF060SEA2
	ExecBlock("F060SEA2",.f.,.f.)
Endif
MsUnlock()
FKCOMMIT()

RecLock("SE1",.F.)
SE1->E1_PORTADO := cPort060
SE1->E1_AGEDEP  := cAgen060
SE1->E1_SITUACA := cSituacao
SE1->E1_CONTRAT := cContrato
SE1->E1_NUMBOR  := cNumBor
SE1->E1_DATABOR := dDataBase
SE1->E1_MOVIMEN := dDataBase
SE1->E1_CONTA	 := cConta060
*/

RecLock("SE1",.F.)
SE1->E1_NUMBCO  := _cNumBco
SE1->E1_SITUACA := '1'
SE1->E1_CODBAR  := _cCodbar
SE1->E1_CODDIG  := _cCodDig
MsUnLock()
              
If _lNovoNro
	RecLock("SEE",.f.)
	SEE->EE_FAXATU := Soma1(SEE->EE_FAXATU)
	MsUnlock()  
EndIf

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Calculo do Digito da Linha Digitavel //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function DV_LINHA(Pedaco, nDigito)
/////////////////////////////////////////
Local Peso   := 2
Local nCont  := 0
Local nVal   := 0
Local Dezena := ""
Local Resto  := 0

For i := Len(Pedaco) to 1 Step -1
	
	If Peso == 3
		Peso := 1
	Endif
	
	If Val(SUBSTR(Pedaco,i,1))*Peso >= 10
		nVal := Val(SUBSTR(Pedaco,i,1)) * Peso
		nCont := nCont+(Val(SUBSTR(Str(nVal,2),1,1))+Val(SUBSTR(Str(nVal,2),2,1)))
	Else
		nCont := nCont+(Val(SUBSTR(Pedaco,i,1))* Peso)
	Endif
	
	Peso := Peso + 1
	
Next

nDigito := mod(nCont,10)
nDigito := iif(nDigito == 0,'0',str(10-mod(nCont,10),1))

Return(nDigito)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// módulo 11, de 9 a 2, da direita prá esquerda
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Dv_11_92(_cFator)
//////////////////////////////
Local _nI, _nDv    
Local _nSoma  := 0    
Local _nFator := 10

For _nI := len(alltrim(_cFator)) to 1 step -1

	If _nFator == 2
		_nFator := 9
	Else
		--_nFator
	EndIf
    
	_nSoma += val(substr(alltrim(_cFator),_nI,1)) * _nFator

Next                                               

_nDv := mod(_nSoma,11)
        
_nDv := str(iif(_nDv == 0 .or. _nDv == 10,0,_nDv),1)

Return(_nDv)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// módulo 11, de 2 a 9, da direita prá esquerda             
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Dv_11_29(_cFator)
//////////////////////////////
Local _nI, _nDv    
Local _nSoma  := 0    
Local _nFator := 1

For _nI := len(alltrim(_cFator)) to 1 step -1

	If _nFator == 9
		_nFator := 2
	Else
		++_nFator
	EndIf
    
	_nSoma += val(substr(_cFator,_nI,1)) * _nFator

Next                                               

_nDv := 11 - mod(_nSoma,11)
        
_nDv := str(iif(_nDv == 0 .or. _nDv >= 10,1,_nDv),1)

Return(_nDv)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// módulo 10, de 2 a 1, da direita prá esquerda
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Dv_10_21(_cFator)
//////////////////////////////
Local _nI, _nDv    
Local _nSoma  := 0    
Local _nFator := 1

For _nI := len(alltrim(_cFator)) to 1 step -1

	_nFator := iif(_nFator == 1,2,1)
                     
    _xFator := val(substr(_cFator,_nI,1)) * _nFator
    If _xFator > 9
    	_xFator := str(_xFator,2)
    	_xFator := val(left(_xFator,1)) + val(right(_xFator,1))
    EndIf
	_nSoma += _xFator

Next                                               
         
If _nSoma < 10
	_nDv := str(10 - _nSoma,1)
Else              
	If mod(_nSoma,10) == 0
		_nDv := '0'
	Else
		_nDv := str(10 - mod(_nSoma,10),1)
	EndIf
EndIf
        
Return(_nDv)