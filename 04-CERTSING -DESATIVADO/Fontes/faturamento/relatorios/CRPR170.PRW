#Include "Totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma: |CRPR170  	ºAutor  ³Renato Ruy Bernardo º Data ³  12/08/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatório de Rastreamento de voucher.				      º±±
±±º          ³ 			                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CRPR170()

Local aPergs	:= {}
Local aPedidos 	:= {}

Private aRet	:= {}
Private cPedIn	:= ""
Private cPerg   := "CRP170"

//Perguntas do parambox
aAdd( aPergs ,{6 ,"Gravar arquivo" 	,Space(70)	,"","","",50,.F.,"Arquivos .XML |*.XML"})
aAdd( aPergs ,{2 ,"Tipo Voucher"	,"T"		,{"T=Todos","2=Sub.Pedgar","B=Sub.Voucher","A=Garantia"}, 50,'.T.',.T.}) 
aAdd( aPergs ,{11,"Pedidos"			,""			,'.T.','.T.',.F.})

If !ParamBox(aPergs ,"Parametros ",aRet)
	Alert("O relatório foi cancelado!")
	Return
EndIf

//Cria um array para não estourar a quantidade de pedidos
aPedidos := StrToArray(aRet[3],chr(13)+chr(10))

If Len(aPedidos) > 1000
	Alert("A pesquisa por pedido apenas pode ser realizada ate 1000 pedidos!")
	Return
Elseif Len(aPedidos) == 0
	Alert("A pesquisa somente pode continuar se existir mais de um pedido!")
	Return
EndIf

//Formata os dados para serem utilizados na consulta.
cPedIn := "% "+FormatIn( StrTran(aRet[3],chr(13)+chr(10),","), "," )+" %"

Processa( {|| GerReg() }, "Selecionando registros...")

Return

//Processamento do relatório

Static Function GerReg

Local oExcel 		:= FWMSEXCEL():New()
Local cAcAnt		:= ""
Local cNomArq		:= ""
Local cCcrAnt		:= ""
Local cTipEnt		:= ""
Local nQtd			:= 0

If Select("QCRPR170") > 0
	QCRPR170->(DbCloseArea())
EndIf

If aRet[2] == "T"
	
	BeginSql Alias "QCRPR170"
		
		SELECT * FROM
		(SELECT 		SZ51.Z5_PEDGAR  PEDGAR1,
						SZ51.Z5_PEDGANT PEDORI1,
						SZ51.Z5_CODVOU  VOUCHER1,
						SZ51.Z5_TIPVOU  TPVOUCHER1,
						SZF1.ZF_VALORSW VALORSW1,
						SZF1.ZF_VALORHW VALORHW1,
						SZ52.Z5_PEDGAR  PEDGAR2,
						SZ52.Z5_PEDGANT PEDORI2,
						SZ52.Z5_CODVOU  VOUCHER2,
						SZ52.Z5_TIPVOU  TPVOUCHER2,
						SZF2.ZF_VALORSW VALORSW2,
						SZF2.ZF_VALORHW VALORHW2,
						SZ53.Z5_PEDGAR  PEDGAR3,
						SZ53.Z5_PEDGANT PEDORI3,
						SZ53.Z5_CODVOU  VOUCHER3,
						SZ53.Z5_TIPVOU  TPVOUCHER3,
						SZF3.ZF_VALORSW VALORSW3,
						SZF3.ZF_VALORHW VALORHW3,
						SZF3.ZF_PEDIDO  PEDGAR4
		FROM %Table:SZ5% SZ51
		LEFT JOIN %Table:SZF% SZF1 ON SZF1.ZF_FILIAL = ' ' AND SZF1.ZF_COD = SZ51.Z5_CODVOU AND SZF1.D_E_L_E_T_ = ' '
		LEFT JOIN %Table:SZ5% SZ52 ON SZ52.Z5_FILIAL = ' ' AND SZ52.Z5_PEDGAR = SZF1.ZF_PEDIDO AND SZ52.D_E_L_E_T_ = ' '
		LEFT JOIN %Table:SZF% SZF2 ON SZF2.ZF_FILIAL = ' ' AND SZF2.ZF_COD = SZ52.Z5_CODVOU AND SZF2.D_E_L_E_T_ = ' '
		LEFT JOIN %Table:SZ5% SZ53 ON SZ53.Z5_FILIAL = ' ' AND SZ53.Z5_PEDGAR = SZF2.ZF_PEDIDO AND SZ53.D_E_L_E_T_ = ' '
		LEFT JOIN %Table:SZF% SZF3 ON SZF3.ZF_FILIAL = ' ' AND SZF3.ZF_COD = SZ53.Z5_CODVOU AND SZF3.D_E_L_E_T_ = ' '
		WHERE SZ51.Z5_FILIAL = ' '                        
		AND SZ51.Z5_PEDGAR IN %Exp:cPedIn%
		AND SZ51.Z5_TIPVOU != 'B'
		AND SZ51.D_E_L_E_T_ = ' '
		UNION
		SELECT  		SZ51.Z5_PEDGAR  PEDGAR1,
						SZ51.Z5_PEDGANT PEDORI1,
						SZ51.Z5_CODVOU  VOUCHER1,
						SZ51.Z5_TIPVOU  TPVOUCHER1,
						SZF1.ZF_VALORSW VALORSW1,
						SZF1.ZF_VALORHW VALORHW1,
						' '             PEDGAR2,
						' '             PEDORI2,
						SZF2.ZF_COD     VOUCHER2,
						SZF2.ZF_TIPOVOU TPVOUCHER2,
						SZF2.ZF_VALORSW VALORSW2,
						SZF2.ZF_VALORHW VALORHW2,
						' '  			PEDGAR3,
						' '             PEDORI3,
						SZF3.ZF_COD     VOUCHER3,
						SZF3.ZF_TIPOVOU TPVOUCHER3,
						SZF3.ZF_VALORSW VALORSW3,
						SZF3.ZF_VALORHW VALORHW3,
						SZF3.ZF_PEDIDO  PEDGAR4
		FROM %Table:SZ5% SZ51
		LEFT JOIN %Table:SZF% SZF1 ON SZF1.ZF_FILIAL = ' ' AND SZF1.ZF_COD = Z5_CODVOU AND SZF1.D_E_L_E_T_ = ' '
		LEFT JOIN %Table:SZF% SZF2 ON SZF2.ZF_FILIAL = ' ' AND SZF1.ZF_CODORIG = SZF2.ZF_COD AND SZF2.D_E_L_E_T_ = ' '
		LEFT JOIN %Table:SZF% SZF3 ON SZF3.ZF_FILIAL = ' ' AND SZF2.ZF_CODORIG = SZF3.ZF_COD AND SZF3.D_E_L_E_T_ = ' '
		WHERE
		Z5_FILIAL = ' '
		AND SZ51.Z5_PEDGAR IN %Exp:cPedIn%  
		AND SZ51.Z5_TIPVOU = 'B' 
		AND SZ51.D_E_L_E_T_ = ' ')
		ORDER BY TPVOUCHER1, PEDGAR1
		
	EndSQL

Elseif aRet[2] == "B"

	BeginSql Alias "QCRPR170"
		
		SELECT * FROM
		(SELECT  		SZ51.Z5_PEDGAR  PEDGAR1,
						SZ51.Z5_PEDGANT PEDORI1,
						SZ51.Z5_CODVOU  VOUCHER1,
						SZ51.Z5_TIPVOU  TPVOUCHER1,
						SZF1.ZF_VALORSW VALORSW1,
						SZF1.ZF_VALORHW VALORHW1,
						' '             PEDGAR2,
						' '             PEDORI2,
						SZF2.ZF_COD     VOUCHER2,
						SZF2.ZF_TIPOVOU TPVOUCHER2,
						SZF2.ZF_VALORSW VALORSW2,
						SZF2.ZF_VALORHW VALORHW2,
						' '  			PEDGAR3,
						' '             PEDORI3,
						SZF3.ZF_COD     VOUCHER3,
						SZF3.ZF_TIPOVOU TPVOUCHER3,
						SZF3.ZF_VALORSW VALORSW3,
						SZF3.ZF_VALORHW VALORHW3,
						SZF3.ZF_PEDIDO  PEDGAR4
		FROM %Table:SZ5% SZ51
		LEFT JOIN %Table:SZF% SZF1 ON SZF1.ZF_FILIAL = ' ' AND SZF1.ZF_COD = Z5_CODVOU AND SZF1.D_E_L_E_T_ = ' '
		LEFT JOIN %Table:SZF% SZF2 ON SZF2.ZF_FILIAL = ' ' AND SZF1.ZF_CODORIG = SZF2.ZF_COD AND SZF2.D_E_L_E_T_ = ' '
		LEFT JOIN %Table:SZF% SZF3 ON SZF3.ZF_FILIAL = ' ' AND SZF2.ZF_CODORIG = SZF3.ZF_COD AND SZF3.D_E_L_E_T_ = ' '
		WHERE
		Z5_FILIAL = ' '
		AND SZ51.Z5_PEDGAR IN %Exp:cPedIn%  
		AND SZ51.Z5_TIPVOU = 'B'
		AND SZ51.D_E_L_E_T_ = ' ')
		ORDER BY TPVOUCHER1, PEDGAR1
		
	EndSQL

Else

		BeginSql Alias "QCRPR170"
		
		SELECT * FROM
		(SELECT 		SZ51.Z5_PEDGAR  PEDGAR1,
						SZ51.Z5_PEDGANT PEDORI1,
						SZ51.Z5_CODVOU  VOUCHER1,
						SZ51.Z5_TIPVOU  TPVOUCHER1,
						SZF1.ZF_VALORSW VALORSW1,
						SZF1.ZF_VALORHW VALORHW1,
						SZ52.Z5_PEDGAR  PEDGAR2,
						SZ52.Z5_PEDGANT PEDORI2,
						SZ52.Z5_CODVOU  VOUCHER2,
						SZ52.Z5_TIPVOU  TPVOUCHER2,
						SZF2.ZF_VALORSW VALORSW2,
						SZF2.ZF_VALORHW VALORHW2,
						SZ53.Z5_PEDGAR  PEDGAR3,
						SZ53.Z5_PEDGANT PEDORI3,
						SZ53.Z5_CODVOU  VOUCHER3,
						SZ53.Z5_TIPVOU  TPVOUCHER3,
						SZF3.ZF_VALORSW VALORSW3,
						SZF3.ZF_VALORHW VALORHW3,
						SZF3.ZF_PEDIDO  PEDGAR4
		FROM %Table:SZ5% SZ51
		LEFT JOIN %Table:SZF% SZF1 ON SZF1.ZF_FILIAL = ' ' AND SZF1.ZF_COD = SZ51.Z5_CODVOU AND SZF1.D_E_L_E_T_ = ' '
		LEFT JOIN %Table:SZ5% SZ52 ON SZ52.Z5_FILIAL = ' ' AND SZ52.Z5_PEDGAR = SZF1.ZF_PEDIDO AND SZ52.D_E_L_E_T_ = ' '
		LEFT JOIN %Table:SZF% SZF2 ON SZF2.ZF_FILIAL = ' ' AND SZF2.ZF_COD = SZ52.Z5_CODVOU AND SZF2.D_E_L_E_T_ = ' '
		LEFT JOIN %Table:SZ5% SZ53 ON SZ53.Z5_FILIAL = ' ' AND SZ53.Z5_PEDGAR = SZF2.ZF_PEDIDO AND SZ53.D_E_L_E_T_ = ' '
		LEFT JOIN %Table:SZF% SZF3 ON SZF3.ZF_FILIAL = ' ' AND SZF3.ZF_COD = SZ53.Z5_CODVOU AND SZF3.D_E_L_E_T_ = ' '
		WHERE SZ51.Z5_FILIAL = ' '
		AND SZ51.Z5_PEDGAR IN %Exp:cPedIn%  
		AND SZ51.Z5_TIPVOU = %Exp:aRet[2]%
		AND SZ51.D_E_L_E_T_ = ' ')
		ORDER BY TPVOUCHER1, PEDGAR1
		
	EndSQL
	
EndIf

DbSelectArea("QCRPR170")
QCRPR170->(DbGoTop())


//Cria nova aba
oExcel:AddworkSheet("VOUCHER")

//Cria Cabecalho da tabela
oExcel:AddTable ("VOUCHER","VOUCHER")

//Adiciona cabecalho dos itens
oExcel:AddColumn("VOUCHER","VOUCHER","PED.GAR 1"  		, 2,1)
oExcel:AddColumn("VOUCHER","VOUCHER","PED.ORI 1" 		, 2,1)
oExcel:AddColumn("VOUCHER","VOUCHER","VOUCHER 1" 		, 2,1)
oExcel:AddColumn("VOUCHER","VOUCHER","TP. VOUCHER 1"	, 2,1)
oExcel:AddColumn("VOUCHER","VOUCHER","VALOR SW 1"		, 2,1)
oExcel:AddColumn("VOUCHER","VOUCHER","VALOR HW 1"		, 2,1)

oExcel:AddColumn("VOUCHER","VOUCHER","PED.GAR 2"  		, 2,1)
oExcel:AddColumn("VOUCHER","VOUCHER","PED.ORI 2" 		, 2,1)
oExcel:AddColumn("VOUCHER","VOUCHER","VOUCHER 2" 		, 2,1)
oExcel:AddColumn("VOUCHER","VOUCHER","TP. VOUCHER 2"	, 2,1)
oExcel:AddColumn("VOUCHER","VOUCHER","VALOR SW 2"		, 2,1)
oExcel:AddColumn("VOUCHER","VOUCHER","VALOR HW 2"		, 2,1)

oExcel:AddColumn("VOUCHER","VOUCHER","PED.GAR 3"  		, 2,1)
oExcel:AddColumn("VOUCHER","VOUCHER","PED.ORI 3" 		, 2,1)
oExcel:AddColumn("VOUCHER","VOUCHER","VOUCHER 3" 		, 2,1)
oExcel:AddColumn("VOUCHER","VOUCHER","TP. VOUCHER 3"	, 2,1)
oExcel:AddColumn("VOUCHER","VOUCHER","VALOR SW 3"		, 2,1)
oExcel:AddColumn("VOUCHER","VOUCHER","VALOR HW 3"		, 2,1)

oExcel:AddColumn("VOUCHER","VOUCHER","PED.GAR 4"  		, 2,1)


While !QCRPR170->(EOF())
	
	nQtd += 1
	
	IncProc( "Processo " + AllTrim(Str(nQtd)) + " --> Pedido: " + QCRPR170->PEDGAR1)
	ProcessMessage()
	
	//Adiciona Itens
	oExcel:AddRow("VOUCHER","VOUCHER",{QCRPR170->PEDGAR1,;
	QCRPR170->PEDORI1,;
	QCRPR170->VOUCHER1,;
	Posicione("SZH",1,xFilial("SZH")+QCRPR170->TPVOUCHER1,"ZH_DESCRI"),;
	QCRPR170->VALORSW1,;
	QCRPR170->VALORHW1,;
	QCRPR170->PEDGAR2,;
	QCRPR170->PEDORI2,;
	QCRPR170->VOUCHER2,;
	Posicione("SZH",1,xFilial("SZH")+QCRPR170->TPVOUCHER2,"ZH_DESCRI"),;
	QCRPR170->VALORSW2,;
	QCRPR170->VALORHW2,;
	QCRPR170->PEDGAR3,;
	QCRPR170->PEDORI3,;
	QCRPR170->VOUCHER3,;
	Posicione("SZH",1,xFilial("SZH")+QCRPR170->TPVOUCHER3,"ZH_DESCRI"),;
	QCRPR170->VALORSW3,;
	QCRPR170->VALORHW3,;
	QCRPR170->PEDGAR4})
	
	QCRPR170->(DbSkip())
EndDo


//Salva o Arquivo
oExcel:Activate()
oExcel:GetXMLFile(AllTrim(aRet[1]))

MsgInfo("Arquivo Exportado para: " + AllTrim(aRet[1]))

Return