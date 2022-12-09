user function GerGnre()

dbSelectArea( 'SF2' )
_cFlt := "@ (F2_EMISSAO BETWEEN '20140701' AND '20140731') AND (F2_ICMSRET <> 0) AND (F2_EST NOT IN ('SP','RJ','RS','MG','SC','CE')) AND (D_E_L_E_T_ <> '*')"
SF2->( dbSetFilter( { || &_cFlt }, _cFlt ) )
SF2->( dbGoTop() )
_cFilSF6 := xFilial( 'SF6' )
While ! ( SF2->( Eof() ) )

   If (SF2->F2_ICMSRET <> 0)

      RecLock( 'SF6', .T. )
      SF6->F6_FILIAL   := SF2->F2_FILIAL
      SF6->F6_NUMERO   := SF2->F2_DOC
      SF6->F6_DOC      := SF2->F2_DOC
      SF6->F6_SERIE    := SF2->F2_SERIE
      SF6->F6_EST      := SF2->F2_EST
      SF6->F6_CLIFOR   := SF2->F2_CLIENTE
      SF6->F6_LOJA     := SF2->F2_LOJA
      SF6->F6_TIPODOC  := SF2->F2_TIPO
      SF6->F6_OPERNF   := '2'
      SF6->F6_TIPOIMP  := '3'
      SF6->F6_PROCESS  := '2'
      SF6->F6_DTARREC  := SF2->F2_EMISSAO
      SF6->F6_DTVENC   := (SF2->F2_EMISSAO + 7)
      SF6->F6_MESREF   := Month( SF2->F2_EMISSAO )
      SF6->F6_ANOREF   := Year( SF2->F2_EMISSAO )
      SF6->F6_CODREC   := '100099'
      SF6->F6_VALOR    := SF2->F2_ICMSRET
      SF6->( dbUnLock() )

      RecLock( 'CDC', .T. )
      CDC->CDC_FILIAL := SF2->F2_FILIAL
      CDC->CDC_TPMOV  := 'S'
      CDC->CDC_DOC    := SF2->F2_DOC
      CDC->CDC_SERIE  := SF2->F2_SERIE
      CDC->CDC_CLIFOR := SF2->F2_CLIENTE
      CDC->CDC_LOJA   := SF2->F2_LOJA
      CDC->CDC_GUIA   := SF2->F2_DOC
      CDC->CDC_UF     := SF2->F2_EST
      CDC->CDC_IFCOMP := '000001'
      CDC->( dbUnLock() )

   End
   
   SF2->( dbSkip() )  

End

Return( NIL )