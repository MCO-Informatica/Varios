#Include "PROTHEUS.Ch"
#Include  "FONT.CH"
#Include  "COLORS.CH"


// 17/08/2009 -- Filial com mais de 2 caracteres

// TRADU��O RELEASE P10 1.2 - 21/07/08
/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
��� Fun��o    � Ctba499  � Autor  � Simone Mie Sato         � Data 06.06.02���                                    ���
��������������������������������������������������������������������������Ĵ��
��� Descri��o � Estorno Encerramento do Exercicio Contabil                 ���
��������������������������������������������������������������������������Ĵ��
���Sintaxe    � Ctba499()                                                  ���
��������������������������������������������������������������������������Ĵ��
���Retorno    � Nenhum                                                     ���
��������������������������������������������������������������������������Ĵ��
���  Uso      � SigaCTB                                                    ���
��������������������������������������������������������������������������Ĵ��
��� Par�metros� N�o h�                                                     ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
User Function LS_Ctba499()

Local aMoedCalen	:= {}					// Matriz com todas as moeda/calendario
Local cMensagem		:= ""

Private aRotina := MenuDef()

If ( !AMIIn(34) )		// Acesso somente pelo SIGACTB
	Return
EndIf

//��������������������������������������������������������������Ŀ
//� Armazena todas as moedas/calendarios      					 �
//����������������������������������������������������������������
dbSelectArea("CTG")
dbSetOrder(1)
dbGoTop()
While !Eof() 
	If CTG->CTG_STATUS = "2"
		nPosCalen := ASCAN(aMoedCalen,{|x| x[2] + x[3] == CTG->CTG_FILIAL + CTG->CTG_CALEND })
		If  nPosCalen == 0
			AADD(aMoedCalen,{.F.,CTG->CTG_FILIAL,CTG->CTG_CALEND,CTG->CTG_EXERC})
		EndIf
	EndIf
	dbSkip()
End

//��������������������������������������������������������������Ŀ
//� Mostra tela de aviso - processar exclusivo					 �
//����������������������������������������������������������������
cMensagem := OemToAnsi("E' MELHOR QUE OS ARQUIVOS ASSOCIADOS A ESTA ROTINA ")	+ chr(13)
cMensagem += OemToAnsi("NAO ESTEJA EM USO POR OUTRAS ESTACOES. ")				+ chr(13)
cMensagem += OemToAnsi("FACA COM QUE OS OUTROS USUARIOS SAIAM DO SISTEMA ")		+ chr(13)
cMensagem += Space(40)+CHR(13)
cMensagem += OemToAnsi("VERIFIQUE SE EXISTE ALGUM PRE-LANCAMENTO NO PERIODO ")	+ chr(13) 
cMensagem += OemToAnsi("A SER ENCERRADO. APOS RODAR O ENCERRAMENTO DO EXER- ")	+ chr(13) 
cMensagem += OemToAnsi("CICIO NAO PODERA MAIS EFETIVA-LOS!!!! "		)			+ chr(13)

IF !MsgYesNo(cMensagem,OemToAnsi("ATEN��O"))
	Return
Endif                 

Ctb499Cal(aMoedCalen)

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �Ctb499Cal � Autor � Simone Mie Sato       � Data � 06.06.02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Exibe na tela o calendario e a getdados                    ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � Ctb499Cal(aMoedcalend)                                     ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGACTB                                                    ���
�������������������������������������������������������������������������Ĵ��
���Parametros� aCalend = Array contendo todas as moedas/calendarios       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Ctb499Cal(aMoedCalen)

Local aMostrar	:= {}

Local cCalend

Local nOpca 	:= 0   

Local oDlg
Local oGet                 
Local oMoedCalen          
Local oOk	  	:= LoadBitmap( GetResources(), "LBOK" )	
Local oNo	  	:= LoadBitmap( GetResources(), "LBNO" )

Private aTELA[0][0],aGETS[0],aHeader[0]
Private aCols	:= {}

Private nUsado := 0
Private nPosDtIni, nPosDtFim, nPosStatus

CTG->(dbGoTop())
aMostrar	:= {CTG->CTG_FILIAL,CTG->CTG_CALEND,CTG->CTG_EXERC}

DEFINE MSDIALOG oDlg TITLE OemToAnsi("Estorno Encerramento do Exercicio") FROM 9,0 TO 25,85 OF oMainWnd
DEFINE FONT oFnt1	NAME "Arial" 			Size 10,12 BOLD  	
	
@ 0.3,.5 Say OemToAnsi("Estorno Encerramento do Exercicio") FONT oFnt1 COLOR CLR_RED
@ 13,04 BUTTON "Inverte Selecao" PIXEL OF oDlg SIZE 50,11;
		ACTION (	aEval(oMoedCalen:aArray, {|e| 	e[1] := ! e[1] }),;
						oMoedCalen:Refresh())                           						
						
@ 2,1 LISTBOX oMoedCalen VAR cCalend Fields HEADER "",OemToAnsi("FILIAL"),OemToAnsi("CALENDARIO"),OemToAnsi("EXERCICIO");
		  SIZE 145,70 ;                                                                      
		  ON CHANGE	(ct499Chang(aMoedCalen[oMoedCalen:nAt,2],aMoedCalen[oMoedCalen:nAt,3],aMoedCalen[oMoedCalen:nAt,4],@aMostrar,@oGet));	  		  
		  ON DBLCLICK(aMoedCalen:=CT240Troca(oMoedCalen:nAt,aMoedCalen),oMoedCalen:Refresh());
		  NOSCROLL
oMoedCalen:SetArray(aMoedCalen)
oMoedCalen:bLine := { || {if(aMoedCalen[oMoedCalen:nAt,1],oOk,oNo),aMoedCalen[oMoedCalen:nAt,2],aMoedCalen[oMoedCalen:nAt,3],aMoedCalen[oMoedCalen:nAt,4]}}

CTB010Ahead()
Ctb010Acols(2,aMostrar[3],aMostrar[2],aMostrar[1])
						
//GetDados
oGet := MSGetDados():New(028,160,098,330,1,,,,.T.)					
DEFINE SBUTTON FROM 100, 275 TYPE 1 ACTION (nOpca:=1,oDlg:End()) ENABLE Of oDlg
	
DEFINE SBUTTON FROM 100, 305 TYPE 2 ACTION oDlg:End() ENABLE Of oDlg

ACTIVATE MSDIALOG oDlg CENTERED

IF nOpca == 1
	Processa({|lEnd| ct499Proc(aMoedCalen)})
	DeleteObject(oOk)
	DeleteObject(oNo)			
Endif

	
Return 

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
��� Fun��o    �ct499Chang� Autor  � Simone Mie Sato         � Data 17.06.02���                                    ���
��������������������������������������������������������������������������Ĵ��
��� Descri��o �Acao para quando mudar de linha na ListBox                  ���
��������������������������������������������������������������������������Ĵ��
���Sintaxe    �ct499Chang                                                  ���
��������������������������������������������������������������������������Ĵ��
���Retorno    � Nenhum                                                     ���
��������������������������������������������������������������������������Ĵ��
���  Uso      � SigaCTB                                                    ���
��������������������������������������������������������������������������Ĵ��
��� Par�metros�                                                            ���
���           � 														   ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
STATIC Function ct499Chang(cFilCal,cCodCalend,cExerc,aMostrar,oGet)

Local aSaveArea := GetArea()

aMostrar[1]		:= cFilCal
aMostrar[2]		:=	cCodCalend
aMostrar[3]		:=	cExerc 

CTB010Ahead()
Ctb010Acols(2,aMostrar[3],aMostrar[2],aMostrar[1])

oGet:Refresh()

RestArea(aSaveArea)

Return

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
��� Fun��o    � ct499Proc� Autor  � Simone Mie Sato         � Data 17.06.02���                                    ���
��������������������������������������������������������������������������Ĵ��
��� Descri��o � Inicia o processamento do encerramento do exercicio        ���
��������������������������������������������������������������������������Ĵ��
���Sintaxe    � ct499Proc()                                                ���
��������������������������������������������������������������������������Ĵ��
���Retorno    � Nenhum                                                     ���
��������������������������������������������������������������������������Ĵ��
���  Uso      � SigaCTB                                                    ���
��������������������������������������������������������������������������Ĵ��
��� Par�metros� aMoedCalen = Array contendo as moedas/calendarios          ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
STATIC Function ct499Proc(aMoedCalen)

Local aSaveArea	:= GetArea()
Local dDataIni	:= CTOD("  /  /  ")
Local dDataFim	:= CTOD("  /  /  ")
Local nCalend                           
Local nMoedas	
Local aMoedas	:= {}


For nCalend := 1 to len(aMoedCalen)

	If aMoedCalen[nCalend][1]//Se o calendario foi selecionado
		dbSelectArea("CTE")
		dbSetOrder(1)
		MsSeek(aMoedCalen[nCalend][2])
		While !Eof() .And. CTE->CTE_FILIAL == aMoedCalen[nCalend][2]
		
			If CTE->CTE_CALEND <> aMoedCalend[nCalend][3]		
				dbSkip()
				Loop
			EndIf							
			AADD(aMoedas,{aMoedCalen[nCalend][3],aMoedCalend[nCalend][4],CTE->CTE_MOEDA,aMoedCalen[nCalend][2]})
			dbSkip()
		End
	    
		For nMoedas := 1 to Len(aMoedas)
			//Verificar qual a data inicial e a data final   	
			ct499Data(aMoedas[nMoedas][1],@dDataIni,@dDataFim,aMoedas[nMoedas][4])
	
			//Atualizar flag de saldo encerrado nos arquivos de saldos
			ct499Saldo(aMoedas[nMoedas][4],dDataIni,dDataFim,aMoedas[nMoedas][3])
		
			//Atualizar flag do calendario contabil (CTG)
			ct499CTG(aMoedas[nMoedas][1],aMoedas[nMoedas][2],aMoedas[nMoedas][4])		
		Next
		
		aMoedas	:= {}
		
	EndIf
Next

RestArea(aSaveArea)

Return

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
��� Fun��o    � ct499Data� Autor  � Simone Mie Sato         � Data 17.06.02���                                    ���
��������������������������������������������������������������������������Ĵ��
��� Descri��o � Data Inicial e Final a serem processadas                   ���
��������������������������������������������������������������������������Ĵ��
���Sintaxe    � ct499Data()                                                ���
��������������������������������������������������������������������������Ĵ��
���Retorno    � Nenhum                                                     ���
��������������������������������������������������������������������������Ĵ��
���  Uso      � SigaCTB                                                    ���
��������������������������������������������������������������������������Ĵ��
��� Par�metros� cCodCalend = Codigo do Calendario                          ���
���           � dDataIni   = Data Inicial a ser processada                 ���
���           � dDataFim   = Data Final a ser processada                   ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
STATIC Function ct499Data(cCodCalend,dDataIni,dDataFim,cFilCal)

Local aSaveArea	:= GetArea()
Local cFilCTG		:= xFilial("CTG",cFilCal)
dbSelectArea("CTG")
dbSetOrder(2)
//Pega a data inicial a ser processada
If MsSeek(cFilCTG+cCodCalend)
	dDataIni	:= CTG->CTG_DTINI
EndIf                            

//Pega a data final a ser processada
dbSetorder(3)	
MsSeek(cFilCTG+StrZero((Val(cCodCalend)+1),3),.T.)
dbSkip(-1)
If cFilCTG == CTG->CTG_FILIAL .And. cCodCalend == CTG->CTG_CALEND
	dDataFim	:= CTG->CTG_DTFIM
EndIf

RestArea(aSaveArea)

Return

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
��� Fun��o    �ct499Saldo| Autor  � Simone Mie Sato         � Data 17.06.02���                                    ���
��������������������������������������������������������������������������Ĵ��
��� Descri��o �Atualiza flag dos arquivos de saldos                        ���
��������������������������������������������������������������������������Ĵ��
���Sintaxe    � ct499Saldo(cFilDe,cFilAte,dDataIni,dDataFim)               ���
��������������������������������������������������������������������������Ĵ��
���Retorno    � Nenhum                                                     ���
��������������������������������������������������������������������������Ĵ��
���  Uso      � SigaCTB                                                    ���
��������������������������������������������������������������������������Ĵ��
��� Par�metros� cFilCal  = Codigo da Filial                                ���
���           � dDataIni = Data Inicial a ser encerrada                    ���
���           � dDataFim = Data Final a ser encerrada                      ���
���           � cMoeda   = Moeda a ser encerrada                           ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
STATIC Function ct499Saldo(cFilCal,dDataIni,dDataFim,cMoeda)

Local aSaveArea	:= GetArea()
Local aSaldos	:= {"CT7","CT3","CT4","CTI","CT6","CTC","CTU","CTV","CTW","CTX"}
Local aOrdem	:= {4,3,3,3,1,1,3,5,5,5,5}

Local cInicial	:= ""
Local cChave	:= ""
Local nArqs

#IFDEF TOP
	Local cQuery	:= ""                             
	Local cQueryFlg	:= ""
	Local cSaldos	:= ""                                       	
	Local nMin		:= 0
	Local nMax		:= 0      
#ENDIF

For nArqs	:= 1 to Len(aSaldos)		
	ProcRegua((aSaldos[nArqs])->(RecCount()))
	cInicial := aSaldos[nArqs] + "_"		
	#IFDEF TOP
		If TcSrvType() != "AS/400"	
			cSaldos  := "cSaldos"	
			cQuery := "SELECT R_E_C_N_O_ RECNO "
			cQuery += "FROM "+RetSqlName(aSaldos[nArqs])+ " ARQ "
			cQuery += "WHERE "
			If !Empty(xFilial("CTG"))
				cQuery += "ARQ."+cInicial+ "FILIAL = '"+xFilial(aSaldos[nArqs],cFilCal)+"'  AND "
			EndIf
			cQuery += "ARQ."+cInicial+"DATA BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFim)+"' AND "
			cQuery += "ARQ."+cInicial+"MOEDA = '" + cMoeda + "'"
			cQuery += " ORDER BY RECNO "
			cQuery := ChangeQuery(cQuery)
		
			If ( Select ( "cSaldos" ) <> 0 )
				dbSelectArea ( "cSaldos" )
				dbCloseArea ()
			Endif
			
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cSaldos,.T.,.F.)
		
			
			cQueryFlg 	:= "UPDATE "
			cQueryFlg 	+= RetSqlName(aSaldos[nArqs])+" "
			cQueryFlg 	+= "SET "+cInicial+"STATUS = '1' "
			cQueryFlg   += " WHERE "
			If !Empty(xFilial("CTG"))
				cQueryFlg	+= " " +cInicial+ "FILIAL = '"+xFilial(aSaldos[nArqs],cFilCal)+"' AND "
			EndIf
			cQueryFlg	+= cInicial+"DATA BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFim)+"' AND "
			cQueryFlg	+= cInicial+"MOEDA = '" + cMoeda + "' "

			While cSaldos->(!Eof())
	
				nMin := (cSaldos)->RECNO
			
				nCountReg := 0
				
				While cSaldos->(!EOF()) .and. nCountReg <= 4096
					
					nMax := (cSaldos)->RECNO
					nCountReg++
					cSaldos->(DbSkip())

				End
				
				cChave := " AND R_E_C_N_O_>="+Str(nMin,10,0)+" AND R_E_C_N_O_<="+Str(nMax,10,0)+""
				TcSqlExec(cQueryFlg+cChave)
		
			End
		Else
	#ENDIF 	
		Do Case 
		Case aSaldos[nArqs] $ 'CT7/CT3/CT4/CTI'
			cChave	:= Dtos(dDataIni)
		Case aSaldos[nArqs] = 'CTU'
			cChave	:= "CTD"+"1"+cMoeda+DTOS(dDataIni)		
		Case aSaldos[nArqs] $ 'CTV/CTW/CTX/CTY'
			cChave	:= "1"+cMoeda+DTOS(dDataIni)
		EndCase
		
		
		dbSelectArea(aSaldos[nArqs])      
		dbSetOrder(aOrdem[nArqs])
     	MsSeek(xFilial(aSaldos[nArqs],cFilCal)+cChave,.T.)     	
     	While !Eof() .And. &(cInicial+"FILIAL") == xFilial(aSaldos[nArqs],cFilCal) 
     	
   			If &(cInicial+"MOEDA") <> cMoeda
   				dbSkip()
   				Loop
   			EndIf
     	
   			If &(cInicial+"DATA") < dDataIni .Or. &(cInicial+"DATA") > dDataFim 
   				dbSkip()
   				Loop
   			EndIf
   			
	    	IncProc() 		
	    	
     		Reclock(aSaldos[nArqs],.F.)
			&(aSaldos[nArqs]+"->"+cInicial+"STATUS") := "2"
     	    MsUnlock()
     	    dbSkip()
		End

	#IFDEF TOP
		EndIf
	#ENDIF
Next
RestArea(aSaveArea)

Return

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
��� Fun��o    �ct499CTG  | Autor  � Simone Mie Sato         � Data 17.06.02���                                    ���
��������������������������������������������������������������������������Ĵ��
��� Descri��o �Atualiza flag do calendario contabil                        ���
��������������������������������������������������������������������������Ĵ��
���Sintaxe    � ct499CTG()               ���
��������������������������������������������������������������������������Ĵ��
���Retorno    � Nenhum                                                     ���
��������������������������������������������������������������������������Ĵ��
���  Uso      � SigaCTB                                                    ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
STATIC Function ct499CTG(cCalend,cExerc,cFilCal)

Local aSaveArea	:= GetArea()
Local cFIlCTG		:= xFilial("CTG",cFilCal)

dbSelectArea("CTG")
dbSetOrder(1)
If MsSeek( cFIlCTG +cCalend+cExerc)
	While CTG->CTG_FILIAL == cFIlCTG .And. CTG->CTG_CALEND == cCalend .And. ;
			CTG->CTG_EXERC == cExerc .And. CTG->(!Eof()) 
		Reclock("CTG",.F.)
		CTG->CTG_STATUS := '1'
		MsUnlock()
		CTG->(dbSkip())	
	End
EndIf  

RestArea(aSaveArea)
Return

/*/
���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �MenuDef   � Autor � Ana Paula N. Silva     � Data �01/12/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Utilizacao de menu Funcional                               ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Array com opcoes da rotina.                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Parametros do array a Rotina:                               ���
���          �1. Nome a aparecer no cabecalho                             ���
���          �2. Nome da Rotina associada                                 ���
���          �3. Reservado                                                ���
���          �4. Tipo de Transa��o a ser efetuada:                        ���
���          �		1 - Pesquisa e Posiciona em um Banco de Dados     ���
���          �    2 - Simplesmente Mostra os Campos                       ���
���          �    3 - Inclui registros no Bancos de Dados                 ���
���          �    4 - Altera o registro corrente                          ���
���          �    5 - Remove o registro corrente do Banco de Dados        ���
���          �5. Nivel de acesso                                          ���
���          �6. Habilita Menu Funcional                                  ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MenuDef()
	Local aRotina := {	{ OemToAnsi("Visualizar"),"Ctb499Cal", 0 , 2}}						
Return(aRotina)
