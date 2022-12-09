#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"

//-----------------------------------------------------------------------
/*/{Protheus.doc} CSAG0015
Funcao responsavel por gerar novo boleto a partir de um Numero de OS 
ja gerado.

Realizado ajuste para quando for Boleto Registrado, seja possivel
gerar 10 novos boletos mantendo a mesma numeracao da OS, somente
alterando o Prefixo do Agendamento Externo.

Ex:  
9 -> Agendamento Externo
9 -> Sequencial de boletos gerados (9 a 0) Decrescente.
123456 -> Numero da Ordem de Servico.


@author	Claudio Correa (TOTVS) / Douglas Parreja (Ajustes Boleto Reg.)
@version 11.8
/*/
//-----------------------------------------------------------------------
User Function CSAG0015()

Local lHasButton := .T.
Local lRet := .F.
local cNumControle := ""

Private cOs := PA0->PA0_OS
Private cEmail := Space(100)
Private cClifat := IIF(Empty(PA0->PA0_CLIFAT),PA0->PA0_CLILOC,PA0->PA0_CLIFAT)
Private cCliloj := POSICIONE("SA1",1,xFILIAL("SA1")+cClifat, "A1_LOJA")
Private nTotReg := 0
Private aRet := {}
Private nSoma := 0
Private aVal := {}
Private dGet := Date()

If PA0->PA0_STATUS <> "1" .And. PA0->PA0_STATUS <> "6"

	MsgAlert("Esta Ordem de Serviço ja foi liberada" + CRLF + "Não é possivel a geração de um novo boleto")
	
	Return(lRet)
	
End If

cEmail := PA0->PA0_EMAIL
 
DEFINE MSDIALOG oDlg TITLE "Geração de Boleto" FROM 000, 000  TO 100, 400 COLORS 0, 16777215 PIXEL

oTGet := TGet():New( 005,009,{||cEmail},oDlg, ;
170, 010, "@!",, 0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,"cEmail",,,,lHasButton )
 
oGet := TGet():New( 020, 009, { | u | If( PCount() == 0, dGet, dGet := u ) },oDlg, ;
060, 010, "@D",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"dGet",,,,lHasButton  )

@ 35,120 BUTTON "&Ok"       SIZE 36,12 PIXEL ACTION IIF(lRet := CSAGGBOL(),oDlg:End(),MsgAlert("Boleto não gerado, favor verifique os parametros inseridos."))
@ 35,160 BUTTON "&Cancelar" SIZE 36,12 PIXEL ACTION IIF(oDlg:End(), lRet := .F. , lRet := .F.)
 
ACTIVATE MSDIALOG oDlg CENTERED

Return(lRet)

Static Function CSAGGBOL()

Local cAlert		:= ""
Local cLocal		:= MsDocPath()
Local cAssuntoEm	:= "Geração de Novo Boleto - "+ cOs
local lRet			:= .F.     
local cMVBolReg		:= GetNewPar("MV_BOLETRG","2")   
local lContinua		:= .F. 
local lReclock		:= .F.

nSoma := 0
	
dbSelectArea("PA1")
dbSetOrder(1)
dbSeek(xFilial("PA0")+cOS)

If PA1->(Found())
   
	While PA1->(!EOF()) .and. PA1->PA1_OS == cOS
	
		If PA1->PA1_FATURA == "S" 
	
			AADD(aVal,PA1->PA1_VALOR)
			
		End If
			
		PA1->(DbSkip() )
   
   	End
   	
   	For v := 1 to  Len(aVal)			
			
		nSoma += aVal[v]
			
	Next v
   	
Else 

	If PA1->PA1_FATURA == "N"

		aAdd(aRet,{.T.,"",""})
		
	Else
	
		MsgAlert("Deve haver no minimo um produto com Fatura Sim ou Fatura Não")
 	
		aAdd(aRet,{.F.,"",""})
	
	End If
	
End If

//--------------------------------------------------------------------
// Alterado a logica da estrutura de condicao.
// @autor: Douglas Parreja
// @Since: 30/01/2017
//--------------------------------------------------------------------
dbSelectArea("PAW")
dbSetOrder(4)
dbSeek(xFilial("PA0")+cOs)

If PAW->(Found())

	If dGet >= DaySub( PAW->PAW_DATA, 2 )
	
		cAlert := "A data informada deve ser 48 horas menor que o dia do pré agendamento." + CRLF 
		cAlert += "OS: "+ cOs + CRLF 
		cAlert += "Data Agendamento: "
		cAlert += dToc(PAW->PAW_DATA) + CRLF + CRLF 
		cAlert += "Deseja realizar a geração do Boleto assim mesmo?"
		
		if ApMsgNoYes(cAlert, "Gera Boleto") 
			lContinua := .T.		
		else		
			lRet := .F.
			return(lRet)			
		endif
	else
		lContinua := .T.
	endif
		
	if lContinua
	
		dDataV := DataValida(dGet, .F.)                                     
		
		aRet := U_CSFSGBOL(cClifat,cOs,cCliloj,nSoma,dDataV)
				
		if len(aRet) > 0
			
			If aRet[1][1] == .T.
				
				lRet := aRet[1][1]
				
				cRN := aRet[1][3]
				dDataVen := aRet[1][2]
						
				cAnexo := cOs+".PDF"    					
				//--------------------------------------------------------------------
				// Condicao para enviar e-mail com Boleto (legado) ou Link (ShopLine)
				// @autor: Douglas Parreja
				// @Since: 30/01/2017
				//--------------------------------------------------------------------
				if !empty( cMVBolReg )
					if cMVBolReg == "1" 
						cFileName := cLocal+"\"+cAnexo
					elseif cMVBolReg == "2" 
						if len( aRet[1][4] ) > 0
							cFileName := alltrim( aRet[1][4] )
						else
							cFileName := "Link não gerado, por gentileza informe a Certisign para que possamos providenciar o Boleto."  
							lErro := .T.
						endif
					endif
				endif    
				
				cCase := "ABERTURA"
			
				If lRet := U_CSFSEmail(cOs, cFileName, cEmail, cAssuntoEm, cCase)
				
					DbSelectArea("PA0")
					DbSetOrder(1)
					DbSeek(xFilial("PA0")+cOS)
			
					If Found()							
						BEGIN TRANSACTION                         
							RecLock("PA0",.F.)
							PA0->PA0_LINDIG := cRN
							PA0->PA0_DTEBOL := dDataBase
							PA0->PA0_DTVBOL := dDataVen   
							if cMVBolReg == "2" 
								PA0->PA0_LINK 	:= cFileName
								PA0->PA0_STMAIL	:= "3"	//Gerado novo boleto
							endif
							MsUnlock("PA0")      								
						END TRANSACTION																
						lRet := .T.		
					endif  
					
					if lRet
				   		//--------------------------------------------------------------------
						// Tabela para gerar historico de todos boletos gerados para aquela
						// mesma Ordem de Servico
						// @autor: Douglas Parreja
						// @Since: 30/01/2017
						//--------------------------------------------------------------------
						if cMVBolReg == "2" 
							
							cNumControle := iif( len(aRet[1][5]) > 0, alltrim(aRet[1][5]), "" )  
							
							lRetZZV := u_csGravaZZV( alltrim(PA0->PA0_OS), cNumControle, dDataVen, cFileName  )	 
							if !(lRetZZV)
								Aviso( "Geração de Boleto", "Não foi possível gerar o Histórico do Boleto.", {"Ok"} )	
							endif					
						endif					
					endif				
				
					Aviso( "Geração de Boleto", "Boleto gerado com sucesso", {"Ok"} )
					
					lRet := .T.					
				End If					
			End If								
		Endif
	endif	
Else
	MsgAlert("Não há agendamento relacionado a este atendimento, contate o administrador do sistema!")	
End If
	
Return (lRet)  


