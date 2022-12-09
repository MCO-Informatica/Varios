#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"            
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³EXECMENU  ³ Autor ³ RICARDO CAVALINI      ³ Data ³25/01/2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ MENU PRINCIPAL DAS ICLUSAO DE DADOS SA1/SA2/SB1/SF4/SRV    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³ Data   ³ Bops ³ Manutencao Efetuada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³      ³                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function C_CMENU()

Private aRotina  := {}
Private _FilMaq  := space(6)
Private _FilOp   := space(6)
Private cQueryUp := ""

Processa({||C_AtuSXB()  },"Processando...")  // CRIA DADOS NO SXB DE CADA EMPRESA
Processa({||C_AtuSX6()  },"Processando...")  // CRIA PARAMETROS DE USUARIO EM CADA EMPRESA
Processa({||RIMCONT()  },"Processando...")   // CRIACAO DO BROWSE DA ROTINA PADRAO

Return

// INICIO DA MONTAGEM DA TELA DO CARGA MAQUINA
Static Function RIMCONT()

Private cDelFunc  := ".F." // Validacao para a exclusao. Pode-se utilizar ExecBlock    
PRIVATE aTelaEP   := {}                          
PRIVATE cCadastro := OemToAnsi("Empresas")	                           
PRIVATE TRS_NUMSIN                   
PRIVATE TRS_DTABER                   
PRIVATE TRS_NUMAPD  
PRIVATE TRS_MATRES

// Estrutura da tabela temporaria
_astru     := {}
_carq      := ""
_afields   := {}
aCposBrw   := {}
aEstrut    := {}

aAdd(aCposBrw,      { "C.Grupo"      , "codigo"          ,     "C"     , 02          , 0, ""})
aAdd(aCposBrw,      { "C.filial"     , "filial"         ,     "C"     , 02          , 0, ""})
aAdd(aCposBrw,      { "Empresa"      , "nome"           ,     "C"     , 40          , 0, ""})
aAdd(aCposBrw,      { "Filial"       , "nomf"           ,     "C"     , 60          , 0, ""})
          
aAdd(aEstrut,     { "ORDEM" , "C", 1, 0})

For nX := 1 To Len(aCposBrw)
    aAdd(aEstrut,     { aCposBrw[nX,2], aCposBrw[nX,3], aCposBrw[nX,4], aCposBrw[nX,5]})
Next nX
          
          If Select("TRB") > 0
               TRb->(dbCloseArea())
          EndIf
     
          cArqTMP := CriaTrab(aEstrut, .T.)
          dbUseArea(.T.,, cArqTMP, "TRB", .T., .F.)
          IndRegua( "TRB", cArqTMP, "ORDEM",,,"Indexando registros..." )
          
          DbSelectArea("TRB")
          TRB->(dbClearIndex())
          TRB->(dbSetIndex(cArqTMP + OrdBagExt()))

// alimenta a tabela temporária
Dbselectarea("SM0")
DBGOTOP()
WHILE !EOF()	
	DBSELECTAREA("TRB")	
	RECLOCK("TRB",.T.) 		
	 TRB->codigo  := SM0->M0_CODIGO		
	 TRB->FILIAL  := SM0->M0_CODFIL		
	 TRB->NOME    := SM0->M0_NOME		
	 TRB->NOMF    := SM0->M0_NOMECOM
	MSUNLOCK()    
	DBSELECTAREA("SM0")    
	DBSKIP()
END

Private aRotina := {{"Cad. Cliente   "     ,"U_C_CDSA1"   ,0,3},;  
					{"Cad. Produto   "     ,"U_C_CDSB1"   ,0,3},;
                    {"Cad. Fornecedor"     ,"U_C_CDSA2"   ,0,3},;
                    {"Cad. Estrutura"      ,"U_C_CDSG1"   ,0,3}}     

DbSelectArea("TRB")
mBrowse(6,1,22,75,"TRB",aCposBrw,,,,,)
return

// CRIACAO DE PARAMETROS E CONSULTAS NECESSARIAS PARA ROTINA
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa ³ C_AtuSXB º Autor ³ Microsiga          º Data ³  04/11/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Descricao³ Funcao de processamento da gravacao do SXB - Consultas Pad ³±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³ Uso      ³ FSAtuSXB - V.2.5                                           ³±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function C_AtuSXB()
Local aSXB     := {}
Local aEstrut  := {}
Local nI       := 0
Local nJ       := 0
Local cAlias   := ''
Local cTexto   := ''
Local oProcess

aEstrut :=  {'XB_ALIAS', 'XB_TIPO', 'XB_SEQ', 'XB_COLUNA', 'XB_DESCRI', 'XB_DESCSPA', 'XB_DESCENG', 'XB_CONTEM'               }
// C_SM0 - CONSULTA CADASTRO DE EMPRESA
aAdd( aSXB, {'C_SM0'    , '1'      , '01'    , 'DB'       , 'Filiais'  , 'Filiais'   , 'Filiais'   , 'SM0'                     })
aAdd( aSXB, {'C_SM0'    , '2'      , '01'    , '01'       , 'Codigo'   , 'Codigo'    , 'Codigo'    , ''                        })
aAdd( aSXB, {'C_SM0'    , '2'      , '02'    , '02'       , 'Nome'     , 'Nome'      , 'Nome'      , ''                        })
aAdd( aSXB, {'C_SM0'    , '4'      , '01'    , '01'       , 'Codigo'   , 'Codigo'    , 'Codigo'    , 'M0_CODIGO'               })
aAdd( aSXB, {'C_SM0'    , '4'      , '01'    , '02'       , 'Filial'   , 'Filial'    , 'Filial'    , 'M0_CODFIL'               })
aAdd( aSXB, {'C_SM0'    , '4'      , '01'    , '03'       , 'Nome'     , 'Nome'      , 'Nome'      , 'M0_NOME'                 })
aAdd( aSXB, {'C_SM0'    , '4'      , '02'    , '01'       , 'Nome'     , 'Nome'      , 'Nome'      , 'M0_NOME'                 })
aAdd( aSXB, {'C_SM0'    , '4'      , '02'    , '02'       , 'Nomrgo'   , 'Codigo'    , 'Codigo'    , 'M0_CODIGO'               })
aAdd( aSXB, {'C_SM0'    , '4'      , '02'    , '03'       , 'Filial'   , 'Filial'    , 'Filial'    , 'M0_CODFIL'               })
aAdd( aSXB, {'C_SM0'    , '5'      , '01'    , ''         , ''         , ''          , ''          , 'M0_CODIGO+"/"+M0_CODFIL' })

// C_SA1 - CONSULTA CLIENTE
aAdd( aSXB, {'C_SA1'    , '1'      , '01'    , 'DB'       , 'Cliente'  , 'Cliente'   , 'Cliente'   , 'SA1'                     })
aAdd( aSXB, {'C_SA1'    , '2'      , '01'    , '01'       , 'Codigo'   , 'Codigo'    , 'Codigo'    , ''                        })
aAdd( aSXB, {'C_SA1'    , '2'      , '02'    , '02'       , 'Nome'     , 'Nome'      , 'Nome'      , ''                        })
aAdd( aSXB, {'C_SA1'    , '4'      , '01'    , '01'       , 'Codigo'   , 'Codigo'    , 'Codigo'    , 'A1_COD'                  })
aAdd( aSXB, {'C_SA1'    , '4'      , '01'    , '02'       , 'loja'     , 'loja'      , 'loja'      , 'A1_LOJA'                 })
aAdd( aSXB, {'C_SA1'    , '4'      , '01'    , '03'       , 'Nome'     , 'Nome'      , 'Nome'      , 'A1_NOME'                 })
aAdd( aSXB, {'C_SA1'    , '4'      , '02'    , '01'       , 'Nome'     , 'Nome'      , 'Nome'      , 'A1_NOME'                 })
aAdd( aSXB, {'C_SA1'    , '4'      , '02'    , '02'       , 'Codigo'   , 'Codigo'    , 'Codigo'    , 'A1_COD'                  })
aAdd( aSXB, {'C_SA1'    , '4'      , '02'    , '03'       , 'loja'     , 'loja'      , 'loja'      , 'A1_LOJA'                 })
aAdd( aSXB, {'C_SA1'    , '5'      , '01'    , ''         , ''         , ''          , ''          , 'A1_COD+A1_LOJA'          })

// C_SA2 - CONSULTA FORNECEDOR
aAdd( aSXB, {'C_SA2'    , '1'      , '01'    , 'DB'       , 'Cliente'  , 'Cliente'   , 'Cliente'   , 'SA2'                     })
aAdd( aSXB, {'C_SA2'    , '2'      , '01'    , '01'       , 'Codigo'   , 'Codigo'    , 'Codigo'    , ''                        })
aAdd( aSXB, {'C_SA2'    , '2'      , '02'    , '02'       , 'Nome'     , 'Nome'      , 'Nome'      , ''                        })
aAdd( aSXB, {'C_SA2'    , '4'      , '01'    , '01'       , 'Codigo'   , 'Codigo'    , 'Codigo'    , 'A2_COD'                  })
aAdd( aSXB, {'C_SA2'    , '4'      , '01'    , '02'       , 'loja'     , 'loja'      , 'loja'      , 'A2_LOJA'                 })
aAdd( aSXB, {'C_SA2'    , '4'      , '01'    , '03'       , 'Nome'     , 'Nome'      , 'Nome'      , 'A2_NOME'                 })
aAdd( aSXB, {'C_SA2'    , '4'      , '02'    , '01'       , 'Nome'     , 'Nome'      , 'Nome'      , 'A2_NOME'                 })
aAdd( aSXB, {'C_SA2'    , '4'      , '02'    , '02'       , 'Codigo'   , 'Codigo'    , 'Codigo'    , 'A2_COD'                  })
aAdd( aSXB, {'C_SA2'    , '4'      , '02'    , '03'       , 'loja'     , 'loja'      , 'loja'      , 'A2_LOJA'                 })
aAdd( aSXB, {'C_SA2'    , '5'      , '01'    , ''         , ''         , ''          , ''          , 'A2_COD+A2_LOJA'          })


// Verifica todas as empresas para criacao do paramentro
_aNewSxb := {}  // array com as empresas 
_cNewSxb := ""  // CODIGO DA EMPRESA

// alimenta a tabela temporária
Dbselectarea("SM0")
DBGOTOP()
WHILE !EOF()	
      _cNewSxb := SM0->M0_CODIGO		
	  nScan := aScan(_aNewSxb,{|x| x[1] == _cNewSxb}) // verifica se ja existe no array unico de empresa
	
	  If nScan == 0 
	     aadd(_aNewSxb,{ _cNewSxb,"SXB"+_cNewSxb+"0"})
	  Endif

	DBSELECTAREA("SM0")    
	DBSKIP()
	LOOP
END


// processo de gravacao na tabela sxb
For Gl := 1 to len(_aNewSxb)

	IF cEmpAnt == _aNewSxb[Gl][1]
		// Atualizando dicionário
		dbSelectArea( 'SXB' )
		dbSetOrder( 1 )

		For nI := 1 To Len(aSXB)
			If !Empty(aSXB[nI][1])
				If !SXB->(dbSeek(PadR(aSXB[nI][1],Len(SXB->XB_ALIAS))+aSXB[nI][2]+aSXB[nI][3]+aSXB[nI][4]))
            	
					RecLock('SXB',.T.)
					For nJ := 1 To Len(aSXB[nI])
						If !Empty(FieldName(FieldPos( aEstrut[nJ])))
							FieldPut(FieldPos(aEstrut[nJ]),aSXB[nI][nJ])
						EndIf
					Next nJ
					dbCommit()
					MsUnLock('SXB')
				EndIf
			EndIf
		Next nI
	Else
		// Atualizando dicionário
		_CSXBTBA := _aNewSxb[Gl][2]

		//DbUseArea(.T.,,_CSXBTBA,"TRE",.T.,.F.)
		dbSelectArea('TRE')
		dbsetorder(1)
		DbGotop()

		For nI := 1 To Len(aSXB)
			If !Empty(aSXB[nI][1])
				If !TRE->(dbSeek(PadR(aSXB[nI][1],Len(TRE->XB_ALIAS))+aSXB[nI][2]+aSXB[nI][3]+aSXB[nI][4]))
            	
            		RecLock('TRE',.T.)
					For nJ := 1 To Len(aSXB[nI])
						If !Empty(FieldName(FieldPos( aEstrut[nJ])))
							FieldPut(FieldPos(aEstrut[nJ]),aSXB[nI][nJ])
						EndIf
					Next nJ
					dbCommit()
					MsUnLock('TRE')
				EndIf
			EndIf
		Next nI
	    TRE->(dbclosearea())
	Endif
Next Gl

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa ³ C_AtuSX6 º Autor ³ Microsiga          º Data ³  04/11/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Descricao³ Funcao de processamento da gravacao do SXB - Consultas Pad ³±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³ Uso      ³ FSAtuSXB - V.2.5                                           ³±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function C_AtuSX6()
Local aSX6     := {}
Local aEstrut  := {}
Local nI       := 0
Local nJ       := 0
Local cAlias   := ''
Local cTexto   := ''                   
Local oProcess

aEstrut :=  {'X6_FIL', 'X6_VAR'     , 'X6_TIPO', 'X6_DESCRIC'                                 , 'X6_DSCSPA'                                   , 'X6_DSCENG'                                  ,'X6_DESC1'             ,'X6_DSCSPA1'           ,'X6_DSCENG1'           ,'X6_DESC2','X6_DSCSPA2','X6_DSCENG2','X6_CONTEUD' ,'X6_CONTSPA' ,'X6_CONTENG' ,'X6_PROPRI' }
aAdd( aSX6, {''      , 'MV_C_USSB1' , 'C'      , 'ID DO USUARIO COM DIREITO DE USO NA ROTINA' , 'ID DO USUARIO COM DIREITO DE USO NA ROTINA'  , 'ID DO USUARIO COM DIREITO DE USO NA ROTINA' ,'DE REPLICACAO CARDEAL','DE REPLICACAO CARDEAL','DE REPLICACAO CARDEAL',''        ,''          ,''          ,'"000000/"'  ,'"000000/"'  ,'"000000/"'  ,'U'         })
aAdd( aSX6, {''      , 'MV_C_USSA1' , 'C'      , 'ID DO USUARIO COM DIREITO DE USO NA ROTINA' , 'ID DO USUARIO COM DIREITO DE USO NA ROTINA'  , 'ID DO USUARIO COM DIREITO DE USO NA ROTINA' ,'DE REPLICACAO CARDEAL','DE REPLICACAO CARDEAL','DE REPLICACAO CARDEAL',''        ,''          ,''          ,'"000000/"'  ,'"000000/"'  ,'"000000/"'  ,'U'         })
aAdd( aSX6, {''      , 'MV_C_USSA2' , 'C'      , 'ID DO USUARIO COM DIREITO DE USO NA ROTINA' , 'ID DO USUARIO COM DIREITO DE USO NA ROTINA'  , 'ID DO USUARIO COM DIREITO DE USO NA ROTINA' ,'DE REPLICACAO CARDEAL','DE REPLICACAO CARDEAL','DE REPLICACAO CARDEAL',''        ,''          ,''          ,'"000000/"'  ,'"000000/"'  ,'"000000/"'  ,'U'         })
aAdd( aSX6, {''      , 'MV_C_USSF4' , 'C'      , 'ID DO USUARIO COM DIREITO DE USO NA ROTINA' , 'ID DO USUARIO COM DIREITO DE USO NA ROTINA'  , 'ID DO USUARIO COM DIREITO DE USO NA ROTINA' ,'DE REPLICACAO CARDEAL','DE REPLICACAO CARDEAL','DE REPLICACAO CARDEAL',''        ,''          ,''          ,'"000000/"'  ,'"000000/"'  ,'"000000/"'  ,'U'         })
aAdd( aSX6, {''      , 'MV_C_USSRV' , 'C'      , 'ID DO USUARIO COM DIREITO DE USO NA ROTINA' , 'ID DO USUARIO COM DIREITO DE USO NA ROTINA'  , 'ID DO USUARIO COM DIREITO DE USO NA ROTINA' ,'DE REPLICACAO CARDEAL','DE REPLICACAO CARDEAL','DE REPLICACAO CARDEAL',''        ,''          ,''          ,'"000000/"'  ,'"000000/"'  ,'"000000/"'  ,'U'         })


// Verifica todas as empresas para criacao do paramentro
_aNewSx6 := {}  // array com as empresas 
_cNewSx6 := ""  // CODIGO DA EMPRESA

// alimenta a tabela temporária
Dbselectarea("SM0")
DBGOTOP()
WHILE !EOF()	
      _cNewSx6 := SM0->M0_CODIGO		
	  nScan := aScan(_aNewSx6,{|x| x[1] == _cNewSx6}) // verifica se ja existe no array unico de empresa
	
	  If nScan == 0 
	     aadd(_aNewSx6,{ _cNewSx6,"SX6"+_cNewSx6+"0"})
	  Endif

	DBSELECTAREA("SM0")    
	DBSKIP()
	LOOP
END

// processo de gravacao na tabela sxb
For Jp := 1 to len(_aNewSx6)

	If cEmpAnt == _aNewSx6[Jp][1]

		// Atualizando dicionário
		dbSelectArea( 'SX6' )
		dbSetOrder( 1 )

		For nI := 1 To Len( aSX6 )
			If !Empty( aSX6[nI][2] )
				If !SX6->(dbSeek(PadR(aSX6[nI][1],Len(SX6->X6_FIL))+PadR(aSX6[nI][2],Len(SX6->X6_VAR))))

					RecLock('SX6',.T.)
					For nJ := 1 To Len(aSX6[nI])
						If !Empty( FieldName(FieldPos(aEstrut[nJ])))
							FieldPut(FieldPos(aEstrut[nJ]), aSX6[nI][nJ] )
						EndIf
					Next nJ
					dbCommit()
					MsUnLock('SX6')
				EndIf
			EndIf
		Next nI
    Else
		// Atualizando dicionário
		_CSX6TBA := _aNewSx6[Jp][2]

		DbUseArea(.T.,,_CSX6TBA,"TRZ",.T.,.F.)
		dbsetorder(1)
		DbGotop()

		For nI := 1 To Len( aSX6 )
			If !Empty( aSX6[nI][2] )
				If !TRZ->(dbSeek(PadR(aSX6[nI][1],Len(TRZ->X6_FIL))+PadR(aSX6[nI][2],Len(TRZ->X6_VAR))))

					RecLock('TRZ',.T.)
					For nJ := 1 To Len(aSX6[nI])
						If !Empty( FieldName(FieldPos(aEstrut[nJ])))
							FieldPut(FieldPos(aEstrut[nJ]), aSX6[nI][nJ] )
						EndIf
					Next nJ
					dbCommit()
					MsUnLock('TRZ')
				EndIf
			EndIf
		Next nI
	    TRZ->(dbclosearea())    
    Endif
Next Jp		
Return
