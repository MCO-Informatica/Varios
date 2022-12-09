#Include "Protheus.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPZCVR013  บAutor  ณLucas Fl๓ridi Leme  บ Data ณ  27/08/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Produtos fabricados com especifica MP dentro de um         บฑฑ
ฑฑบ          ณ intervalo de tempo - Solicitado por Arthur                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus 11                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                              
User Function PZCVR013()

Local cPerg		:= PadR("PZCVR013",10)           

AjustaSx1(cPerg)
If Pergunte(cPerg,.T.)    

	Processa( {|| MexProcessa() },"Aguarde" ,"Processando...")
	Processa( {|| GeraExcel("TMP") },"Aguarde" ,"Gerando arquivo excel...")

EndIf

Return() 

          
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMexProcessบAutor  ณMicrosiga           บ Data ณ  08/09/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MexProcessa()

cQry := "SELECT COD,DESCR,SUM(QTDPROD) AS QTDPROD,CODMP,SUM(QTDMP) AS QTDMP FROM ( " +Chr(13)
cQry += "SELECT D3_COD AS COD, B1_DESC AS DESCR, SUM(D3_QUANT) AS QTDPROD, " +Chr(13)
cQry += "				(SELECT DISTINCT D3_COD FROM SD3010 D1 WHERE " +Chr(13)
cQry += "				    D1.D3_ESTORNO <> 'S' AND " +Chr(13)
cQry += "					D1.D3_OP = D0.D3_OP AND D1.D_E_L_E_T_ <> '*'AND " +Chr(13)
cQry += "					D1.D3_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND " +Chr(13)
cQry += "					D1.D3_CF IN ('RE1','RE2') AND " +Chr(13)
cQry += "					D1.D3_COD = '"+ mv_par03 +"')  AS CODMP,  " +Chr(13)
cQry += "				(SELECT DISTINCT SUM (D3_QUANT) FROM SD3010 D2 WHERE  " +Chr(13)
cQry += "					D2.D3_ESTORNO <> 'S' AND " +Chr(13)
cQry += "					D2.D3_OP = D0.D3_OP AND D2.D_E_L_E_T_ <> '*' AND " +Chr(13)
cQry += "					D2.D3_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND " +Chr(13)
cQry += "					D2.D3_CF IN ('RE1','RE2') AND " +Chr(13)
cQry += "					D2.D3_COD = '"+ mv_par03 +"')  AS QTDMP " +Chr(13)
cQry += "FROM SD3010 D0  " +Chr(13)
cQry += "INNER JOIN SB1010 B1 ON B1_COD = D0.D3_COD " +Chr(13)
cQry += "WHERE " +Chr(13)
cQry += "D0.D_E_L_E_T_<> '*' AND " +Chr(13)
cQry += "D3_ESTORNO <> 'S' AND " +Chr(13)
cQry += "D3_CF = 'PR0' AND " +Chr(13)
cQry += "D3_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND " +Chr(13)
cQry += "D3_OP IN (  SELECT D3_OP FROM SD3010 D3  WHERE " +Chr(13)
cQry += "			D3.D_E_L_E_T_ <> '*'AND " +Chr(13)
cQry += "							D3_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND " +Chr(13)
cQry += "							D3_ESTORNO <> 'S' AND " +Chr(13)
cQry += "							D3.D3_CF IN ('RE1','RE2') AND " +Chr(13)
cQry += "							D3_COD = '"+ mv_par03 +"' ) " +Chr(13)
cQry += "GROUP BY D3_COD, B1_DESC, D3_OP) AS TESTE2 " +Chr(13)
cQry += "GROUP BY COD,DESCR,CODMP " +Chr(13)
cQry += "ORDER BY QTDPROD DESC, QTDMP DESC  " +Chr(13)

Memowrite("PZCVR013.txt",cQry)
TcQuery cQry New Alias "TMP"                                       

//TcSetField("TMP","DEBITO","N",TamSx3("CT2_VALOR")[1],2)        
//TcSetField("TMP","CREDITO","N",TamSx3("CT2_VALOR")[1],2)  
//TcSetField("TMP","REG_CT2","N",14,0)  

                      
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustaSX1 บAutor  ณ                    บ Data ณ  02/06/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AjustaSX1(cPerg)

Local aRea	:= GetArea()
Local aSx1	:= {}

DBSelectArea("SX1")
SX1->(DBSetOrder(1))
cPerg := PadR(cPerg, Len(SX1->X1_GRUPO))
SX1->(DBSeek(cPerg+"01"))       
AADD(	aSx1,{ cPerg,"01","De Data?"			,"mv_par01"	,"D",8,0,0,"G","", 	"mv_par01","","","","","","" } )
AADD(	aSx1,{ cPerg,"02","Ate Data?"			,"mv_par02"	,"D",8,0,0,"G","",	"mv_par02","","","","","","" } ) 
AADD(	aSx1,{ cPerg,"03","Escolha a MP:"	   	,"mv_par03"	,"C",TAMSX3("B1_COD")[1],0,0,"G","",	"mv_par03","","","","","SB1" } )


If SX1->X1_GRUPO != cPerg
	For I := 1 To Len( aSx1 )
		If !SX1->( DBSeek( aSx1[I][1] + aSx1[I][2] ) )
			Reclock( "SX1", .T. )
			SX1->X1_GRUPO		:= aSx1[i][1] //Grupo
			SX1->X1_ORDEM		:= aSx1[i][2] //Ordem do campo
			SX1->X1_PERGUNT		:= aSx1[i][3] //Pergunta
			SX1->X1_PERSPA		:= aSx1[i][3] //Pergunta Espanhol
	   		SX1->X1_PERENG		:= aSx1[i][3] //Pergunta Ingles
			SX1->X1_VARIAVL		:= aSx1[i][4] //Variavel do campo
			SX1->X1_TIPO		:= aSx1[i][5] //Tipo de valor
			SX1->X1_TAMANHO		:= aSx1[i][6] //Tamanho do campo
			SX1->X1_DECIMAL		:= aSx1[i][7] //Formato numerico
			SX1->X1_PRESEL		:= aSx1[i][8] //Pre sele็ใo do combo
			SX1->X1_GSC		:= aSx1[i][9] //Tipo de componente
			SX1->X1_VAR01		:= aSx1[i][10]//Variavel que carrega resposta
			SX1->X1_DEF01		:= aSx1[i][11]//Defini็๕es do combo-box
			SX1->X1_DEF02		:= aSx1[i][12]
			SX1->X1_DEF03		:= aSx1[i][13]
			SX1->X1_DEF04		:= aSx1[i][14]
			SX1->X1_VALID		:= aSx1[i][15]
			SX1->X1_F3			:= aSx1[i][16]
			MsUnlock()
		Endif
	Next
Endif

RestArea(aRea)

Return(cPerg)		

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณGeraExcel บAutor  ณ                    บ Data ณ  05/12/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGeracao de arquivo excel 						              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GeraExcel(cAlias)
Local _cPathExcel:="C:\MICROSIGA\"

DbSelectArea("TMP")
DbGotop()
ProcRegua(TMP->(RecCount()))
If !TMP->(Eof())
	_aStru := TMP->(DbStruct())
	oExcel    := FWMSEXCEL():New()
	oExcel:AddworkSheet("PRODUTOSXPROD")
	oExcel:AddTable ("PRODUTOSXPROD","PRODUTOSXPROD")
	For _x := 1 to Len(_aStru)
		If _aStru[_x,2] == "N"
			oExcel:AddColumn("PRODUTOSXPROD","PRODUTOSXPROD",_aStru[_x,1],3,2)
		ElseIf _aStru[_x,2] == "C"
			If "/" $ _aStru[_x,1]
				oExcel:AddColumn("PRODUTOSXPROD","PRODUTOSXPROD",_aStru[_x,1],1,4)
			Else
				oExcel:AddColumn("PRODUTOSXPROD","PRODUTOSXPROD",_aStru[_x,1],1,1)
			EndIf
		EndIf
	Next
	
	While !TMP->(Eof())
		IncProc("Gerando Excel....")
		_aLinha := Array(Len(_aStru))
		For _x := 1 To Len(_aStru)
			_cCpo := Alltrim(_aStru[_x,1])
			_aLinha[_x] := TMP->&(_cCpo)
		Next
		
		oExcel:AddRow("PRODUTOSXPROD","PRODUTOSXPROD",_aLinha)
		TMP->(DbSkip())
	EndDo
	
	
	oExcel:Activate()
	_cFile := (CriaTrab(NIL, .F.) + ".xml")
	While File(_cFile)
		_cFile := (CriaTrab(NIL, .F.) + ".xml")
	EndDo
	oExcel:GetXMLFile(_cFile)
	oExcel:DeActivate()
	If !(File(_cFile))
		_cFile := ""
		TMP->(DbCloseArea())
		Break
	EndIf
	_cFileTMP := (GetTempPath() + _cFile)
	If !(__CopyFile(_cFile , _cFileTMP))
		fErase( _cFile )
		_cFile := ""
		TMP->(DbCloseArea())
		Break
	EndIf
	fErase(_cFile)
	_cFile := _cFileTMP
	If !(File(_cFile))
		_cFile := ""
		TMP->(DbCloseArea())
		Break
	EndIf
	oMsExcel := MsExcel():New()
	oMsExcel:WorkBooks:Open(_cFile)
	oMsExcel:SetVisible(.T.)
	oMsExcel := oMsExcel:Destroy()
	
	FreeObj(oExcel)
	oExcel := NIL
	
EndIf
TMP->(DbCloseArea())



Return Nil           
