#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"

/*
+==================+========================+=====================+
|Programa:LSVIMPSF |Autor:Antonio Carlos    |Data: 26/08/08       |
|                  |      Ricardo Felipelli |Data: 15/09/08       |
+==================+========================+=====================|
|Descricao: Rotina responsavel pela importacao da tabela PAT onde |
|realizamos a movimentacao bancaria no Protheus(SE5).             |
+=================================================================+
|Uso: Laselva                                                     |
+=================================================================+
*/

User Function LSVIMPMB(aParam)

Local nHdlLock	:= 0
Local cArqLock 	:= "LSVIMPMB.lck"
Private _lJob	:= (aParam == Nil .Or. ValType(aParam) <> "A")

If !_lJob
	If aParam == Nil .Or. ValType(aParam) <> "A"
		Conout("Parametros nao recebidos => Empresa e Filial")
		Return
	Else
		Conout("Parametros recebidos => Empresa "+aParam[1]+" Filial "+aParam[2])
	EndIf
	
	//====================================================//
	//Efetua o Lock de gravacao da Rotina - Monousuario   //
	//====================================================//
	
	FErase(cArqLock)
	nHdlLock := MsFCreate(cArqLock)
	If nHdlLock < 0
		Conout("Rotina "+FunName()+" ja em execução.")
		Return(.T.)
	EndIf
	
	If FindFunction('WFPREPENV')
		Conout("Preparando Environment")
		WfPrepENV(aParam[1], aParam[2])
	Else
		Prepare Environment Empresa aParam[1]Filial aParam[2] Tables "PAT","SE5"
	EndIf
	Conout("Iniciando LSVIMPMB")
	Conout(Replicate("_",50))
	
	Integra()
	
	Conout("Finalizando LSVIMPMB")
	Conout(Replicate("_",50))
	
	Reset Environment
	
	//==========================================//
	// Cancela o Lock de gravacao da rotina     //
	//==========================================//
	
	FClose(nHdlLock)
	FErase(cArqLock)
	
Else
	AtuDados()
EndIf

Return



Static Function AtuDados()

Local cCadastro    	:= "Importa Movimentacao Bancaria"
Local aSays        	:= {}
Local aButtons     	:= {}
Local nOpc        	:= 0
Local oDlg
Private oProcess


AADD(aSays,OemToAnsi("Esta rotina realiza a importacao dos registros de movimentacao"))
AADD(aSays,OemToAnsi("bancaria do Socim para a tabela SE5 do Protheus."))

AADD(aButtons, { 1,.T.,{|o| nOpc:= 1,If(MsgYesNo(OemToAnsi("Confirma processamento?"),OemToAnsi("Atenção")),o:oWnd:End(),nOpc:=0) } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

FormBatch( cCadastro, aSays, aButtons,,200,405 )

If nOpc == 1
	Processa( {|lEnd| Integra(@lEnd)}, "Aguarde...","Executando rotina.", .T. )
EndIf

Return Nil

Static Function Integra()

Local aArea		:= GetArea()
Local nTotRec	:= 0
Local _aCpoErr	:= {}
Local lGrava	:= .T.
Local cHoraI	:= Time()
Local cHoraF

//PAT_FILIAL + PAT_DTFECH + PAT_OPERAD + PAT_PDV + PAT_TURNO + PAT_NUMCFI + PAT_FORMA

cQryPAT := " SELECT PAT_FILIAL, PAT_DTFECH, SUM(PAT_VLRSIS) AS VALOR, SUM(PAT_VLRDIG) AS VALORDIG, PAT_TURNO, PAT_FORMA, PAT_BANCO, PAT_AGENCI, PAT_CONTA, PAT_NUMCFI  "
cQryPAT += " FROM "+RetSqlName("PAT")+" PAT (NOLOCK)"

cQryPAT += " WHERE PAT_DTFECH >= '20080901' AND  PAT_DTFECH <= '20090630' AND "
// autorizado pelo sr,jonas

cQryPAT += " PAT_FORMA = 'R$' AND "
cQryPAT += " PAT.D_E_L_E_T_ = '' "
cQryPAT += " AND PAT_STATUS <> 'S' "
cQryPAT += " GROUP BY PAT_FILIAL, PAT_DTFECH, PAT_TURNO, PAT_FORMA, PAT_BANCO, PAT_AGENCI, PAT_CONTA, PAT_NUMCFI "
cQryPAT += " ORDER BY PAT_FILIAL, PAT_DTFECH, PAT_TURNO "

dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQryPAT), "TMPPAT", .F., .T.)

Count To nTotRec
ProcRegua(nTotRec)

//Inicio da integracao

DbSelectArea("TMPPAT")
TMPPAT->(DbGoTop())
If TMPPAT->(!Eof())
	
	While !TMPPAT->(Eof())
		
		_PAT_DTFECH := TMPPAT->PAT_DTFECH
		_PAT_FILIAL := TMPPAT->PAT_FILIAL
		
		While !TMPPAT->(Eof()) .AND. _PAT_DTFECH==TMPPAT->PAT_DTFECH .AND. _PAT_FILIAL==TMPPAT->PAT_FILIAL
			
			If _lJob
				IncProc("Processando...")
			Else
				Conout("PAT -> SE5 "+TMPPAT->PAT_FILIAL+"-"+TMPPAT->PAT_DTFECH+"-"+TMPPAT->PAT_TURNO)
			EndIf
			
			
			Begin Transaction
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Tabela de resumo PAT -> SE5          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			
			DbSelectArea("SX5")
			Dbsetorder(01)
			SX5->(dbseek(space(02)+'ZD'+TMPPAT->PAT_FILIAL))
			if SX5->(found())
				_conta := alltrim(SX5->X5_DESCRI)
			else
				_conta := ''
			endif
			
			DbSelectArea("SE5")
			SE5->(DbOrderNickName("DOCUMEN"))
			//SE5->(DbSetOrder("A"))
			
			lGrava := !SE5->(DbSeek(TMPPAT->PAT_FILIAL+TMPPAT->PAT_DTFECH+TMPPAT->PAT_TURNO))
			
			RecLock("SE5",lGrava)
			
			SE5->E5_FILIAL 	    := TMPPAT->PAT_FILIAL
			SE5->E5_DATA 		:= STOD(TMPPAT->PAT_DTFECH)
			SE5->E5_MOEDA 		:= TMPPAT->PAT_FORMA
			SE5->E5_VALOR 		:= TMPPAT->VALOR
			SE5->E5_NATUREZ 	:= "DEPOSITO"
			SE5->E5_BANCO 		:= TMPPAT->PAT_BANCO
			SE5->E5_AGENCIA 	:= TMPPAT->PAT_AGENCI
			SE5->E5_CONTA 		:= TMPPAT->PAT_CONTA
			SE5->E5_DOCUMEN		:= TMPPAT->PAT_FILIAL+TMPPAT->PAT_DTFECH+TMPPAT->PAT_TURNO
			SE5->E5_VENCTO      := STOD(TMPPAT->PAT_DTFECH)
			SE5->E5_RECPAG   	:= "R"
			SE5->E5_BENEF 		:= Alltrim(GetAdvFVal("SM0","M0_NOME",cEmpAnt + TMPPAT->PAT_FILIAL,1))+" - "+Alltrim(GetAdvFVal("SM0","M0_FILIAL",cEmpAnt + TMPPAT->PAT_FILIAL,1))
			SE5->E5_HISTOR   	:= "MOVTO EM REAIS - "+DTOC(SE5->E5_DATA)+" PERIODO: "+TMPPAT->PAT_TURNO
			SE5->E5_DTDIGIT		:= STOD(TMPPAT->PAT_DTFECH)
			SE5->E5_DTDISPO		:= STOD(TMPPAT->PAT_DTFECH)
			SE5->E5_FILORIG	    := TMPPAT->PAT_FILIAL
			SE5->E5_MODSPB	    := "4"
			SE5->E5_DEBITO      := _conta
			SE5->E5_SERREC      := TMPPAT->PAT_NUMCFI
			
			SE5->(MsUnlock())
			
			if  TMPPAT->VALORDIG - TMPPAT->VALOR  <> 0
				RecLock("SE5",.T.)
				
				SE5->E5_FILIAL 	    := TMPPAT->PAT_FILIAL
				SE5->E5_DATA 		:= STOD(TMPPAT->PAT_DTFECH)
				SE5->E5_MOEDA 		:= TMPPAT->PAT_FORMA
				SE5->E5_VALOR 		:= TMPPAT->VALORDIG-TMPPAT->VALOR
				SE5->E5_NATUREZ 	:= "DEPOSITO"
				SE5->E5_BANCO 		:= TMPPAT->PAT_BANCO
				SE5->E5_AGENCIA 	:= TMPPAT->PAT_AGENCI
				SE5->E5_CONTA 		:= TMPPAT->PAT_CONTA
				SE5->E5_DOCUMEN		:= TMPPAT->PAT_FILIAL+TMPPAT->PAT_DTFECH+TMPPAT->PAT_TURNO
				SE5->E5_VENCTO      := STOD(TMPPAT->PAT_DTFECH)
				SE5->E5_RECPAG   	:= "R"
				SE5->E5_BENEF 		:= Alltrim(GetAdvFVal("SM0","M0_NOME",cEmpAnt + TMPPAT->PAT_FILIAL,1))+" - "+Alltrim(GetAdvFVal("SM0","M0_FILIAL",cEmpAnt + TMPPAT->PAT_FILIAL,1))
				IF TMPPAT->VALORDIG-TMPPAT->VALOR < 0
					SE5->E5_HISTOR   	:= "FALTA EM REAIS (Q.C.) - "+DTOC(SE5->E5_DATA)+" PER.: "+TMPPAT->PAT_TURNO
					SE5->E5_DEBITO := '43011009'
				ELSE
					SE5->E5_HISTOR   	:= "SOBRA EM REAIS - "+DTOC(SE5->E5_DATA)+" PERIODO: "+TMPPAT->PAT_TURNO
					SE5->E5_DEBITO := '55512002'
				END
				
				SE5->E5_DTDIGIT		:= STOD(TMPPAT->PAT_DTFECH)
				SE5->E5_DTDISPO		:= STOD(TMPPAT->PAT_DTFECH)
				SE5->E5_FILORIG	    := TMPPAT->PAT_FILIAL
				SE5->E5_MODSPB	    := "4"
				SE5->E5_SERREC      := TMPPAT->PAT_NUMCFI
				
				SE5->(MsUnlock())
				
			endif
			
			End Transaction
			
			TMPPAT->(DbSkip())
		ENDDO
		
		
		DbSelectArea("PAT")
		PAT->(DbSetOrder(1))
		PAT->(DBSEEK(_PAT_FILIAL+_PAT_DTFECH))
		
		while PAT->(!EOF()) .AND. PAT->PAT_DTFECH==ctod(subst(_PAT_DTFECH,7,2)+"/"+subst(_PAT_DTFECH,5,2)+"/"+subst(_PAT_DTFECH,3,2)) .AND. _PAT_FILIAL==PAT->PAT_FILIAL
			IF empty(PAT->PAT_STATUS)
				RecLock("PAT",.F.)
				PAT->PAT_STATUS := "S"
				MsUnLock()
			ENDIF
			PAT->(DBSKIP())
		ENDDO
		
	EndDo
	
	
	cHoraF := Time()
	If _lJob
		Aviso("Importacao","Importacao realizada com sucesso!, Inicio: "+cHoraI+" Fim: "+cHoraF ,{"Ok"})
	Else
		Conout("LSVIMPSF - Importacao realizada com sucesso!")
	EndIf
Else
	If _lJob
		Aviso("Importacao","Nao ha registros para importacao!",{"Ok"})
	Else
		Conout("LSVIMPSF - Nao ha registros para importacao!")
	EndIf
	
EndIf

DbSelectArea("TMPPAT")
DbCloseArea("TMPPAT")

RestArea(aArea)

Return   
