#INCLUDE "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CFINA02  �Autor  � Raphael Nascimento � Data �  28/01/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gera��o de Dados Excel - SE1 / Dados para Controle do      ���
���          � Financeiro                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � AP7 - Espec�fico CertiSign                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION RFIN001()

Local cDesc1      		:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         	:= "de acordo com os parametros informados pelo usuario."
Local cDesc3         	:= "Relatorio de Comissoes"
Local cPict          	:= ""
Local titulo       	 	:= "Relatorio de Comissoes"                  
Local nLin         		:= 80
Local Cabec1       		:= ""
Local Cabec2			:= ""   
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite          := 220
Private tamanho         := "G"
Private nomeprog        := "RFIN001" 
Private nTipo           := 18
Private aReturn         := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      		:= Space(10)
Private cbcont     		:= 00
Private CONTFL     		:= 01
Private m_pag      		:= 01
Private wnrel      		:= "RFIN001" 
Private cString 		:= ""
Private cPerg			:= "CFIN02"

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

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

SetRegua(RecCount())  

_cFiltro := " SELECT 
_cFiltro += " SubStr(E1_EMISSAO,7,2)||'/'||SubStr(E1_EMISSAO,5,2)||'/'||SubStr(E1_EMISSAO,1,4) AS EMISSAO, "
_cFiltro += " E1_SERIE AS SERIE, "
_cFiltro += " E1_NUM AS NUMERO, "
_cFiltro += " E1_PREFIXO AS PREFIXO, "
_cFiltro += " E1_PARCELA AS PARCELA, "
_cFiltro += " SubStr(E1_VENCREA,7,2)||'/'||SubStr(E1_VENCREA,5,2)||'/'||SubStr(E1_VENCREA,1,4) AS VENCIMENTO, "
_cFiltro += " E1_CLIENTE AS CLIENTE, "
_cFiltro += " E1_LOJA AS LOJA, " 
_cFiltro += " E1_NOMCLI AS NOME_CLI, "
_cFiltro += " E1_VEND1 AS VEND1, "
_cFiltro += " NVL((SELECT A3_NOME FROM SA3010 WHERE A3_COD = E1_VEND1 ),'') AS NOME_VENDEDOR,			"
_cFiltro += " E1_VEND2 AS VEND2, "
_cFiltro += " NVL((SELECT A3_NOME FROM SA3010 WHERE A3_COD = E1_VEND2 ),'') AS NOME_VENDEDOR2,			"
_cFiltro += " SubStr(E1_BAIXA,7,2)||'/'||SubStr(E1_BAIXA,5,2)||'/'||SubStr(E1_BAIXA,1,4) AS BAIXA, 	"
_cFiltro += " E1_NATUREZ AS  NATUREZA, "
_cFiltro += " E1_PEDIDO AS PEDIDO, "
_cFiltro += " E1_VALOR AS VALOR_REAL, "
_cFiltro += " E1_TIPO AS TIPO, "



_cFiltro += " E1_VALOR AS VALOR"
_cFiltro += " FROM " + RetSQLName("SE1") + " SE1 " 
_cFiltro += " WHERE E1_EMISSAO between '" + DtoS(mv_par01) + "' AND '" + DtoS(mv_par02) + "' AND "
_cFiltro += " E1_VENCREA   >= '" + DtoS(mv_par03) + "' AND E1_VENCREA   <= '" + DtoS(mv_par04) + "' "  

If !Empty(mv_par05)
_cTro7 := ''
_cPar7 := mv_par05
		_cTro7 := At(',',_cPar7) 
		If _cTro7 <> 0 
		   _cPar7 := Stuff(_cPar7,_cTro7,1,"','")
		EndiF
_cFiltro += " AND E1_PREFIXO IN ('"+(_cPar7)+"')" 
Endif

If !Empty(mv_par06)
_cTro8 := ''
_cPar8 := mv_par06
		_cTro8 := At(',',_cPar8) 
		If _cTro8 <> 0 
		   _cPar8 := Stuff(_cPar8,_cTro8,1,"','")
		EndiF
_cFiltro += " AND E1_PREFIXO NOT IN ('"+(_cPar8)+"')" 
Endif                            

If !Empty(mv_par07)
_cTro2 := ''
_cPar2 := mv_par07
		_cTro2 := At(',',_cPar2) 
		If _cTro2 <> 0 
		   _cPar2 := Stuff(_cPar2,_cTro2,1,"','")
		EndiF
_cFiltro += " AND E1_NATUREZ IN ('"+(_cPar2)+"')"
Endif

If !Empty(mv_par08)
_cTro3 := ''
_cPar3 := mv_par08
		_cTro3 := At(',',_cPar3) 
		If _cTro3 <> 0 
		   _cPar3 := Stuff(_cPar3,_cTro3,1,"','")
		EndiF
_cFiltro += " AND E1_NATUREZ NOT IN ('"+(_cPar3)+"')"
Endif		                          

_cFiltro += " AND E1_VEND1   >= '" + mv_par09 + "' AND E1_VEND1   <= '" + mv_par10 + "' AND "
_cFiltro += " E1_CLIENTE >= '" + mv_par11 + "' AND E1_CLIENTE <= '" + mv_par13 + "' AND " 
_cFiltro += " E1_LOJA    >= '" + mv_par12 + "' AND E1_LOJA <= '" + mv_par14 + "' "

If !Empty(mv_par17)
_cTro0 := ''
_cPar0 := mv_par17
		_cTro0 := At(',',_cPar0) 
		If _cTro0 <> 0 
		   _cPar0 := Stuff(_cPar0,_cTro0,1,"','")
		EndiF
_cFiltro += " AND E1_TIPO IN ('"+(_cPar0)+"')"
EndIf
_cFiltro += " AND SE1.D_E_L_E_T_= ' '
_cFiltro += " ORDER BY EMISSAO, NUMERO,	SERIE, PARCELA "

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

dbUseArea( .T., "TopConn", TCGenQry(,,_cFiltro), "TRB", .F., .F. )      

_aDados		:= {}      
AAdd(_aDados, {"EMISSAO","SERIE","NUMERO","PREFIXO","PARCELA","VENCIMENTO","CLIENTE","LOJA","VEND1","VEND2","BAIXA","TIPO","NATUREZA","NOME_CLI","PEDIDO","VALOR_REAL","VALOR_BAIXADO"})
AAdd(_aDados, {})
              
      

DbSelectArea("TRB") 
TRB->(dbGoTop())

While !TRB->(Eof())

   If lAbortPrint
      @100,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif
   
	AAdd(_aDAdos,	{STOD(TRB->EMISSAO),TRB->SERIE,TRB->NUMERO,TRB->PREFIXO,TRB->PARCELA,STOD(TRB->VENCIMENTO),;
					TRB->CLIENTE,TRB->LOJA,TRB->VEND1,TRB->VEND2,STOD(TRB->BAIXA),TRB->TIPO,TRB->NATUREZA,TRB->NOME_CLI,;
					TRB->PEDIDO,TRANSFORM(TRB->VALOR, "@E 999,999.99"),TRANSFORM(Posicione('SE5',14, xFilial('SE5')+TRB->PREFIXO+TRB->NUMERO+TRB->PARCELA+'R', 'E5_VALOR'), "@E 999,999.99")})

   TRB->(dbSkip()) 

EndDo
                                                   

DlgToExcel({ {"ARRAY","Comissao de Vendas", "Comissao", _aDados} }) 

                                                                     
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