#Include 'Protheus.ch'

//+-----------------------------------------------------------------------+
//| Rotina | CSGCTXFUN | Autor | Rafael Beghini | Data | 13.06.2018 
//+-----------------------------------------------------------------------+
//| Descr. | FONTE CRIADO PARA MANUTENÇÕES DIVERSAS NO MÓDULO DE CONTRATOS
//+-----------------------------------------------------------------------+
//| Uso    | CertiSign Certificadora Digital
//+-----------------------------------------------------------------------+

//Realiza o insert na tabela CNN para a operação [047 Contratos - Banco de Conhec.]
User Function CSUpdCnn()
    Processa( {|| A010Proc() }, "Criando registro [047 Contratos - Banco de Conhec.]", "Processando aguarde...", .F.)
Return
Static Function A010Proc()
    Local cSQL      := ''
    Local cTRB      := ''
    Local cCount    := ''
    Local nCount    := 0
    Local nLin      := 0

    cSQL += "SELECT CNN.* " + CRLF
    cSQL += "FROM   " + RetSqlName('CNN') + " CNN " + CRLF
    cSQL += "       INNER JOIN " + RetSqlName('CN9') + " CN9 " + CRLF
    cSQL += "               ON CN9_FILIAL = CNN_FILIAL " + CRLF
    cSQL += "                  AND CN9_NUMERO = CNN_CONTRA " + CRLF
    cSQL += "                  AND CN9_SITUAC = '05' " + CRLF
    cSQL += "                  AND CN9.D_E_L_E_T_ = ' ' " + CRLF
    cSQL += "WHERE  CNN.D_E_L_E_T_ = ' ' " + CRLF
    cSQL += "       AND CNN_TRACOD = '038' " + CRLF
    cSQL += "       AND NOT EXISTS (SELECT * " + CRLF
    cSQL += "                       FROM   " + RetSqlName('CNN') + " X " + CRLF
    cSQL += "                       WHERE  X.D_E_L_E_T_ = ' ' " + CRLF
    cSQL += "                              AND X.CNN_FILIAL = CNN.CNN_FILIAL " + CRLF
    cSQL += "                              AND X.CNN_CONTRA = CNN.CNN_CONTRA " + CRLF
    cSQL += "                              AND X.CNN_TRACOD = '047' " + CRLF
    cSQL += "                              AND X.CNN_GRPCOD = CNN.CNN_GRPCOD " + CRLF
    cSQL += "                              AND X.CNN_USRCOD = CNN.CNN_USRCOD)" + CRLF

    cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	
	cCount := ' SELECT COUNT(*) COUNT FROM ( ' + cSQL + ' ) QUERY '
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cCount),cTRB,.F.,.T.)
	nCount := (cTRB)->COUNT
	(cTRB)->( dbCloseArea() )
	FErase( cTRB + GetDBExtension() )
	
	ProcRegua( nCount )

	cTRB := GetNextAlias()
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.F.,.T.)

    IF .NOT. (cTRB)->( EOF() )
        Begin Transaction
            While .NOT. (cTRB)->( EOF() )
                nLin++
                IncProc( "Atualizando registro " + cValToChar( nLin ) + ' de ' + cValToChar( nCount ) )
                
                    CNN->( RecLock('CNN',.T.) )
                    CNN->CNN_FILIAL := (cTRB)->CNN_FILIAL
                    CNN->CNN_CONTRA := (cTRB)->CNN_CONTRA
                    CNN->CNN_USRCOD := (cTRB)->CNN_USRCOD
                    CNN->CNN_GRPCOD := (cTRB)->CNN_GRPCOD
                    CNN->CNN_TRACOD := '047' //Contratos - Banco de Conhec.
                    CNN->( MsUnLock() )

                (cTRB)->( dbSkip() )
            End
        End Transaction
        MsgInfo('Processo finalizado, por favor verifique.','CSUpdCnn')
	Else
        MsgAlert('Não há dados para processar.','CSUpdCnn')
    EndIF
	(cTRB)->( dbCloseArea() )
	FErase( cTRB + GetDBExtension() )
Return