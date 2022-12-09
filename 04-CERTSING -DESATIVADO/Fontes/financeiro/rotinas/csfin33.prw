#Include "Protheus.ch"
#Include "topconn.ch"
#Include "TbiConn.ch"

//Função para Baixa de títulos não compensados regularmente por compensação, sem contabilização (MOTIVO BNC)
User Function csfin33()

Local lJob 		:= ( Select( "SX6" ) == 0 )
Local cJobMod 	:= 'FIN'
Local cJobEmp	:= '01'
Local cJobFil	:= '02'

Local cTrb	  := GetNextAlias()
Local cEmisDe := '20210601'  //'20210301'
Local cEmisAt := '20210706'  //'20210401'

Local nRecIn  := 0

	If lJob
		RpcSetType( 3 )
		RpcSetEnv( cJobEmp, cJobFil, , , cJobMod )
	EndIf

	cSql := "SELECT MIN(R_E_C_N_O_) RECMIN FROM "+RetSqlName("SE5")+" E5 "
   cSql += "WHERE E5_FILIAL = '"+xFilial("SE5")+"' "
   cSql += "AND E5_DATA >= '"+cEmisDe+"' AND E5_DATA <= '"+cEmisAt+"' AND D_E_L_E_T_ = ' ' "
	
   cSql := ChangeQuery( cSql )
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cTrb,.F.,.T.)
	if !(cTrb)->( Eof() )
       nRecIn  := (ctrb)->recmin
    endif
	(cTrb)->( dbCloseArea() )
	FErase( cTrb + GetDBExtension() )

    if nRecIn > 0
       Conout( "INICIO EXECUÇÃO BuscaTit - "+dtoc(date())+"-"+time() )
       BuscaTit(nRecIn)
       Conout( "FIM EXECUÇÃO BuscaTit - "+dtoc(date())+"-"+time() )
       Conout( "INICIO EXECUÇÃO BuscaNat - "+dtoc(date())+"-"+time() )
       BuscaNat(nRecIn)
       Conout( "FIM EXECUÇÃO BuscaNat - "+dtoc(date())+"-"+time() )
    endif

Return

Static Function BuscaTit(nRecIn)
Local cSql := ""
Local cTrb := GetNextAlias()
Local cTmp := GetNextAlias()
Local cTmp1:= GetNextAlias()

    cSql := "SELECT * FROM ( "
    cSql += "SELECT /*+ INDEX(E5 "+RetSqlName("SE5")+"_PK) */ E5.R_E_C_N_O_ RECSE5,E5_PREFIXO PREF,E5_NUMERO,E5_PARCELA PAR,E5_TIPO,E5_CLIFOR CLI,"
    //cSql += "SELECT E5.R_E_C_N_O_ RECSE5,E5_PREFIXO PREF,E5_NUMERO,E5_PARCELA PAR,E5_TIPO,E5_CLIFOR CLI,"
    cSql += "E5_LOJA LJ,E5_VALOR,E5_MOTBX,E5_DOCUMEN,E5_DATA,E5_IDORIG,E5_TABORI,"
    cSql += "(SELECT E1_EMISSAO FROM "+RetSqlName("SE1")+" E11 WHERE E1_FILIAL = E5_FILIAL AND E1_PREFIXO = E5_PREFIXO AND E1_NUM = E5_NUMERO AND E1_PARCELA = E5_PARCELA AND E1_TIPO = E5_TIPO AND E11.D_E_L_E_T_ = ' ') EMITIT,"
    cSql += "(SELECT E1_EMISSAO FROM "+RetSqlName("SE1")+" E12 WHERE E1_FILIAL = E5_FILIAL AND E1_PREFIXO = E5_PREFIXO AND E1_NUM = E5_NUMERO AND E1_PARCELA = E5_PARCELA AND E1_TIPO = 'PR' AND E12.D_E_L_E_T_ = ' ') EMIPR,"
    cSql += "(SELECT MAX(E1_EMISSAO) FROM "+RetSqlName("SE1")+" E13 WHERE E1_FILIAL = E5_FILIAL AND E1_PEDIDO = SUBSTR(E5_NUMERO,1,6) AND E1_TIPO = 'NF' AND E13.D_E_L_E_T_ = ' ') EMINF "
    cSql += "FROM "+RetSqlName("SE5")+" E5 "
    cSql += "WHERE R_E_C_N_O_ >= "+str(nRecIn)+" AND E5_FILIAL = '"+xFilial("SE5")+"' AND E5_TIPO = 'NCC' AND E5.D_E_L_E_T_ = ' ' AND E5_MOTBX != ' ' AND E5_DOCUMEN != ' ' "
    //cSql += "WHERE E5_FILIAL = ' ' AND E5_PREFIXO = 'RCP' AND E5_NUMERO IN ('9GXH98','9GXLGB','9GXOX2','9GWYEF','9GXIM6','9GXHV6','9GXJZI','9GXFUS','9GXFFZ','9GXDBK','9GXEFM','9HFWTY','9GWZR4','9GXPVC') AND E5_TIPO = 'NCC' AND E5.D_E_L_E_T_ = ' ' AND E5_MOTBX != ' ' AND E5_DOCUMEN != ' ' "
    cSql += ") "
    //cSql += ") WHERE (E5_DATA = EMIPR OR E5_DATA = EMINF) AND E5_DATA < EMITIT "
    //cSql += ") WHERE E5_DATA = EMIPR AND E5_DATA < EMITIT"
    //cSql += ") WHERE E5_DATA = EMIPR "

    cSql := ChangeQuery( cSql )
	 dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cTrb,.F.,.T.)
    Conout( "INICIO PROCESSAMENTO BuscaTit - "+dtoc(date())+"-"+time() )
    While !(cTrb)->( Eof() )
      
      //if (cTrb)->e5_data == (cTrb)->emipr .and. (cTrb)->e5_data < (cTrb)->emitit 
      if ( (cTrb)->e5_data == (cTrb)->emipr .or. (cTrb)->e5_data = (cTrb)->eminf ) .and. (cTrb)->e5_data < (cTrb)->emitit 

         SE5->( dbGoTo( (cTrb)->recse5 ) )

         SE5->( RecLock( "SE5", .F. ) )
         SE5->E5_DATA    := stod('20210706')
         SE5->E5_DTDIGIT := stod('20210706')
         SE5->E5_DTDISPO := stod('20210706')
         SE5->(MsUnLock())

         if SE5->E5_TABORI == "FK1"
            cSql := "SELECT R_E_C_N_O_ RECFK1 FROM "+RetSqlName("FK1")+" WHERE FK1_FILIAL = '"+xFilial("FK1")+"' "
            cSql += "AND FK1_IDFK1 = '"+SE5->E5_IDORIG+"' AND D_E_L_E_T_ = ' ' "

            cSql := ChangeQuery( cSql )
            dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cTmp,.F.,.T.)
            if !(cTmp)->( Eof() )

               FK1->( dbGoTo( (cTmp)->recfk1 ) )

               FK1->( RecLock( "FK1", .F. ) )
               FK1->FK1_DATA   := stod('20210706')
               FK1->FK1_DTDIGI := stod('20210706')
               FK1->FK1_DTDISP := stod('20210706')
               FK1->(MsUnLock())
            endif
            (cTmp)->( dbCloseArea() )
            FErase( cTmp + GetDBExtension() )
         elseif SE5->E5_TABORI == "FK5"
            cSql := "SELECT R_E_C_N_O_ RECFK5 FROM "+RetSqlName("FK5")+" WHERE FK5_FILIAL = '"+xFilial("FK5")+"' "
            cSql += "AND FK5_IDMOV = '"+SE5->E5_IDORIG+"' AND D_E_L_E_T_ = ' ' "

            cSql := ChangeQuery( cSql )
            dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cTmp,.F.,.T.)
            if !(cTmp)->( Eof() )

               FK5->( dbGoTo( (cTmp)->recfk5 ) )

               FK5->( RecLock( "FK1", .F. ) )
               FK5->FK5_DATA   := stod('20210706')
               FK5->FK5_DTDISP := stod('20210706')
               FK5->(MsUnLock())
            endif
            (cTmp)->( dbCloseArea() )
            FErase( cTmp + GetDBExtension() )
         endif
         Conout( "PROCESSAMENTO BuscaTit TITULO: "+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA )

         cSql := "SELECT E5.R_E_C_N_O_ RECSE5 FROM "+RetSqlName("SE5")+" E5 "
         cSql += "WHERE E5_FILIAL = '"+xFilial("SE5")+"' AND E5_PREFIXO = '"+substr(se5->e5_documen,1,3)+"' "
         cSql += "AND E5_NUMERO = '"+substr(se5->e5_documen,4,9)+"' AND E5_PARCELA = '"+substr(se5->e5_documen,13,2)+"' "
         cSql += "AND E5_TIPO = '"+substr(se5->e5_documen,15,3)+"' "
         cSql += "AND E5_CLIFOR = '"+se5->e5_clifor+"' AND E5_LOJA = '"+se5->e5_loja+"' AND E5.D_E_L_E_T_ = ' ' "
         cSql += "AND E5_DOCUMEN = '"+se5->e5_prefixo+se5->e5_numero+se5->e5_parcela+se5->e5_tipo+substr((cTrb)->e5_documen,18,2)+"' "

         cSql := ChangeQuery( cSql )
         dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cTmp,.F.,.T.)
         While !(cTmp)->( Eof() )

            SE5->( dbGoTo( (cTmp)->recse5 ) )

            SE5->( RecLock( "SE5", .F. ) )
            SE5->E5_DATA    := stod('20210706')
            SE5->E5_DTDIGIT := stod('20210706')
            SE5->E5_DTDISPO := stod('20210706')
            SE5->(MsUnLock())

            if SE5->E5_TABORI == "FK1"
               cSql := "SELECT R_E_C_N_O_ RECFK1 FROM "+RetSqlName("FK1")+" WHERE FK1_FILIAL = '"+xFilial("FK1")+"' "
               cSql += "AND FK1_IDFK1 = '"+SE5->E5_IDORIG+"' AND D_E_L_E_T_ = ' ' "

               cSql := ChangeQuery( cSql )
               dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cTmp1,.F.,.T.)
               if !(cTmp1)->( Eof() )
                    
                  FK1->( dbGoTo( (cTmp1)->recfk1 ) )

                  FK1->( RecLock( "FK1", .F. ) )
                  FK1->FK1_DATA   := stod('20210706')
                  FK1->FK1_DTDIGI := stod('20210706')
                  FK1->FK1_DTDISP := stod('20210706')
                  FK1->(MsUnLock())
               endif
               (cTmp1)->( dbCloseArea() )
               FErase( cTmp1 + GetDBExtension() )
            elseif SE5->E5_TABORI == "FK5"
               cSql := "SELECT R_E_C_N_O_ RECFK5 FROM "+RetSqlName("FK5")+" WHERE FK5_FILIAL = '"+xFilial("FK5")+"' "
               cSql += "AND FK5_IDMOV = '"+SE5->E5_IDORIG+"' AND D_E_L_E_T_ = ' ' "

               cSql := ChangeQuery( cSql )
               dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cTmp1,.F.,.T.)
               if !(cTmp1)->( Eof() )

                  FK5->( dbGoTo( (cTmp1)->recfk5 ) )

                  FK5->( RecLock( "FK5", .F. ) )
                  FK5->FK5_DATA   := stod('20210706')
                  FK5->FK5_DTDISP := stod('20210706')
                  FK5->(MsUnLock())
               endif
               (cTmp1)->( dbCloseArea() )
               FErase( cTmp1 + GetDBExtension() )
            endif
            Conout( "PROCESSAMENTO BuscaTit TITULO: "+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA )

            (cTmp)->( dbSkip() )
         end

         (cTmp)->( dbCloseArea() )
         FErase( cTmp + GetDBExtension() )
      endif
      
      (cTrb)->( dbSkip() )
	end

	(cTrb)->( dbCloseArea() )
	FErase( cTrb + GetDBExtension() )

Return

Static Function BuscaNat(nRecIn)
Local cSql := ""
Local cTrb := GetNextAlias()
Local cTmp := GetNextAlias()

    cSql := "SELECT * FROM ( "
    cSql += "SELECT /*+ INDEX(E5 "+RetSqlName("SE5")+"_PK) */ E5.R_E_C_N_O_ RECSE5,E5_PREFIXO PREF,E5_NUMERO,E5_PARCELA PAR,E5_TIPO,E5_CLIFOR CLI,E5_LOJA LJ,E5_VALOR,E5_MOTBX,E5_DOCUMEN,E5_DATA,E5_NATUREZ,"
    //cSql += "SELECT E5.R_E_C_N_O_ RECSE5,E5_PREFIXO PREF,E5_NUMERO,E5_PARCELA PAR,E5_TIPO,E5_CLIFOR CLI,E5_LOJA LJ,E5_VALOR,E5_MOTBX,E5_DOCUMEN,E5_DATA,E5_NATUREZ,"
    cSql += "(SELECT E1_NATUREZ FROM "+RetSqlName("SE1")+" E1 WHERE E1_FILIAL = E5_FILIAL AND E1_PREFIXO = E5_PREFIXO AND E1_NUM = E5_NUMERO AND E1_PARCELA = E5_PARCELA AND E1_TIPO = E5_TIPO AND E1.D_E_L_E_T_ = ' ' ) NATSE1 "
    cSql += "FROM "+RetSqlName("SE5")+" E5 "
    cSql += "WHERE R_E_C_N_O_ > "+str(nRecIn)+" AND E5_FILIAL = '"+xFilial("SE5")+"' AND E5.D_E_L_E_T_ = ' ' AND E5_MOTBX != ' ' "
    //cSql += "WHERE E5_FILIAL = ' ' AND E5_PREFIXO = 'RCP' AND E5_NUMERO IN ('9GXH98','9GXLGB','9GXOX2','9GWYEF','9GXIM6','9GXHV6','9GXJZI','9GXFUS','9GXFFZ','9GXDBK','9GXEFM','9HFWTY','9GWZR4','9GXPVC') AND E5_TIPO = 'NCC' AND E5.D_E_L_E_T_ = ' ' AND E5_MOTBX != ' ' "
    cSql += " ) "
    //cSql += " ) WHERE E5_NATUREZ != NATSE1 "

	 cSql := ChangeQuery( cSql )
	 dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cTrb,.F.,.T.)
    Conout( "INICIO PROCESSAMENTO BuscaNat - "+dtoc(date())+"-"+time() )
    While !(cTrb)->( Eof() )

      if (cTrb)->E5_NATUREZ != (cTrb)->NATSE1
      
         SE5->( dbGoTo( (cTrb)->recse5 ) )
        
         SE5->( RecLock( "SE5", .F. ) )
         SE5->E5_NATUREZ := (cTrb)->NATSE1
         SE5->(MsUnLock())

         if SE5->E5_TABORI == "FK1"
            cSql := "SELECT R_E_C_N_O_ RECFK1 FROM "+RetSqlName("FK1")+" WHERE FK1_FILIAL = '"+xFilial("FK1")+"' "
            cSql += "AND FK1_IDFK1 = '"+SE5->E5_IDORIG+"' AND D_E_L_E_T_ = ' ' "

            cSql := ChangeQuery( cSql )
            dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cTmp,.F.,.T.)
            if !(cTmp)->( Eof() )
                    
               FK1->( dbGoTo( (cTmp)->recfk1 ) )

               FK1->( RecLock( "FK1", .F. ) )
               FK1->FK1_NATURE := (cTrb)->NATSE1
               FK1->(MsUnLock())
            endif
            (cTmp)->( dbCloseArea() )
            FErase( cTmp + GetDBExtension() )
         elseif SE5->E5_TABORI == "FK5"
            cSql := "SELECT R_E_C_N_O_ RECFK5 FROM "+RetSqlName("FK5")+" WHERE FK5_FILIAL = '"+xFilial("FK5")+"' "
            cSql += "AND FK5_IDMOV = '"+SE5->E5_IDORIG+"' AND D_E_L_E_T_ = ' ' "

            cSql := ChangeQuery( cSql )
            dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cTmp,.F.,.T.)
            if !(cTmp)->( Eof() )

               FK5->( dbGoTo( (cTmp)->recfk5 ) )

               FK5->( RecLock( "FK5", .F. ) )
               FK5->FK5_NATURE := (cTrb)->NATSE1
               FK5->(MsUnLock())
            endif
            (cTmp)->( dbCloseArea() )
            FErase( cTmp + GetDBExtension() )
         endif

         Conout( "PROCESSAMENTO BuscaNat TITULO: "+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA )

      endif

      (cTrb)->( dbSkip() )
	end

	(cTrb)->( dbCloseArea() )
	FErase( cTrb + GetDBExtension() )

Return
