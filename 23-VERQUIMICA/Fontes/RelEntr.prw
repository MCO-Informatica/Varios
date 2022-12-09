#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#DEFINE DMPAPER_A4 9
#DEFINE CRLF CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RELENTR   ºAutor  ³Nelson Junior       º Data ³  11/12/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatório de entregas.                                      º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RelEntr(lAutoZ13)

Local oReport
Local oSection1
Local oSection2
Local oSection3
Local oSection4
Local cTitulo := 'Relatório de Entregas'
Default lAutoZ13 := .F.

If lAutoZ13
	oReport := TReport():New("RELENTR", cTitulo, , {|oReport| PrintReport(oReport)}, "Demonstra as entregas do romaneio.")
Else
	oReport := TReport():New("RELENTR", cTitulo, "RELENTR", {|oReport| PrintReport(oReport)}, "Demonstra as entregas do romaneio.")
EndIf
oReport:SetLandScape() //Retrato
oReport:SetTotalInLine(.F.)
oReport:ShowHeader()

If lAutoZ13
	MV_PAR01 := Z13->Z13_NUMERO
Else
	PutSX1("RELENTR","01","Romaneio","","","MV_CH1","C",06,0,0,"G","","Z13","","","MV_PAR01","","","","","","","","","","","","","","","","","","","")
	Pergunte(oReport:uParam,.F.)
EndIf

oSection1 := TRSection():New(oReport)
oSection1:SetTotalInLine(.F.)

oSection2 := TRSection():New(oReport)
oSection2:SetTotalInLine(.F.)

oSection3 := TRSection():New(oReport)
oSection3:SetTotalInLine(.F.)

oSection4 := TRSection():New(oReport)
oSection4:SetTotalInLine(.F.)

TRCell():New(oSection1,"NUMERO"			,,"Número:",		""							,	7						 ,,,,,)
TRCell():New(oSection1,"DESNUMERO"		,,"Des. Número",	PesqPict("Z13","Z13_NUMERO"),	TamSX3("Z13_NUMERO")[1]+1,,,,,)
TRCell():New(oSection1,"MOTORISTA"		,,"Motorista:",		""							,	30						 ,,,,,)
TRCell():New(oSection1,"DESMOTORISTA"	,,"Des. Motorista",	""							,	30						 ,,,,,)
TRCell():New(oSection1,"PLACA"			,,"Placa:",	   		""							,	6						 ,,,,,)
TRCell():New(oSection1,"DESPLACA"		,,"Des. Placa",		PesqPict("Z13","Z13_PLACA" ),	TamSX3("Z13_PLACA" )[1]+1,,,,,)

TRCell():New(oSection2,"NOTA"		,,"NF",			PesqPict("Z14","Z14_NOTA"	), TamSX3("Z14_NOTA"  )[1]+3,,,,,)
TRCell():New(oSection2,"PEDIDO"		,,"Pedido",		PesqPict("SD2","D2_PEDIDO"	), TamSX3("D2_PEDIDO" )[1]+3,,,,,)
TRCell():New(oSection2,"CLIENTE"	,,"Cliente",	PesqPict("SA1","A1_NOME"	), TamSX3("A1_NOME"	  )[1]+3,,,,,)
TRCell():New(oSection2,"MUNICIPIO"	,,"Municipio",	PesqPict("SA1","A1_MUN"		), TamSX3("A1_MUN"	  )[1]+3,,,,,)
TRCell():New(oSection2,"BAIRRO"		,,"Bairro",		PesqPict("SA1","A1_BAIRRO"	), TamSX3("A1_BAIRRO" )[1]+3,,,,,)
TRCell():New(oSection2,"PRODUTO"	,,"Produto",	PesqPict("SB1","B1_VQ_COD"	), TamSX3("B1_VQ_COD" )[1]+3,,,,,)
TRCell():New(oSection2,"QTDE"		,,"Qtde. (KG)",	PesqPict("SD2","D2_QUANT"	), TamSX3("D2_QUANT"  )[1]+3,,,"RIGHT",,"RIGHT")
TRCell():New(oSection2,"PESOBRUTO"	,,"Peso Bruto",	PesqPict("SF2","F2_PBRUTO"	), TamSX3("F2_PBRUTO" )[1]+3,,,"RIGHT",,"RIGHT")
TRCell():New(oSection2,"VOLUME"		,,"Volume",		PesqPict("SF2","F2_VOLUME1"	), TamSX3("F2_VOLUME1")[1]+3,,,"RIGHT",,"RIGHT")
TRCell():New(oSection2,"EMBALAGEM"	,,"Embalagem",	PesqPict("SB1","B1_VQ_EM"	), TamSX3("B1_VQ_EM"  )[1]+3,,,,,)
TRCell():New(oSection2,"TIPOFRETE"	,,"Tipo Frete",	""							 , 30						,,,,,)
TRCell():New(oSection2,"LOTE"		,,"Lote",		""							 , 30						,,,,,)

TRCell():New(oSection3,"DESCPROD1"	,,"Desc. Produto:", "",	14,,,,,)

TRCell():New(oSection3,"DESCPROD2"	,,"Desc. Produto:",	"",	112,;
/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,.T.,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.F.)

TRCell():New(oSection3,"NRORDEM"	,,"Nº Ordem:",		"",	28,,,,,)
TRCell():New(oSection3,"NREMBALAGEM",,"Nº Embalagem:",	"",	13,,,,,)


//Mesmo layout da seção 2, mas para totalizar na mão os valores
TRCell():New(oSection4,"NOTA"		,,"NF",					PesqPict("Z14","Z14_NOTA"	), TamSX3("Z14_NOTA"  )[1]+3,,,,,)
TRCell():New(oSection4,"PEDIDO"		,,"Pedido",				PesqPict("SD2","D2_PEDIDO"	), TamSX3("D2_PEDIDO" )[1]+3,,,,,)
TRCell():New(oSection4,"TOTENT"		,,"Total de Entregas",	""						     , TamSX3("A1_NOME"	  )[1]+3,,,"RIGHT",,"RIGHT")
TRCell():New(oSection4,"MUNICIPIO"	,,"Municipio", 			PesqPict("SA1","A1_MUN"		), TamSX3("A1_MUN"	  )[1]+3,,,,,)
TRCell():New(oSection4,"BAIRRO"		,,"Bairro",	 			PesqPict("SA1","A1_BAIRRO"	), TamSX3("A1_BAIRRO" )[1]+3,,,,,)
TRCell():New(oSection4,"TOTAL"		,,"Total", 		  		""							 , TamSX3("B1_VQ_COD" )[1]+3,,,"RIGHT",,"RIGHT")
TRCell():New(oSection4,"TOTQTDE"	,,"Qtde. (KG)",			PesqPict("SD2","D2_QUANT"	), TamSX3("D2_QUANT"  )[1]+3,,,"RIGHT",,"RIGHT")
TRCell():New(oSection4,"TOTPBRU"	,,"Peso Bruto",			PesqPict("SF2","F2_PBRUTO"	), TamSX3("F2_PBRUTO" )[1]+3,,,"RIGHT",,"RIGHT")
TRCell():New(oSection4,"VOLUME"		,,"Volume",	   			PesqPict("SF2","F2_VOLUME1"	), TamSX3("F2_VOLUME1")[1]+3,,,"RIGHT",,"RIGHT")
TRCell():New(oSection4,"EMBALAGEM"	,,"Embalagem", 			PesqPict("SB1","B1_VQ_EM"	), TamSX3("B1_VQ_EM"  )[1]+3,,,,,)
TRCell():New(oSection4,"TIPOFRETE"	,,"Tipo Frete",			""							 , 30						,,,,,)
TRCell():New(oSection4,"LOTE"		,,"Lote",	   			""							 , 30						,,,,,)
//

oReport:printDialog()

Return()
//
/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+------------------------------+------------------+||
||| Programa: PrintReport| Autor:                       | Data: 15/12/2014 |||
||+-----------+----------+------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(2)
Local oSection3 := oReport:Section(3)
Local oSection4 := oReport:Section(4)

Local _nCli		:= 0
Local _nQtde	:= 0
Local _nPesBru	:= 0
Local _cCliente := ""

cQry :=" SELECT * "
/*
cQry +="    Z13.Z13_NUMERO, "
cQry +="    Z13.Z13_PLACA, "
cQry +="    Z14.Z14_NOTA, "
cQry +="    Z14.Z14_SERIE, "
cQry +="    Z14.Z14_CLIENT, "
cQry +="    Z14.Z14_LOJA, "
cQry +="    SD2.D2_PEDIDO, "
cQry +="    SD2.D2_COD, "
cQry +="    SD2.D2_QUANT, "
cQry +="    SF2.F2_PBRUTO, "
cQry +="    SF2.F2_VOLUME1 "
*/
cQry +=" FROM "+RetSQLName("Z13")+" Z13 "
cQry +="    INNER JOIN "+RetSQLName("Z14")+" Z14 ON "
cQry +="       Z13.Z13_NUMERO = Z14.Z14_NUMERO "
cQry +="       AND Z14.D_E_L_E_T_ <> '*' "
cQry +="    INNER JOIN "+RetSQLName("SF2")+" SF2 ON "
cQry +="       Z14.Z14_NOTA       = SF2.F2_DOC "
cQry +="       AND Z14.Z14_SERIE  = SF2.F2_SERIE "
cQry +="       AND Z14.Z14_CLIENT = SF2.F2_CLIENTE "
cQry +="       AND Z14.Z14_LOJA   = SF2.F2_LOJA "
cQry +="       AND SF2.D_E_L_E_T_ <> '*' "
cQry +="    INNER JOIN "+RetSQLName("SD2")+" SD2 ON "
cQry += "      SF2.F2_DOC         = SD2.D2_DOC "
cQry +="       AND SF2.F2_SERIE   = SD2.D2_SERIE "
cQry +="       AND SF2.F2_CLIENTE = SD2.D2_CLIENTE "
cQry +="       AND SF2.F2_LOJA    = SD2.D2_LOJA "
cQry +="       AND SD2.D_E_L_E_T_ <> '*' "
cQry +=" WHERE "
cQry +="    Z13.D_E_L_E_T_ <> '*' "
cQry +="    AND Z13.Z13_NUMERO = '"+MV_PAR01+"' "
/*cQry +="GROUP BY "+CRLF
cQry +="Z13.Z13_NUMERO, "+CRLF
cQry +="Z13.Z13_PLACA, "+CRLF
cQry +="Z14.Z14_NOTA, "+CRLF
cQry +="Z14.Z14_SERIE, "+CRLF
cQry +="Z14.Z14_CLIENT, "+CRLF
cQry +="Z14.Z14_LOJA, "+CRLF
cQry +="SD2.D2_PEDIDO, "+CRLF
cQry +="SD2.D2_COD "+CRLF*/

cQry := ChangeQuery(cQry)

If Select("QRY") > 0
	QRY->(DbCloseArea())
EndIf

TcQuery cQry New Alias "QRY"

DbSelectArea("QRY")
nTotalReg := Contar("QRY", "!EoF()")
QRY->(DbGoTop())

oReport:SetMeter(nTotalReg)

oSection1:Init()
oSection1:SetHeaderSection(.F.)

oSection1:Cell("NUMERO"):SetValue("Número: ")
oSection1:Cell("NUMERO"):lBold := .T.
oSection1:Cell("DESNUMERO"):SetValue(QRY->Z13_NUMERO)

oSection1:Cell("MOTORISTA"):SetValue("Motorista: ")
oSection1:Cell("MOTORISTA"):lBold := .T.
oSection1:Cell("DESMOTORISTA"):SetValue("")

oSection1:Cell("PLACA"):SetValue("Placa: ")
oSection1:Cell("PLACA"):lBold := .T.
oSection1:Cell("DESPLACA"):SetValue(QRY->Z13_PLACA)

oSection1:PrintLine()

oSection1:Finish()

While QRY->(!EoF())
	
	oSection2:Init()
	oSection2:SetHeaderSection(.T.)
	
	If _cCliente <> Posicione("SA1",1,xFilial("SA1")+QRY->(Z14_CLIENT+Z14_LOJA),"A1_NOME")
		_nCli 	  := _nCli+1
		_cCliente := Posicione("SA1",1,xFilial("SA1")+QRY->(Z14_CLIENT+Z14_LOJA),"A1_NOME")
	EndIf
	
	oSection2:Cell("NOTA"):SetValue(QRY->Z14_NOTA)
	oSection2:Cell("PEDIDO"):SetValue(QRY->D2_PEDIDO)
	oSection2:Cell("CLIENTE"):SetValue(_cCliente)
	oSection2:Cell("MUNICIPIO"):SetValue(Posicione("SA1",1,xFilial("SA1")+QRY->(Z14_CLIENT+Z14_LOJA),"A1_MUN"))
	oSection2:Cell("BAIRRO"):SetValue(Posicione("SA1",1,xFilial("SA1")+QRY->(Z14_CLIENT+Z14_LOJA),"A1_BAIRRO"))
	oSection2:Cell("PRODUTO"):SetValue(Posicione("SB1",1,xFilial("SB1")+QRY->D2_COD,"B1_VQ_COD"))
	
	oSection2:Cell("QTDE"):SetValue(QRY->D2_QUANT)
	oSection2:Cell("PESOBRUTO"):SetValue(QRY->F2_PBRUTO)
	
	_nQtde	 += QRY->D2_QUANT
	_nPesBru += QRY->F2_PBRUTO
	
	oSection2:Cell("VOLUME"):SetValue(QRY->F2_VOLUME1)
	oSection2:Cell("EMBALAGEM"):SetValue(Posicione("SB1",1,xFilial("SB1")+Posicione("SB1",1,xFilial("SB1")+QRY->D2_COD,"B1_VQ_EM"),"B1_VQ_COD"))
	
	cTipoFret := ""
	If QRY->F2_VQ_FRET == "V"
		If QRY->F2_VQ_FVER == "N" // Normal
			cTipoFret := "VER Normal"
		ElseIf QRY->F2_VQ_FVER == "R" //Negociado/Retira
			cTipoFret := "VER Negociado/Retira"
		ElseIf QRY->F2_VQ_FVER == "D" //Negociado/Redespacho
			cTipoFret := "VER Negociado/Redespacho"
		EndIf
	Else
		If QRY->F2_VQ_FCLI == "R" //Retira
			cTipoFret := "CLI Retira"
		ElseIf QRY->F2_VQ_FCLI == "D" //Redespacho
			cTipoFret := "CLI Redespacho"
		EndIf
	EndIf
	
	oSection2:Cell("TIPOFRETE"):SetValue(cTipoFret)
	oSection2:Cell("LOTE"):SetValue("")
	
	oSection2:PrintLine()
	
	oSection2:Finish()
	
	oReport:ThinLine()
	
	SB5->(DbSetOrder(1))
	SB5->(DbSeek(xFilial("SB5")+QRY->D2_COD))
	
	If DY3->(DbSeek(xFilial("DY3")+SB5->B5_ONU))
		
		oSection3:Init()
		oSection3:SetHeaderSection(.F.)
		
		oSection3:Cell("DESCPROD1"):SetValue("Desc. Produto:")
		oSection3:Cell("DESCPROD1"):lBold := .T.
		
		oSection3:Cell("DESCPROD2"):SetValue("ONU "+AllTrim(DY3->DY3_ONU)+", "+AllTrim(DY3->DY3_DESCRI)+", "+AllTrim(DY3->DY3_CLASSE)+", "+AllTrim(DY3->DY3_NRISCO)+", "+AllTrim(DY3->DY3_GRPEMB))
		
		oSection3:Cell("NRORDEM"):SetValue("Nº Ordem:")
		oSection3:Cell("NRORDEM"):lBold := .T.
		
		oSection3:Cell("NREMBALAGEM"):SetValue("Nº Embalagem:")
		oSection3:Cell("NREMBALAGEM"):lBold := .T.
		
		oSection3:PrintLine()
		
		oReport:IncRow()
		oReport:FatLine()
		oReport:IncRow()
		
		oSection3:Finish()
		
	EndIf
	
	QRY->(DbSkip())
	
	oReport:IncMeter()
	
EndDo

oSection4:Init()
oSection4:SetHeaderSection(.F.)

oSection4:Cell("TOTENT"):SetValue("Total de Entregas: "+AllTrim(Str(_nCli)))
oSection4:Cell("TOTAL"):SetValue("Total:")
oSection4:Cell("TOTQTDE"):SetValue(_nQtde)
oSection4:Cell("TOTPBRU"):SetValue(_nPesBru)

oSection4:PrintLine()

oSection4:Finish()

If Select("QRY") > 0
	QRY->(DbCloseArea())
EndIf

Return()

