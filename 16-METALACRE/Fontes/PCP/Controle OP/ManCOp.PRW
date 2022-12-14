#include "rwmake.ch"
#include "topconn.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "COLORS.CH"

User Function ManCop

Private cCadastro := "Manuten??o de Apontamentos"  

Private aCores := {	 {"PWU->PWU_STATUS =='P'" , 'BR_VERDE'  },;        // Opera??o Iniciada
		             {"PWU->PWU_STATUS =='F'" , 'BR_AZUL'      },;        // Opera??o Finalizada
		             {"PWU->PWU_STATUS =='E'" , 'BR_VERMELHO'     },;        // Opera??o Encerrada
		             {"PWU->PWU_STATUS =='R'" , 'BR_VIOLETA'    },;        // Opera??o Apontada
		             {"PWU->PWU_STATUS =='C'" , 'BR_CINZA'    }}        //  Opera??o Cancelada
// P=Iniciado;F=Finalizada;E=Encerrada;R=Apontada;C=Cancelada
 
//?????????????????????????????????????????????????????????????????????Ŀ
//? Monta um aRotina proprio                                            ?
//???????????????????????????????????????????????????????????????????????

Private aRotina := { {"Pesquisar","AxPesqui",0,1 } ,;
                     {"Visualizar","AxVisual",0,2} ,;
                     {"Estorna Apto","U_EstoApo()",0,4   } ,;
                     {"Legenda","U_Leadleg()",0,5},;
                     {"Tempo Decorrido","U_CalcDecor()",0,5},;
                     {"Excluir","AxDeleta",0,6   }}

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "PWU"

dbSelectArea("PWU")
dbSetOrder(1)   
mBrowse( 6,1,22,75,cString,,,,,6,aCores)
Return(.T.)
        
*************************
User Function Leadleg    // fun??o para legenda colorida
************************* 
       
aLegenda := {{"BR_VERDE","Opera??o Iniciada"},;
             {"BR_AZUL", "Opera??o Finalizada"},;
             {"BR_VERMELHO", "Opera??o Encerrada"},;
             {"BR_VIOLETA", "Opera??o Apontada"},;
             {"BR_CINZA", "Opera??o Cancelada"}}  

BrwLegenda("Apontamentos de Produ??o","Legenda",aLegenda)
return(.T.)




// Dialog Principal


/*
???????????????????????????????????????
???????????????????????????????????????
? ?????????????????????????????????????
??rograma  ?elaSenha ?utor  ?uiz Alberto      ?Data ? 26/06/12   ??
???????????????????????????????????????
??esc.     ?ria tela para digitar senha                                ??
??         ?														  ??
???????????????????????????????????????
???????????????????????????????????????
???????????????????????????????????????
???????????????????????????????????????
*/

Static Function TelaPSW()
Local _cSenha 	 := Space(10)         
Local _cIdCracha := Space(06)
Local cGet3 	 := Space(10)
Local oGet1
Local oGet2
Local oGet3
Local lOk := .t.
Local lEdit := .f.

// Variaveis Private da Funcao
Local oDlg

&& Cria\Valida Parametros
//_CriaSX6()

DEFINE MSDIALOG oDlg TITLE "Informe Crach?" FROM 178,181 TO 350,410 PIXEL Style DS_MODALFRAME 
oDlg:lEscClose := .F. //N? permite sair ao usuario se precionar o ESC

//	@80,10 MsGet oSen Var cSen Picture "@S40" Valid .T.  PASSWORD Pixel of oDlg
// Cria Componentes Padroes do Sistema
@  001, 002 Say "ID Cracha" Size  030, 008 COLOR CLR_BLACK PIXEL OF oDlg
@  010, 002 MsGet oGet1 Var _cIdCracha Size  084, 009 COLOR CLR_BLACK Picture "@*" PASSWORD PIXEL OF oDlg

	@  010, 091 Button "OK" Size  023, 012 PIXEL OF oDlg;
	Action(ValidaSenha(_cIdCracha,_cSenha,@lOk,lEdit),oDlg:End())
	
	@  032, 091 Button "Cancelar" Size  023, 012 PIXEL OF oDlg;
	Action( lOk:=.F.,Alert("Cancelado pelo administrador!","Atencao"),oDlg:End())


ACTIVATE MSDIALOG oDlg CENTERED

Return(lOk)

/*
?????????????????????????????????????
 ????????????????????????????????????
?esc      ?Valida senha e Usuario   Luiz Alberto em 26-06-2012        ?
?????????????????????????????????????
?????????????????????????????????????
*/
Static Function ValidaSenha( _cIdCracha, xcSenha,lOk,lEdit ,cGet3)

Local cSenhax_ :='admin' // GetMv("MV_METPSSW")
Local cUserx_  :='administrator' //GetMv("MV_METUSER")
Local _axUser:={}

_cIdCracha := PadR(_cIdCracha,06)

if lEdit .And. !Empty(_cIdCracha)
	_axUser:=Separa( cUserx_,";",.T.)
	
	If !SRA->(dbSetOrder(1), dbSeek(xFilial("SRA")+_cIdCracha))	//+xcSenha
		Alert("Cracha N?o Localizado!","Atencao")
		lOk:=.F.
		Return lOk				
	Endif
ElseIf !Empty(_cIdCracha)
	IF Alltrim(xcSenha)  == Alltrim(cSenhax_)
		lOk:=.T.
		Return lOk
	Else            
		If !SRA->(dbSetOrder(1), dbSeek(xFilial("SRA")+_cIdCracha))	//+xcSenha
			Alert("Cracha N?o Localizado!","Atencao")
			lOk:=.F.
			Return lOk				
		Else
			If !SRA->RA_CODFUNC$'00001'	// Cargo funcionario
				Alert("Aten??o Apenas Supervisores Poder?o Efetuar Estornos de Apontamentos !","Atencao")
				lOk:=.F.
			Else
				lOk := .t.
			Endif
			If !Empty(SRA->RA_DEMISSA)	// Cargo funcionario
				Alert("Aten??o Funcionario Demitido !","Atencao")
				lOk:=.F.
			Else
				lOk := .t.
			Endif
			Return lOk
		Endif
	Endif
Endif
Return


// Efetua o Cancelamento do Log de Apontamento ///

User Function EstoApo()
Local aArea := GetArea()

If !TelaPSW()
	Return .f.
Endif

If PWU->PWU_STATUS == 'R'
	MsgStop("Aten??o Ordem J? Apontada na Produ??o, efetue o Estorno pela Rotina de Apontamento Mod 2 - Os Apontamentos ser?o disponibilizados apenas Finalizados !")
	RestArea(aArea)
	Return .f.
ElseIf PWU->PWU_STATUS == 'E'
	If !MsgNoYes("Ordem J? Encerrada Deseja Estornar ?",OemToAnsi('ATENCAO'))
		RestArea(aArea)
		Return .f.
	Else
		cHrIni := Left(Time(),5)
		cHrSom := '00:03'

		If RecLock("PWU",.f.)
			PWU->PWU_DTATE  :=	dDataBase
			PWU->PWU_HRATE	:=	StrTran(StrZero(SomaHoras(cHrIni,cHrSom),5,2),'.',':')
			PWU->PWU_STATUS	:=	'F'    
			PWU->PWU_LOG	:=	'Log Apto * Estorno Encerrado * Por ' + Capital(SRA->RA_NOME) + " em " + DtoC(dDataBase) + " as " + Time()
			PWU->(MsUnlock())
		Endif
		
		cOrdem 	:= PWU->PWU_OP
		cItem  	:= PWU->PWU_ITEM
		cSequen	:= PWU->PWU_SEQUEN            
		dData   := dDataBase
		
		SC2->(dbSetOrder(1), dbSeek(xFilial("SC2")+cOrdem+cItem+cSequen))
		cHora   := Time()                      
		cOperacao := PWU->PWU_OPERAC

		// Conforme Solicita??o Janaina em 29-02-2016 na? estornar os demais lan?amentos apenas o que est? posicionado.

		If PWU->(dbSetOrder(2), dbSeek(xFilial("PWU")+cOrdem+cItem+cSequen))
			While PWU->(!Eof()) .And. PWU->PWU_FILIAL == xFilial("PWU") .And. PWU->PWU_OP+PWU->PWU_ITEM+PWU->PWU_SEQUEN == cOrdem+cItem+cSequen
				If !PWU->PWU_STATUS $ 'R*C'
					If RecLock("PWU",.F.)    
						PWU->PWU_STATUS	:=	'F'    
						PWU->(MsUnlock())
					Endif
				Endif
				PWU->(dbSkip(1))
			Enddo
		Endif		
	Endif
ElseIf PWU->PWU_STATUS == 'F'
	If !MsgNoYes("Ordem J? Finalizada Deseja Estornar ?",OemToAnsi('ATENCAO'))
		RestArea(aArea)
		Return .f.
	Else
		If RecLock("PWU",.f.)
			PWU->PWU_DTFIM	:=	CtoD('')
			PWU->PWU_HRFIM	:=	Space(05)
			PWU->PWU_TEMPO  :=  Space(05)
			PWU->PWU_DTATE  :=	CtoD('')
			PWU->PWU_HRATE	:=	Space(05)
			PWU->PWU_STATUS	:=	'P'    
			PWU->PWU_LOG	:=	'Log Apto * Estorno Finalizado * Por ' + Capital(SRA->RA_NOME) + " em " + DtoC(dDataBase) + " as " + Time()
			PWU->(MsUnlock())
		Endif
	Endif
ElseIf PWU->PWU_STATUS == 'P'
	If !MsgNoYes("Ordem Apenas Iniciada Deseja Cancelar ?",OemToAnsi('ATENCAO'))
		RestArea(aArea)
		Return .f.
	Else          
		If RecLock("PWU",.f.)
			PWU->PWU_STATUS	:=	"C"
			PWU->PWU_LOG	:=	'Log Apto * Cancelado * Por ' + Capital(SRA->RA_NOME) + " em " + DtoC(dDataBase) + " as " + Time()
			PWU->(MsUnlock())
		Endif
	Endif
Endif

RestArea(aArea)
Return .t.

User Function CalcDecor()
					nDias	:=	Date()-PWU->PWU_DTINI

					If nDias > 0
						nHrInicio := Val(StrTran(PWU->PWU_HRINI,':','.'))      
						nHrAtual  := Val(StrTran(Left(Time(),5),':','.'))      
						nTotHora  := SubHoras(24.0,nHrInicio)
						
						
						nDias--
						
						For nHr := 1 To nDias-1
							nTotHora := SomaHoras(nTotHora,24.00)
						Next
						
						nTotHora := SomaHoras(nTotHora,nHrAtual)
						cDecorrido := StrTran(Str(nTotHora),'.',':')
					Else
						cDecorrido := ELAPTIME(AllTrim(PWU->PWU_HRINI)+':00',Time())
					Endif
					
Alert(cDecorrido)
Return .t.
