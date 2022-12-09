User Function ProdFHM()
          
If cFilAnt = '0101' // THM
   cCod := '0001'
ElseIf cFilAnt = '0102' // THF
   cCod := '0279'
ElseIf cFilAnt = '0201' // TWM
   cCod := '0150'
ElseIf cFilAnt = '0202' // TWF
   cCod := '0411'
Else 
   cCod := '0000'
End 

_cFilSB1 := xFilial( 'SB1' )

_cQryIt := 'select lce.codlanc D1_ITEM, codprod D1_COD, codunicom D1_UM, quantida D1_QUANT, vlruni  D1_VUNIT,lce.chave PK_Idx,'
_cQryIt += 'vlrmerc D1_TOTAL, icmsbas D1_BASEICM, icmsvlr D1_VALICM, staicms D1_ORIGEM, stbicms D1_CSTICM,'
_cQryIt += 'ipibas D1_BASEIPI, icmsali D1_PICM, ipivlr D1_VALIPI, sittribipi D1_CSTIPI, lce.cfop D1_CF, stbas  D1_BRICMS,'
_cQryIt += 'icmsst D1_ICMSRET, out_cofins D1_BASIMP5, out_alicof D1_ALQIMP5, out_valcof D1_VALIMP5,'
_cQryIt += 'out_stpis  D1_CSTPIS,out_baspis D1_BASIMP6,out_alipis D1_ALQIMP6,out_valpis D1_VALIMP6,out_stcof D1_CSTCOF'
_cQryIt += ' from [lcereg54' + cCod + '] lce'
_cQryIt += ' left outer join [nfentrad' + cCod + '] nfe onadmin	 nfe.chave = lce.chave'
_cQryIt += " where nfe.dtdocum > '2014-00-00' " // and nfe.chave"
//    _cQryIt += " where lce.chave = '" + CAB->PK_Idx + "'"

_cQryIt := "SELECT DISTINCT  D1_COD, B1_DESC, D1_DESCR, SUBSTRING(D1_CLASFIS,1,1) D1_ORIGEM, SUBSTRING(D1_CLASFIS,2,2) D1_CSTICM, D1_CLASFIS "
_cQryIt += "FROM SD1010 SD1 LEFT OUTER JOIN SB1010 SB1 ON D1_COD = B1_COD AND SB1.D_E_L_E_T_ = '' WHERE SD1.D_E_L_E_T_ = '' AND B1_DESC IS NULL"


dbUseArea( .T.,"TOPCONN",TcGenQry(,,_cQryIt),"ITE",.T.,.T.)
                                                                                         
While ! ( ITE->( Eof() ) )

   cProduto   := ITE->D1_COD

   If  ! ( SB1->( dbSeek( _cFilSB1 + cProduto, .F. ) )  )

        _cCST    := ITE->D1_ORIGEM
        _cCST    += ITE->D1_CSTICM

       RecLock( 'SB1', .T. )
   
       SB1->B1_COD  := cProduto
       SB1->B1_TIPO := 'PA'
       SB1->B1_LOCPAD := '01'
       SB1->B1_ORIGEM := Substr( _cCST, 1, 1 )
       SB1->B1_GARANT := '2'
       SB1->( dbUnLock() )   
           
       _cUpd := "update SB1010 SET B1_DESC = descricao, B1_UM = codunicom, B1_POSIPI = replace(nbmsh,'.','') from PROD_FHM PRO where B1_COD = '" 
       _cUpd += cProduto + "' and PRO.codigo = '"+ cProduto + "'"
        tcsqlexec( _cUpd )

   End

   ITE->( dbSkip() )

End

ITE->( dbCloseArea() )

Return( NIL )