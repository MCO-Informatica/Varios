#Include "RwMake.ch"
#Include "Protheus.ch"
#Include "Topconn.ch"        

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ                                                                      
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAFAT003   บ Autor ณ Bruno Parreira     บ Data ณ  22/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Retorno de mercadoria por Obra                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออหออออออออออหออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAlteracoesณ Actual Trend   บ 10/01/12 บ Altera็ao na montagem da       บฑฑ
ฑฑบ          ณ                บ          บ GetDados                       บฑฑ
ฑฑบ          ณ Actual Trend   บ 12/01/12 บ Analise de campos enviados a   บฑฑ
ฑฑบ          ณ                บ          บ ExecAuto                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออสออออออออออสออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Lisonda Engenharia e Construcoes Ltda.          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function AFAT003()
                                      
Local oDlg
Local nOpca        := 0
Local aAdvSize     := MsAdvSize()  
Local lEnd         := .F.
Local lRet         := .T.
Local lPerg        := .T.
Local cPerg        := "AFAT003"

Private oGetDados
Private cMailFil02 := AllTrim( SuperGetMv("MV_XMAIL02",,"tatiane@playpiso.com.br") )
Private cMailFil00 := AllTrim( SuperGetMv("MV_XMAIL00",,"flavio@lisonda.com.br") )
Private oFont1     := TFont():New("Calibri",,025,,.T.,,,,,.F.,.F.)
Private lRefresh   := .T.
Private aCampos    := { "D2_EMISSAO", "D2_CLIENTE", "D2_LOJA", "D2_DOC", "D2_SERIE", "D2_ITEM", "D2_COD", "D2_UM", "B1_DESC", "D2_QUANT", "D2_PRCVEN", "D1_QUANT", "D2_QTSEGUM", "D2_IDENTB6" }  //adicionado campo D2_IDENTB6
Private aHeadRet   := {}
Private aColsRet   := {}
Private aRotina    := {{"Pesquisar" , "AxPesqui", 0, 1},;
{"Visualizar", "AxVisual", 0, 2},;
{"Incluir"   , "AxInclui", 0, 3},;
{"Alterar"   , "AxAltera", 0, 4},;
{"Excluit"   , "AxDeleta", 0, 5}}

A003PERG(cPerg)
lPerg := Pergunte(cPerg)

If lPerg == .T.
	If AllTrim(Mv_Par01) $ AllTrim( GetMV("MV_XOBRRES") )
		MsgAlert("Obra Restrita!!!")
		lRet := .F.
	Else
		DbSelectArea("CTT")                                                                        
		CTT->( DbSetOrder(1) )
		If CTT->( DbSeek(xFilial("CTT") + Mv_Par01) )    
		 	IF CTT->CTT_MSFIL <> '02' .and. CTT->CTT_MSFIL <> '01'  // adicionado inicio bloco para tratar as obras do RJ filial 03 ..... luiz henrique 28/05/2014
			    RecLock("CTT", .F.)                                // se filial for diferente de 02 ou 04
			 		CTT->CTT_MSFIL := '01'                         // CTT_MSFIL (03) passa a ser 04
				MsUnLock()                                         //Pois todas as notas fiscais transmitidas tem que ser geradas ou pela Lisonda Alphaville (04) ou pela PlayPiso (02)
			EndIf                                                  // e as obras do RJ devem ser transmitidas com a filial 04 Lisonda ....final do bloco luiz henrique	28/05/2014
		   		If cFilAnt <> CTT->CTT_MSFIL  
			  		MsgAlert("Obra mencionada pertence a outra filial. Favor logar-se com a filial correta. Filial: "+CTT->CTT_MSFIL)
			   		lRet := .F.
		   		EndIf
		Else
			MsgAlert("A obra mencionada nใo existe!!!")
			lRet := .F.
		EndIf
	EndIf
	
	If lRet == .T.
		cObra := Mv_par01+"  -  "+GetAdvFVal("CTT", "CTT_DESC01", xFilial("?")+Mv_par01, 1, "-")
		
		DbSelectArea("SX3")
		SX3->( DbSetOrder(2) )
		For _n1 := 1 to Len(aCampos)
			If SX3->( DbSeek(aCampos[_n1]) ) .And. Alltrim(SX3->X3_CAMPO) == aCampos[_n1]
				If AllTrim(aCampos[_n1]) == "D1_QUANT"
					cTitHead := "Saldo"
				ElseIf AllTrim(aCampos[_n1]) == "D2_QUANT" 	//"D2_QTSEGUM"
					cTitHead := "Qt. Solicitada"
				Else
					cTitHead := Trim( X3Titulo() )
				EndIf
				
				Aadd( aHeadRet, {cTitHead, SX3->X3_CAMPO, SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL, " "/*SX3->X3_VALID*/, SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_F3, SX3->X3_CONTEXT, SX3->X3_CBOX, SX3->X3_RELACAO } )
			EndIf
		Next _n1
		SX3->( DbSetOrder(1) )
		
		Processa( {|lEnd| lExecuta := A003DADOS(@lEnd)}, "Aguarde...","Analisando dados da Obra", .T. )
		
		If Len(aColsRet) <= 0
			Aadd(aColsRet,Array(Len(aHeadRet)+1))
			For nI := 1 To Len(aHeadRet)
				aColsRet[1][nI] := CriaVar(aHeadRet[nI][2])
			Next
			aColsRet[1][Len(aHeadRet)+1] := .F.
		EndIf
		
		// ************************ Monta Interface
		Define Dialog oDlg Title " Retorno de Mercadoria " From aAdvSize[7],0 To aAdvSize[6],aAdvSize[5]-50 COLORS 0,16777215 Pixel
		
		@ 008, 010 Say oSay1 Prompt "OBRA : "           Size 100,020 Of oDlg Font oFont1 Pixel
		@ 008, 050 Say oSay1 Prompt cObra               Size 500,020 Of oDlg Font oFont1 Colors 16711680, 16777215 Pixel
		@ 006, 505 Button oButton1  Prompt "&Gerar NF"  Size 035,015 Of oDlg Action Iif(A003GRAVA(),oDlg:End(),) Pixel Message "Gerar Pr้-Nota"
		
		oGetDados := MsNewGetDados():New(25, 05, aAdvSize[4], aAdvSize[3]-27, GD_UPDATE, "AllwaysTrue", "AllwaysTrue", , {"D2_QTSEGUM"}, 0, 999, "U_A003VALID()", "", "AllwaysTrue", oDlg, aHeadRet, aColsRet )
		oGetDados:oBrowse:lUseDefaultColors := .F.
		oGetDados:oBrowse:SetBlkBackColor({|| A003CORES( oGetDados:aCols, oGetDados:nAt) })
		
		Activate MsDialog oDlg Centered
	EndIf
EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณA003PERG  บ Autor ณ Bruno Parreira     บ Data ณ  22/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Cria parametros da rotina                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Lisonda Engenharia e Construcoes Ltda.          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function A003PERG(cPerg)

Local aAreaAtu	:= GetArea()
Local aAreaSX1	:= SX1->( GetArea() )

PutSx1(	cPerg, "01", "C๓digo da Obra         ? ", "" , "", "Mv_ch1", TAMSX3( "CTT_CUSTO"  )[3], TAMSX3( "CTT_CUSTO"  )[1], TAMSX3( "CTT_CUSTO"  )[2], 0,"G","","CTT","","N","Mv_par01",        "","","","",           "","","", "","","", "","","","","","",{"Digite o codigo da Obra    ",""},{""},{""},"")
PutSx1(	cPerg, "02", "Tipo de Retorno        ? ", "" , "", "Mv_ch2","N"                        ,                       1  ,                         0 , 2,"C","",   "","","N","Mv_par02","Material","","","","Equipamento","","", "","","", "","","","","","",{"Selecione o tipo de retorno ",""},{""},{""},"")

RestArea( aAreaSX1 )
RestArea( aAreaAtu )
                                                  
Return(cPerg)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณA003DADOS บ Autor ณ Bruno Parreira     บ Data ณ  22/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Retorno de mercadoria por Obra                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Lisonda Engenharia e Construcoes Ltda.          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function A003DADOS()

Local cQuery  := ""
Local nTotReg := 0
Local nContar := 0
Local cNumNota:= ""
                   
cQuery :=        " SELECT SD2.D2_FILIAL, SD2.D2_CCUSTO, SD2.D2_EMISSAO, SD2.D2_DOC, SD2.D2_SERIE,SD2.D2_IDENTB6, SD2.D2_CLIENTE, SD2.D2_LOJA, SD2.D2_ITEM, SD2.D2_COD, SB1.B1_DESC,                
//cQuery += CRLF + "        SD2.D2_UM, SD2.D2_QUANT, SD2.D2_PRCVEN, SD2.D2_TOTAL, (SD2.D2_QUANT - ISNULL(SD1.D1_QUANT,0)) AS D1_QUANT, 0 AS SALDO  "
cQuery += CRLF + "        SD2.D2_UM, SD2.D2_QUANT, SD2.D2_PRCVEN, SD2.D2_TOTAL, (SD2.D2_QUANT - ISNULL(SUM(SD1.D1_QUANT),0)) AS D1_QUANT, 0 AS SALDO  "
cQuery += CRLF + "   FROM "+RetSqlName("SD2")+" SD2 "
cQuery += CRLF + "  INNER JOIN "+RetSqlName("SB1")+" SB1 "
cQuery += CRLF + "     ON SB1.B1_COD      = SD2.D2_COD "
//cQuery += CRLF + "    AND SB1.D_E_L_E_T_  = ' ' "
cQuery += CRLF + "    AND SB1.D_E_L_E_T_  <> '*' "
cQuery += CRLF + "  INNER JOIN "+RetSqlName("SC5")+" SC5 "
cQuery += CRLF + "     ON SC5.C5_FILIAL   = SD2.D2_FILIAL "
cQuery += CRLF + "    AND SC5.C5_XPEDFIN <> 'S' "
cQuery += CRLF + "    AND SC5.C5_NUM      = SD2.D2_PEDIDO "       
cQuery += CRLF + "   AND SC5.C5_CCUSTO = SD2.D2_CCUSTO"
//cQuery += CRLF + "    AND SC5.D_E_L_E_T_  = ' ' "
cQuery += CRLF + "    AND SC5.D_E_L_E_T_  <> '*' "
cQuery += CRLF + "   LEFT JOIN "+RetSqlName("SD1")+" SD1 "           
cQuery += CRLF + "     ON SD1.D1_NFORI    = SD2.D2_DOC "
//cQuery += CRLF + "    AND SD1.D1_LOJA     = SD2.D2_LOJA "      //comentado para poder tratar o retorno da loja 02 e 03
//cQuery += CRLF + "    AND SD1.D1_NFORI    = SD2.D2_DOC "
cQuery += CRLF + "    AND SD1.D1_SERIORI  = SD2.D2_SERIE "
cQuery += CRLF + "    AND SD1.D1_ITEMORI  = SD2.D2_ITEM "
cQuery += CRLF + "    AND SD1.D1_COD      = SD2.D2_COD "  
cQuery += CRLF + "    AND SD1.D1_CC     = SD2.D2_CCUSTO " 
//cQuery += CRLF + "    AND SD1.D1_FORNECE  = SD2.D2_CLIENTE " //comentar para tratar retorno quando cliente diferente de 000607 homologacao
cQuery += CRLF + "    AND SD1.D_E_L_E_T_  = ' ' "
cQuery += CRLF + "  WHERE SD2.D2_CCUSTO   = '"+ Mv_par01 +"'"
If Mv_Par02 == 2
	cQuery += CRLF + "    AND SUBSTRING(SD2.D2_CF,2,3)  = '554' "
Else
	cQuery += CRLF + "    AND SUBSTRING(SD2.D2_CF,2,3) <> '554' "
EndIf
cQuery += CRLF + "    AND SD2.D2_TIPO NOT IN ('D','B')
//cQuery += CRLF + "    AND SD2.D_E_L_E_T_  = ' ' "
cQuery += CRLF + "    AND SD2.D_E_L_E_T_  <> '*' "
//cQuery += CRLF + "  ORDER BY SD2.D2_FILIAL, SD2.D2_CLIENTE,SD2.D2_CCUSTO, SD2.D2_DOC, SD2.D2_SERIE, SD2.D2_ITEM "
cQuery += CRLF + " GROUP BY  SD2.D2_FILIAL, SD2.D2_CLIENTE,SD2.D2_CCUSTO, SD2.D2_DOC, SD2.D2_SERIE, SD2.D2_ITEM, SD2.D2_EMISSAO,SD2.D2_IDENTB6,SD2.D2_LOJA, SD2.D2_ITEM, SD2.D2_COD, SB1.B1_DESC,  SD2.D2_UM, SD2.D2_QUANT, SD2.D2_PRCVEN, SD2.D2_TOTAL "
cAliasA := GetNextAlias()
cQuery  := ChangeQuery(cQuery)

DbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cAliasA , .F., .T.)
aEval( SD2->(DbStruct()),{|x| If(x[2] != "C", TcSetField(cAliasA, AllTrim(x[1]), x[2], x[3], x[4]),Nil)})
aEval( SD1->(DbStruct()),{|x| If(x[2] != "C", TcSetField(cAliasA, AllTrim(x[1]), x[2], x[3], x[4]),Nil)})
aEval( SB1->(DbStruct()),{|x| If(x[2] != "C", TcSetField(cAliasA, AllTrim(x[1]), x[2], x[3], x[4]),Nil)})

DbSelectArea( cAliasA )
(cAliasA)->( DbEval( { || nTotReg++ },,{ || !Eof() } ) )
(cAliasA)->( DbGoTop() )


cNumNota := (cAliasA)->D2_DOC

ProcRegua( nTotReg )
While (cAliasA)->( !Eof() )
	IncProc("Gerando Planilha, regs : "+StrZero(++nContar,6)+" de "+StrZero(nTotReg,6))
	
	If cNumNota <> (cAliasA)->D2_DOC
		Aadd(aColsRet,Array(Len(aHeadRet)+1))
		For nI := 1 To Len(aHeadRet)
			aColsRet[Len(aColsRet)][nI] := ""
		Next
		aColsRet[Len(aColsRet)][Len(aHeadRet)+1] := .T.
		
		cNumNota := (cAliasA)->D2_DOC
	EndIf
	
	Aadd(aColsRet,Array(Len(aHeadRet)+1))
	For nI := 1 To Len(aHeadRet)
		If AllTrim(aHeadRet[nI][2]) == "D2_QTSEGUM"
			aColsRet[Len(aColsRet)][nI] := (cAliasA)->SALDO
		Else
			If ( aHeadRet[nI][10] != "V")
				aColsRet[Len(aColsRet)][nI] := FieldGet(FieldPos(aHeadRet[nI][2]))
			Else
				aColsRet[Len(aColsRet)][nI] := CriaVar(aHeadRet[nI][2])
			EndIf
		EndIf
	Next
	aColsRet[Len(aColsRet)][Len(aHeadRet)+1] := .F.
	
	(cAliasA)->( DbSkip() )
End-While

(cAliasA)->( DbCloseArea() )

Return()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณA003CORES บ Autor ณ Bruno Parreira     บ Data ณ  22/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Altera cores da GetDados                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Lisonda Engenharia e Construcoes Ltda.          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function A003CORES(aLinha, nLinha)

Local nPosQtdSol := aScan(aHeadRet,{|x| x[2] = "D2_QTSEGUM"})
Local nPosQtdSld := aScan(aHeadRet,{|x| x[2] = "D1_QUANT"  })
Local nPosQtdNot := aScan(aHeadRet,{|x| x[2] = "D2_QUANT"  })
Local nPosNumDoc := aScan(aHeadRet,{|x| x[2] = "D2_DOC"    })
Local nRet		 := 16702938     //azul claro

Do Case
	Case Empty(aLinha[nLinha][nPosQtdSld]) .And. !Empty(aLinha[nLinha][nPosNumDoc])
		nRet := 4210943      //vermelho
		
	Case Empty(aLinha[nLinha][nPosNumDoc])
		nRet := 15790320     //16777215
		
	Case !Empty(aLinha[nLinha][nPosQtdSol])
		nRet := 8454016      //verde
		
	Case !Empty(aLinha[nLinha][nPosQtdSld]) .And. aLinha[nLinha][nPosQtdSld] < aLinha[nLinha][nPosQtdNot]
		nRet := 8454143      //amarelo
		
	Case Empty(aLinha[nLinha][nPosQtdSol])
		nRet := 16702938     //azul claro
EndCase

Return nRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณA003VALID บ Autor ณ Bruno Parreira     บ Data ณ  22/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Valida campo digitado na getDados                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Lisonda Engenharia e Construcoes Ltda.          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function A003VALID()

Local nPosQtdSol := aScan(aHeadRet,{|x| x[2] = "D2_QTSEGUM"})
Local nPosQtdSld := aScan(aHeadRet,{|x| x[2] = "D1_QUANT"  })
Local nPosQtdNot := aScan(aHeadRet,{|x| x[2] = "D2_QUANT"  })
Local nPosNumDoc := aScan(aHeadRet,{|x| x[2] = "D2_DOC"    })    
Local nPosFornece := aScan(aHeadRet,{|x| x[2] = "D2_CLIENTE"}) //INCLUIDO LINHA PARA TRATAR FORNECEDOR DIFERENTE DE 000607 NO RETORNO  - LH ACTUAL 05/12/2016
Local nPosLoja	 := aScan(aHeadRet,{|x| x[2] = "D2_LOJA"})  //INCLUIDO LINHA PARA TRATAR LOJA FORNECEDOR DIFERENTE DE 000607 NO RETORNO  - LH ACTUAL 05/12/2016
Local lRet		 := .T.
public cA100For1   := aCols[n][nPosFornece] //INCLUIDO LINHA PARA TRATAR FORNECEDOR DIFERENTE DE 000607 NO RETORNO  - LH ACTUAL 05/12/2016
public cLoja1   := aCols[n][nPosLoja]      //INCLUIDO LINHA PARA TRATAR LOJA FORNECEDOR DIFERENTE DE 000607 NO RETORNO  - LH ACTUAL 05/12/2016 

If Empty(oGetDados:aCols[n][nPosNumDoc])
	oGetDados:aCols[n][nPosQtdSol] := ""
Else
	If M->D2_QTSEGUM  > 0    //quantidade solicitada
		If oGetDados:aCols[n][nPosQtdNot] == 0
			MsgBox("Quantidade definida deste produto na nota estแ zerada.","Retorno de Material","ALERT")
			
			oGetDados:aCols[n][nPosQtdSol] := 0
			lRet := .F.
		EndIf
		
		If  M->D2_QTSEGUM > oGetDados:aCols[n][nPosQtdSld]
			MsgBox("Quantidade solicitada ้ maior que a disponํvel.","Retorno de Material","ALERT")
			
			oGetDados:aCols[n][nPosQtdSol] := 0
			lRet := .F.
		EndIf
	EndIf
EndIf
oGetDados:Refresh()

Return(lRet)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณA003GRAVA บ Autor ณ Bruno Parreira     บ Data ณ  22/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Gera NF de retorno                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Lisonda Engenharia e Construcoes Ltda.          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function A003GRAVA()

Local n1           := 0
Local aItens       := {}
Local aCabecNF     := {}
Local aItensNF     := {}
Local aItensSZD    := {}
Local cNFiscal     := ""
Local cSerie       := ""
Local cMensagem    := "" 

Local lOk          := .F.

Private nPosQtdSol := aScan(aHeadRet,{|x| AllTrim( x[2] ) == "D2_QTSEGUM"})
Private nPosPrd    := aScan(aHeadRet,{|x| AllTrim( x[2] ) == "D2_COD"    })
Private nPosSol    := aScan(aHeadRet,{|x| AllTrim( x[2] ) == "D2_QTSEGUM"})
Private nPosVal    := aScan(aHeadRet,{|x| AllTrim( x[2] ) == "D2_PRCVEN" })
Private nPosDoc    := aScan(aHeadRet,{|x| AllTrim( x[2] ) == "D2_DOC"    })
Private nPosSer    := aScan(aHeadRet,{|x| AllTrim( x[2] ) == "D2_SERIE"  })
Private nPosIte    := aScan(aHeadRet,{|x| AllTrim( x[2] ) == "D2_ITEM"   })
Private nPosCli    := aScan(aHeadRet,{|x| AllTrim( x[2] ) == "D2_CLIENTE"})
Private nPosLoj    := aScan(aHeadRet,{|x| AllTrim( x[2] ) == "D2_LOJA"   })
Private nPosQtd    := aScan(aHeadRet,{|x| AllTrim( x[2] ) == "D2_QUANT"  })
Private nPosDes    := aScan(aHeadRet,{|x| AllTrim( x[2] ) == "B1_DESC"   })
Private nPosUnm    := aScan(aHeadRet,{|x| AllTrim( x[2] ) == "D2_UM"     })  
Private nPosDtOri  := aScan(aHeadRet,{|x| AllTrim( x[2] ) == "D2_EMISSAO"})  //criado para tratar o campo data de origem da NF na SD1 
PRIVATE nPosIdentB6:= aScan(aHeadRet,{|x| AllTrim( x[2] ) == "D2_IDENTB6"}) //criado para tratar o campo IDENTB6 na SD1

Private cFormul    := "S"
Private cA100For   := ""
Private cLoja      := ""
Private lMSErroAuto:= .F.

ProcRegua( Len(oGetDados:aCols) )
For _n1 := 1 To Len(oGetDados:aCols)
	IncProc("Analisando Dados com Qtde Solicitadao")
	
	If !Empty(oGetDados:aCols[_n1, 1])
		If oGetDados:aCols[_n1, nPosQtdSol] <> 0                            
			Aadd(aItens,Array(Len(aHeadRet)+1))
			
			For _n2 := 1 To Len(oGetDados:aCols[_n1])
				aItens[Len(aItens),_n2] := oGetDados:aCols[_n1,_n2]
			Next _n2
		EndIf
	EndIf                                
Next _n1

If Len(aItens) <= 0
	MsgInfo("Nใo foi digitada a 'Qt. Solicitada' para nenhum item, impossivel gera a Nota !!!", "Aten็ใo")
Else
	cA100For := cA100For1 //  oGetDados:aCols[1][nPosCli]  -  comentado para tratar os fornecedores quando cliente diferente de 000607 LH ACTUAL
    //criada expressao abaixo para tratar a nova loja 03 da Lisonda 000607 com o CNPJ valido LH ACTUAL 31/10/2016
		if cA100For='000607'  
     	cLoja:='03'
    	else
    	cLoja	 := cLoja1 //oGetDados:aCols[1][nPosLoj] -  comentado para tratar os fornecedores quando loja do cliente diferente de 000607 03 LH ACTUAL
        endif 
    //Fim da expressao para tratar a loja 03 Lisonda 000607 LH ACTUAL 31/10/2016
	aCols    := aClone(aItens)              
	
	//NfeNextDoc(@cNFiscal,@cSerie,.T.)
	//substituida a linha acima pelo bloco abaixo [Mauro Nagata, Actual Trend, 06/03/2013]
	Do While .T.
   	If !NfeNextDoc(@cNFiscal,@cSerie,.T.)
		MsgBox("Tempo para escolher o n๚mero e s้rie da NF foi esgotado. Clique no Botใo GERAR NF e selecione a S้rie e N๚mero da Nota Fiscal, depois click no Botใo OK","Gerar NF","ALERT")       			
		Return .F.
	EndIf	 
   	If !Empty(cNFiscal+cSerie)
   	   Exit
   	EndIf  
   	MsgBox("N๚mero da Nota Fiscal em Branco. Para gerar a nota fiscal de retorno, selecione a S้rie e N๚mero da Nota Fiscal, depois click no Botใo [OK]. Nใo foi gerada a Nota Fiscal","Gerar NF","ALERT")
		Return .F.   	
   EndDo	
	
	cEst := GetAdvFVal("SA1", "A1_EST",xFilial("SA1") + cA100For + cLoja , 1, "-")
	
	Aadd(aCabecNF,{"F1_FILIAL"  	, xFilial("SF1")		, NIL})
	Aadd(aCabecNF,{"F1_DOC"    	    , cNFiscal				, NIL})
	Aadd(aCabecNF,{"F1_SERIE"    	, cSerie 				, NIL})
	Aadd(aCabecNF,{"F1_EMISSAO"  	, dDataBase				, NIL})
	Aadd(aCabecNF,{"F1_FORNECE"  	, cA100For              , NIL})
	Aadd(aCabecNF,{"F1_LOJA"    	, cLoja                 , NIL})
	If Mv_Par02 == 1
		Aadd(aCabecNF,{"F1_TIPO"    , "D" 					, NIL})
	Else
		Aadd(aCabecNF,{"F1_TIPO"    , "B" 				    , NIL})
	EndIf
	Aadd(aCabecNF,{"F1_FORMUL"   	, "S" 					, NIL})
	Aadd(aCabecNF,{"F1_ESPECIE"  	, "SPED"  			    , NIL})
	Aadd(aCabecNF,{"F1_EST"    	    , cEst 				    , NIL})
	Aadd(aCabecNF,{"F1_DTDIGIT"  	, dDataBase			    , NIL})
	Aadd(aCabecNF,{"F1_RECBMTO"  	, Ctod("") 			    , NIL})
	Aadd(aCabecNF,{"F1_DESPESA"  	, 0     			    , NIL})
	Aadd(aCabecNF,{"F1_FRETE"  	    , 0     			    , NIL})
	Aadd(aCabecNF,{"F1_SEGURO"  	, 0					    , NIL})
	Aadd(aCabecNF,{"F1_DESCONT"  	, 0					    , NIL})
	                                                        	
	ProcRegua( Len(aItens) )
	For _n3 := 1 to len(aItens)
		IncProc(" Gerando Nota " +cSerie+" - "+cNFiscal)
		
		aItensAux := {}
		Aadd(aItensAux,{"D1_FILIAL"  , xFilial("SD1")	    , NIL})
		Aadd(aItensAux,{"D1_DOC"     , cNFiscal			    , NIL})
		Aadd(aItensAux,{"D1_SERIE"   , cSerie 			    , NIL})
		Aadd(aItensAux,{"D1_FORNECE" , aItens[_n3][nPosCli] , NIL})
		Aadd(aItensAux,{"D1_LOJA"  	 , aItens[_n3][nPosLoj] , NIL})
		Aadd(aItensAux,{"D1_COD"  	 , aItens[_n3][nPosPrd] , NIL})
		Aadd(aItensAux,{"D1_QUANT"   , aItens[_n3][nPosSol] , NIL})
		Aadd(aItensAux,{"D1_VUNIT"   , aItens[_n3][nPosVal] , NIL})
		Aadd(aItensAux,{"D1_TOTAL"   , ROUND(aItens[_n3][nPosSol]*aItens[_n3][nPosVal],2) , NIL})
		Aadd(aItensAux,{"D1_CC"    	 , Mv_par01              , NIL})
		Aadd(aItensAux,{"D1_NFORI"   , aItens[_n3][nPosDoc] , NIL})
		Aadd(aItensAux,{"D1_SERIORI" , aItens[_n3][nPosSer] , NIL})
		Aadd(aItensAux,{"D1_ITEMORI" , aItens[_n3][nPosIte] , NIL})  
		Aadd(aItensAux,{"D1_XDTORIG"  , aItens[_n3][nPosDtOri] , NIL})     //criado o campo D1_XDTORIG para passar o conteudo para D1_DATORI - luiz henrique 27/03/2015
		Aadd(aItensAux,{"D1_XIDPD3" , aItens[_n3][nPosIdentB6] , NIL})  //criado o campo D1_XIDPD3 para passar o conteudo para D1_IDENTB6 - luiz henrique 27/03/2015
		Aadd(aItensAux,{"D1_ITEM" , StrZero(_n3,4) , NIL})    //adicionado o campo D1_ITEM para ser tratado a pesquisa na ordem 1 - luiz henrique 27/03/2015
		
		Aadd(aItensNF, aItensAux)
		
		Aadd(aItensSZD,{xFilial("SD1"),;
		"000",;
		aItens[_n3][nPosPrd],;
		aItens[_n3][nPosDes],;
		aItens[_n3][nPosSol],; 
		aItens[_n3][nPosVal],;    
		aItens[_n3][nPosSol]*aItens[_n3][nPosVal],; 
		cNFiscal,;
		cSerie,;
		Mv_par01,;
		aItens[_n3][nPosUnm],;
		aItens[_n3][nPosDoc],;
		aItens[_n3][nPosSer],;
		aItens[_n3][nPosIte],;
		aItens[_n3][nPosCli],;
		aItens[_n3][nPosLoj],;    
		aItens[_n3][nPosDtOri],;             // data de origem da NF - luiz henrique 27/03/2015
		aItens[_n3][nPosIdentB6]})            //numero da identificacao no SB6 - luiz henrique 27/03/2015
	 
		
		lPara := .T.
	Next _n3
	
	Mv_old01 := Mv_par01
	Mv_old02 := Mv_par02
	
	If Len(aCabecNF) > 0 .And. Len(aItensNF) > 0
  	//incluida linha abaixo [Mauro Nagata, Actual Trend, 06/03/2013]	   
      BEGIN TRANSACTION
	  
//MSExecAuto({|x,y,z,w| MATA140(x,y,z,,w)}, aCabecNF, aItensNF, 3, 1) 
MSExecAuto({|x,y,z| MATA140(x,y,z)}, aCabecNF, aItensNF,3)
		
		Mv_par01 := Mv_old01
		Mv_par02 := Mv_old02
		
		If lMSErroAuto == .T.
			MostraErro()
			DisarmTransaction()                                     
			//incluido bloco abaixo [Mauro Nagata, Actual Trend, 06/03/2013]
			MsgBox("Nใo foi gerada a Nota Fiscal","Gerar NF","ALERT")
			Return .F.
			//fim bloco [Mauro Nagata, Actual Trend, 06/03/2013]
		Else
		                                                   
			A003SZD(aItensSZD)
			
			A003MAIL(aItensSZD)
			
			cMensagem := "Nota Fiscal :"+cSerie +"/"+cNFiscal+", gerada com sucesso !!!"
		EndIf     
		
		//incluida a linha abaixo [Mauro Nagata, Actual Trend, 06/03/2013]
      END TRANSACTION 
      
		aColsRet:= {}
		A003DADOS()
		oGetDados:aCols := aClone(aColsRet)
		
		oGetDados:Refresh()
		
		If !Empty(cMensagem)
			MsgInfo(cMensagem)
		EndIf
	EndIf            
EndIf

//Retun()
//substituida a linha abaixo [Mauro Nagata, Actual Trend, 06/03/2013]
Return(.T.)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ A003SZD  บ Autor ณ Bruno Parreira     บ Data ณ  22/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Grava item da NF de retorno na tabela SZD                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Lisonda Engenharia e Construcoes Ltda.          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function A003SZD(aItensSZD)

DbSelectArea("SZD")
SZD->( DbSetOrder(1) )    // ZD_FILIAL+ZD_CLIENTE+ZD_LOJA+ZD_NOTAORI+ZD_SERIORI+ZD_ITEMORI+ZD_COD
ProcRegua( Len(aItensSZD) )

For _n2 := 1 to Len(aItensSZD)
	IncProc("Granvando SZD ")
	
	If DbSeek( xFilial("SZD") + aItensSZD[_n2][13] + aItensSZD[_n2][14] + aItensSZD[_n2][10] + aItensSZD[_n2][11] + aItensSZD[_n2][12] + aItensSZD[_n2][03] + aItensSZD[_n2][16] ) 
		RecLock("SZD",.F.)
	Else
		RecLock("SZD",.T.)
	EndIf
	
	SZD->ZD_FILIAL 	:= aItensSZD[_n2][01]
	SZD->ZD_ITEM 	:= StrZero(_n2,2)
	SZD->ZD_COD 	:= aItensSZD[_n2][03]
	SZD->ZD_DESCRI 	:= aItensSZD[_n2][04]
	SZD->ZD_QUANT 	:= aItensSZD[_n2][05]
	SZD->ZD_DOC 	:= aItensSZD[_n2][08]  
	SZD->ZD_SERIE 	:= aItensSZD[_n2][09] 
	SZD->ZD_OBRA 	:= aItensSZD[_n2][10]
	SZD->ZD_UM 	    := aItensSZD[_n2][11]   
	SZD->ZD_NOTAORI	:= aItensSZD[_n2][12]    
	SZD->ZD_SERIORI	:= aItensSZD[_n2][13]    
	SZD->ZD_ITEMORI	:= aItensSZD[_n2][14]    
	SZD->ZD_CLIENTE	:= aItensSZD[_n2][15]    
	SZD->ZD_LOJA	:= aItensSZD[_n2][16]   
	SZD->ZD_DATORI	:= aItensSZD[_n2][17]           // data origem da NF - luiz henrique 27/03/2015
	SZD->ZD_IDENTB6	:= aItensSZD[_n2][18]           //identificacao na sb6  - luiz henrique 27/03/2015
	MsUnlock()
	
Next _n2


Return()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ A003MAIL บ Autor ณ Bruno Parreira     บ Data ณ  22/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Envia email de aviso aos  responsaveis                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Lisonda Engenharia e Construcoes Ltda.          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function A003MAIL(aItensSZD)

Local cArqOrig   := "\HTML\AFAT003.HTM"
Local cArqDest   := "C:\SIGA_FAT003.HTML"
Local aUsers     := PswRet()

Private cEmailUsR := AllTrim(aUsers[1][14])    //email do usuario requisitante
Private cNome_user:= aUsers[1][4]
Private c_Texto   := ""

//Criar parametros para inserir emails
If cFilAnt == '02'
	cEmailClas := cMailFil02
Else
	cEmailClas := cMailFil00
EndIf

cObra  	:= AllTrim(aItensSZD[01][08])
cNFEnt 	:= AllTrim(aItensSZD[01][06])
cSerEnt	:= AllTrim(aItensSZD[01][07])
cClient := AllTrim(aItensSZD[01][13])
cLoja   := AllTrim(aItensSZD[01][14])

lRet := A003HTML(cArqOrig,cArqDest)

cPar1   := cEmailClas+Iif(!Empty(cEmailUsR) .And. !Empty(cEmailClas) , ";", "")+cEmailUsR
cPar2   := "Solicita็ใo de classifica็ใo de Pr้ Nota de Entrada. [Doc/Serie: "+ cNFEnt +"/"+ cSerEnt +"] [Obra: "+ cObra +"] [Usuแrio: "+AllTrim(cNome_User)+"]"

lRet := U_FGen010(cPar1,cPar2,c_Texto,,.F.)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ A003HTML บ Autor ณ Bruno Parreira     บ Data ณ  22/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Abre e aramazena buffer do arquivo HTML                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Lisonda Engenharia e Construcoes Ltda.          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function A003HTML(c_FileOrig, c_FileDest)

Local l_Ret 	:= .T.
Local c_Buffer	:= ""
Local n_Posicao	:= 0
Local n_QtdReg	:= 0
Local n_RegAtu	:= 0

If !File(c_FileOrig)
	l_Ret := .F.
	MsgStop("Arquivo ["+c_FileOrig+"] nใo localizado.", "Nใo localizou")
Else
	Ft_fuse( c_FileOrig ) 		// Abre o arquivo
	Ft_FGoTop()
	n_QtdReg := Ft_fLastRec()
	
	nHandle	:= MSFCREATE( c_FileDest )
	
	While !ft_fEof() .And. l_Ret
		
		c_Buffer := ft_fReadln()
		
		FWrite(nHandle, &("'" + c_Buffer + "'"))
		c_texto += &("'" + c_Buffer + "'")
		
		ft_fSkip()
	Enddo
	
	fClose(nHandle)
EndIf

Return l_Ret            




/*/
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณNfeNextDocณ Autor ณ Edson Maricate        ณ Data ณ04.03.2000 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ          ณEsta rotina controla a numeracao do documento de entrada qdo ณฑฑ
ฑฑณ          ณo formulario for proprio                                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณExpD1: Data de Emissao                                       ณฑฑ
ฑฑณ          ณ                                                             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณExpL1: Indica se a data eh valida                            ณฑฑ
ฑฑณ          ณ                                                             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณEsta rotina tem como objetivo controlar/atualizar a numeracaoณฑฑ
ฑฑณ          ณdo documento de entrada quando o formulario for proprio.     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ Materiais                                                   ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function NfeNextDoc(cNFiscal,cNfSerie,lAtiva)               

//criado Static Function NfeNextDoc do fonte MATA103X [Mauro Nagata, Actual Trend, 20180624]

Local aArea	   := GetArea()
Local aAreaSF1 := SF1->(GetArea())
Local lRetorno := .T.
Local nItensNf := 0
Local cTipoNf  := SuperGetMv("MV_TPNRNFS")

If cFormul == "S" .And. lAtiva
	Private cNumero:= ""
	Private cSerie := ""
	lRetorno:= Sx5NumNota(@cSerie,cTipoNf)
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Validacao da NF informada pelo usuario                       ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If lRetorno .And. cTipoNF <> "3"
		SF1->(dbSetOrder(1))
		If SF1->(MsSeek(xFilial("SF1")+cNumero+cSerie+cA100For+cLoja,.F.))
			Help(" ",1,"EXISTNF")
			lRetorno := .F.
			cNumero:= ""
			cSerie := ""
		EndIf
	EndIf
	If lRetorno
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Verifica o numero de maximo de itens da serie.               ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		aEval(aCols,{|x| nItensNf += IIF(x[Len(x)],0,1)})
		If nItensNf > 0 	.And. nItensNf > a460NumIt(cSerie,.T.)
			Help(" ",1,"A100NITENS")
			lRetorno := .F.
		Else
			If cTipoNf <> "3"
				cNumero := NxtSX5Nota(cSerie, NIL, cTipoNf)
			Else 
				cNumero := Space(TamSx3("F1_DOC")[1])
			EndIf
		EndIf
	EndIf

	If lRetorno
	   cNFiscal:=cNumero
	   cNFSerie:=cSerie
    Else 
	   cNFiscal:= CriaVar("F1_DOC",.F.)
	   cNFSerie:= CriaVar("F1_SERIE",.F.)    
    EndIf
ElseIf cFormul == "N" .And. lAtiva
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica o preenchimento dos campos.        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If Empty(ca100For) .Or. Empty(dDEmissao) .Or. Empty(cTipo) .Or. (Empty(cNFiscal).And.cFormul<>"S")
		Help(" ",1,"A100FALTA")
		lRetorno := .F.
	EndIf

	SF1->(dbSetOrder(1))
	If SF1->(MsSeek(xFilial("SF1")+cNFiscal+cNfSerie+cA100For+cLoja,.F.))
		Help(" ",1,"EXISTNF")
		lRetorno := .F.
	EndIf
EndIf
RestArea(aAreaSF1)
RestArea(aArea)
Return(lRetorno)
