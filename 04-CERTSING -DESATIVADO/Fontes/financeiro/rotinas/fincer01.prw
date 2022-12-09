#Include 'Protheus.ch'

// Numero de titulos selecionados por vez para compensacao
#DEFINE N_NUMPROC	20

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤ-ฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFunao    ณFINCER01 ณ Autor ณ Opvs (David)          ณ Data ณ 18/01/2013 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤ-มฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescriao ณ Rotina responsavel pela sele็ใo de titulos de vendas varejoณฑฑ
ฑฑณ          ณ ou hardware avulso para compensa็ใo com RA                 ณฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
aAdd( aPergs ,{9,"Informe o intervalo de datas de vencimento dos Tํtulos de Vendas",100,20,.T.})   
aAdd( aPergs ,{1,"Vencto De:",space(8),"99/99/99","DtoC(CtoD(M->MV_PAR02))==M->MV_PAR02",,".T.",8,.T. })                                      
aAdd( aPergs ,{1,"Vencto At้:",space(8),"99/99/99","DtoC(CtoD(M->MV_PAR03))==M->MV_PAR03",,".T.",8,.T. })                                      
aAdd( aPergs ,{9,"Informe o intervalo de datas de emissใo dos Tํtulos do Tipo RA",100,20,.T.})   
aAdd( aPergs ,{1,"Emissใo De:",space(8),"99/99/99","DtoC(CtoD(M->MV_PAR05))==M->MV_PAR05",,".T.",8,.T. })                                      
aAdd( aPergs ,{1,"Emissใo At้:",space(8),"99/99/99","DtoC(CtoD(M->MV_PAR05))==M->MV_PAR05",,".T.",8,.T. })                                      

If ParamBox(aPergs ,"Parโmetros para Compensa็ใo",@aRetPar)      
	lRet := .T.   
Else      
	lRet := .F.   
EndIf
                 
//Caso confirme a tela de parโmetros realiza o processamento
If lRet

	cDeE1	:= DtoS( CtoD( aRetPar[2] ) ) //Data de Vencimento
	cAtE1	:= DtoS( CtoD( aRetPar[3] ) ) //Data At้ Vencimento
	cDeRA	:= DtoS( CtoD( aRetPar[5] ) ) //Data de Emissใo
	cAtRA	:= DtoS( CtoD( aRetPar[6] ) ) //Data At้ Emissใo                   
                                    
	oProcess := MsNewProcess():New( { |lEnd| lRet := ProcComp( @lEnd, cDeRA, cAtRA, cDeE1, cAtE1, nTotRA ) }, "@Compensa็ใo Vendas x RA", "Processos concluํdos 1/4", .T. )
	oProcess:Activate()
	
	If lRet
		MsgInfo("Compensa็ใo realizada com sucesso")	
	EndIf                                                    
    
EndIf

Return(lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ProcComp บAutor  ณ Gustavo Prudente   บ Data ณ  21/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Efetua o processamento das compensacoes                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Financeiro                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
oProcess:IncRegua1( "Processos concluํdos 1/4" )

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
	MsgAlert("Nใo Foram Encontrados Tํtulos do Tipo RA para o Parโmetros de Emissใo Informados. Por Favor, Verifique!")
	Return lRet
EndIF	

oProcess:SetRegua2( nTotRA )                                                  
oProcess:IncRegua2( "Tํitulos de RA processados: " + AllTrim( Str( nProc ) ) )

oProcess:IncRegua1( "Processos concluํdos 2/4" )
                               
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
	MsgAlert("Nใo Foram Encontrados Tํtulos para o Parโmetros de Vencimento Informados.Por Favor, Verifique!")
   	Return lRet
EndIf          

oProcess:IncRegua1( "Processos concluํdos 3/4" )

Do While lTemRA .And. lTemSE1
                              
	If lEnd                                
		MsgInfo( cCancela, "Fim" )
		Exit
	EndIf
	
	aRecE1	:= {}              
	aRecRA	:= {}
	
	//Query para sele็ใo de RA
	cSqlRA	:= ""
	cSqlRA	+= " SELECT R_E_C_N_O_ E1RA "
	cSqlRA	+= " FROM " + RetSqlName("SE1")
	cSqlRA	+= cWhereRA + " AND "
	cSqlRA	+= " ROWNUM <= " + AllTrim( Str( N_NUMPROC ) ) + " "	// Limita o processamento de compensacao - performance
	cSqlRA  += " ORDER BY E1_EMISSAO "

	dbUseArea( .T., "TOPCONN", TcGenQry(,,cSqlRA), "QRYRA", .F., .T. )

	lTemRA := QRYRA->( ! EoF() )

	If lTemRA
		
		//Query para sele็ใo de tํtulos de venda varejo ou hardware avulso
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
					oProcess:IncRegua2( "Tํitulos de RA processados: " + AllTrim( Str( nProc ) ) )
				EndIf
			Next nProc
			
		EndIf

		QRYSE1->( DbCloseArea() )

	EndIf                                                  
	
	QRYRA->( DbCloseArea() )
	
EndDo    
                    
oProcess:IncRegua2( "Tํitulos de RA processados: " + AllTrim( Str( nProc ) ) )

FGERLog( 3, nHandle )	// Fecha arquivo de log

oProcess:IncRegua1( "Processos concluํdos 4/4" )
    
Return lRet



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFINCER01  บAutor  ณMicrosiga           บ Data ณ  01/24/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
			MsgStop( "Nใo foi possํvel abrir o arquivo de log. Processo finalizado." )
			lRet := .F.
		Else				
			fSeek(  nHandle, 0, 2 )     // Posiciona no final do arquivo
			fWrite( nHandle, "Log de processamento - Compensa็ใo Vendas x RA - " + DtoC( Date() ) + CRLF )
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