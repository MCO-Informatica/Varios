#INCLUDE "rwmake.ch"
/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
���Programa  � RFATA15  � Autor � Ricardo Correa de Souza � Data � 01/05/2011 ���
�����������������������������������������������������������������������������Ĵ��
���Descricao � Grava os Dados da Coleta                                       ���
�����������������������������������������������������������������������������Ĵ��
���Observacao� RFATA13()                                                      ���
�����������������������������������������������������������������������������Ĵ��
���Uso       � Ricaelle Industria e Comercio Ltda                             ���
�����������������������������������������������������������������������������Ĵ��
���             ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL              ���
�����������������������������������������������������������������������������Ĵ��
���Programador   �  Data  �              Motivo da Alteracao                  ���
�����������������������������������������������������������������������������Ĵ��
���              �        �                                                   ���
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
*/

User Function RFATA15()

lRet:=.f.
if !Empty(SC9->C9_NFISCAL) .and. Empty(SC9->C9_X_DTCOL)  
   lRet:=.t.
ElseIf !Empty(SC9->C9_NFISCAL) .And. !Empty(SC9->C9_X_DTCOL)  
   MsgBox("Coleta j� realizada","INFO") 
   lRet:=.f.
ElseIf Empty(SC9->C9_NFISCAL)
   MsgBox("S� pode informar coleta ap�s o faturamento","INFO") 
   lRet:=.f.
endif

if lRet

   @ 030,1 TO 300,500 DIALOG oDlg3 TITLE "Coleta"

   cNFCol	:= SC9->C9_NFISCAL+" / "+SC9->C9_SERIENF
   dDtCol   := ctod(" / / ")
   cNomCol  := Space(50)
   cDocCol  := Space(20)
   cTraCol	:=Posicione("SA4",1,xFilial("SA4")+Posicione("SF2",1,xFilial("SF2")+SC9->C9_NFISCAL+SC9->C9_SERIENF,"F2_TRANSP"),"A4_NOME")
   
   @ 15,010 SAY "Nota Fiscal:   "
   @ 15,100 GET cNFCol When .f. SIZE 100,10 
   @ 30,010 SAY "Transportadora:"
   @ 30,100 GET cTraCol When .f. SIZE 100,10 
   @ 45,010 SAY "Data Coleta:   " 
   @ 45,100 GET dDtCol SIZE 50,10 VALID !Empty(dDtCol) 
   @ 60,010 SAY "Coletado por:  "
   @ 60,100 GET cNomCol SIZE 100,10 VALID !Empty(cNomCol)  
   @ 75,010 SAY "RG:            "
   @ 75,100 GET cDocCol SIZE 100,10 VALID !Empty(cDocCol)  

   ACTIVATE DIALOG oDlg3 CENTERED ON INIT EnchoiceBar(oDlg3,{|| Processa( {|| Grava() } ) }, {|| Close(oDlg3)} ) 

endif
  
Return


Static Function GRAVA

ProcRegua(10)

cNFiscal:=SC9->C9_NFISCAL
cSerie  :=SC9->C9_SERIENF

dbSelectArea("SD2")
dbSetOrder(3)
dbSeek(xFilial()+cNfiscal+cSerie)

While !Eof() .and. D2_DOC==cNFiscal .and. D2_SERIE==cSerie

      //Posiciona no Item Liberado
      dbSelectArea("SC9")
      dbSetOrder(1)
      dbSeek(xFilial()+SD2->D2_PEDIDO+SD2->D2_ITEMPV)
      
      While !Eof() .and. C9_PEDIDO==SD2->D2_PEDIDO .and. C9_ITEM==SD2->D2_ITEMPV

            if C9_NFISCAL==SD2->D2_DOC .and. C9_SERIENF==SD2->D2_SERIE
               IncProc()
               RecLock("SC9",.f.)
                 C9_X_DTCOL  	:=dDtCol
                 C9_X_NOMEC 	:=cNomCol
                 C9_X_DOCCO		:=cDocCol
               MsUnlock()    
            endif
         dbSkip()
      end

   dbSelectArea("SD2")
   dbSkip()

end

Close(oDlg3)

Return