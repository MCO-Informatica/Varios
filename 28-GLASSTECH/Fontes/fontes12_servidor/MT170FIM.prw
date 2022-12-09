/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT170FIM  บAutor  ณ S้rgio Santana     บ Data ณ  13/10/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Esta rotina tem por finalidade atualizar o n๚mero da soli  บฑฑ
ฑฑบ          ณ cita็ใo de compra sempre que houver quebra do grupo do pro บฑฑ
ฑฑบ          ณ duto.                                                      บฑฑ
ฑฑบ          ณ Trabalha em conjunto com o ponto de entrada MT170QRY, onde บฑฑ
ฑฑบ          ณ deve executar a rotina com o indice 4 Grupo de Produto.    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Glasstech                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MT170FIM()
	
	LOCAL _cNumSC := ' '
	LOCAL _cGrupo := ''
	LOCAL _nItem  := 0
	LOCAL _cQry
	
	If Len( ParamIxb ) <> 0

       If Len( ParamIxb[1] ) <> 0

          _cNumSC := ParamIxb[1][1][2]

       End

    End
	
	If (MV_PAR20 = 2) .And. (_cNumSC <> ' ')

		_cQry := "SELECT SC1.R_E_C_N_O_ NREC, B1_GRUPO, B1_COD, SY1.Y1_COD "
		_cQry += "FROM " + RetSQLName( 'SC1' ) + " SC1 "
		_cQry += "LEFT OUTER JOIN " + RetSQLName( 'SB1' ) + " SB1 ON (SB1.B1_FILIAL = '" + xFilial( 'SB1' ) + "') AND (SB1.B1_COD = SC1.C1_PRODUTO) AND (SB1.D_E_L_E_T_ <> '*') "
		_cQry += "LEFT OUTER JOIN " + RetSQLName( 'SAJ' ) + " SAJ ON (SAJ.AJ_FILIAL = '" + xFilial( 'SAJ' ) + "') AND (SAJ.AJ_GRCOM = SB1.B1_GRUPCOM) AND (SAJ.D_E_L_E_T_ <> '*') "
		_cQry += "LEFT OUTER JOIN " + RetSQLName( 'SY1' ) + " SY1 ON (SY1.Y1_FILIAL = '" + xFilial( 'SY1' ) + "') AND (SY1.Y1_USER = SAJ.AJ_USER) AND (SY1.D_E_L_E_T_ <> '*') "
		_cQry += "WHERE (SC1.C1_FILIAL = '" + xFilial( 'SC1' ) + "') AND (SC1.C1_NUM = '" + _cNumSC + "') AND (SC1.D_E_L_E_T_ <> '*')"
		
		dbUseArea( .T., 'TOPCONN', TCGenQry(,,_cQry), 'TMPGRP', .T., .T. )
		
		_cUpd := "UPDATE SC1010 SET C1_NUM = 'ffffff' WHERE (SC1.C1_FILIAL = '" + xFilial( 'SC1' ) + "') AND  (C1_NUM = '" + _cNumSC + "') AND (D_E_L_E_T_ <> '*')"
		_lRet := TCSQLExec( _cUpd )
		
		TMPGRP->( dbGoTop() )
		_cGrupo := TMPGRP->B1_GRUPO
		
		While ! (TMPGRP->( Eof() ))
		   
		   SC1->( dbGoTo( TMPGRP->NREC ) )
		
		   If TMPGRP->B1_GRUPO <> _cGrupo
		
		      _nItem := 0
		      _cNumSC := GetNumSC1( .T. )
		      _cGrupo := TMPGRP->B1_GRUPO
		      SC1->( ConfirmSX8() )

           End		

		   _nItem ++
		   RecLock( 'SC1', .F. )

		   SC1->C1_NUM     := _cNumSC
		   SC1->C1_ITEM    := StrZero( _nItem, 4, 0 )
		   SC1->C1_CODCOMP := TMPGRP->Y1_COD
		   SC1->C1_APROV   := 'B'

		   SC1->( MSUnLock() )
		
		   TMPGRP->( dbSkip() )
		
		End
		
		TMPGRP->( dbCloseArea() )

	End
	
Return( NIL )