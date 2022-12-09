/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT105FIM  �Autor  �S�rgio Santana      � Data �  04/01/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Esta rotina tem a finalidade de gerar a pre-requisi��o du- ���
���          � rante a inclus�o da solicita��o ao armaz�m                 ���
�������������������������������������������������������������������������͹��
���Uso       � Glastech                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT185TST( cA105Num )

LOCAL _nIdx      := SCP->( IndexOrd() )                                                   
LOCAL _cFilSCP   := xFilial( 'SCP' )
LOCAL _lOpc      := if( Paramixb = 1, .T., .F. )
LOCAL _nRec      := 0
LOCAL _nLen      := 0
LOCAL nAglutSC   := 0
LOCAL lRateio    := .F.
LOCAL n1Cnt      := 0
LOCAL aRecSCP    := {}
LOCAL aCamposSCP := {}
LOCAL aCamposSD3 := {}

PRIVATE cAlias     := 'SCP'

If _lOpc

   _aArea := GetArea()
   _nRec := SCP->( RecNo() )
   SCP->( dbSetOrder(1) )
   SCP->( dbSeek( _cFilSCP + cA105Num, .T. ) )

   While (SCP->CP_FILIAL = _cFilSCP) .And.;
         (SCP->CP_NUM    = cA105Num) .And.;
         ! (SCP->( Eof() ) )

      /*
        []----------------------------------------------------------------------------------[]

          Monta array contendo os itens a serem baixados informando o c�digo de movimenta��o

        []----------------------------------------------------------------------------------[]
      */


      aCamposSCP := {;
                     {"CP_FILIAL"  ,SCP->CP_FILIAL ,NIL },;
                     {"CP_NUM"     ,SCP->CP_NUM    ,NIL },;
                     {"CP_ITEM"    ,SCP->CP_ITEM   ,NIL },;
                     {"CP_EMISSAO" ,SCP->CP_EMISSAO,NIL },;
                     {"CP_LOCAL"   ,SCP->CP_LOCAL  ,NIL },;
                     {"CP_QUANT"   ,SCP->CP_QUANT  ,NIL } ;
                    } 

      aCamposSD3 := {;
                     {"D3_FILIAL"  ,SCP->CP_FILIAL  ,NIL },;
                     {"D3_TM"      , '540'          ,NIL },;  // Tipo do Mov. 
                     {"D3_COD"     ,SCP->CP_PRODUTO ,NIL },;
                     {"D3_LOCAL"   ,SCP->CP_LOCAL   ,NIL },;
                     {"D3_DOC"     ,SCP->CP_NUM+'-'+SCP->CP_ITEM ,NIL },;  // No.do Docto.
                     {"D3_EMISSAO" ,dDataBase       ,NIL };
                    }

      SCP->( dbSkip() )

   End

   lMSHelpAuto := .T.
   lMsErroAuto := .F.

   MSExecAuto( { |v,x,y,z| mata185(v,x,y) }, aCamposSCP, aCamposSD3, 1 )  // 1 Baixa Rotina Automatica

   If lMsErroAuto
			
      MsgInfo('Erro ao realizar a Baixa Autom�tica da Requisi��o, por gentileze verifique o erro na proxima tela.','Baixa Requisi��o')
	  MostraErro()

   End
  
   SCP->( dbSetOrder( _nIdx ) )
   SCP->( dbGoTo( _nRec ) )

End

Return( NIL )