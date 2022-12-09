#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function K0002()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("_DDATA,")

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴엽�
굇쿎liente   � Kenia Industrias Texteis Ltda.                             낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇旼컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴엽�
굇쿛rograma:#� K0002.prw                                                  낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿏escricao:� Programa para efetuar inventario automatico.               낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컫컴컴컴컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿏ata:     � 01/09/00    � Implantacao: � 04/09/00                      낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컨컴컴컴컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿛rogramad:� Sergio Oliveira                                            낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇旼컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴엽�
굇쿚bjetivos:� Para cada PA, sera procurado lancamento de inventario. Ca -낢�
굇�          � so nao tenha (01/09/00), lancar inventarios zerados.       낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇旼컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴엽�
굇쿚bservacao� Os lancamentos de inventario com a mesma data tem efeito   낢�
굇�          � cumulativo.                                                낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇旼컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴엽�
굇쿌rquivos :� SB1 e SD7.                                                 낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/

MSGBOX("Esta rotina devera ser executada com o maximo de atencao","ATENCAO","ALERT")

If SM0->M0_CODIGO != "01"

   MsgBox("Somente na empresa Oficial","Atencao","Alert")
   __RetProc()

EndIf
   
   Processa( {|| ATUB72() }, "Inventariando automaticamente c/ brancos...")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>    Processa( {|| Execute(ATUB72) }, "Inventariando automaticamente c/ brancos...")
   __RetProc()


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>    FUNCTION ATUB72
Static FUNCTION ATUB72()

   _dData := Ctod("02/09/00")

   DbSelectArea("SB2")
   DbSetOrder(1)     

   DbSelectArea("SB1")
   DbSetOrder(1)

   DbSelectArea("SB7")
   DbSetOrder(1)
/*
  旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�  
  �                Ler todos os PA's.                                       �  
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�  
*/
   DbSelectArea("SB1")
   DbSetOrder(1)
   DBGOTOP()
   ProcRegua(LastRec())
   While !Eof() .and. SB1->B1_FILIAL == xFilial()

	  /// retira o rastro
	  RecLock("SB1",.F.)
	  SB1->B1_RASTRO := "N"
	  MsUnLock()

/*
  旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�  
  � 	Procurar por lancamentos de inventario em 02/09/00. 				�
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�  
*/
   IncProc("Aguarde, Selecionando os Produtos")
	 
//	   If (SubStr(SB1->B1_COD,Len(AllTrim(SB1->B1_COD))-2,3)=="000")
//		  DbSkip()
//		  Loop
//	   EndIf

   If (LEN(ALLTRIM(SB1->B1_COD))==6 .OR. (LEN(ALLTRIM(SB1->B1_COD))==7 .AND. SUBSTR(SB1->B1_COD,1,1)=="1"))
	 
		DbSelectArea("SB2")
		If !DbSeek(xFilial()+SB1->B1_COD+"01",.F.)
		   DbSelectArea("SB1")
		   DbSkip()
		   Loop
		EndIf
	 
		DbSelectArea("SB7")
		If !DbSeek(xFilial()+Dtos(_dData)+SB1->B1_COD+SB1->B1_LOCPAD,.F.)
/*
  旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�  
  �          Agora, lancar registros de inventario zerado.                  �  
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�  
*/ 
		   DbSelectArea("SB7")
		   RecLock("SB7",.T.)
		   SB7->B7_FILIAL  := xFilial()
		   SB7->B7_COD	   := SB1->B1_COD
		   SB7->B7_LOCAL   := SB1->B1_LOCPAD
		   SB7->B7_TIPO    := SB1->B1_TIPO
		   SB7->B7_DOC	   := "02/09" // NAO INFLUENCIA
		   SB7->B7_QUANT   := 0
		   SB7->B7_DATA    := CTOD("02/09/00")
		   MsUnLock()
	 
		EndIf

		DbSelectArea("SB1")
		DbSkip()
   Else

		DbSelectArea("SB1")
		DbSkip()
		Loop

   EndIf


EndDo
	 
__RetProc()


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

