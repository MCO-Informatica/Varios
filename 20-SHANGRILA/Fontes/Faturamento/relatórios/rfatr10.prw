#INCLUDE "rwmake.ch"
/*
*********************************************************************************
***Programa  � RFATR10  � Autor � Eduardo Marcolongo      � Data � 26/08/2009 ***
*********************************************************************************
***Descricao � Demonstrativo de Resultado                                     ***
*********************************************************************************
***Uso       �                      Solicitante: Rodrigo                      ***
*********************************************************************************
***             ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL              ***
*********************************************************************************
***Programador   �  Data  �              Motivo da Alteracao                  ***
*********************************************************************************
***                															  **
*********************************************************************************
*/
User Function RFATR10

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Demonstrativo de Resultados"
Local cPict          := ""
Local titulo         := "Demonstrativo de Resultados"
Local nLin         	 := 80
Local Cabec1       	 := "Data          Recebidos       Pagos        ICMS    IPI   ST"
Local Cabec2       	 := ""
Local imprime      	 := .T.
Local aOrd 			 := ""//{"Por Data","Por Cliente","Por Natureza","Por Vendedor"}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "RFATR10"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RFATR10"
Private cString 	 := ""
Private cPerg   	 := PadR("FINR07",Len(SX1->X1_GRUPO))
Private nOrdem

Private cRef1   := ""
Private cRef2   := ""
Private cCliente:= ""
Private cNome   := ""       

Private nValor1 := 0
Private nValor2 := 0
Private nAcum1  := 0
Private nAcum2  := 0

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
validperg()
Pergunte(cPerg,.f.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)
If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)
nOrdem:= aReturn[8]
Cabec1       	 := ""
Cabec2       	 := "NATUREZA        "

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  23/05/05   ���
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

Local _aTmp  := {}                    
AAdd ( _aTmp, {"CLIENTE" 	,"C", 20, 00} ) 
AAdd ( _aTmp, {"SCLIENTE" 	,"C", 60, 00} ) 
AAdd ( _aTmp, {"REF1" 		,"N", 12, 02} )
AAdd ( _aTmp, {"REF2" 		,"N", 12, 02} )  
AAdd ( _aTmp, {"ACUM1" 	    ,"N", 12, 02} ) 
AAdd ( _aTmp, {"ACUM2" 		,"N", 12, 02} )

_cTable := CriaTrab(_aTmp,.T.)
DbUseArea(.T.,"DBFCDX",_cTable,"DTF",.T.,.F.)

cRef1 := SubStr(DTOS(mv_par01),1,6)
cRef2 := SubStr(DTOS(mv_par02),1,6)
periodo1()

dbSelectArea("DTF")
SetRegua(RecCount())
dbGoTop()                   

While !EOF()

   //���������������������������������������������������������������������Ŀ
   //� Verifica o cancelamento pelo usuario...                             �
   //�����������������������������������������������������������������������
   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //���������������������������������������������������������������������Ŀ
   //� Impressao do cabecalho do relatorio. . .                            �
   //�����������������������������������������������������������������������
   If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif  

       @nLin,02  PSAY DTF->CLIENTE
       @nLin,20  PSAY DTF->SCLIENTE
       @nLin,35  PSAY DTF->REF1     Picture "@E 999,999.99"
       @nLin,50  PSAY DTF->REF2     Picture "@E 999,999.99"
       @nLin,65  PSAY DTF->ACUM1    Picture "@E 999,999.99"
       @nLin,80  PSAY DTF->ACUM2    Picture "@E 999,999.99"
   dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo              

//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������

SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

dbCloseArea("DTF")
MS_FLUSH()

Return

Static Function periodo1()
Local cQuery := ""                                    
cQuery := "SELECT F2_CLIENTE, A1_NOME, SUM(D2_TOTAL) AS D2_TOTAL "
cQuery += "FROM SF2010 INNER JOIN SD2010 ON (F2_DOC = D2_DOC) AND (F2_SERIE = D2_SERIE) "
cQuery += "INNER JOIN SF4010 ON (D2_TES = F4_CODIGO) INNER JOIN SA1010 ON (F2_CLIENTE = A1_COD) "
cQuery += "WHERE SUBSTR(D2_EMISSAO,1,6) = '"+cRef1+"' AND F4_TIPO = 'S' AND F4_DUPLIC = 'S' AND SD2010.D_E_L_E_T_ = '' "
cQuery += "GROUP BY F2_CLIENTE, A1_NOME"
cQuery := ChangeQuery(cQuery)
	
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"P1",.T.,.T.)
dbSelectArea("P1")
dbGoTop()        
Do While !P1->(Eof())
   IncProc("Carregando...") // Atualiza barra de progresso
   dbSelectArea("DTF")              
   RecLock("DTF",.t.)    
   DTF->CLIENTE  := P1->F2_CLIENTE
   DTF->SCLIENTE := P1->A1_NOME
   DTF->REF1     := P1->D2_TOTAL
   MsUnLock()
   P1->(dbSkip())
Enddo
dbCloseArea("P1")
Return                                                  

Static Function periodo2()
Local cQuery := ""                                    
cQuery := "SELECT F2_CLIENTE, A1_NOME, SUM(D2_TOTAL) AS D2_TOTAL "
cQuery += "FROM SF2010 INNER JOIN SD2010 ON (F2_DOC = D2_DOC) AND (F2_SERIE = D2_SERIE) "
cQuery += "INNER JOIN SF4010 ON (D2_TES = F4_CODIGO) INNER JOIN SA1010 ON (F2_CLIENTE = A1_COD) "
cQuery += "WHERE SUBSTR(D2_EMISSAO,1,6) = '"+cRef2+"' AND F4_TIPO = 'S' AND F4_DUPLIC = 'S' AND SD2010.D_E_L_E_T_ = '' "
cQuery += "GROUP BY F2_CLIENTE, A1_NOME"
cQuery := ChangeQuery(cQuery)
	
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"P2",.T.,.T.)
dbSelectArea("P2")
dbGoTop()        
nValor1 := P2->D2_TOTAL
if (P2->F2_CLIENTE <> "") 
   cCliente := P2->F2_CLIENTE
   cNome := P2->A1_NOME
EndIf
dbCloseArea("P2")
Return                                                  

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �VALIDPERG � Autor � AP5 IDE            � Data �  13/04/07   ���
�������������������������������������������������������������������������͹��
���Descri��o � Verifica a existencia das perguntas criando-as caso seja   ���
���          � necessario                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ValidPerg

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
//cPerg := PADR(cPerg,6)

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","1o Periodo         ?","1o Periodo         ?","1o Periodo         ?","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","20 Periodo         ?","2o Periodo         ?","2o Periodo         ?","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//aAdd(aRegs,{cPerg,"03","Da Filial          ?","Da Filial          ?","Da Filial          ?","mv_ch3","C",02,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//aAdd(aRegs,{cPerg,"04","Ate Filial         ?","Ate Filial         ?","Ate Filial         ?","mv_ch4","C",02,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//aAdd(aRegs,{cPerg,"05","Da Natureza        ?","Da Natureza        ?","Da Natureza        ?","mv_ch5","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//aAdd(aRegs,{cPerg,"06","Ate Natureza       ?","Ate Natureza       ?","Ate Natureza       ?","mv_ch6","C",06,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i := 1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return
