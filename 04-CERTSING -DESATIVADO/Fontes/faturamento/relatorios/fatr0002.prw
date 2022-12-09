#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �  FATR0002� Autor � Douglas Mello      � Data �  14/09/2010 ���
�������������������������������������������������������������������������͹��
���Descricao � Relatorio de Vendas por Vendedor com segundo vendedor      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico CertSign                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FATR0002()

Local cDesc1      		:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         	:= "de acordo com os parametros informados pelo usuario."
Local cDesc3         	:= "Demonstrativo de Vendas"
Local cPict          	:= ""
Local titulo       	 	:= "Vendas por Vendedor"                  
Local nLin         		:= 80
                         // 1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123
                         //          10        20        30        40       50         60        70        80       90        100        110       120      130        140       150       160       170       180       190       200       210       220
Local Cabec1       		:= " VENDEDOR_1	                                VENDEDOR_2	                                 F2_CLIENTE	                                                 QUANTIDADE	   TOTAL_VENDA"
Local Cabec2			:= ""   
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite          := 220
Private tamanho         := "G"
Private nomeprog        := "FATR0002" 
Private nTipo           := 18
Private aReturn         := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      		:= Space(10)
Private cbcont     		:= 00
Private CONTFL     		:= 01
Private m_pag      		:= 01
Private wnrel      		:= "FATR0002" 
Private cString 		:= ""
Private cPerg			:= "FATR02"

AjustaSX1()
If !Pergunte(cPerg,.T.)
	Return
Else

	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
	
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
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  16/12/2009 ���
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

Local nOrdem
Local cVend1	:= 	""
Local cVend2	:= 	""  
Local vPrimeira := 	1
Local vQtdeSub	:=	0
Local vQtdeTot	:=	0
Local vSubTot	:=	0
Local vTotal	:=	0
Private _aDados	:= 	{}                     
Private _aCabec := 	{}

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

SetRegua(RecCount())  

//���������������������������������������������������������������������Ŀ
//� Montando tabela temporaria										    �
//�����������������������������������������������������������������������

_cQuery := "SELECT "																					+Chr(13)+Chr(10)
_cQuery += " (SELECT A3_NOME FROM SA3010 WHERE A3_COD = SC5.C5_VEND1) AS VENDEDOR_1,"					+Chr(13)+Chr(10)
_cQuery += " NVL((SELECT A3_NOME FROM SA3010 WHERE A3_COD = SC5.C5_VEND2),'') AS VENDEDOR_2,"		+Chr(13)+Chr(10)
_cQuery += " (SELECT A1_NOME FROM SA1010 SA1 WHERE SA1.A1_COD = SF2.F2_CLIENTE AND SA1.A1_LOJA = SF2.F2_LOJA) AS F2_CLIENTE,"+Chr(13)+Chr(10)
_cQuery += " SUM(SD2.D2_QUANT) AS QUANTIDADE,"															+Chr(13)+Chr(10)
_cQuery += " SUM(SF2.F2_VALBRUT) AS TOTAL_VENDA "														+Chr(13)+Chr(10)
_cQuery += " FROM "																						+Chr(13)+Chr(10)
_cQuery += " SA3010 SA3 INNER JOIN (SC5010 SC5 INNER JOIN (SF2010 SF2 INNER JOIN SD2010 SD2 ON SF2.F2_DOC = SD2.D2_DOC AND SD2.D2_FILIAL = SF2.F2_FILIAL) ON SC5.C5_NOTA = SF2.F2_DOC AND SC5.C5_FILIAL = '"+xFilial("SC5")+"' AND SF2.F2_FILIAL = '"+xFilial("SF2")+"') ON SA3.A3_COD = SC5.C5_VEND1"+Chr(13)+Chr(10)
_cQuery += " WHERE"																						+Chr(13)+Chr(10)
_cQuery += " SF2.F2_EMISSAO 	>= '"+ DtoS(mv_par01) +"'"												+Chr(13)+Chr(10)
_cQuery += " AND SF2.F2_EMISSAO <= '"+ DtoS(mv_par02) +"'"												+Chr(13)+Chr(10)
_cQuery += " AND SC5.C5_VEND1 	>= '" + Alltrim(mv_par03) + "'"											+Chr(13)+Chr(10)
_cQuery += " AND SC5.C5_VEND1 	<= '" + Alltrim(mv_par04) + "'"											+Chr(13)+Chr(10)
_cQuery += " AND SC5.C5_VEND2 	>= '" + Alltrim(mv_par05) + "'"											+Chr(13)+Chr(10)
_cQuery += " AND SC5.C5_VEND2 	<= '" + Alltrim(mv_par06) + "'"											+Chr(13)+Chr(10)
_cQuery += " AND SA3.A3_XCANAL IN ('000001','000003')"	+Chr(13)+Chr(10) // Solicitado pelo Jos� Roberto Garcia colocar somente esses codigos
_cQuery += " AND SC5.D_E_L_E_T_ = ' '"																	+Chr(13)+Chr(10)
_cQuery += " AND SF2.D_E_L_E_T_ = ' '"																	+Chr(13)+Chr(10)
_cQuery += " AND SD2.D_E_L_E_T_ = ' '"																	+Chr(13)+Chr(10)
_cQuery += " AND SA3.D_E_L_E_T_ = ' '"																	+Chr(13)+Chr(10)
_cQuery += " GROUP BY SC5.C5_VEND1,SC5.C5_VEND2,F2_CLIENTE,SF2.F2_LOJA"									+Chr(13)+Chr(10)
_cQuery += " ORDER BY VENDEDOR_1,VENDEDOR_2"															+Chr(13)+Chr(10)

If Select("TRC") > 0
	TRC->(DbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), "TRC", .F., .T.)

//���������������������������������������������������������������������Ŀ
//� Montando Itens do cabe�alho										    �
//�����������������������������������������������������������������������
                                               
@ nLin,002 psay	"Periodo do Faturamento"
nLin++
@ nLin,002 psay	mv_par01
@ nLin,012 psay	"a"
@ nLin,014 psay	mv_par02
nLin++


//���������������������������������������������������������������������Ŀ
//� Montando array para exportar para Excel							    �
//�����������������������������������������������������������������������

AAdd(_aDados, {"Perido Faturamento",MV_PAR01," a ",MV_PAR02,""})
AAdd(_aDados, {"VENDEDOR 1","VENDEDOR 2","CLIENTE","QUANTIDADE","TOTAL VENDA"})
AAdd(_aDados, {})

DbSelectArea("TRC") 
TRC->(dbGoTop())

While !TRC->(Eof())

	If lAbortPrint
    	@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      	Exit
   	Endif
                          
    //���������������������������������������������������������������������Ŀ
	//� Impressao do cabecalho do relatorio. . .                            �
	//�����������������������������������������������������������������������
	If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
    If vPrimeira <> 1
    	If cVend2 <> TRC->VENDEDOR_2
				//@ nLin,020 psay	"Sub Total"
				@ nLin,150 psay Transform(vQtdeSub,'@E 999,999,999.99')
				@ nLin,166 psay Transform(vSubTot,'@E 999,999,999.99')
				AAdd(_aDados, {"","","Sub Total",vQtdeSub,vSubTot})
				vQtdeSub	:=	0
				vSubTot		:=	0
				If cVend1 <> TRC->VENDEDOR_1
					//@ nLin,020 psay	"Total Geral"
					@ nLin,150 psay Transform(vQtdeTot,'@E 999,999,999.99')
					@ nLin,166 psay Transform(vTotal,'@E 999,999,999.99')
					AAdd(_aDados, {"","","Total Geral",vQtdeTot,vTotal})
					vQtdeTot	:=	0                                   
					vTotal		:=	0
				EndIf
		Else
			If cVend1 <> TRC->VENDEDOR_1
				//@ nLin,020 psay	"Total Geral"
				@ nLin,150 psay Transform(vQtdeTot,'@E 999,999,999.99')
				@ nLin,166 psay Transform(vTotal,'@E 999,999,999.99')
				AAdd(_aDados, {"","","Total Geral",vQtdeTot,vTotal})
				vQtdeTot	:=	0
				vTotal		:=	0
			EndIf
		EndIf
		
	EndIf
	
	@ nLin,002 psay TRC->VENDEDOR_1
	@ nLin,045 psay TRC->VENDEDOR_2
	@ nLin,090 psay TRC->F2_CLIENTE
	@ nLin,150 psay TRC->QUANTIDADE
	@ nLin,166 psay Transform(TRC->TOTAL_VENDA,'@E 999,999,999.99')
	
	AAdd(_aDados,	{TRC->VENDEDOR_1,;
					TRC->VENDEDOR_2,;
				 	TRC->F2_CLIENTE,;
				 	TRC->QUANTIDADE,;
				 	Transform(TRC->TOTAL_VENDA,'@E 999,999,999.99')})
	
	cVend1	:=	TRC->VENDEDOR_1
	cVend2	:=	TRC->VENDEDOR_2
	vQtdeSub+=	TRC->QUANTIDADE
	vQtdeTot+=	TRC->QUANTIDADE
	vSubTot +=	TRC->TOTAL_VENDA
	vTotal	+=	TRC->TOTAL_VENDA
	vPrimeira	+= 1
	nLin++
	TRC->(dbSkip())

EndDo

@ nLin,166 psay Transform(vSubTot,'@E 999,999,999.99')
nLin++
@ nLin,166 psay Transform(vTotal,'@E 999,999,999.99')
                                                                      

AAdd(_aDados, {"","","Sub Total",vQtdeSub,vSubTot})
AAdd(_aDados, {"","","Total Geral",vQtdeTot,vTotal})

//���������������������������������������������������������������������Ŀ
//� Gerando Excel													    �
//�����������������������������������������������������������������������

If mv_par07 == 1
	DlgToExcel({ {"ARRAY","Vendas por Vendedor", _aCabec, _aDados} }) 
EndIf

//Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
                                                                     
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
���Fun��o    � AjustaSX1    �Autor �  Douglas Mello		�    16/12/2009   ���
�������������������������������������������������������������������������-���
���Descri��o � Ajusta perguntas do SX1                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function AjustaSX1()

Local aArea := GetArea()

PutSx1(cPerg,"01","Data Faturamento De","Data Faturamento De","Data Faturamento De","mv_ch1","D",08,00,01,"G","","   ","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Data Inicial a ser considerada"})
PutSx1(cPerg,"02","Data Faturamento Ate","Data Faturamento Ate","Data Faturamento Ate","mv_ch2","D",08,00,01,"G","","   ","","","mv_par02"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Data Final a ser considerada"})
PutSx1(cPerg,"03","Vendedor 1 De       ","Vendedor 1 De       ","Vendedor 1 De       ","mv_ch3","C",06,00,01,"G","","SA3","","","mv_par03"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Vendedor inicial a ser considerado"})
PutSx1(cPerg,"04","Vendedor 1 Ate      ","Veadedor 1 Ate      ","Vendedor 1 Ate      ","mv_ch4","C",06,00,01,"G","","SA3","","","mv_par04"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Vendedor final a ser considerado"})
PutSx1(cPerg,"05","Vendedor 2 De       ","Vendedor 2 De       ","Vendedor 2 De       ","mv_ch5","C",06,00,01,"G","","SA3","","","mv_par05"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Vendedor inicial a ser considerado"})
PutSx1(cPerg,"06","Vendedor 2 Ate      ","Veadedor 2 Ate      ","Vendedor 2 Ate      ","mv_ch6","C",06,00,01,"G","","SA3","","","mv_par06"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Vendedor final a ser considerado"})
PutSx1(cPerg,"07","Gera Excel?	 	   ","Gera Excel?	 	  ","Gera Excel?	 	 ","mv_ch7","N",01,00,01,"C","",""   ,"","","mv_par07","Sim","Sim","Sim","","Nao","Nao","Nao","","","","","","","","","","","","","",{"Cria arquivo Excel"})

RestArea(aArea)

Return   


