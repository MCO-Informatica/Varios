#Include 'Protheus.ch'

// Numero de titulos selecionados por vez para compensacao
#DEFINE N_NUMPROC	20

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
����������������������-��������������������������������������������������Ŀ��
���Fun�ao    �FINCER01 � Autor � Opvs (David)          � Data � 18/01/2013 ���
�����������������������-�������������������������������������������������Ĵ��
���Descri�ao � Rotina responsavel pela sele��o de titulos de vendas varejo���
���          � ou hardware avulso para compensa��o com RA                 ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function FINCER01()

Local cSqlE1	:= ""
Local cSqlRA	:= ""
Local aPergs	:= {}
Local lRet		:= .T.
Local aRetPar	:= {}
Local cDeE1		:= space(10)
Local cAtE1		:= space(10)
Local cDeRA		:= space(10)
Local cAtRA		:= space(10)

Local nTotRA	:= 0

Private oProcess

//Perguntas da rotina
aAdd( aPergs ,{9,"Informe o intervalo de datas de vencimento dos T�tulos de Vendas",100,20,.T.})   
aAdd( aPergs ,{1,"Vencto De:",space(8),"99/99/99","DtoC(CtoD(M->MV_PAR02))==M->MV_PAR02",,".T.",8,.T. })                                      
aAdd( aPergs ,{1,"Vencto At�:",space(8),"99/99/99","DtoC(CtoD(M->MV_PAR03))==M->MV_PAR03",,".T.",8,.T. })                                      
aAdd( aPergs ,{9,"Informe o intervalo de datas de emiss�o dos T�tulos do Tipo RA",100,20,.T.})   
aAdd( aPergs ,{1,"Emiss�o De:",space(8),"99/99/99","DtoC(CtoD(M->MV_PAR05))==M->MV_PAR05",,".T.",8,.T. })                                      
aAdd( aPergs ,{1,"Emiss�o At�:",space(8),"99/99/99","DtoC(CtoD(M->MV_PAR05))==M->MV_PAR05",,".T.",8,.T. })                                      

If ParamBox(aPergs ,"Par�metros para Compensa��o",@aRetPar)      
	lRet := .T.   
Else      
	lRet := .F.   
EndIf
                 
//Caso confirme a tela de par�metros realiza o processamento
If lRet

	cDeE1	:= DtoS( CtoD( aRetPar[2] ) ) //Data de Vencimento
	cAtE1	:= DtoS( CtoD( aRetPar[3] ) ) //Data At� Vencimento
	cDeRA	:= DtoS( CtoD( aRetPar[5] ) ) //Data de Emiss�o
	cAtRA	:= DtoS( CtoD( aRetPar[6] ) ) //Data At� Emiss�o                   
                                    
	oProcess := MsNewProcess():New( { |lEnd| lRet := ProcComp( @lEnd, cDeRA, cAtRA, cDeE1, cAtE1, nTotRA ) }, "@Compensa��o Vendas x RA", "Processos conclu�dos 1/4", .T. )
	oProcess:Activate()
	
	If lRet
		MsgInfo("Compensa��o realizada com sucesso")	
	EndIf                                                    
    
EndIf

Return(lRet)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ProcComp �Autor  � Gustavo Prudente   � Data �  21/01/13   ���
�������������������������������������������������������������������������͹��
���Descricao � Efetua o processamento das compensacoes                    ���
�������������������������������������������������������������������������͹��
���Uso       � Financeiro                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ProcComp( lEnd, cDeRA, cAtRA, cDeE1, cAtE1, nTotRA )

Local aRecE1	:= {}                                        
Local aRecRA	:= {}                                 
Local aLogRA	:= {}
Local aLogE1	:= {}

Local nCont		:= 0       
Local nProc		:= 1

Local lRet		:= .T.                        
Local lTemRA	:= .T.                        
Local lTemSE1	:= .T.                        

Local cWhereRA	:= ""                                             
Local cWhereE1	:= ""

Local nHandle	:= 0

// Cria e abre arquivo de gravacao do log dos titulos a processar
If ! FGERLog( 1, @nHandle )
	Return .F. 
EndIf

oProcess:SetRegua1( 4 )
oProcess:IncRegua1( "Processos conclu�dos 1/4" )

// Busca total de titulos de RA
cSqlRA		:= ""
cSqlRA		+= " SELECT COUNT( R_E_C_N_O_ ) TOTRA "
cSqlRA		+= " FROM " + RetSqlName("SE1")

cWhereRA	:= " WHERE "
cWhereRA	+= "   E1_FILIAL = '" + xFilial("SE1") + "' AND "
cWhereRA	+= "   E1_TIPO = 'RA' AND "	
cWhereRA	+= "   E1_EMISSAO BETWEEN '" + cDeRA + "' AND '" + cAtRA + "' AND "
cWhereRA	+= "   E1_SALDO > 0 AND "  
cWhereRA	+= "   E1_PORTADO = '341' AND "
cWhereRA	+= "   D_E_L_E_T_ = ' ' "

cSqlRA		+= cWhereRA

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSqlRA),"QRYTOT",.F.,.T.)
                    
nTotRA := QRYTOT->TOTRA

QRYTOT->( dbCloseArea() )

lRet := ( nTotRA > 0 )

If ! lRet
	MsgAlert("N�o Foram Encontrados T�tulos do Tipo RA para o Par�metros de Emiss�o Informados. Por Favor, Verifique!")
	Return lRet
EndIF	

oProcess:SetRegua2( nTotRA )                                                  
oProcess:IncRegua2( "T�itulos de RA processados: " + AllTrim( Str( nProc ) ) )

oProcess:IncRegua1( "Processos conclu�dos 2/4" )
                               
// Busca total de titulos de Nota Fiscal
cSqlE1		:= ""
cSqlE1		+= " SELECT COUNT( R_E_C_N_O_ ) TOTE1 "
cSqlE1		+= " FROM " + RetSqlName("SE1")

cWhereE1	:= " WHERE "
cWhereE1	+= "   E1_FILIAL = '"+xFilial("SE1")+"' AND "
cWhereE1	+= "   E1_TIPO = 'NF' AND "
cWhereE1	+= "   E1_SALDO > 0 AND "
cWhereE1	+= "   E1_VENCTO BETWEEN '" + cDeE1 + "' AND '" + cAtE1 + "' AND "
cWhereE1	+= "   ( E1_PEDGAR > ' ' or E1_XNPSITE > ' ' ) AND "
cWhereE1	+= "   E1_TIPMOV = '1' AND "
cWhereE1	+= "   D_E_L_E_T_ = ' ' "

cSqlE1		+= cWhereE1
	
dbUseArea( .T., "TOPCONN", TcGenQry(,,cSqlE1), "QRYTOT", .F., .T. )
    
lRet := ( QRYTOT->TOTE1 > 0 )

QRYTOT->( dbCloseArea() )	    
          
If ! lRet
	MsgAlert("N�o Foram Encontrados T�tulos para o Par�metros de Vencimento Informados.Por Favor, Verifique!")
   	Return lRet
EndIf          

oProcess:IncRegua1( "Processos conclu�dos 3/4" )

Do While lTemRA .And. lTemSE1
                              
	If lEnd                                
		MsgInfo( cCancela, "Fim" )
		Exit
	EndIf
	
	aRecE1	:= {}              
	aRecRA	:= {}
	
	//Query para sele��o de RA
	cSqlRA	:= ""
	cSqlRA	+= " SELECT R_E_C_N_O_ E1RA "
	cSqlRA	+= " FROM " + RetSqlName("SE1")
	cSqlRA	+= cWhereRA + " AND "
	cSqlRA	+= " ROWNUM <= " + AllTrim( Str( N_NUMPROC ) ) + " "	// Limita o processamento de compensacao - performance
	cSqlRA  += " ORDER BY E1_EMISSAO "

	dbUseArea( .T., "TOPCONN", TcGenQry(,,cSqlRA), "QRYRA", .F., .T. )

	lTemRA := QRYRA->( ! EoF() )

	If lTemRA
		
		//Query para sele��o de t�tulos de venda varejo ou hardware avulso
		cSqlE1	:= ""
		cSqlE1	+= " SELECT R_E_C_N_O_ E1REC "
		cSqlE1	+= " FROM " + RetSqlName("SE1")
		cSqlE1	+= cWhereE1 + " AND "
		cSqlE1	+= " ROWNUM <= " + AllTrim( Str( N_NUMPROC ) ) + " "	// Limita o processamento de compensacao - performance
		cSqlE1  += " ORDER BY E1_EMISSAO "

		dbUseArea( .T., "TOPCONN", TcGenQry(,,cSqlE1), "QRYSE1", .F., .T. )
			
		lTemSE1 := QRYSE1->( ! EoF() )
		
		If lTemSE1

			QRYRA->(  DbEval( {|lEnd| Aadd( aRecRA, QRYRA->E1RA   ) } ) )		// Monta array com RAs
			QRYSE1->( DbEval( {|lEnd| Aadd( aRecE1, QRYSE1->E1REC ) } ) )		// Monta array com Titulos a Receber
			                  
			// Grava log dos titulos a processar
			FGERLog( 2, nHandle, aRecRA, aRecE1 )
			
			If ! lEnd         
				//executa rotina para compensacao 
				lRet := MaIntBxCR( 3, aRecE1,, aRecRA,, {.F.,.F.,.F.,.F.,.F.,.F.},,,,, dDatabase )
			EndIf                   
        
			For nCont := 1 To Len( aRecRA )
				If aRecRA[ nCont ] == 0                                          
					nProc ++
					oProcess:IncRegua2( "T�itulos de RA processados: " + AllTrim( Str( nProc ) ) )
				EndIf
			Next nProc
			
		EndIf

		QRYSE1->( DbCloseArea() )

	EndIf                                                  
	
	QRYRA->( DbCloseArea() )
	
EndDo    
                    
oProcess:IncRegua2( "T�itulos de RA processados: " + AllTrim( Str( nProc ) ) )

FGERLog( 3, nHandle )	// Fecha arquivo de log

oProcess:IncRegua1( "Processos conclu�dos 4/4" )
    
Return lRet



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FINCER01  �Autor  �Microsiga           � Data �  01/24/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FGERLog( nTipo, nHandle, aRecRA, aRecE1 )

Local nX 		:= 0               

Local cProcRA	:= ""
Local cProcE1	:= ""
Local cFile		:= ""
Local lRet		:= .T.
Local nError	:= 0

Default nTipo := 0

If nTipo == 1	// Cria

	cFile := Criatrab(,.F.) + "CMP.LOG"           
                       
	nHandle := fCreate( cFile )

	If nHandle < 0                                                                           
		nError := fError()                                                      
		MsgAlert( "Nao foi possivel criar o arquivo de Log " + cFile + ". Erro numero: " + PadR( Str( nError ), 4 ) )
		lRet := .F.
	Else
		fClose( nHandle )
	EndIf	
                    
	If lRet

		nHandle := fOpen( cFile, 2 )
		
		If nHandle == -1 .Or. Empty( cFile )
			MsgStop( "N�o foi poss�vel abrir o arquivo de log. Processo finalizado." )
			lRet := .F.
		Else				
			fSeek(  nHandle, 0, 2 )     // Posiciona no final do arquivo
			fWrite( nHandle, "Log de processamento - Compensa��o Vendas x RA - " + DtoC( Date() ) + CRLF )
		EndIf

	EndIf

ElseIf nTipo == 2		// Grava

	// Grava log de titulos de RA
	For nX := 1 To Len( aRecRA )
		cProcRA += "'" + AllTrim( Str( aRecRA[ nX ] ) ) + "', "
	Next nX
	
	// Grava log de titulos de vendas
	For nX := 1 To Len( aRecE1 )
		cProcE1 += "'" + AllTrim( Str( aRecE1[ nX ] ) ) + "', "
	Next nX
	
	cProcE1 := SubStr( cProcE1, 1, Len( cProcE1 ) - 1 )
	                             
	fSeek(  nHandle, 0, 2 )     // Posiciona no final do arquivo
	fWrite( nHandle, CRLF + Time() + " - Registros Processados:" + CRLF + cProcRA + CRLF + cProcE1 + CRLF )

ElseIf nTipo == 3		// Fecha

	fClose( nHandle )
	
EndIf

Return lRet