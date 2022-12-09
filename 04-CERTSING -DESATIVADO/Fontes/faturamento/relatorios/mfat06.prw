#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �  MFAT06  � Autor � Edgar Serrano      � Data �  28/05/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Demosntrativo de Vendas                                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico CertSign.                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MFat06

Local cDesc1      		:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         	:= "de acordo com os parametros informados pelo usuario."
Local cDesc3         	:= "Demonstrativo de Vendas"
Local cPict          	:= ""
Local titulo       	 	:= "Demonstrativo de Vendas"                  
Local nLin         		:= 80
Local Cabec1       		:= "MES        CANAL         PRODUTO            DESCRICAO                SEGUIMENTO       CLI/LOJA   NOME               QTD     VEND1   NOME1             VEND2     NOME2   NF/ITEM    BPAG    AR                VALOR    EMISSAO "
Local Cabec2			:= ""   
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite          := 220
Private tamanho         := "G"
Private nomeprog        := "MFAT06" 
Private nTipo           := 18
Private aReturn         := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
//Private cbtxt      		:= Space(10)
Private cbcont     		:= 00
Private CONTFL     		:= 01
Private m_pag      		:= 01
Private wnrel      		:= "MFAT06" 
Private cString 		:= ""
Private cPerg			:= "MFAT06"

AjustaSX1()
If !Pergunte(cPerg,.T.)
	Return
Else

	wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
	   Return
	Endif
	
	nTipo := If(aReturn[4]==1,15,18)
	
	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

EndIf
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  28/05/09   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

//Local nOrdem
Local _nI
//dbSelectArea(cString)
//dbSetOrder(1)

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

SetRegua(RecCount())  

cAcuTes := Alltrim(MV_PAR12)
cAcuTes += Alltrim(MV_PAR11)
_aTes		:= StrToArray(Alltrim(cAcuTes),";")
_cTes		:= "("
For _nI := 1 To Len(_aTes)
	_cTes += "'" + _aTes[_nI] + "'"	
	If _nI <> Len(_aTes)
		_cTes += ","
	EndIf                                                     
	
Next _nI
_cTes += ")"

_cQuery := " Select 																									"+Chr(13)+Chr(10)
_cQuery += " SubStr(SD2.D2_EMISSAO,5,2)||'/'||SUBSTR(SD2.D2_EMISSAO,1,4)	As Mes,                                         "+Chr(13)+Chr(10)
_cQuery += " SZ2.Z2_CANAL												As Canal,                                       "+Chr(13)+Chr(10)
_cQuery += " SD2.D2_COD													As Produto,                                     "+Chr(13)+Chr(10)
_cQuery += " SB1.B1_DESC												As Descricao,                                   "+Chr(13)+Chr(10)
_cQuery += " SZ1.Z1_DESCSEG												As Seguimento,                                  "+Chr(13)+Chr(10)
_cQuery += " SD2.D2_CLIENTE												As Cliente,                                 	"+Chr(13)+Chr(10)
_cQuery += " SD2.D2_LOJA												As Loja,                                        "+Chr(13)+Chr(10)
_cQuery += " SA1.A1_NOME												As Nome,                                		"+Chr(13)+Chr(10)
_cQuery += " SD2.D2_QUANT												As Quantidade,                                  "+Chr(13)+Chr(10)
_cQuery += " SC5.C5_VEND1												As Cod_Vend1,                                   "+Chr(13)+Chr(10)
_cQuery += " NVL((SELECT A3_NOME FROM SA3010 WHERE A3_COD = SC5.C5_VEND1 AND D_E_L_E_T_ = ' ' ),'') As Nome1,		"+Chr(13)+Chr(10)
_cQuery += " SF2.F2_VEND2 												As Cod_Vend2,                                   "+Chr(13)+Chr(10)
_cQuery += " NVL((SELECT A3_NOME FROM SA3010 WHERE A3_COD = SF2.F2_VEND2 AND D_E_L_E_T_ = ' ' ),'') As Nome2,		"+Chr(13)+Chr(10)
_cQuery += " SD2.D2_DOC													As Nota_Fiscal,                                 "+Chr(13)+Chr(10)
_cQuery += " SD2.D2_ITEM												As Item_Nota,                                   "+Chr(13)+Chr(10)
_cQuery += " SC5.C5_CHVBPAG												As Numero_BPAG,                                 "+Chr(13)+Chr(10)
_cQuery += " SC5.C5_AR													As Ar,                                          "+Chr(13)+Chr(10)
_cQuery += " CAST (D2_TOTAL AS NUMBER(13,2))             				As Valor,                                       "+Chr(13)+Chr(10)
_cQuery += " SD2.D2_EMISSAO												As Emissao,                                     "+Chr(13)+Chr(10)
_cQuery += " SD2.D2_TES													As TES,											"+Chr(13)+Chr(10)
_cQuery += " NVL((SELECT C6_NROPOR FROM SC6010 SC6 WHERE C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND SC6.C6_NROPOR <> '' AND SC6.D_E_L_E_T_ = ' ' GROUP BY C6_NROPOR ),'' ) AS NUM_OPORTUNIDADE "+Chr(13)+Chr(10)
_cQuery += " From                                                                                                       "+Chr(13)+Chr(10)
_cQuery += RetSQLName("SD2") + " SD2,                                                                                   "+Chr(13)+Chr(10)
_cQuery += RetSQLName("SB1") + " SB1,                                                                                   "+Chr(13)+Chr(10)
_cQuery += RetSQLName("SA1") + " SA1,                                                                                   "+Chr(13)+Chr(10)
_cQuery += RetSQLName("SF2") + " SF2,                                                                                   "+Chr(13)+Chr(10)
_cQuery += RetSQLName("SA3") + " SA3,                                                                                   "+Chr(13)+Chr(10)
_cQuery += RetSQLName("SC5") + " SC5,                                                                                   "+Chr(13)+Chr(10)
_cQuery += RetSQLName("SZ2") + " SZ2,                                                                                   "+Chr(13)+Chr(10)
_cQuery += RetSQLName("SZ1") + " SZ1                                                                                    "+Chr(13)+Chr(10)
_cQuery += " Where                                                                                                      "+Chr(13)+Chr(10)
_cQuery += " SD2.D2_EMISSAO 	>= 	'" + DtoS(mv_par01) + "' 	AND                                                     "+Chr(13)+Chr(10)
_cQuery += " SD2.D2_EMISSAO 	<= 	'" + DtoS(mv_par02) + "' 	AND                                                     "+Chr(13)+Chr(10)
_cQuery += " SD2.D2_COD     	>= 	' " + Alltrim(mv_par03) + " ' AND 													"+Chr(13)+Chr(10)
_cQuery += " SD2.D2_COD  		<= 	' " + Alltrim(mv_par04)+ " ' 	AND                                                     "+Chr(13)+Chr(10)
_cQuery += " SC5.C5_VEND1   	>= 	' " + mv_par05 + " ' 			AND                                                     "+Chr(13)+Chr(10)
_cQuery += " SC5.C5_VEND1 		<= 	' " + mv_par06 + "'  		AND                                                     "+Chr(13)+Chr(10)
_cQuery += " SF2.F2_VEND2    	>= 	'" + mv_par07 + "' 			AND                                                     "+Chr(13)+Chr(10)
_cQuery += " SF2.F2_VEND2  		<= 	'" + mv_par08 + "'			AND                                                     "+Chr(13)+Chr(10)
_cQuery += " SZ2.Z2_CODIGO   	>= 	'" + mv_par09 + "' 			AND                                                     "+Chr(13)+Chr(10)
_cQuery += " SZ2.Z2_CODIGO 		<= 	'" + mv_par10 + "' 			AND                                                     "+Chr(13)+Chr(10)
_cQuery += " SF2.F2_CLIENTE    	>= 	'" + mv_par14 + "' 			AND                                                     "+Chr(13)+Chr(10)
_cQuery += " SF2.F2_CLIENTE		<= 	'" + mv_par15 + "'			AND                                                     "+Chr(13)+Chr(10)
_cQuery += " SD2.D2_TES 		IN 	"+ _cTes + "	 			AND                                                     "+Chr(13)+Chr(10)
_cQuery += " SD2.D2_FILIAL		=	SB1.B1_FILIAL 				AND 					                                "+Chr(13)+Chr(10)	// SB1 -> EXCLUSIVO
_cQuery += " SD2.D2_COD			=	SB1.B1_COD 					AND                                                     "+Chr(13)+Chr(10)
_cQuery += " SD2.D2_CLIENTE 	= 	SA1.A1_COD 					AND 						                            "+Chr(13)+Chr(10) 	// SA1 -> COMPARTILHADO
_cQuery += " SD2.D2_DOC			= 	SF2.F2_DOC 					AND                                                     "+Chr(13)+Chr(10)
_cQuery += " SD2.D2_SERIE 		= 	SF2.F2_SERIE 				AND                                                     "+Chr(13)+Chr(10)
_cQuery += " SF2.F2_VEND1 		= 	SA3.A3_COD 					AND                                                     "+Chr(13)+Chr(10)
_cQuery += " SD2.D2_FILIAL 		= 	'"+xFilial("SD2")+"' 		AND 													"+Chr(13)+Chr(10) 	// SB1 -> EXCLUSIVO                                 
_cQuery += " SC5.C5_FILIAL 		= 	'"+xFilial("SC5")+"'		AND 													"+Chr(13)+Chr(10) 	// SB1 -> EXCLUSIVO
_cQuery += " SD2.D2_PEDIDO 		= 	SC5.C5_NUM 					AND                                                     "+Chr(13)+Chr(10)
_cQuery += " SA3.A3_XCANAL 		= 	SZ2.Z2_CODIGO 				AND                                                     "+Chr(13)+Chr(10)
_cQuery += " SB1.B1_XSEG 		= 	SZ1.Z1_CODSEG 				AND                                                     "+Chr(13)+Chr(10)           
_cQuery += " SD2.D_E_L_E_T_ 	=	' '							AND                                                     "+Chr(13)+Chr(10)
_cQuery += " SB1.D_E_L_E_T_ 	= 	' '							AND                                                     "+Chr(13)+Chr(10)
_cQuery += " SA1.D_E_L_E_T_ 	= 	' '							AND                                                     "+Chr(13)+Chr(10)
_cQuery += " SF2.D_E_L_E_T_ 	= 	' '							AND                                                     "+Chr(13)+Chr(10)
_cQuery += " SA3.D_E_L_E_T_ 	= 	' '							AND                                                     "+Chr(13)+Chr(10)
_cQuery += " SC5.D_E_L_E_T_ 	= 	' '							AND                                                     "+Chr(13)+Chr(10)
_cQuery += " SZ2.D_E_L_E_T_ 	= 	' '							AND                                                     "+Chr(13)+Chr(10)
_cQuery += " SZ1.D_E_L_E_T_ 	= 	' '                                                                                 "+Chr(13)+Chr(10)
_cQuery += " Order By Mes, SD2.D2_DOC, SA3.A3_NOME, SD2.D2_ITEM, Seguimento, Canal 							"

//MemoWrite("c:\MFINR020.txt",_cQuery)
If Select("TRC") > 0
	TRC->(DbCloseArea())
EndIf
dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), "TRC", .F., .T.)
//TCSetField("TRC","Emissao"	,"D")


_cDataBase 	:= dDataBase 
_cTime 		:= Time()
_aCabec 	:= {}
_aDados		:= {}


//AAdd(_aDados, {"Data de Emiss�o: ",_cDataBase,,"Horario:",_cTime})		
//AAdd(_aDados, {})
AAdd(_aDados, {"MES","CANAL","PRODUTO","DESCRICAO","SEGUIMENTO","CLI/LOJA","NOME","QTD","VEND1","NOME VEND1", "VEND2", "NOME VEND2","NF/ITEM","BPAG","AR","VALOR","EMISSAO","TES","Numero_Oportunidade"})
AAdd(_aDados, {})

DbSelectArea("TRC") 
TRC->(dbGoTop())
While !TRC->(Eof())

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif
 
   //"MES       CANAL         PRODUTO            DESCRICAO                SEGUIMENTO       CLI/LOJA   NOME               QTD     VEND    NOME             VEND2     NF/ITEM    BPAG    AR            VALOR        EMISSAO "
   
   //"MES        CANAL         PRODUTO            DESCRICAO                SEGUIMENTO       CLI/LOJA   NOME               QTD     VEND1   NOME1             VEND2     NOME2   NF/ITEM    BPAG    AR                VALOR    EMISSAO "

   // 1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123
   //          10        20        30        40       50         60        70        80       90        100        110       120      130        140       150       160       170       180       190       200       210       220
   
   @ nLin, 000 PSAY TRC->Mes
   @ nLin, 011 PSAY SubStr(TRC->Canal, 1, 12)
   @ nLin, 025 PSAY TRC->Produto
   @ nLin, 044 PSAY SubStr(TRC->Descricao, 1, 24)
   @ nLin, 069 PSAY SubStr(TRC->Seguimento, 1, 16)            
   @ nLin, 087 PSAY TRC->Cliente + "/" + TRC->Loja
   @ nLin, 098 PSAY SubStr(TRC->Nome, 1, 18)
   @ nLin, 119 PSAY Alltrim(Str(TRC->Quantidade))
   @ nLin, 125 PSAY TRC->Cod_Vend1
   //@ nLin, 133 PSAY Posicione("SA3", 1, xFilial("SA3") + TRC->Cod_Vend1, "A3_NOME")
   @ nLin, 133 PSAY TRC->Nome1
   @ nLin, 151 PSAY TRC->Cod_Vend2
   @ nLin, 161 PSAY TRC->Nome2
   @ nLin, 169 PSAY Alltrim(TRC->Nota_Fiscal) + "/" + Alltrim(TRC->Item_Nota)
   @ nLin, 180 PSAY TRC->Numero_BPAG
   @ nLin, 188 PSAY TRC->Ar               
   @ nLin, 200 PSAY Transform(TRC->Valor,  '@E 999,999,999.99')    
   //@ nLin, 215 PSAY DtoC(TRC->Emissao)
   @ nLin, 215 PSAY STOD(TRC->Emissao)
                                     
	AAdd(_aDados, 	{TRC->Mes,TRC->Canal,TRC->Produto,TRC->Descricao,TRC->Seguimento,TRC->Cliente + "/" + TRC->Loja,TRC->Nome,TRC->Quantidade,;
					TRC->Cod_Vend1,TRC->Nome1,TRC->Cod_Vend2,TRC->Nome2,Alltrim(TRC->Nota_Fiscal) + "/" + Alltrim(TRC->Item_Nota),TRC->Numero_BPAG,;
					TRC->Ar,Transform(TRC->Valor,  '@E 999,999,999.99'), STOD(TRC->Emissao),TES, TRC->NUM_OPORTUNIDADE})   

   nLin++

   TRC->(dbSkip()) 
EndDo

If mv_par13 == 1
	DlgToExcel({{"ARRAY","Demosntrativo de Vendas", _aCabec, _aDados}}) 
EndIf
                                                                     
SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������-���
���Fun��o    � AjustaSX1    �Autor �  Edgar Serrano       �    28.05.2009 ���
�������������������������������������������������������������������������-���
���Descri��o � Ajusta perguntas do SX1                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AjustaSX1()
Local aArea := GetArea()

PutSx1(cPerg,"01","Emissao De         ","Emissao De         ","Emissao De         ","mv_ch1","D",08,00,01,"G","","   ","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Data Inicial a ser considerada"})
PutSx1(cPerg,"02","Emissao Ate        ","Emissao Ate        ","Emissao Ate        ","mv_ch2","D",08,00,01,"G","","   ","","","mv_par02"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Data Final a ser considerada"})
PutSx1(cPerg,"03","Produto De         ","Produto De         ","Produto De         ","mv_ch3","C",15,00,01,"G","","SB1","","","mv_par03"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Produto inicial a ser considerado"})
PutSx1(cPerg,"04","Produto Ate        ","Produto Ate        ","Produto Ate        ","mv_ch4","C",15,00,01,"G","","SB1","","","mv_par04"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Produto final a ser considerado"})
PutSx1(cPerg,"05","Vendedor De        ","Vendedor De        ","Vendedor De        ","mv_ch5","C",06,00,01,"G","","SA3","","","mv_par05"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Vendedor inicial a ser considerado"})
PutSx1(cPerg,"06","Vendedor De        ","Veadedor Ate       ","Vendedor Ate       ","mv_ch6","C",06,00,01,"G","","SA3","","","mv_par06"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Vendedor final a ser considerado"})
PutSx1(cPerg,"07","Canal De           ","Canal De           ","Canal De           ","mv_ch7","C",06,00,01,"G","","SZ2","","","mv_par07"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Canal inicial a ser considerado"})
PutSx1(cPerg,"08","Canal Ate          ","Canal Ate          ","Canal Ate          ","mv_ch8","C",06,00,01,"G","","SZ2","","","mv_par08"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Canal final a ser considerado"})
PutSx1(cPerg,"09","TES                ","TES                ","TES                ","mv_ch9","C",30,00,01,"G","","   ","","","mv_par09"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Exemplo: 501;502;503"}) 
PutSx1(cPerg,"10","Excel			  ","Excel              ","Excel              ","mv_chA","N",01,00,01,"C","",""   ,"","","mv_par10","Sim","Sim","Sim","","Nao","Nao","Nao","","","","","","","","","","","","","",{"Criar arquivo Exce"})

RestArea(aArea)
Return   