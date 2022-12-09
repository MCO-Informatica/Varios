#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RCOM004  � Autor � luiz Henrique      � Data �  26/04/12   ���
�������������������������������������������������������������������������͹��
���Descricao �relatorio dos ultimos precos                                ���
���          �de compra                                                   ���
�������������������������������������������������������������������������͹��
���Uso       � Actual Trend                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function RCOM004()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "UTIMOS PRE�OS DE COMPRA"
Local cPict          := ""
Local titulo       := "ULTIMOS PRE�OS DE COMPRAS"
Local nLin         := 80

//                                 10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220
//                       0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Local Cabec1         := "FORNECEDOR      DESCRICAO             PRODUTO               DESCRICAO                         DATA    QUANT  VALOR UNIT IMPOSTO   TOTAL
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 136
Private tamanho          := "G"
Private nomeprog         := "RCOM004" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := "RCOM004"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RCOM004" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SD1"  

AjustaSX1()
			
Pergunte(cPerg,.F.)

dbSelectArea("SD1")
dbSetOrder(1)



//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  26/04/12   ���
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
 
aStruSD1  := SD1->(dbStruct())
 

cQuery :=                    " SELECT SD1.D1_FORNECE,SA2.A2_NREDUZ,SD1.D1_COD,SB1.B1_DESC,SD1.D1_EMISSAO,SD1.D1_VALIPI+SD1.D1_ICMSRET AS IMPOSTO,SD1.D1_QUANT,SD1.D1_VUNIT,SD1.D1_TOTAL+SD1.D1_VALIPI+SD1.D1_ICMSRET AS TOTAL
cQuery += CHR(13)+CHR(10) + " FROM SD1010 SD1
cQuery += CHR(13)+CHR(10) + " INNER JOIN SA2010 SA2 ON SD1.D1_FORNECE = SA2.A2_COD
cQuery += CHR(13)+CHR(10) + " INNER JOIN SB1010 SB1 ON SD1.D1_COD = SB1.B1_COD
cQuery += CHR(13)+CHR(10) + " WHERE SD1.D1_EMISSAO BETWEEN '"+dtos(mv_par03)+"' and '"+dtos(mv_par04)+"'
cQuery += CHR(13)+CHR(10) + "       and SD1.D1_COD BETWEEN '"+mv_par01+"' and '"+mv_par02+"'                                              
cQuery += CHR(13)+CHR(10) + " ORDER BY D1_EMISSAO DESC


cAliasA := GetNextAlias()
cQuery  := ChangeQuery(cQuery)

DbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cAliasA , .F., .T.)

For nX := 1 To Len(aStruSD1)
	If ( aStruSD1[nX][2] <> "C" )
		TcSetField(cAliasA,aStruSD1[nX][1],aStruSD1[nX][2],aStruSD1[nX][3],aStruSD1[nX][4])
	EndIf
Next nX
   
TcSetField(cAliasA,"D1_EMISSAO","D",8,0)

dbSelectArea(cAliasA)


//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

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
   
    
   	  
   

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
   		@nLin,00  PSAY (cAliasA)->D1_FORNECE+"   "+(cAliasA)->A2_NREDUZ
   		@nLin,39  PSAY (cAliasA)->D1_COD+(cAliasA)->B1_DESC
   		@nLin,94  PSAY (cAliasA)->D1_EMISSAO
   		@nLin,104 PSAY (cAliasA)->D1_QUANT
   	  	@nLin,112 PSAY (cAliasA)->D1_VUNIT
        @nLin,121 PSAY (cAliasA)->IMPOSTO
   		@nLin,130 PSAY (cAliasA)->TOTAL
	
		
   nLin := nLin + 1 // Avanca a linha de impressao
     
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

MS_FLUSH()

Return   

 /*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � AjustaSX1    �Autor �  Mauro Nagata        �Data� 24/03/11 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ajusta perguntas do SX1                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function AjustaSX1()

Local cAlias := Alias(), aPerg := {}
Local nI, nPerg
//      cGrupo 	cOrde cDesPor cDesSpa	cDesEng   cVar	cTipo 	cTamanho	cDecimal	nPreSel		cGSC	cValid	cF3	cGrpSXG	cPyme	cVar01		cDef1Por	cDef1Spa	cDef1Eng	cCnt01	cDef2Por	cDef2Spa	cDef2Eng	cDef3Por	cDef3Spa	cDef3Eng	cDef4Por	cDef4Spa	cDef4Eng	cDef5Por	cDef5Spa	cDef5Eng	aHelpPor			aHelpEng			aHelpSpa			cHelp) 

Aadd(aPerg, {"01","De Produto  ? ","?","?","mv_ch1","C",15,"G","mv_par01","","","","","","","",0,""})
Aadd(aPerg, {"02","Ate Produto ? ","?","?","mv_ch2","C",15,"G","mv_par02","","","","","","","",0,""})
Aadd(aPerg, {"03","Da Data     ? ","?","?","mv_ch3","D",8,"G","mv_par03","","","","","","","",0,""})
Aadd(aPerg, {"04","Ate Data    ? ","?","?","mv_ch4","D",8,"G","mv_par04","","","","","","","",0,""})

nPerg := Len(aPerg)                                                                                                                              	

DbSelectArea("SX1")
DbSetOrder(1)
For nI := 1 To nPerg
	If !DbSeek(Pad(cPerg,10)+aPerg[nI,1])
		RecLock("SX1",.T.)
		Replace X1_GRUPO	With cPerg
		Replace X1_ORDEM	With aPerg[nI,01]
		Replace X1_PERGUNT	With aPerg[nI,02]
		Replace X1_PERSPA	With aPerg[nI,03]
		Replace X1_PERENG	With aPerg[nI,04]
		Replace X1_VARIAVL	With aPerg[nI,05]
		Replace X1_TIPO		With aPerg[nI,06]
		Replace X1_TAMANHO	With aPerg[nI,07]
		Replace X1_GSC		With aPerg[nI,08]
		Replace X1_VAR01	With aPerg[nI,09]
		Replace X1_DEF01	With aPerg[nI,10]
		Replace X1_DEFSPA1	With aPerg[nI,11]
		Replace X1_DEFENG1	With aPerg[nI,12]
		Replace X1_CNT01	With aPerg[nI,13]
		Replace X1_DEF02	With aPerg[nI,14]
		Replace X1_DEFSPA2	With aPerg[nI,15]
		Replace X1_DEFENG2	With aPerg[nI,16]
		Replace X1_PRESEL 	With aPerg[nI,17]
		Replace X1_F3    	With aPerg[nI,18]
	
		MsUnlock()
	EndIf
Next

DbSelectArea(cAlias)

Return 
