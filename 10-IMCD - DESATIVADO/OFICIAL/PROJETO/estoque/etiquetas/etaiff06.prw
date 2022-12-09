#INCLUDE "topconn.ch"
#INCLUDE "SHELL.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWIZARD.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "PARMTYPE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณETAIFF01  บAutor  Luiz Oliveira        บ Data ณ  10/08/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImpressao etiqueta de endere็amento TAIFF                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ETAIFF06()

	Local lContinua := .T.
	local cFilBkp   := cFilAnt
	cFilant := "02"

	vSetImp := {}
	vSetImp := ExParam()

	If Empty(vSetImp[1,8])
		MsgAlert("Informe um local de impressao valido")
		lContinua := .F.
	EndIf

	If !CB5SetImp(vSetImp[1,8])
		MsgAlert("Local de Impressใo "+vSetImp[1,8]+" nao Encontrado!")
		lContinua := .F.
		Return
	Endif

	If lContinua
		ImpEti07(vSetImp[1,1],vSetImp[1,2],vSetImp[1,3],vSetImp[1,4],vSetImp[1,5],vSetImp[1,6],vSetImp[1,7])

		MSCBCLOSEPRINTER()
	EndIf

	cFilAnt := cFilBkp

Return
//////////////////////////////////////////
//Rotina de impressao de etiqueta      //
/////////////////////////////////////////
Static Function ImpEti07(vDoc1,vDoc2,vDoc3,vDoc4,vDoc5,vDoc6,vDoc7,vDoc8)

	Local cQuery	:= ""
	Local dQuery	:= ""
	Local cAliasNew	:= GetNextAlias()
	Local cTipoBar	:= 'MB07' //128
	Local cCodBar	:= ''
	Local sConteudo	:= ""
	Local cForn := cProd := cCodProd := cCOdDCB := cDesDCB := cNfiscal := cLote := cFabrinte := cExport := " "
	Local cUmidade := cLumin := cOrigem := cProced := " "
	Local cPliq := cPBruto := cTemper := 0
	Local cFabricao := cVal := " "
	Local vManual := .F.
	Local vLoop := .F.
	Local vSair := .F.
	Local z := 0
	Local cStatus := "APROVADO"

	Private ENTERL     := CHR(13)+CHR(10)

//+-----------------------
//| Cria filtro temporario
//+-----------------------

	cAliasNew:= GetNextAlias()

	vDoc1 := alltrim(vDoc1)
	vDoc2 := alltrim(vDoc2)
	vDoc3 := alltrim(vDoc3)
	vDoc4 := alltrim(vDoc4)
	vDoc5 := alltrim(vDoc5)
	vDoc6 := alltrim(vDoc6)
	vDoc7 := alltrim(vDoc7)

	cQuery 	:= " SELECT * FROM SBF020 LOTE INNER JOIN SB1020 PRD ON BF_PRODUTO = B1_COD AND LOTE.BF_FILIAL = '02' "
	cQuery 	+= " WHERE LOTE.BF_LOCALIZ BETWEEN '" +vDoc1+"' AND '" +vDoc2+"' AND LOTE.BF_PRODUTO BETWEEN '" +vDoc3+"' AND '" +vDoc4+"' AND LOTE.BF_LOCAL = '" +vDoc7+"' "
	cQuery 	+= " AND LOTE.BF_LOTECTL BETWEEN '" +vDoc5+"' AND '" +vDoc6+"' AND PRD.D_E_L_E_T_ <> '*' "
	cQuery 	+= " AND LOTE.D_E_L_E_T_ <> '*' "

	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasNew,.T.,.T.)

	(cAliasNew)->(dbGoTop())
	DbGotop()

	If Select("RMIN") > 0
		RMIN->( dbCloseArea() )
	EndIf

	dQuery 	:= " SELECT *  FROM " +RetSqlName("SD1")
	dQuery 	+= " WHERE D1_FILIAL = '"+ xFilial("SD1")+"' AND D_E_L_E_T_ <> '*' AND "
	dQuery 	+= " D1_COD =   '" +(cAliasNew)->BF_PRODUTO+"' "
	dQuery 	+= " AND D1_LOTECTL = '"+(cAliasNew)->BF_LOTECTL+"' "
	dQuery 	+= " AND D1_FILIAL = '02' "

	TCQUERY dQuery  NEW ALIAS "RMIN"
	DbSelectArea("RMIN")
	DbGotop()



	If MsgYesNo( "Deseja inserir quantidade manual ?" , "ATENCAO")

		cTitulo := "** Altera็ใo de dados da etiqueta **" //titulo da janela
		cTexto1 := "Qtd. Etiquetas: "   //label
		cTexto2 := "Peso bruto: "   //label
		cTexto3 := "Peso Liquido: "   //label

		cQtdEtq   := CriaVar("B1_QE",.T.) //varivel de cnpj - criavar - cria a variavel com o tamanho do campo que consta em sx3
		cPesoB   := CriaVar("BF_QUANT",.T.) //varivel de cnpj - criavar - cria a variavel com o tamanho do campo que consta em sx3
		cPesoL   := CriaVar("BF_QUANT",.T.) //varivel de cnpj - criavar - cria a variavel com o tamanho do campo que consta em sx3

		cQtdEtq   := 1 //varivel de cnpj - criavar - cria a variavel com o tamanho do campo que consta em sx3
		cPesoB   := 1 //varivel de cnpj - criavar - cria a variavel com o tamanho do campo que consta em sx3
		cPesoL   := 1 //varivel de cnpj - criavar - cria a variavel com o tamanho do campo que consta em sx3


		DEFINE MSDIALOG oDlg TITLE cTitulo FROM 000,000 TO 200,300 PIXEL   //monta janela

		@005,005 TO 100,145 OF oDlg PIXEL
		@015,020 SAY cTexto1 SIZE 060,007 OF oDlg PIXEL
		@012,075 MSGET cQtdEtq SIZE 055,011 OF oDlg PIXEL PICTURE "@R 99999"

		@030,020 SAY cTexto2 SIZE 060,007 OF oDlg PIXEL             //label
		@027,075 MSGET cPesoB SIZE 055,011 OF oDlg PIXEL  PICTURE "@R 9,999,999.9999" //"@R 99999"

		@045,020 SAY cTexto3 SIZE 060,007 OF oDlg PIXEL             //label
		@042,075 MSGET cPesoL SIZE 055,011 OF oDlg PIXEL  PICTURE "@R 9,999,999.9999"

		DEFINE SBUTTON FROM 075,100 TYPE 1;
			ACTION (oDlg:End()) ENABLE OF oDlg               //recebe opcao 0 e fecha, porem continua a execu็ao

		ACTIVATE MSDIALOG oDlg CENTERED

		vManual := .T.

		xQtdEtq := cQtdEtq

	Endif


	If vManual == .F.
		If MsgYesNo( "Deseja selecionar etiqueta especifica ?" , "ATENCAO")

			cTitulo := "** Impressใo da etiqueta especifica **" //titulo da janela
			cTexto1 := "Numero da Etiqueta De: "   //label
			cTexto2 := "Numero da Etiqueta Ate: "   //label

			cNumDe   := CriaVar("B1_QE",.T.) //varivel de cnpj - criavar - cria a variavel com o tamanho do campo que consta em sx3
			cNumAte   := CriaVar("B1_QE",.T.) //varivel de cnpj - criavar - cria a variavel com o tamanho do campo que consta em sx3

			cNumetq   := 1 //varivel de cnpj - criavar - cria a variavel com o tamanho do campo que consta em sx3
			cNumetq   := 99999 //varivel de cnpj - criavar - cria a variavel com o tamanho do campo que consta em sx3

			DEFINE MSDIALOG oDlg TITLE cTitulo FROM 000,000 TO 200,300 PIXEL   //monta janela

			@005,005 TO 100,145 OF oDlg PIXEL
			@015,020 SAY cTexto1 SIZE 060,007 OF oDlg PIXEL
			@012,075 MSGET cNumDe SIZE 055,011 OF oDlg PIXEL PICTURE "@R 99999"

			@030,020 SAY cTexto2 SIZE 060,007 OF oDlg PIXEL
			@027,075 MSGET cNumAte SIZE 055,011 OF oDlg PIXEL  PICTURE "@R 99999"

			DEFINE SBUTTON FROM 075,100 TYPE 1;
				ACTION (oDlg:End()) ENABLE OF oDlg               //recebe opcao 0 e fecha, porem continua a execu็ao

			ACTIVATE MSDIALOG oDlg CENTERED

			vLoop := .T.
		Endif
	Endif

	While (cAliasNew)->(!Eof())

		If	vManual == .F.
			xQtdEtq := 0
			xQtdEtq := (cAliasNew)->BF_QUANT / (cAliasNew)->B1_QE
		Endif

		For z := 1 to xQtdEtq

			If vLoop
				If z < cNumDe
					z := cNumDe
				Endif

				If z > cNumAte
					Return()
				Endif
			endif

			//quantidade de etiquetas


			cCodBar:= ALLTRIM((cAliasNew)->BF_PRODUTO)
			cCodBar1:= ALLTRIM((cAliasNew)->BF_LOTECTL)
			FWLogMsg("INFO", "", "BusinessObject", "ETAIFF06" , "", "", cCodBar1 , 0, 0)
			MSCBBEGIN(1,6)

			//cabe็alho
			MSCBSAY(010,005,"IMCD","N","0","035,040")
			MSCBSAY(024,006,"Brasil Farma","N","0","025,025")

			MSCBSAY(050,003,"Fone: (11) 5591-2300","N","0","020,020")
			MSCBSAY(050,006,"CNPJ: 62.651.955/0001-66","N","0","020,020")

			MSCBLineH(01,10,100)

			//Produto

			MSCBSAY(005,015,ALLTRIM(STR(z)) + "/" + ALLTRIM(STR(xQtdEtq)),"N","0","028,028")

			MSCBSAY(005,019, "Produto: ","N","0","028,028")

			MSCBSAY(019,019, substr((cAliasNew)->B1_DESC,1,25),"N","0","025,028")

			MSCBSAY(005,024, "DCB: " + ALLTRIM((cAliasNew)->B1_DCB),"N","0","025,028")

			MSCBSAY(030,024, "CAS: " + ALLTRIM((cAliasNew)->B1_CASNUM),"N","0","025,028")

			xDescDCB := " "
			xDescDCB := Posicione("ZDC",1,xFilial("ZDC")+(cAliasNew)->B1_DCB,"ZDC_DESC")

			MSCBSAY(005,028,ALLTRIM(xDescDCB),"N","0","025,028")

			If vManual
				MSCBSAY(045,030,"P.Liquido: " + ALLTRIM(STR(cPesoL)),"N","0","025,028")
			Else
				MSCBSAY(045,030,"P.Liquido: " + ALLTRIM(STR((cAliasNew)->B1_QE)),"N","0","025,028")
			Endif

			If vManual
				MSCBSAY(073,030,"P.Bruto: " + ALLTRIM(STR(cPesoB)),"N","0","025,028")
			Else
				If (cAliasNew)->B1_PESBRU > 0 .and. (cAliasNew)->B1_PESO > 0
					MSCBSAY(073,030,"P.Bruto: " + ALLTRIM(STR((cAliasNew)->B1_QE*((cAliasNew)->B1_PESBRU/(cAliasNew)->B1_PESO))),"N","0","025,028")
				Else
					MSCBSAY(073,030,"P.Bruto: " + ALLTRIM(STR((cAliasNew)->B1_QE)),"N","0","025,028")
				Endif
			Endif

			MSCBSAY(005,033,"Endere็o: " + ALLTRIM((cAliasNew)->BF_LOCALIZ),"N","0","025,028")


			MSCBSAY(005,037,"Lote Forn.: " + ALLTRIM((cAliasNew)->BF_LOTECTL),"N","0","025,028")


			DBSELECTAREA("SB8")
			dbsetorder(5)
			DBSEEK(xFilial("SB8")+(cAliasNew)->BF_PRODUTO+(cAliasNew)->BF_LOTECTL)


			MSCBSAY(073,037,"Fab.: " + Dtoc(SB8->B8_DFABRIC) ,"N","0","025,028")

			MSCBSAY(073,041,"Val.: " + Dtoc(SB8->B8_DTVALID) ,"N","0","025,028")

			MSCBSAY(005,042, "Cond. Armazenagem: " + ALLTRIM(strtran((cAliasNew)->B1_XTEMP, "ฐ", " ")),"N","0","020,020")

			MSCBSAY(005,045, "Umidade: " + ALLTRIM(strtran((cAliasNew)->B1_XDUMI, "ฐ", " ")),"N","0","020,020")

			MSCBSAY(005,048, "Luminosidade: " + ALLTRIM(strtran((cAliasNew)->B1_XDLUM, "ฐ", " ")),"N","0","020,020")

			//Rodap้

			MSCBSAY(015,071,"Farmac๊utico Responsแvel: Beatriz Fernandes Machado - CRF - SP 36.245 ","N","0","018,018")

			MSCBSAY(012,073,"Rua Arquiteto Olav Redig de Campos, 105 - Torre B - 25 Andar - Sใo Paulo/SP ","N","0","018,018")

			MSCBSAYBAR(067,012,cCodBar,"N",cTipoBar,9.36,.F.,.T.,.F.,,2,1,.F.,.F.,"1",.T.)

			MSCBSAYBAR(062,058,cCodBar1,"N",cTipoBar,9.36,.F.,.T.,.F.,,2,1,.F.,.F.,"1",.T.)

			cFabric := ' '
			cOrigem := ' '
			DBSELECTAREA("SA2")
			dbsetorder(1)
			if DBSEEK(xFilial("SA2")+RMIN->D1_FABRIC+RMIN->D1_LOJFABR)
				cFabric :=  SUBSTR(SA2->A2_NOME,1,30)

				DBSELECTAREA("SYA")
				dbsetorder(1)
				DBSEEK(xFilial("SYA")+SA2->A2_PAIS)
				cOrigem :=  ALLTRIM(SYA->YA_DESCR)

			Endif

			MSCBSAY(005,051, "Fabricante: " +cFabric,"N","0","020,020")
			MSCBSAY(073,051, "Origem: " +cOrigem,"N","0","020,020")

			DBSELECTAREA("SA2")
			dbsetorder(1)
			DBSEEK(xFilial("SA2")+RMIN->D1_FORNECE+RMIN->D1_LOJA)

			MSCBSAY(005,054, "Exportador: " + SUBSTR(SA2->A2_NOME,1,40),"N","0","020,020")

			DBSELECTAREA("SYA")
			dbsetorder(1)
			DBSEEK(xFilial("SYA")+SA2->A2_PAIS)

			MSCBSAY(073,054, "Procedencia: " + ALLTRIM(SYA->YA_DESCR) ,"N","0","020,020")

			MSCBSAY(005,059, "ENTRADA" ,"N","0","032,032")
			cStatus := iif( (cAliasNew)->BF_LOCAL <> "RP","APROVADO","REPROVADO")
			MSCBSAY(005,063, cStatus  ,"N","0","038,038")

			If vSair
				Return()
			Endif

			sConteudo:=MSCBEND()
		Next Z

		(cAliasNew)->(dbSkip())
	EndDo

	(cAliasNew)->(DbCloseArea())

	If Empty(sConteudo)
		MsgAlert("Sem Dados para Impressใo! Verifique os Parametros!!!","A T E N ว ร O!!!")
		Return
	EndIf

Return sConteudo

Static Function ExParam()
	Local aPergs := {}
	Local aRet := {}
	Local lRet
	Local vConf := {}

	xDoc1 := xDoc2 := xDoc3 := xDoc4 := xDoc5 := xDoc6 := space(15)
	xDoc7 := space(2)
	xDoc8 := space(06)

	aAdd( aPergs ,{1,"End. de : ",xDoc1  ,"@!",'.T.', ,'.T.',40,.T.})
	aAdd( aPergs ,{1,"End ate : ",xDoc2  ,"@!",'.T.', ,'.T.',40,.T.})
	aAdd( aPergs ,{1,"Prod. de : ",xDoc3  ,"@!",'.T.', ,'.T.',40,.T.})
	aAdd( aPergs ,{1,"Prod ate : ",xDoc4  ,"@!",'.T.', ,'.T.',40,.T.})
	aAdd( aPergs ,{1,"Lote de : ",xDoc5  ,"@!",'.T.', ,'.T.',40,.T.})
	aAdd( aPergs ,{1,"Lote ate : ",xDoc6  ,"@!",'.T.', ,'.T.',40,.T.})

	aAdd( aPergs ,{1,"Armazem : ",xDoc7  ,"@!",'.T.', ,'.T.',40,.T.})

	aAdd( aPergs ,{1,"Impressora: ",xDoc8 ,"@!",'.T.',"CB5",'.T.',40,.T.})


	If ParamBox(aPergs ,"Parametros6 ",aRet)
		lRet := .T.
	Else
		lRet := .F.
	EndIf

	If lRet
		aAdd( vConf ,{aRet[1],aRet[2],aRet[3],aRet[4],aRet[5],aRet[6],aRet[7],aRet[8]})
	Else

		Alert("Botใo Cancelar")
		Return()

	Endif

Return (vConf)
