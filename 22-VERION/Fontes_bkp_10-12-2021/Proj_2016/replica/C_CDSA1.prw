#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �C_CDSA1   � Autor � RICARDO CAVALINI      � Data �25/01/2016���
�������������������������������������������������������������������������Ĵ��
���Descricao � INCLUSAO DE DADOS NO CADASTRO DE CLIENTE SA1               ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.� Data   � Bops � Manutencao Efetuada                    ���
�������������������������������������������������������������������������Ĵ��
���              �  /  /  �      �                                        ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
*/
User Function C_CDSA1()

Private aRotina  := {}
Private _FilMaq  := space(6)
Private _FilOp   := space(6)
Private cQueryUp := ""


Processa({||SA1COPI()  },"Processando de Replicacao de Clientes")
Return

// INICIO DA MONTAGEM DA TELA
Static Function SA1COPI()

Private cDelFunc  := ".F." // Validacao para a exclusao. Pode-se utilizar ExecBlock
PRIVATE aTelaEP   := {}
PRIVATE cCadastro := OemToAnsi("Cadastro de Cliente")

__cCodPrd := Space(08)
__cDesPrd := Space(60)
__ceMPfIL := cEmpAnt+"/"+cFilAnt
oStat     := ""
cStat     := ""
aStat     := {"Inclusao"}
_lRetUs   := .F.
_lTdCrr   := .T.
_cUsuA1   := Getmv("MV_C_USSA1") 

//If !RetCodUsr() $ _cUsuA1
//   ApMsgAlert("Usuario sem direito de usar a rotina. (( MV_C_USSA1 ))")
//   Return
//Endif 

@ 000,000 To 290,410 Dialog oDlg0 Title "Cadastro de Cliente"
@ 010,005 SAY "Cliente/Loja"
@ 010,050 Get __cCodPrd   SIZE 050,10 F3 "C_SA1" Valid c_Dsa1(__cCodPrd)
@ 030,005 SAY "Descri��o"
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � _EpOK     � Autor � RICARDO CAVALINI   � Data � 25/01/2016 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � BOTAO PARA CONFIRMA A ALTERACAO.                           ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
*/
Static Function _EpOk()

Local aHeader   := {}
Local aRecno    := {}
Local aCols     := {}
Local ACARDEMP  := {}
Local cEPCod    := __cCodPrd
Local nUsado
            
_CCGC := POSICIONE("SA1",1,XFILIAL("SA1")+__cCodPrd,"A1_CGC")


cSvFilAnt := cFilAnt // Salva a Filial Anterior
cSvEmpAnt := cEmpAnt // Salva a Empresa Anterior
cOrFilAnt := SUBSTR(__ceMPfIL,4,2) // Filial conforme parametro
cOrEmpAnt := SUBSTR(__ceMPfIL,1,2) // Empresa conforme parametro
cFilAnt   := SUBSTR(__ceMPfIL,4,2) // atualiza o parametro
cEmpAnt   := SUBSTR(__ceMPfIL,1,2) // atualiza o parametro
cSvArqTab := cArqTab // Salva os arquivos de //trabalho
cModo     := ""          // Modo de acesso do arquivo aberto //"E" ou "C"
aAreaSA1  := SA1->( GetArea() )
cFilNew   := ""
cEmpNew   := cEmpAnt

If Empty(Alltrim(cEPCod))
	ApMsgAlert("Campo Cliente/Loja, em branco. Favor preencher !!!")
	return
endif

if cSvEmpAnt <> cOrEmpAnt .and. !(EqualFullName("SA1",cEmpAnt,cSvEmpAnt))
	
	IF !(EqualFullName("SA1",cEmpAnt,cSvEmpAnt))
		aArea  := SA1->(GetArea())
		nOrder := SA1->(IndexOrd())
		
		EmpChangeTable("SA1",cEmpAnt,cSvEmpAnt,nOrder )
		
		// tipo de arquivo corrente
		_ASX2TB  := {}
		CMODO    := ""
		_CSX2TBB := "SX2"+ALLTRIM(cEmpAnt)+"0"
		
		
		DbUseArea(.T.,,_CSX2TBB,"TRW",.T.,.F.)
		dbSetOrder(1)
		MsSeek("SA1")
		While !Eof() .And. TRW->X2_CHAVE == "SA1"
			AADD(_ASX2TB,{TRW->X2_ARQUIVO,TRW->X2_MODO})
			CMODO := TRW->X2_MODO
			dbSelectArea("TRW")
			dbSkip()
		End
		
		// Obtem os campos da tabela SA1-CLIENTE 
		nUsado := 0
		
		_CSX3TBB := "SX3"+ALLTRIM(cEmpAnt)+"0"
		DbUseArea(.T.,,_CSX3TBB,"TRR",.T.,.F.)
		dbSetOrder(1)
		MsSeek("SA1")
		While !Eof() .And. TRR->X3_ARQUIVO == "SA1"
			If X3Uso(TRR->X3_USADO) .And. cNivel >= TRR->X3_NIVEL
				Aadd(aHeader, { AllTrim(X3Titulo()),TRR->X3_CAMPO  ,TRR->X3_PICTURE,TRR->X3_TAMANHO,TRR->X3_DECIMAL,;
				TRR->X3_VALID      ,TRR->X3_USADO  ,TRR->X3_TIPO   ,TRR->X3_F3     ,TRR->X3_CONTEXT,;
				X3Cbox()           ,TRR->X3_RELACAO,".T."})
				nUsado++
			EndIf
			dbSelectArea("TRR")
			dbSkip()
		End
		
		// Seleciona o cliente a copiar em outras filiais e aloca os dados do clientes em seus respectivos campos
		dbSelectArea("SA1")
		dbSetOrder(3)
		IF CMODO == "C"
			IF !dbSeek("  "+_CCGC)
			    ApMsgAlert("Cliente nao cadastrado na filial indicada. Verifique !!!")
			    Return
			Endif
			
		ELSE
			IF !dbSeek(cFilAnt+_CCGC)
			    ApMsgAlert("Cliente nao cadastrado na filial indicada. Verifique !!!")
			    Return
			Endif
		ENDIF
		
		Aadd(aCols,Array(nUsado+1))
		Aadd(aRecno,SA1->(Recno()))
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

else
	
	// tipo de arquivo corrente
	_ASX2TB := {}
	dbSelectArea("SX2")
	dbSetOrder(1)
	MsSeek("SA1")
	While !Eof() .And. SX2->X2_CHAVE == "SA1"
		AADD(_ASX2TB,{SX2->X2_ARQUIVO,SX2->X2_MODO})
		CMODO := SX2->X2_MODO
		dbSelectArea("SX2")
		dbSkip()
	End
	
	// Obtem os campos da tabela SA1-CLIENTE 
	nUsado := 0
	
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("SA1")
	While !Eof() .And. SX3->X3_ARQUIVO == "SA1"
		If X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL
			Aadd(aHeader, { AllTrim(X3Titulo()),SX3->X3_CAMPO  ,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,;
			SX3->X3_VALID      ,SX3->X3_USADO  ,SX3->X3_TIPO   ,SX3->X3_F3     ,SX3->X3_CONTEXT,;
			X3Cbox()           ,SX3->X3_RELACAO,".T."})
			nUsado++
		EndIf
		dbSelectArea("SX3")
		dbSkip()
	End
	
	// Seleciona o clientes a copiar em outras filiais e aloca os dados do CLIENTE em seus respectivos campos
	dbSelectArea("SA1")
	dbSetOrder(3)
	IF CMODO == "C"
		if !dbSeek("  "+_CCGC)
		    ApMsgAlert("Cliente nao cadastrado na filial indicada. Verifique !!!")
		    Return
		Endif
	ELSE
		if !dbSeek(cFilAnt+_CCGC)
		    ApMsgAlert("Cliente nao cadastrado na filial indicada. Verifique !!!")
		    Return
		Endif
		
	ENDIF
	
	Aadd(aCols,Array(nUsado+1))
	Aadd(aRecno,SA1->(Recno()))
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
ACARDEMP := U_C_CAR01(cEmpAnt,cFilAnt,CMODO,cStat,"SA1")
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
	
	IF cModo == "E"  // replica dos dados somente se a empresa estiver com a tabela "SA1" exclusiva !!!!!
		For Gl := 1 to Len(_APRPFIL)
			// Testa para evitar duplicidade de cadastramento em outras filiais
			lOk := .T.
            If Alltrim(cStat)=="Inclusao"
				dbSelectArea("SA1")
				DBSETORDER(3)
				If dbSeek(alltrim(_APRPFIL[Gl,2])+_CCGC)
					ApMsgAlert("Cliente ja cadastrado na filial "+alltrim(_APRPFIL[Gl,2]))
					lOk := .F.
				Endif
			Endif 
			
			// Grava o clientes selecionado nas demais filiais da mesma empresa de origem...
			If lOk
				For nCntFor := 1 To Len(aCols)
					If ( !aCols[nCntFor][nUsado+1] )

	                    If Alltrim(cStat) <> "Inclusao"
							dbSelectArea("SA1")
                            DBSETORDER(3)
							if !dbSeek(alltrim(_APRPFIL[Gl,2])+_CCGC)                            
					           ApMsgAlert("Cliente nao cadastrado na filial "+alltrim(_APRPFIL[Gl,2])+". Procure o Administrador...")										           
  					           _lTdCrr := .F.
							Else
								RecLock("SA1",.F.)
							   _lTdCrr := .T.
							endif   
						else	
							RecLock("SA1",.T.)							
						   _lTdCrr := .T.
					    Endif
                        
                        if _lTdCrr
							SA1->A1_FILIAL := alltrim(_APRPFIL[Gl,2])
							For nCntFor2 := 1 To nUsado
								If ( aHeader[nCntFor2][10] != "V" ) .or. ( ALLTRIM(UPPER(aHeader[nCntFor2][2])) != "A1_FILIAL" )
									SA1->(FieldPut(FieldPos(aHeader[nCntFor2][2]),aCols[nCntFor][nCntFor2]))
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

// Validacao para ver se as outras empresa selecionadas tem a tabela "SA1" comum ou exclusiva...
_aunicafil := {}
__cempNew  := ""
nScan      := 0

// encontra somente uma empresa para verificacao do SX2, conforme codigo da empresa....
For jp := 1 to len(_AOUTFIL)
	__cempNew  := _AOUTFIL[jp,1]  // posicao do array do codigo da empresa
	
	nScan := aScan(_aunicafil,{|x| x[1] == __cempNew})  // verifica se ja existe no array unico de empresa
	
	If ( nScan==0 )
		aadd(_aunicafil,{ _AOUTFIL[jp,1],"SA1"})
	Endif
Next jp

//  analise no sx2 das outras empresas para fazer a inclusao de dados na empresa/filial.
_cCmum   := .F.
_cEmpMom := ""
For mc := 1 to Len(_aunicafil)
	_cCmum   := TableId("SA1",cOrEmpAnt,"SA1",_aunicafil[mc,1])
	_cEmpMom := _aunicafil[mc,1]  // empresa do momento/atual para analise e replicacao de dados
	
	if !_cCmum  // Se nao for comum o SA1.
		
		// Tabela SX2 compartilhada ou exclusiva, dentro da empresa corrente....
		For me := 1 to Len(_AOUTFIL)
			If _cEmpMom == _AOUTFIL[me,1]
				cFilNew   :=  _AOUTFIL[me,2]
				cEmpNew   :=  _AOUTFIL[me,1]
				nOrder    := 1
				
				IF !(EqualFullName("SA1",cEmpNew,cEmpAnt))
					aArea  := SA1->(GetArea())
					nOrder := SA1->(IndexOrd())
					
					
					EmpChangeTable("SA1",cEmpNew,cEmpAnt,nOrder )
					
					// abrir a tabela nova e ver se e exclusiva ou compartilhada
					_ASX2TBa := {}
					CMODOa   := ""
					_CSX2TBA := "SX2"+ALLTRIM(cEmpNew)+"0"   
					IF ALLTRIM(cEmpNew) == "01"                      
					   _cSXETBA := "  \DATA\SA1"+ALLTRIM(cEmpNew)+"0"					
					ELSE
					   _cSXETBA := "  \data\SA1"+ALLTRIM(cEmpNew)+"0"
					ENDIF   
					
					DbUseArea(.T.,,_CSX2TBA,"TRX",.T.,.F.)
					dbsetorder(1)
					DbGotop()
					MsSeek("SA1")
					While !Eof() .and. alltrim(TRX->X2_CHAVE) == "SA1"
						
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


		// Grava�ao de dados na tabela
		IF cModoa == "E"
			For Gl := 1 to Len(_AOUTFIL)
				IF _cEmpMom == _AOUTFIL[GL,1]    
				
					// Testa para evitar duplicidade de cadastramento em outras filiais
					lOk := .T.
                    If Alltrim(cStat)=="Inclusao"
						dbSelectArea("SA1")                         
						DBSETORDER(3)
						If dbSeek(alltrim(_AOUTFIL[Gl,2])+_CCGC)
							ApMsgAlert("Cliente ja cadastrado na Empresa: "+alltrim(_AOUTFIL[Gl,1])+"filial "+alltrim(_AOUTFIL[Gl,2]))
							lOk := .F.
						Endif
					Endif
					
					// Grava o cliente selecionado na filial...
					If lOk
						For nCntFor := 1 To Len(aCols)
							If ( !aCols[nCntFor][nUsado+1] )

			                    If Alltrim(cStat) <> "Inclusao"
									dbSelectArea("SA1")        
									DBSETORDER(3)
									if !dbSeek(alltrim(_AOUTFIL[Gl,2])+_CCGC)                            
							           ApMsgAlert("Cliente nao cadastrado na filial "+alltrim(_APRPFIL[Gl,2])+". Procure o Administrador...")										           
		  					           _lTdCrr := .F.
									Else
										RecLock("SA1",.F.)
		  					           _lTdCrr := .T.
									endif
								Else	
									RecLock("SA1",.T.)							
	  					           _lTdCrr := .T.									
							    Endif
                                
                                IF _lTdCrr
									SA1->A1_FILIAL := alltrim(_AOUTFIL[Gl,2])
									For nCntFor2 := 1 To nUsado
										If ( aHeader[nCntFor2][10] != "V" ) .or. ( ALLTRIM(UPPER(aHeader[nCntFor2][2])) != "A1_FILIAL" )
											SA1->(FieldPut(FieldPos(aHeader[nCntFor2][2]),aCols[nCntFor][nCntFor2]))
										EndIf
									Next nCntFor2
									MsUnLock()
								ENDIF	
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
						dbSelectArea("SA1")                                 
						DBSETORDER(3)
						If dbSeek("  "+_CCGC)
							ApMsgAlert("Cliente ja cadastrado na filial "+alltrim(_AOUTFIL[Gl,2]))
							lOk := .F.
						Endif
					Endif	
					
					// Grava o cliente selecionado na filial...
					If lOk
						For nCntFor := 1 To Len(aCols)
							If ( !aCols[nCntFor][nUsado+1] )
			                    
			                    If Alltrim(cStat) <> "Inclusao"
									dbSelectArea("SA1")
									DBSETORDER(3)
									IF !dbSeek("  "+_CCGC)                            
							           ApMsgAlert("Cliente nao cadastrado na filial "+alltrim(_APRPFIL[Gl,2])+". Procure o Administrador...")										           
		  					           _lTdCrr := .F.
									ELSE
										RecLock("SA1",.F.)
		  					           _lTdCrr := .T.
									ENDIF
								else	
									RecLock("SA1",.T.)							
	  					           _lTdCrr := .T.
							    Endif
							    
							    IF _lTdCrr
									SA1->A1_FILIAL := ""
									                                   									
									For nCntFor2 := 1 To nUsado
										If ( aHeader[nCntFor2][10] != "V" ) .or. (( ALLTRIM(UPPER(aHeader[nCntFor2][2])) != "A1_FILIAL" ) .or. ( ALLTRIM(UPPER(aHeader[nCntFor2][2])) != "A1_COD" ))
											SA1->(FieldPut(FieldPos(aHeader[nCntFor2][2]),aCols[nCntFor][nCntFor2]))
										EndIf
									Next nCntFor2     
									                                                              
									SA1->A1_COD    := GETSXENUM("SA1","A1_COD",_cSXETBA)    // acha o numero do cliente na outra filial....
									
									MsUnLock("SA1")
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
	EmpChangeTable("SA1",cEmpAnt,cEmpnew,nOrder )
endif	

Close(oDlg0)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � _EPFECH  � Autor � RICARDO CAVALINI   � Data � 25/01/2016 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � BOTAO PARA FECHAR A TELA SEM GRAVAR                        ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
*/
Static function _EPFech()
Close(oDlg0)
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �TableId   � Autor � RICARDO CAVALINI      � Data �25/01/2016���
�������������������������������������������������������������������������Ĵ��
���Descricao � Verifica compartilhamento de tabelas                       ���
��� Utilize a fun��o RetFullName() para ver se existe a necessidade       ���
��� de se estar abrindo a Tabela da outra empresa.                        ���
���                                                                       ���
���Pode ocorrer da Tabela ser compartilhada entre empresas.               ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.� Data   � Bops � Manutencao Efetuada                    ���
�������������������������������������������������������������������������Ĵ��
���              �  /  /  �      �                                        ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
*/
Static Function TableId(cAlias1,cEmp1,cAlias2,cEmp2)
Local cTableEmp1 := RetFullName(cAlias1,cEmp1)
Local cTableEmp2 := RetFullName(cAlias2,cEmp2)
Return( ( cTableEmp1 == cTableEmp2 ) )



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �c_Dprod   � Autor � RICARDO CAVALINI      � Data �25/01/2016���
�������������������������������������������������������������������������Ĵ��
���Descricao � obtem a descricao do cliente                               ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.� Data   � Bops � Manutencao Efetuada                    ���
�������������������������������������������������������������������������Ĵ��
���              �  /  /  �      �                                        ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
*/
Static function c_DSA1(PROCST)
__cDProd  := ""
__cCstPr  := PROCST
__cDesPrd := Posicione("SA1",1,XFILIAL("SA1")+__cCstPr,"A1_NOME")
return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �c_Dprod   � Autor � RICARDO CAVALINI      � Data �25/01/2016���
�������������������������������������������������������������������������Ĵ��
���Descricao � valida o codigo da empresa                                 ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.� Data   � Bops � Manutencao Efetuada                    ���
�������������������������������������������������������������������������Ĵ��
���              �  /  /  �      �                                        ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
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
