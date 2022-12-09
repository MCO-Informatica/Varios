#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³C_CDSA2   ³ Autor ³ RICARDO CAVALINI      ³ Data ³25/01/2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ INCLUSAO DE DADOS NO CADASTRO DE fornecedor SA2            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³ Data   ³ Bops ³ Manutencao Efetuada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³      ³                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function C_CDSA2()

Private aRotina  := {}
Private _FilMaq  := space(6)
Private _FilOp   := space(6)
Private cQueryUp := ""


Processa({||SA2COPI()  },"Processando de Replicacao de Fornecedor")
Return

// INICIO DA MONTAGEM DA TELA
Static Function SA2COPI()

Private cDelFunc  := ".F." // Validacao para a exclusao. Pode-se utilizar ExecBlock
PRIVATE aTelaEP   := {}
PRIVATE cCadastro := OemToAnsi("Cadastro de Fornecedor")

__cCodPrd := Space(08)
__cDesPrd := Space(60)
__ceMPfIL := cEmpAnt+"/"+cFilAnt
oStat     := ""
cStat     := ""
aStat     := {"Inclusao"}
_lTdCrr   := .T.
_cUsuA2   := Getmv("MV_C_USSA2") 

//If !RetCodUsr() $ _cUsuA2
//   ApMsgAlert("Usuario sem direito de usar a rotina. (( MV_C_USSA2 ))")
//   Return
//Endif 

@ 000,000 To 290,410 Dialog oDlg0 Title "Cadastro de Fornecedor"
@ 010,005 SAY "Fornec/Loja"
@ 010,050 Get __cCodPrd   SIZE 050,10 F3 "C_SA2" Valid c_Dsa2(__cCodPrd)
@ 030,005 SAY "Descrição"
@ 030,050 Get __cDesPrd   SIZE 150,10 When .F.
@ 050,005 SAY "Emp/Fil Origem"
@ 050,050 Get __ceMPfIL   SIZE 150,10 F3 "C_SM0"  Valid c_Echav(__ceMPfIL)
@ 070,005 SAY "Operacao"
@ 070,050 MSCOMBOBOX oStat VAR cStat ITEMS aStat OF oDlg0 PIXEL SIZE 045,050
@ 130,015 BmpButton Type 1 Action _EpOk()
@ 130,130 BmpButton Type 2 Action _EpFech()
Activate Dialog oDlg0 Centered
//Close(oDlg0)
return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ _EpOK     ³ Autor ³ RICARDO CAVALINI   ³ Data ³ 25/01/2016 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ BOTAO PARA CONFIRMA A ALTERACAO.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function _EpOk()

Local aHeader   := {}
Local aRecno    := {}
Local aCols     := {}
Local ACARDEMP  := {}
Local cEPCod    := __cCodPrd
Local nUsado           

_CCGC := POSICIONE("SA2",1,XFILIAL("SA2")+__cCodPrd,"A2_CGC")

cSvFilAnt := cFilAnt // Salva a Filial Anterior
cSvEmpAnt := cEmpAnt // Salva a Empresa Anterior
cOrFilAnt := SUBSTR(__ceMPfIL,4,2) // Filial conforme parametro
cOrEmpAnt := SUBSTR(__ceMPfIL,1,2) // Empresa conforme parametro
cFilAnt   :=  SUBSTR(__ceMPfIL,4,2) // atualiza o parametro
cEmpAnt   :=  SUBSTR(__ceMPfIL,1,2) // atualiza o parametro
cSvArqTab := cArqTab // Salva os arquivos de //trabalho
cModo     := ""          // Modo de acesso do arquivo aberto //"E" ou "C"
aAreaSA2  := SA2->( GetArea() )
cFilNew   := ""
cEmpNew   := cEmpAnt

If Empty(Alltrim(cEPCod))
	ApMsgAlert("Campo Fornec/Loja, em branco. Favor preencher !!!")
	return
endif

if cSvEmpAnt <> cOrEmpAnt .and. !(EqualFullName("SA2",cEmpAnt,cSvEmpAnt))
	
	IF !(EqualFullName("SA2",cEmpAnt,cSvEmpAnt))
		aArea  := SA2->(GetArea())
		nOrder := SA2->(IndexOrd())
		
		EmpChangeTable("SA2",cEmpAnt,cSvEmpAnt,nOrder )
		
		// tipo de arquivo corrente
		_ASX2TB  := {}
		CMODO    := ""
		_CSX2TBB := "SX2"+ALLTRIM(cEmpAnt)+"0"
		
		
		DbUseArea(.T.,,_CSX2TBB,"TRW",.T.,.F.)
		dbSetOrder(1)
		MsSeek("SA2")
		While !Eof() .And. TRW->X2_CHAVE == "SA2"
			AADD(_ASX2TB,{TRW->X2_ARQUIVO,TRW->X2_MODO})
			CMODO := TRW->X2_MODO
			dbSelectArea("TRW")
			dbSkip()
		End
		
		// Obtem os campos da tabela SA2-FORNECEDOR 
		nUsado := 0
		
		_CSX3TBB := "SX3"+ALLTRIM(cEmpAnt)+"0"
		DbUseArea(.T.,,_CSX3TBB,"TRR",.T.,.F.)
		dbSetOrder(1)
		MsSeek("SA2")
		While !Eof() .And. TRR->X3_ARQUIVO == "SA2"
			If X3Uso(TRR->X3_USADO) .And. cNivel >= TRR->X3_NIVEL
				Aadd(aHeader, { AllTrim(X3Titulo()),TRR->X3_CAMPO  ,TRR->X3_PICTURE,TRR->X3_TAMANHO,TRR->X3_DECIMAL,;
				TRR->X3_VALID      ,TRR->X3_USADO  ,TRR->X3_TIPO   ,TRR->X3_F3     ,TRR->X3_CONTEXT,;
				X3Cbox()           ,TRR->X3_RELACAO,".T."})
				nUsado++
			EndIf
			dbSelectArea("TRR")
			dbSkip()
		End
		
		// Seleciona o FORNEC a copiar em outras filiais e aloca os dados do FORNEC em seus respectivos campos
		dbSelectArea("SA2")
		dbSetOrder(3)
		IF CMODO == "C"
			IF !dbSeek("  "+_CCGC)
			    ApMsgAlert("Fornecedor nao cadastrado na filial indicada. Verifique !!!")
			    Return
			Endif
		ELSE
			if !dbSeek(cFilAnt+_CCGC)
			    ApMsgAlert("Fornecedor nao cadastrado na filial indicada. Verifique !!!")
			    Return
            endif
		ENDIF
		
		Aadd(aCols,Array(nUsado+1))
		Aadd(aRecno,SA2->(Recno()))
		For nX := 1 To nUsado
			If ( aHeader[nX,10] !=  "V" )
				aCols[Len(aCols)][nX] := FieldGet(FieldPos(aHeader[nX,2]))
			else
				aCols[Len(aCols)][nX] := CriaVar(aHeader[nX,2],.T.)
			EndIf
		Next nX
		
		aCols[Len(aCols)][nUsado+1] := .F.
	ENDIF
	
    TRW->(DbCloseArea())
    TRR->(DbCloseArea())

Else
	
	// tipo de arquivo corrente
	_ASX2TB := {}
	dbSelectArea("SX2")
	dbSetOrder(1)
	MsSeek("SA2")
	While !Eof() .And. SX2->X2_CHAVE == "SA2"
		AADD(_ASX2TB,{SX2->X2_ARQUIVO,SX2->X2_MODO})
		CMODO := SX2->X2_MODO
		dbSelectArea("SX2")
		dbSkip()
	End
	
	// Obtem os campos da tabela SA2-FORNEC 
	nUsado := 0
	
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("SA2")
	While !Eof() .And. SX3->X3_ARQUIVO == "SA2"
		If X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL
			Aadd(aHeader, { AllTrim(X3Titulo()),SX3->X3_CAMPO  ,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,;
			SX3->X3_VALID      ,SX3->X3_USADO  ,SX3->X3_TIPO   ,SX3->X3_F3     ,SX3->X3_CONTEXT,;
			X3Cbox()           ,SX3->X3_RELACAO,".T."})
			nUsado++
		EndIf
		dbSelectArea("SX3")
		dbSkip()
	End
	
	// Seleciona o FORNEC a copiar em outras filiais e aloca os dados do FORNECEDOR em seus respectivos campos
	dbSelectArea("SA2")
	dbSetOrder(3)
	IF CMODO == "C"
		if !dbSeek("  "+_CCGC)
		    ApMsgAlert("Fornecedor nao cadastrado na filial indicada. Verifique !!!")
		    Return
        endif
	ELSE
		if !dbSeek(cFilAnt+_CCGC)
		    ApMsgAlert("Fornecedor nao cadastrado na filial indicada. Verifique !!!")
		    Return
        endif
	ENDIF
	
	Aadd(aCols,Array(nUsado+1))
	Aadd(aRecno,SA2->(Recno()))
	For nX := 1 To nUsado
		If ( aHeader[nX,10] !=  "V" )
			aCols[Len(aCols)][nX] := FieldGet(FieldPos(aHeader[nX,2]))
		else
			aCols[Len(aCols)][nX] := CriaVar(aHeader[nX,2],.T.)
		EndIf
	Next nX
	
	aCols[Len(aCols)][nUsado+1] := .F.
endif

// FECHA A TELA
Close(oDlg0)

// ESCOLHAR AS EMPRESAS PARA COPIA
ACARDEMP := U_C_CAR01(cEmpAnt,cFilAnt,CMODO,cStat,"SA2")
_APRPFIL := {}
_AOUTFIL := {}

// fecha a rotina por ter sido cancelada na tela das filiais...
If Len(ACARDEMP) = 0
   Return(NIL)
Endif

// SEPARAR FILIAIS E EMPRESAS
For rc := 1 to len(ACARDEMP)
	If cEmpAnt == ACARDEMP[rc,1]
		AADD(_APRPFIL,{ACARDEMP[rc,1],ACARDEMP[rc,2]})  // empresa de origem
	ELSE
		AADD(_AOUTFIL,{ACARDEMP[rc,1],ACARDEMP[rc,2]}) // outras empresas marcadas no browse
	ENDIF
next rc

// INCLUSAO DE DADOS DA MESMA EMPRESA E FILIAL
IF LEN(_APRPFIL) > 0
	
	IF cModo == "E"  // replica dos dados somente se a empresa estiver com a tabela "SA2" exclusiva !!!!!
		For Gl := 1 to Len(_APRPFIL)
			// Testa para evitar duplicidade de cadastramento em outras filiais
			lOk := .T.
            If Alltrim(cStat)=="Inclusao"
				dbSelectArea("SA2")
				dbsetorder(3)
				If dbSeek(alltrim(_APRPFIL[Gl,2])+_CCGC)
					ApMsgAlert("Fornecedor ja cadastrado na filial "+alltrim(_APRPFIL[Gl,2]))
					lOk := .F.
				Endif
			Endif 
			
			// Grava o Fornec selecionado nas demais filiais da mesma empresa de origem...
			If lOk
				For nCntFor := 1 To Len(aCols)
					If ( !aCols[nCntFor][nUsado+1] )

	                    If Alltrim(cStat) <> "Inclusao"
							dbSelectArea("SA2")        
							dbsetorder(3)
							if !dbSeek(alltrim(_APRPFIL[Gl,2])+_CCGC)                            
					           ApMsgAlert("Forncedor nao cadastrado na filial "+alltrim(_APRPFIL[Gl,2])+". Procure o Administrador...")										           
  					           _lTdCrr := .F.
							else
								RecLock("SA2",.F.)
  					           _lTdCrr := .T.
							endif
						else	
							RecLock("SA2",.T.)							
				           _lTdCrr := .T.
					    Endif
                        
                        if _lTdCrr
							SA2->A2_FILIAL := alltrim(_APRPFIL[Gl,2])
							For nCntFor2 := 1 To nUsado
								If ( aHeader[nCntFor2][10] != "V" ) .or. ( ALLTRIM(UPPER(aHeader[nCntFor2][2])) != "A2_FILIAL" )
									SA2->(FieldPut(FieldPos(aHeader[nCntFor2][2]),aCols[nCntFor][nCntFor2]))
								EndIf
							Next nCntFor2
							MsUnLock()
						endif	
					Endif
				Next nCntFor
			Endif
		Next Gl
	ENDIF
ENDIF

// Validacao para ver se as outras empresa selecionadas tem a tabela "SA2" comum ou exclusiva...
_aunicafil := {}
__cempNew  := ""
nScan      := 0

// encontra somente uma empresa para verificacao do SX2, conforme codigo da empresa....
For jp := 1 to len(_AOUTFIL)
	__cempNew  := _AOUTFIL[jp,1]  // posicao do array do codigo da empresa
	
	nScan := aScan(_aunicafil,{|x| x[1] == __cempNew})  // verifica se ja existe no array unico de empresa
	
	If ( nScan==0 )
		aadd(_aunicafil,{ _AOUTFIL[jp,1],"SA2"})
	Endif
Next jp

//  analise no sx2 das outras empresas para fazer a inclusao de dados na empresa/filial.
_cCmum   := .F.
_cEmpMom := ""
For mc := 1 to Len(_aunicafil)
	_cCmum   := TableId("SA2",cOrEmpAnt,"SA2",_aunicafil[mc,1])
	_cEmpMom := _aunicafil[mc,1]  // empresa do momento/atual para analise e replicacao de dados
	
	if !_cCmum  // Se nao for comum o SA2.
		
		// Tabela SX2 compartilhada ou exclusiva, dentro da empresa corrente....
		For me := 1 to Len(_AOUTFIL)
			If _cEmpMom == _AOUTFIL[me,1]
				cFilNew   :=  _AOUTFIL[me,2]
				cEmpNew   :=  _AOUTFIL[me,1]
				nOrder    := 1
				
				IF !(EqualFullName("SA2",cEmpNew,cEmpAnt))
					aArea  := SA2->(GetArea())
					nOrder := SA2->(IndexOrd())

					EmpChangeTable("SA2",cEmpNew,cEmpAnt,nOrder )
					
					// abrir a tabela nova e ver se e exclusiva ou compartilhada
					_ASX2TBa := {}
					CMODOa   := ""
					_CSX2TBA := "SX2"+ALLTRIM(cEmpNew)+"0"
					
					IF ALLTRIM(cEmpNew) == "01"                      
					   _cSXETBA := "  \DATA\SA2"+ALLTRIM(cEmpNew)+"0"					
					ELSE
					   _cSXETBA := "  \DATA\SA2"+ALLTRIM(cEmpNew)+"0"
					ENDIF   
					
					DbUseArea(.T.,,_CSX2TBA,"TRX",.T.,.F.)
					dbsetorder(1)
					DbGotop()
					MsSeek("SA2")
					While !Eof() .and. alltrim(TRX->X2_CHAVE) == "SA2"
						
						AADD(_ASX2TBa,{TRX->X2_ARQUIVO,TRX->X2_MODO})
						CMODOa := TRX->X2_MODO
						
						dbSelectArea("TRX")
						dbSkip()
					End
				endif
			Endif
			dbSelectArea("TRX")
			DBCLOSEAREA()
		Next me
		
		// Gravaçao de dados na tabela
		IF cModoa == "E"
			For Gl := 1 to Len(_AOUTFIL)
				IF _cEmpMom == _AOUTFIL[GL,1]    
				
					// Testa para evitar duplicidade de cadastramento em outras filiais
					lOk := .T.
                    If Alltrim(cStat)=="Inclusao"
						dbSelectArea("SA2")
						dbsetorder(3)
						If dbSeek(alltrim(_AOUTFIL[Gl,2])+_CCGC)
							ApMsgAlert("Fornecedor ja cadastrado na Empresa: "+alltrim(_AOUTFIL[Gl,1])+"filial "+alltrim(_AOUTFIL[Gl,2]))
							lOk := .F.
						Endif
					Endif
					
					// Grava o Fornec selecionado na filial...
					If lOk
						For nCntFor := 1 To Len(aCols)
							If ( !aCols[nCntFor][nUsado+1] )

			                    If Alltrim(cStat) <> "Inclusao"
									dbSelectArea("SA2")        
									dbsetorder(3)
									if !dbSeek(alltrim(_AOUTFIL[Gl,2])+_CCGC)                            
							           ApMsgAlert("Fornecedor nao cadastrado na filial "+alltrim(_APRPFIL[Gl,2])+". Procure o Administrador...")										           
  							           _lTdCrr := .F.
									Else
										RecLock("SA2",.F.)
		  					           _lTdCrr := .T.
									endif
								else	
									RecLock("SA2",.T.)							
	  					           _lTdCrr := .T.
							    Endif
							    
							    
							    if _lTdCrr
									SA2->A2_FILIAL := alltrim(_AOUTFIL[Gl,2])
									For nCntFor2 := 1 To nUsado
										If ( aHeader[nCntFor2][10] != "V" ) .or. ( ALLTRIM(UPPER(aHeader[nCntFor2][2])) != "A2_FILIAL" )
											SA2->(FieldPut(FieldPos(aHeader[nCntFor2][2]),aCols[nCntFor][nCntFor2]))
										EndIf
									Next nCntFor2
									MsUnLock()
								Endif	
							Endif
						Next nCntFor
					Endif
				Endif
			Next Gl
			
		Elseif cModoa == "C"
			_nnrfil := 0
			For Gl := 1 to Len(_AOUTFIL)
				IF _cEmpMom == _AOUTFIL[GL,1] .and. _nnrfil = 0 
				
                
					// Testa para evitar duplicidade de cadastramento em outras filiais
					lOk := .T.
                    If Alltrim(cStat)=="Inclusao"
						dbSelectArea("SA2")                                 
						dbsetorder(3)
						If dbSeek("  "+_CCGC)
							ApMsgAlert("Fornecedor ja cadastrado na filial "+alltrim(_AOUTFIL[Gl,2]))
							lOk := .F.
						Endif
					Endif	
					
					// Grava o Fornec selecionado na filial...
					If lOk
						For nCntFor := 1 To Len(aCols)
							If ( !aCols[nCntFor][nUsado+1] )
			                    
			                    If Alltrim(cStat) <> "Inclusao"
									dbSelectArea("SA2")
									dbsetorder(3)
									if !dbSeek("  "+_CCGC)                            
							           ApMsgAlert("Fornecedor nao cadastrado na filial "+alltrim(_APRPFIL[Gl,2])+". Procure o Administrador...")										           
  							           _lTdCrr := .F.
									Else
										RecLock("SA2",.F.)
		  					           _lTdCrr := .T.
									Endif
								else	
									RecLock("SA2",.T.)							
	  					            _lTdCrr := .T.
							    Endif
							    
							    IF _lTdCrr
									SA2->A2_FILIAL := ""
									For nCntFor2 := 1 To nUsado
										If ( aHeader[nCntFor2][10] != "V" ) .or. ( ALLTRIM(UPPER(aHeader[nCntFor2][2])) != "A2_FILIAL" )
											SA2->(FieldPut(FieldPos(aHeader[nCntFor2][2]),aCols[nCntFor][nCntFor2]))
										EndIf
									Next nCntFor2

									SA2->A2_COD    := GETSXENUM("SA2","A2_COD",_cSXETBA)    
									MsUnLock()
								ENDIF	
							Endif
						Next nCntFor
					Endif
					_nnrfil++
				Endif
			Next Gl
		ENDIF
	Endif
Next mc

if cSvEmpAnt <> cEmpnew
	// abertura da tabela conforme empresa original
	EmpChangeTable("SA2",cEmpAnt,cEmpnew,nOrder )
endif	

Close(oDlg0)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ _EPFECH  ³ Autor ³ RICARDO CAVALINI   ³ Data ³ 25/01/2016 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ BOTAO PARA FECHAR A TELA SEM GRAVAR                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static function _EPFech()
Close(oDlg0)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³TableId   ³ Autor ³ RICARDO CAVALINI      ³ Data ³25/01/2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Verifica compartilhamento de tabelas                       ³±±
±±³ Utilize a função RetFullName() para ver se existe a necessidade       ³±±
±±³ de se estar abrindo a Tabela da outra empresa.                        ³±±
±±³                                                                       ³±±
±±³Pode ocorrer da Tabela ser compartilhada entre empresas.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³ Data   ³ Bops ³ Manutencao Efetuada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³      ³                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function TableId(cAlias1,cEmp1,cAlias2,cEmp2)
Local cTableEmp1 := RetFullName(cAlias1,cEmp1)
Local cTableEmp2 := RetFullName(cAlias2,cEmp2)
Return( ( cTableEmp1 == cTableEmp2 ) )



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³c_Dprod   ³ Autor ³ RICARDO CAVALINI      ³ Data ³25/01/2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ obtem a descricao do Fornec                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³ Data   ³ Bops ³ Manutencao Efetuada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³      ³                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static function c_DSA2(PROCST)
__cDProd  := ""
__cCstPr  := PROCST
__cDesPrd := Posicione("SA2",1,XFILIAL("SA2")+__cCstPr,"A2_NOME")
return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³c_Dprod   ³ Autor ³ RICARDO CAVALINI      ³ Data ³25/01/2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ valida o codigo da empresa                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³ Data   ³ Bops ³ Manutencao Efetuada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³      ³                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static function c_Echav(__ceMPfIL)
__cDEmpr  := __ceMPfIL    
__cAEmpr  := substr(__ceMPfIL,1,2)
__cFEmpr  := substr(__ceMPfIL,4,2)
__cDRetr  := .t.

DbSelectArea("SM0")
Dbsetorder(1)
if !Dbseek(__cAEmpr+__cFEmpr)
	__cDRetr  := .f.
   ApMsgAlert("Empresa/Filial nao cadastrada.Verificar")	
endif

return(__cDRetr)
