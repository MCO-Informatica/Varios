#INCLUDE 'Protheus.ch'
#INCLUDE 'TOPCONN.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �TTD2 �Autor  �DenisVarella          � Data �  23/03/17   ���
�������������������������������������������������������������������������͹��
���Desc.     �Geracao de relat�rio NF de Sa�da           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function NBFIS001()

Local cPerg		:= PadR("NBFIS001",10)           

AjustaSx1(cPerg)
If Pergunte(cPerg,.T.)

	Processa( {|| Plan02() },"Aguarde" ,"Processando...")

EndIf

Return() 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AjustaSX1 �Autor  �                    � Data �             ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function AjustaSX1(cPerg)

Local aRea	:= GetArea()
Local aSx1	:= {} 
local i:=0

DBSelectArea("SX1")
SX1->(DBSetOrder(1))
cPerg := PadR(cPerg, Len(SX1->X1_GRUPO))
SX1->(DBSeek(cPerg+"01"))       
AADD(	aSx1,{ cPerg,"01","Data Emiss�o De?"			,"mv_par01"	,"D",8,0,0, "G","", 	"mv_par01","","","","","","" } )
AADD(	aSx1,{ cPerg,"02","Data Emiss�o At�?"			,"mv_par02"	,"D",8,0,0, "G","",		"mv_par02","","","","","","" } )
AADD(	aSx1,{ cPerg,"03","Fornec/Cliente De?"			,"mv_par03"	,"C",6,0,0, "G","",		"mv_par03","","","","","SA1","" } )
AADD(	aSx1,{ cPerg,"04","Fornec/Cliente At�?"			,"mv_par04"	,"C",6,0,0, "G","",		"mv_par04","","","","","SA1","" } )
AADD(	aSx1,{ cPerg,"07","Produto De?"					,"mv_par05"	,"C",15,0,0, "G","",	"mv_par05","","","","","SB1","" } )
AADD(	aSx1,{ cPerg,"08","Produto At�?"				,"mv_par06"	,"C",15,0,0, "G","",	"mv_par06","","","","","SB1","" } )

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
			SX1->X1_PRESEL		:= aSx1[i][8] //Pre sele��o do combo
			SX1->X1_GSC			:= aSx1[i][9] //Tipo de componente
			SX1->X1_VAR01		:= aSx1[i][10]//Variavel que carrega resposta
			SX1->X1_DEF01		:= aSx1[i][11]//Defini��es do combo-box
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

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � Plan02()       � Autor � AF Custom       � Data � 27/11/13 ���
�������������������������������������������������������������������������Ĵ��
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function Plan02()
Local _cPathExcel:="C:\TEMP\"
Local  _cPath 	  := AllTrim(GetTempPath())
Local  _cArquivo  := CriaTrab(,.F.)
Local oExcel := Fwmsexcel():new() 
Local oFWMsExcel
Local cURLXML:= ''
Local cQuery:=""

Private _nHandle  := FCreate(_cArquivo)

cQuery := "SELECT  " + Chr(13)
cQuery += " SUBSTRING(D2_EMISSAO,7,2) + '/' + SUBSTRING(D2_EMISSAO,5,2) + '/' + SUBSTRING(D2_EMISSAO,1,4) as DT_EMISSAO , " +  Chr(13)
cQuery += "D2_DOC NOTA,  " + Chr(13)
cQuery += "D2_TIPO TIPO, " + Chr(13)
cQuery += "D2_CLIENTE COD_CLI, " + Chr(13)
cQuery += "D2_LOJA LJ_CLI, " + Chr(13)
cQuery += "CASE WHEN D2_TIPO <> 'B' AND D2_TIPO <> 'D'  " + Chr(13)
cQuery += "THEN (SELECT A1_NOME FROM  SA1010  WHERE D_E_L_E_T_ <> '*' AND A1_COD = SD2.D2_CLIENTE AND A1_LOJA = SD2.D2_LOJA) " + Chr(13) 
cQuery += "ELSE (SELECT A2_NOME FROM SA2010 WHERE D_E_L_E_T_ <> '*' AND A2_COD = SD2.D2_CLIENTE AND A2_LOJA = SD2.D2_LOJA) END FORN_CLI,  " + Chr(13)
cQuery += "CASE WHEN D2_TIPO <> 'B' AND D2_TIPO <> 'D'  " + Chr(13)
cQuery += "THEN (SELECT A1_NREDUZ FROM  SA1010  WHERE D_E_L_E_T_ <> '*' AND A1_COD = SD2.D2_CLIENTE AND A1_LOJA = SD2.D2_LOJA) " + Chr(13) 
cQuery += "ELSE (SELECT A2_NREDUZ FROM SA2010 WHERE D_E_L_E_T_ <> '*' AND A2_COD = SD2.D2_CLIENTE AND A2_LOJA = SD2.D2_LOJA) END FANTASIA,  " + Chr(13)
cQuery += "CASE WHEN D2_TIPO <> 'B' AND D2_TIPO <> 'D'  " + Chr(13)
cQuery += "THEN (SELECT A1_CGC FROM  SA1010  WHERE D_E_L_E_T_ <> '*' AND A1_COD = SD2.D2_CLIENTE AND A1_LOJA = SD2.D2_LOJA) " + Chr(13) 
cQuery += "ELSE (SELECT A2_CGC FROM SA2010 WHERE D_E_L_E_T_ <> '*' AND A2_COD = SD2.D2_CLIENTE AND A2_LOJA = SD2.D2_LOJA) END CNPJ,  " + Chr(13)
cQuery += "F2_EST ESTADO, " + Chr(13)
cQuery += "A4_COD COD_TRAN, " + Chr(13)
cQuery += "A4_NREDUZ TRANSPOR, " + Chr(13)
cQuery += "D2_COD COD_PROD, " + Chr(13)
cQuery += "B1_DESC PRODUTO, " + Chr(13) 
cQuery += "B1_TIPO TP_PROD, " + Chr(13) 
cQuery += "B1_POSIPI NCM, " + Chr(13)
cQuery += "D2_LOCAL ALMOX, " + Chr(13) 
cQuery += "D2_QUANT QUANT, " + Chr(13)
cQuery += "D2_PRCVEN VLR_UNIT, " + Chr(13)
cQuery += "D2_TOTAL TOTAL, " + Chr(13)
cQuery += "D2_TES TES, " + Chr(13)
cQuery += "D2_CF CFOP, " + Chr(13) 
cQuery += "F4_ESTOQUE ESTOQUE, " + Chr(13) 
cQuery += "D2_IDENTB6 P_TERCE, " + Chr(13) 
cQuery += "F4_DUPLIC DUPLIC, " + Chr(13)
cQuery += "F2_COND CPAG, " + Chr(13)
cQuery += "F2_VEND1 VENDEDOR, " + Chr(13) 
cQuery += "D2_VALFRE VLRFRETE, " + Chr(13) 
cQuery += "D2_DESPESA VLRDESP, " + Chr(13) 
cQuery += "D2_SEGURO VLR_SEG, " + Chr(13)
cQuery += "D2_DESCON VLRDESC,  " + Chr(13)
cQuery += "D2_CUSTO1 CUSTO,  " + Chr(13)
cQuery += "D2_CLASFIS CLA_FISC,  " + Chr(13)
cQuery += "D2_PICM ALIQICMS,  " + Chr(13)
cQuery += "D2_VALICM VLRICMS,  " + Chr(13)
cQuery += "D2_ICMSCOM ICMS_COMP, " + Chr(13)
cQuery += "F4_CREDICM APUR_ICMS,  " + Chr(13)
cQuery += "D2_IPI ALIQIPI,    " + Chr(13)
cQuery += "D2_VALIPI VLRIPI,       " + Chr(13)
cQuery += "F4_CREDIPI APUR_IPI, " + Chr(13)
cQuery += "F4_CTIPI CST_IPI, " + Chr(13)
cQuery += "F4_CSTPIS CST_PIS, " + Chr(13)
cQuery += "F4_CSTCOF CST_COF,  " + Chr(13)
cQuery += "D2_BASIMP5 BAS_COF,  " + Chr(13)
cQuery += "D2_ALQIMP5 ALQ_COF, " + Chr(13)
cQuery += "D2_VALIMP5 VLR_COF,  " + Chr(13)
cQuery += "D2_BASIMP6 BAS_PIS,  " + Chr(13)
cQuery += "D2_ALQIMP6 ALQ_PIS,  " + Chr(13)
cQuery += "D2_VALIMP6 VLR_PIS,  " + Chr(13)
cQuery += "D2_VALISS VLR_ISS,  " + Chr(13)
cQuery += "F2_VALISS REC_ISS,  " + Chr(13)
cQuery += "D2_VALIRRF VLR_IR,  " + Chr(13)
cQuery += "D2_VALINS VLR_INSS, " + Chr(13)
cQuery += "D2_SERIORI SER_ORIG,  " + Chr(13)
cQuery += "D2_NFORI NF_ORIG,  " + Chr(13)
cQuery += "D2_ITEMORI IT_ORIG, " + Chr(13)
cQuery += "D2_LOTECTL LOTE, " + Chr(13)
cQuery += "A3_NOME NOMEVEND, " + Chr(13)
cQuery += " SUBSTRING(D2_DTVALID,7,2) + '/' + SUBSTRING(D2_DTVALID,5,2) + '/' + SUBSTRING(D2_DTVALID,1,4) as DT_VALID, " +  Chr(13)
cQuery += "F2_CHVNFE CHAVE_NFE " + Chr(13)
cQuery += "FROM SD2010 SD2 " + Chr(13) 
cQuery += "LEFT JOIN SA1010 SA1 ON  " + Chr(13)
cQuery += "SA1.D_E_L_E_T_ <> '*' AND SD2.D2_CLIENTE = SA1.A1_COD AND SD2.D2_LOJA = SA1.A1_LOJA " + Chr(13)
cQuery += "LEFT JOIN SA2010 SA2 ON  " + Chr(13)
cQuery += "SA2.D_E_L_E_T_ <> '*' AND SD2.D2_CLIENTE = SA2.A2_COD AND SD2.D2_LOJA = SA2.A2_LOJA " + Chr(13)  
cQuery += "INNER JOIN SB1010 SB1 ON  " + Chr(13)
cQuery += "SB1.D_E_L_E_T_ <> '*' AND SD2.D2_COD = SB1.B1_COD " + Chr(13) 
//cQuery += "INNER JOIN SA4010 SA4 ON " + Chr(13)
//cQuery += "SA4.D_E_L_E_T_ <> '*' AND SA4.A4_COD = SD2.D2_COD " + Char(13)
cQuery += "INNER JOIN SF4010 SF4 ON  " + Chr(13)
cQuery += "SD2.D2_TES = SF4.F4_CODIGO  " + Chr(13)
cQuery += "AND SF4.D_E_L_E_T_ <> '*' " + Chr(13)
cQuery += "INNER JOIN SF2010 SF2 ON  " + Chr(13)
cQuery += "SF2.F2_SERIE = SD2.D2_SERIE AND  " + Chr(13)
cQuery += "SF2.F2_DOC = SD2.D2_DOC AND " + Chr(13)
cQuery += "SF2.F2_CLIENTE = SD2.D2_CLIENTE AND " + Chr(13)
cQuery += "SF2.D_E_L_E_T_ <> '*' " + Chr(13)
cQuery += "LEFT JOIN SA3010 SA3 ON  " + Chr(13)
cQuery += "SA3.A3_COD = SF2.F2_VEND1 AND " + Chr(13)
cQuery += "SA3.D_E_L_E_T_ <> '*' " + Chr(13)
cQuery += "LEFT JOIN SA4010 SA4 ON " + Chr(13)
cQuery += "SA4.A4_COD = SF2.F2_TRANSP AND " + Chr(13)   
cQuery += "SA4.D_E_L_E_T_ <> '*' " + Chr(13)
cQuery += "WHERE SD2.D_E_L_E_T_ <> '*' AND  " + Chr(13)
cQuery += "SD2.D2_EMISSAO BETWEEN '" + dTOS(mv_par01) + "' AND '" + DTos(mv_par02) + "' AND " + Chr(13)
cQuery += "SD2.D2_CLIENTE BETWEEN'" + mv_par03 + "' AND '" + mv_par04 + "' AND " + Chr(13)
cQuery += "SD2.D2_COD BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' " + Chr(13)
cQuery += "ORDER BY SD2.D2_EMISSAO " + Chr(13)

memowrite("NFSAIDAS",cQuery)

TcQuery cQuery New Alias (cAliasD2:=GetNextAlias())

If (cAliasD2)->(!Eof())
	_lRet := .T.
EndIf


oExcel:AddworkSheet("PAR�METROS")
oExcel:AddTable("PAR�METROS","PAR�METROS")
oExcel:AddColumn("PAR�METROS","PAR�METROS","PARAMETROS",1,1)
oExcel:AddColumn("PAR�METROS","PAR�METROS","VALOR",1,1)

oExcel:AddRow("PAR�METROS","PAR�METROS",{'Data Digita��o De',;
DTOC(mv_par01)})

oExcel:AddRow("PAR�METROS","PAR�METROS",{'Data Digita��o At�',;
DTOC(mv_par02)})

oExcel:AddRow("PAR�METROS","PAR�METROS",{'Fornec/Cliente De',;
mv_par03})

oExcel:AddRow("PAR�METROS","PAR�METROS",{'Fornec/Cliente At�',;
mv_par04})

oExcel:AddRow("PAR�METROS","PAR�METROS",{'Produto De',;
mv_par05})

oExcel:AddRow("PAR�METROS","PAR�METROS",{'Produto At�',;
mv_par06})

oExcel:AddworkSheet("RELAT�RIO")
oExcel:AddTable("RELAT�RIO","NF SA�DA")
oExcel:AddColumn("RELAT�RIO","NF SA�DA","DATA EMISS�O",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","NOTA",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","TIPO",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","C�D. CLIENTE",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","LI CLIENTE",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","FORN CLIENTE",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","NOME FANTASIA",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","CNPJ",1,1) 
oExcel:AddColumn("RELAT�RIO","NF SA�DA","ESTADO",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","COD_TRAN",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","TRANSPOR",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","C�D. PRODUTO",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","PRODUTO",1,1)    
oExcel:AddColumn("RELAT�RIO","NF SA�DA","TP_PROD",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","NCM",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","ALMOX",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","QUANT",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","VLR_UNIT",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","TOTAL",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","TES",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","CFOP",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","ESTOQUE",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","P TERCEIROS",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","DUPLIC",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","CPAG",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","COD. VENDEDOR",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","NOME VENDEDOR",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","VLR FRETE",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","VLR DESPESA",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","VLR SEGURO",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","VLR DESCONTO",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","CUSTO",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","CLA FIS",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","ALIQ ICMS",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","VLR ICMS",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","ICMS COMP",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","APUR ICMS",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","ALIQ IPI",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","VLR IPI",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","APUR IPI",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","CST IPI",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","CST PIS",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","CST COF",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","BASE COFINS",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","ALIQ COFINS",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","VLR COFINS",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","BASE PIS",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","ALIQ PIS",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","VLR PIS",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","VLR ISS",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","REC ISS",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","VLR IR",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","VLR INSS",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","SER ORIGEM",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","NF ORIGEM",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","IT ORIGEM",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","LOTE",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","DT VALID",1,1)
oExcel:AddColumn("RELAT�RIO","NF SA�DA","CHAVE_NFE",1,1)

(cAliasD2)->(DbGotOP())

While !(cAliasD2)->(EOF())

oExcel:AddRow("RELAT�RIO","NF SA�DA",{(cAliasD2)->DT_EMISSAO,;
(cAliasD2)->NOTA,;
(cAliasD2)->TIPO,;
(cAliasD2)->COD_CLI,;
(cAliasD2)->LJ_CLI,;
(cAliasD2)->FORN_CLI,;
(cAliasD2)->FANTASIA,;
(cAliasD2)->CNPJ,;
(cAliasD2)->ESTADO,;
(cAliasD2)->COD_TRAN,;
(cAliasD2)->TRANSPOR,;
(cAliasD2)->COD_PROD,;
(cAliasD2)->PRODUTO,;
(cAliasD2)->TP_PROD,;
(cAliasD2)->NCM,;
(cAliasD2)->ALMOX,;
(cAliasD2)->QUANT,;
(cAliasD2)->VLR_UNIT,;
(cAliasD2)->TOTAL,;
(cAliasD2)->TES,;
(cAliasD2)->CFOP,;
(cAliasD2)->ESTOQUE,;
(cAliasD2)->P_TERCE,;
(cAliasD2)->DUPLIC,;
(cAliasD2)->CPAG,;
(cAliasD2)->VENDEDOR,;
(cAliasD2)->NOMEVEND,;
(cAliasD2)->VLRFRETE,;
(cAliasD2)->VLRDESP,;
(cAliasD2)->VLR_SEG,;
(cAliasD2)->VLRDESC,;
(cAliasD2)->CUSTO,;
(cAliasD2)->CLA_FISC,;
(cAliasD2)->ALIQICMS,;
(cAliasD2)->VLRICMS,;
(cAliasD2)->ICMS_COMP,;
(cAliasD2)->APUR_ICMS,;
(cAliasD2)->ALIQIPI,;
(cAliasD2)->VLRIPI,;
(cAliasD2)->APUR_IPI,;
(cAliasD2)->CST_IPI,;
(cAliasD2)->CST_PIS,;
(cAliasD2)->CST_COF,;
(cAliasD2)->BAS_COF,;
(cAliasD2)->ALQ_COF,;
(cAliasD2)->VLR_COF,;
(cAliasD2)->BAS_PIS,;
(cAliasD2)->ALQ_PIS,;
(cAliasD2)->VLR_PIS,;
(cAliasD2)->VLR_ISS,;
(cAliasD2)->REC_ISS,;
(cAliasD2)->VLR_IR,;
(cAliasD2)->VLR_INSS,;
(cAliasD2)->SER_ORIG,;
(cAliasD2)->NF_ORIG,;
(cAliasD2)->IT_ORIG,;
(cAliasD2)->LOTE,;
(cAliasD2)->DT_VALID,;
(cAliasD2)->CHAVE_NFE})


(cAliasD2)->(DbSKip())
Enddo


oExcel:Activate()
oExcel:GetXMLFile(_cArquivo+".xml")

__CopyFile(_cArquivo+".xml",_cPathExcel+_cArquivo+".xml")

	If ! ApOleClient( 'MsExcel' )
		MsgAlert( 'MsExcel nao instalado' )
	Else
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( _cPathExcel+_cArquivo+".xml") // Abre uma planilha
		oExcelApp:SetVisible(.T.)
	EndIf

Return

Plan02()