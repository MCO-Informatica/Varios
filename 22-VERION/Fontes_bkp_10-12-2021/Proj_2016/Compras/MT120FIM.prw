#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MT120FIM  ³ Autor ³ RICARDO CAVALINI      ³ Data ³01/09/2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³ Ponto de entrada utilizado apos a gravacao do pedido de    ³±±
±±³Descricao ³ compras, tem por objetivo duplicar os pedidos entre a      ³±±
±±³          ³ empresa AEM e Verion. Conforme solicitacao do cliente      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³ Data   ³ Bops ³ Manutencao Efetuada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³      ³                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT120FIM()
                             
// ponto de entrada que so deve funcionar na AEM E NA INCLUSAO SOMENTE
IF cEmpAnt == "01" 
   Return
ENDIF

IF cEmpAnt == "02"  .AND. PARAMIXB[1] = 3   .AND. PARAMIXB[3] = 0     
   Return
ENDIF

IF cEmpAnt == "02"  .AND. PARAMIXB[1] <> 3 
   Return
ENDIF

// chamada do programa para replidar o pedido de compras entre as empresas AEM  e Verion
Processa({||SC7COPI()},"Replicacao de Pedido de Compras (AEM ==> Verion)!!!")

Return

// INICIO DA MONTAGEM DOS DADOS
Static Function SC7COPI()
Local aHeader   := {}
Local aRecno    := {}
Local aCols     := {}
Local ACARDEMP  := {}
Local cEPCod    := SC7->C7_NUM  //__cCodPrd
Local nUsado

cSvFilAnt := cFilAnt // Salva a Filial Anterior
cSvEmpAnt := cEmpAnt // Salva a Empresa Anterior
cOrFilAnt := cFilAnt // SUBSTR(__ceMPfIL,4,2) // Filial conforme parametro
cOrEmpAnt := cEmpAnt // SUBSTR(__ceMPfIL,1,2) // Empresa conforme parametro
cSvArqTab := cArqTab // Salva os arquivos de //trabalho
cModo     := ""      // Modo de acesso do arquivo aberto //"E" ou "C"
aAreaSC7  := SC7->( GetArea() )
cFilNew   := ""
cEmpNew   := ""
_lTdCrr   := .T.
_cpcAEM   := PARAMIXB[2]

If SC7->(C7_FORNECE+C7_LOJA) $ "00000101/00006301"
   If  MsgYesNo("Este Pedido usa o fornecedor Verion. Deseja copia-lo para empresa Verion ?")
       _lTdCrr   := .T.
   Else
      Return
   Endif
Else 
  Return
Endif

// Obtem os campos da tabela SC7 - PEDIDO DE COMPRAS
nUsado := 0

dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("SC7")
While !Eof() .And. SX3->X3_ARQUIVO == "SC7"
	If X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL
		Aadd(aHeader, { AllTrim(X3Titulo()),SX3->X3_CAMPO  ,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,;
		SX3->X3_VALID      ,SX3->X3_USADO  ,SX3->X3_TIPO   ,SX3->X3_F3     ,SX3->X3_CONTEXT,;
		X3Cbox()           ,SX3->X3_RELACAO,".T."})
		nUsado++
	EndIf
	dbSelectArea("SX3")
	dbSkip()
End


// Seleciona o pedido de compras a copiar...
_CMOEDA := ""
_NTXMOE := 0

dbSelectArea("SC7")
dbSetOrder(1)
If !dbSeek(cFilAnt+cEPCod)
	ApMsgAlert("Pedido nao encontrado. Finalizando a rotina, sem fazer a copia !!!")
	Return
Endif

While !Eof() .and. SC7->C7_NUM == cEPCod
_CMOEDA := SC7->C7_MOEDA
_NTXMOE := SC7->C7_TXMOEDA

// monta matriz com a informacao dos campos do pedido de compras....
Aadd(aCols,Array(nUsado+1))
Aadd(aRecno,SC7->(Recno()))
For nX := 1 To nUsado
	If ( aHeader[nX,10] !=  "V" )
		aCols[Len(aCols)][nX] := FieldGet(FieldPos(aHeader[nX,2]))
	else
		aCols[Len(aCols)][nX] := CriaVar(aHeader[nX,2],.T.)
	EndIf
Next nX

aCols[Len(aCols)][nUsado+1] := .F.

  DBSELECTAREA("SC7")
  DBSKIP()
  LOOP

END

ACARDEMP := {}
_AOUTFIL := {}

// ESCOLHAR AS EMPRESAS PARA COPIA
AADD(ACARDEMP, {"01","01"}) // {empresa,filial}  VERION
AADD(_AOUTFIL, {"01","01"}) // {empresa,filial}  VERION

// fecha a rotina por ter sido cancelada na tela das filiais...
If Len(ACARDEMP) = 0
	Return(NIL)
Endif

// Validacao para ver se as outras empresa selecionadas tem a tabela "SB1" comum ou exclusiva...
_aunicafil := {}
__cempNew  := ""
nScan      := 0

// encontra somente uma empresa para verificacao do SX2, conforme codigo da empresa....
For jp := 1 to len(_AOUTFIL)
	__cempNew  := _AOUTFIL[jp,1]  // posicao do array do codigo da empresa
	
	nScan := aScan(_aunicafil,{|x| x[1] == __cempNew})  // verifica se ja existe no array unico de empresa
	
	If ( nScan==0 )
		aadd(_aunicafil,{ _AOUTFIL[jp,1],"SC7"})
	Endif
Next jp

//  analise no sx2 das outras empresas para fazer a inclusao de dados na empresa/filial.
_cCmum   := .F.
_cEmpMom := ""
For mc := 1 to Len(_aunicafil)
	
	// Verifica compartilhamento da tabela entre as empresas, ou seja, verifica se a tabela e comum entre as empresas...
	//          TableId("TABELA",EMPRESA ATUAL,"TABELA",EMPESA QUE RECBERA A INFORMACAO)
	_cCmum   := TableId("SC7"   ,cOrEmpAnt    ,"SC7"   ,_aunicafil[mc,1])
	
	_cEmpMom := _aunicafil[mc,1]  // empresa que recebera a informacao
	
	if !_cCmum  // Se nao for comum o SC7.
		
		If _cEmpMom == _AOUTFIL[1,1]
			cFilNew   :=  _AOUTFIL[1,2]  // filial que recebera o registro
			cEmpNew   :=  _AOUTFIL[1,1]  // empresa que recebera o registro
			nOrder    := 1                // index que sera usado
			
			// Verifica se a Tabela e Compartilhada entre empresas
			IF !(EqualFullName("SC7",cEmpNew,cEmpAnt))
				aArea  := SC7->(GetArea())
				nOrder := SC7->(IndexOrd())
				
				//Abre Tabelas de Outra empresa com o Mesmo alias
				EmpChangeTable("SC7",cEmpNew,cEmpAnt,nOrder )
			endif
		Endif
		
		// Gravaçao de dados na tabela
		For Gl := 1 to Len(_AOUTFIL)
			IF _cEmpMom == _AOUTFIL[GL,1]
				
				// Testa para evitar duplicidade de cadastramento em outras filiais
				lOk := .T. 
		
				dbSelectArea("SC7")
				dbsetorder(1)
				dbgotop()
				DBSEEK(alltrim(_AOUTFIL[Gl,2])+"100000",.T.)
				DBSKIP(-1)
				                                                                           
				cEPCodn := STRZERO((VAL(SC7->C7_NUM)+1),6)

				dbSelectArea("SC7")
				dbsetorder(1)
				dbgotop()
				If dbSeek(alltrim(_AOUTFIL[Gl,2])+cEPCodn)
					ApMsgAlert("Pedido ja cadastrado ")
					lOk := .F.
				Endif
				
				// Grava o pedido de compras
				If lOk
					For nCntFor := 1 To Len(aCols)
						If ( !aCols[nCntFor][nUsado+1] )
							
							RecLock("SC7",.T.)
							_lTdCrr := .T.
							
							if _lTdCrr
								SC7->C7_FILIAL  := alltrim(_AOUTFIL[Gl,2])
								SC7->C7_NUM     := cEPCodn
								SC7->C7_FORNECE := "000093"
								SC7->C7_LOJA    := "01"
								SC7->C7_COND    := "050"     
								SC7->C7_EMISSAO := DDATABASE
								SC7->C7_FILENT  := "01"    
								SC7->C7_TIPO    := 1     
								SC7->C7_IPIBRUT := "B"
								SC7->C7_MOEDA   := _CMOEDA
								SC7->C7_TXMOEDA := _NTXMOE 
 				 							
								For nCntFor2 := 1 To nUsado
									If ( aHeader[nCntFor2][10] != "V" ) .or.;
									  !(ALLTRIM(UPPER(aHeader[nCntFor2][2]))$"C7_FILIAL/C7_NUM/C7_FORNECE/C7_LOJA/C7_COND/C7_EMISSAO/C7_FILENT/C7_TIPO/C7_IPIBRUT/C7_V_PCORI")
										SC7->(FieldPut(FieldPos(aHeader[nCntFor2][2]),aCols[nCntFor][nCntFor2]))
									EndIf                          
								Next nCntFor2
 							    SC7->C7_V_PCORI := alltrim(_cpcAEM)
 							    SC7->C7_NUMSC   := ""
 							    SC7->C7_ITEMSC  := ""
							    
								MsUnLock("SC7")
							endif
						Endif
					Next nCntFor
				Endif
			Endif
		Next Gl
	Endif
Next mc

msgalert("Pedido na Verion: "+cEPCodn)

// abertura da tabela conforme empresa original - Retorna o arquivo para empresa AEM
EmpChangeTable("SC7",cEmpAnt,cEmpnew,nOrder )                    


// Grava numero de pedido de compras gerado na Verion. Na empresa AEM para controle do usuario.                                                                 
dbselectarea("SC7")
dbSetorder(1)
DbGotop()    

If Dbseek(Xfilial("SC7")+_cpcAEM)


   While !Eof() .and. SC7->C7_NUM == _cpcAEM
   
         Dbselectarea("SC7")   
         RecLock("SC7",.F.)
          SC7->C7_V_PCORI := cEPCodn
         MsUnLock("SC7")

         Dbselectarea("SC7")      
         DbSkip()
         Loop
   End
Endif

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