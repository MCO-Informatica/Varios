#include "rwmake.ch"        
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RFIN002  � Autor � CM                 � Data �  21/10/06   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina de Impress�ao de Faturas a Receber                  ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico empresa Minexco - Protheus 8                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function RFIN002()        

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("TAMANHO,LIMITE,TITULO,CDESC1,CDESC2,CDESC3,CSTRING,ARETURN")
SetPrvt("CPERG,NLASTKEY,LI,CSAVSCR1,CSAVCUR1,CSAVROW1")
SetPrvt("CSAVCOL1,CSAVCOR1,WNREL")

//+--------------------------------------------------------------+
//� Define Variaveis.                                            �
//+--------------------------------------------------------------+
tamanho := "P" 
limite  := 80
titulo  := "EMISSAO DE DUPLICATAS - FATURAS"
cDesc1  := "Este programa ir� emitir as Duplicatas conforme"
cDesc2  := "parametros especificados."
cDesc3  := ""
cString := "SE1"
aReturn := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
cPerg   :="MTR750"
nLastKey := 0
li := 0

//+---------------------------------------------+
//� Variaveis utilizadas para parametros	      �
//� mv_par01		// Duplicata de		         �
//� mv_par02		// Duplicata ate	            �
//� mv_par03		// Serie                		�
//+---------------------------------------------+

//+--------------------------------------------------------------+
//� Verifica as perguntas selecionadas                           �
//+--------------------------------------------------------------+

pergunte("MTR750",.F.)

//+--------------------------------------------------------------+
//� Envia controle para a funcao SETPRINT.                       �
//+--------------------------------------------------------------+
wnrel :="RFIN002" 

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,)

If LastKey() == 27 .Or. nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .Or. nLastKey == 27
   Return
Endif

dbSelectArea("SE1")
dbSetOrder(1)
dbSeek(Xfilial()+mv_par03)
	
If Found()
	Set Print On   
	Set Device to Print
	
	While E1_NUM >= mv_par01 .and. E1_NUM <= mv_par02 .And. E1_PREFIXO == mv_par03 .and. !Eof() 
		If E1_FATURA == "NOTFAT"
				
			@ li,058 PSAY E1_EMISSAO	
			@ li,076 PSAY E1_NUM
			li:= li + 5
			@ li,022 PSAY E1_NUM
			@ li,029 PSAY E1_VALOR 
			@ li,051 PSAY E1_NUM
			@ li,060 PSAY E1_VENCTO
			li:= li + 6
			DbSelectArea("SA1")
			DbSetOrder(1)
			DbSeek(Xfilial()+SE1->E1_CLIENTE+SE1->E1_LOJA)
			If found()
				@ li,029 PSAY A1_NOME
				li:= li + 1
				@ li,029 PSAY A1_END
				li:= li +1
				@ li,029 PSAY A1_MUN
				@ li,053 PSAY A1_EST
				@ li,063 PSAY A1_CEP
				li := li + 1
				@ li,000 PSAY CHR(15)
				@ li,050 PSAY A1_ENDCOB
				@ li,100 PSAY CHR(18)
				li := li + 1
				@ li,029 PSAY A1_CGC
				@ li,050 PSAY A1_INSCR
				li := li + 3
			Endif	

			//buscar os T�tulos que compoem esse fatura e imprimi-los
		
			DbSelectArea("SE1")
		
			@ li,029 PSAY Subs(RTRIM(SUBS(EXTENSO(E1_VALOR),1,55)) + REPLICATE("*",54),1,54)
			li:= li + 1
      	@ li,029 PSAY Subs(RTRIM(SUBS(EXTENSO(E1_VALOR),56,55)) + REPLICATE("*",54),1,54) 
		   li:= li + 1
   	   @ li,029 PSAY Subs(RTRIM(SUBS(EXTENSO(E1_VALOR),112,55)) + REPLICATE("*",54),1,54)
			li:= li + 1
	      @ li,029 PSAY Subs(RTRIM(SUBS(EXTENSO(E1_VALOR),168,55)) + REPLICATE("*",54),1,54)		
			DbSkip()
		Else
			Dbskip()
			Loop
		Endif
		li := 16
	EndDO
EndIf

Set Device to Screen
DbSelectArea("SE1")
DbSetOrder(1)
DbSelectArea("SA1")
DbSetOrder(1)

//+------------------------------------------------------------------+
//� Se impressao em Disco, chama Spool.                              �
//+------------------------------------------------------------------+
If aReturn[5] == 1
   Set Printer To 
   dbCommitAll()
   ourspool(wnrel)
Endif


//+------------------------------------------------------------------+
//� Libera relatorio para Spool da Rede.                             �
//+------------------------------------------------------------------+
FT_PFLUSH()

