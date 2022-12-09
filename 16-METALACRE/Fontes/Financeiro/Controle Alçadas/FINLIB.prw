#include "rwmake.ch"
#include 'protheus.ch'
#include "Topconn.ch"
//-----------------------------------------------------------------------
/*/{Protheus.doc} FINLIB - Tela de libera��o de titulos contas a pagar

@param	 nenhum
@return	 Nenhum
@author  Luiz Alberto V Alves
@since 	 22/03/2017
@version 1.0
@project Metalacre
/*/
//-----------------------------------------------------------------------
User Function FINLIB
Local cFitroUs  	:= ""
local lFiltroUs1	:=.T.
Local _cFilQuery	:= ""
Local _lFilBrowse   := .T.
Local _aCores		:= { { 'CR_STATUS== "01"', 'DISABLE' },;   //Bloqueado p/ sistema (aguardando outros niveis)
{ 'CR_STATUS== "02"', 'BR_AZUL' },;   //Aguardando Liberacao do usuario
{ 'CR_STATUS== "03"', 'ENABLE'  },;   //Pedido Liberado pelo usuario
{ 'CR_STATUS== "04"', 'BR_LARANJA'},;   //Pedido Bloqueado pelo usuario
{ 'CR_STATUS== "05"', 'BR_CINZA'} }   //Pedido Liberado por outro usuario

Private _cFilQuery	:= ""
Private _cFiltraSCR
Private _aFixe :={ {AllTrim(RetTitle("CR_FILIAL")),"CR_FILIAL"},;
{AllTrim(RetTitle("CR_NUM")),"CR_NUM"},;
{AllTrim(RetTitle("CR_TIPO")),"CR_TIPO"},;
{AllTrim(RetTitle("CR_USER")),"CR_USER"},;
{AllTrim(RetTitle("CR_APROV")),"CR_APROV"},;
{AllTrim(RetTitle("CR_NIVEL")),"CR_NIVEL"},;
{AllTrim(RetTitle("CR_TOTAL")),"CR_TOTAL"},;
{AllTrim(RetTitle("CR_EMISSAO")),"CR_EMISSAO"} }

Private _aIndexSCR		:= {}
Private _bFilSCRBrw 	:= {|| Nil}
Private _cXFiltraSCR
Private aRotina 		:= MenuDef()
Private cCadastro		:= OemToAnsi("Libera��o - Titulos a Pagar")
Private _cFilQry        := ""
Private _lAprov         := .F.

If !SAK->(dbSetOrder(2), dbSeek(xFilial("SAK")+__cUserId))
	MsgStop("Aten��o Usu�rio N�o Possui Cadastro como Liberador de titulos a Pagar !")
	Return .f.
Else
	_lAprov := .t.
Endif

If _lAprov
	Pergunte("MTA097",.T.)
EndIf
//������������������������������������������������������Ŀ
//� Controle de Aprovacao : CR_STATUS -->                �
//� 01 - Bloqueado p/ sistema (aguardando outros niveis) �
//� 02 - Aguardando Liberacao do usuario                 �
//� 03 - Pedido Liberado pelo usuario                    �
//� 04 - Pedido Bloqueado pelo usuario                   �
//� 05 - Pedido Liberado por outro usuario               �
//��������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Inicaliza a funcao FilBrowse para filtrar a mBrowse          �
//����������������������������������������������������������������
dbSelectArea("SCR")
dbSetOrder(1)

_cFiltraSCR  := 'CR_FILIAL=="'+xFilial("SCR")+'"'//+'.And.CR_USER=="'+__cUserId
If _lAprov .AND. _lFilBrowse
	_cFiltraSCR  := 'CR_FILIAL=="'+xFilial("SCR")+'"'+'.And.CR_USER=="'+__cUserId
	_cFilQry     := " CR_FILIAL='"+xFilial("SCR")+"' AND CR_USER='"+__cUserId+"'"
ElseIf !_lAprov .AND. _lFilBrowse
	_cFiltraSCR  := 'CR_FILIAL=="'+xFilial("SCR")+'"'+'.And.CR_USER=="'+__cUserId
	_cFilQry     := " CR_FILIAL='"+xFilial("SCR")+"' AND CR_USER='"+__cUserId+"'"
EndIf

If _lAprov
	Do Case
		Case mv_par01 == 1
			_cFiltraSCR += '".And.CR_STATUS=="04"'
			_cFilQry    += " AND CR_STATUS='04' "
		Case mv_par01 == 2
			_cFiltraSCR += '".And.(CR_STATUS=="03".OR.CR_STATUS=="05")'
			_cFilQry    += " AND (CR_STATUS='03' OR CR_STATUS='05') "
		Case mv_par01 == 3
			_cFiltraSCR += '"'
			_cFilQry    += " "
		OtherWise
			_cFiltraSCR += '".And.(CR_STATUS=="01".OR.CR_STATUS=="02")'
			_cFilQry    += " AND (CR_STATUS='01' OR CR_STATUS='02' ) "
	EndCase
Else
	_cFiltraSCR += '".And.CR_STATUS=="02"'
	_cFilQry    += " AND CR_STATUS='02' "
EndIf
_cFiltraSCR += '.And.CR_TIPO=="PG"'
_cFilQry    += " AND CR_TIPO='PG' "

_cFiltraSCR := StrTran(_cFiltraSCR,'""','"')

_bFilSCRBrw 	:= {|| FilBrowse("SCR",@_aIndexSCR,@_cFiltraSCR) }
Eval(_bFilSCRBrw)



//��������������������������������������������������������������Ŀ
//� Endereca a funcao de BROWSE                                  �
//����������������������������������������������������������������
mBrowse( 6, 1,22,75,"SCR",_aFixe,,,,2,_aCores,,,,,,,,IIF(!Empty(_cFilQuery),_cFilQuery, NIL))

//������������������������������������������������������������������������Ŀ
//� Finaliza o uso da funcao FilBrowse e retorna os indices padroes.       �
//��������������������������������������������������������������������������


EndFilBrw("SCR",_aIndexSCR)

Return Nil

//-----------------------------------------------------------------------
/*/{Protheus.doc} MenuDef - Menu da Tela de Libera��o de SC�s

LOCALIZA��O: SACOMA07 - Libera��o de Solicita��o de Compras

@param	 nTipo 1 Libera��o 2 Rejei��o 3 Visualizacao da SC
@return	 Nenhum
@author  Cassio Faria
@since 	 25/12/2016
@version 1.0
@project MAN0000001 - Savis
/*/
//-----------------------------------------------------------------------
Static Function MenuDef()

Private aRotina	:= {{ "Pesquisar"	, "AxPesqui"		, 0 , 1,,.F.},;
{OemToAnsi("Ver Titulo"),"U_LIBSC(3)",  0 , 2, 0, nil},;
{OemToAnsi("Libera"),"U_LIBSC(1)",  0 , 2, 0, nil},;
{OemToAnsi("Rejeitar"),"U_LIBSC(2)",  0 , 2, 0, nil},;
{OemToAnsi("Legenda"),"U_LEGSC()",  0 , 2, 0, .F.}}


Return(aRotina)

//-----------------------------------------------------------------------
/*/{Protheus.doc} LIBSC - Tela Manuten��o de Aprova��es

LOCALIZA��O: SACOMA07 - Libera��o de Solicita��o de Compras

@param	 nTipo 1 Libera��o 2 Rejei��o 3 Visualizacao da SC
@return	 Nenhum
@author  Cassio Faria
@since 	 25/12/2016
@version 1.0
@project MAN0000001 - Savis
/*/
//-----------------------------------------------------------------------
User Function LIBSC(nTipo)
Local aArea := GetArea()
Local cNivel := SCR->CR_NIVEL
Local nTamanho  := TamSX3("E2_PREFIXO")[1] + TamSX3("E2_NUM")[1] + TamSX3("E2_PARCELA")[1] + TamSX3("E2_TIPO")[1] + TamSX3("E2_FORNECE")[1] + TamSX3("E2_LOJA")[1]

cTipo := 'Libera��o'
If nTipo == 2
	cTipo := 'Rejei��o'
Endif

If nTipo==3	// Visualiza SC
	cNumTit := PadR(SCR->CR_NUM,nTamanho)
	SE2->(dbSetOrder(1), dbSeek(xFilial("SE2")+cNumTit))
	
	AXVisual('SE2',SE2->(Recno()),2)
	
	RestArea(aArea)
	Return .t.
Endif

// Padroniza o tamanho da Variavel cNumTit com base no tamanho do campo CR_NUM Padr�o

cNumTit := PadR(SCR->CR_NUM,TamSX3("CR_NUM")[1])

lContinua := .t.

// Se a Solicita��o foi Rejeitada N�o Permite novas A��es

If SCR->CR_STATUS == '04'
	MsgStop("Aten��o Solicita��o com Rejei��o Imposs�vel Efetuar " + cTipo + " ! ")
	RestArea(aArea)
	Return .f.
Endif                      

// Se a Solicita��o foi Liberada N�o Permite novas A��es

If SCR->CR_STATUS $ '03*05'
	MsgStop("Aten��o Solicita��o J� Aprovada Imposs�vel Efetuar " + cTipo + " ! ")
	RestArea(aArea)
	Return .f.
Endif                      

nRegSCR := SCR->(Recno())

// Verifica se Existe nivel inferior necessitando de aprova��o.
// em caso afirmativo n�o permite que o usu�rio com nivel superior efetue manuten��o.

If SCR->(dbSetOrder(1), dbSeek(xFilial("SCR")+'PG'+cNumTit))
	While SCR->(!Eof()) .And. SCR->(CR_FILIAL+CR_TIPO+CR_NUM) = xFilial("SCR") + "PG" + cNumTit
		If SCR->CR_STATUS <> "03" .And. SCR->CR_NIVEL < cNivel
			lContinua := .f.
			Exit
		Endif
		
		SCR->(dbSkip(1))
	Enddo
Endif

SCR->(dbGoTo(nRegSCR))

If !lContinua
	MsgStop("Aten��o Existem Niveis Diferentes de Aprovadores Com Direitos de Aprova��o ou Rejei��o, Imposs�vel Continuar !")
	RestArea(aArea)
	Return .f.
Endif                      

If	!MsgYesNo(OemToAnsi('Confirma a ' + cTipo + ' do Titulo Posicionado ?'))
	RestArea(aArea)
	Return .f.
Endif

If nTipo==2	// Rejeita SC
/*	
	// Efetua abertura de janela para preenchimento de justificativa de rejei��o pelo aprovador

	nOpc := 0
	cMotRej := CRIAVAR("C1_OBS")
	
	DEFINE FONT oFont NAME "Courier New" SIZE 7,14
	
	@ 3,0 TO 70,550 DIALOG oDlg1 TITLE OemToAnsi("INFORME MOTIVO DA REJEI��O")
	@ 5,35 Get cMotRej PICTURE "@!" VALID NaoVazio() SIZE 200,008 OF oDlg1  PIXEL
	@ 20,240 BMPBUTTON TYPE 1  ACTION ( nOpc := 1 , oDlg1:End() )
	ACTIVATE DIALOG oDlg1 CENTER
	
	If nOpc<> 1
		MsgStop("Aten��o Informe o Motivo da Rejei��o !")
		RestArea(aArea)
		Return .f.
	Endif */
Endif                      

// Grava Posicao do Registro Atual SCR

dbSelectArea("SCR")
dbSetOrder(1)
Set Filter To		// Desabilita o Filtro da Tabela SCR para que eu Possa Localizar novos Aprovadores
dbGoTop()

SCR->(dbGoTo(nRegSCR))	// Retorna a Posi��o Gravada da SCR

If nTipo==1	// Libera SC
	If SAK->(dbSetOrder(2), dbSeek(xFilial("SAK")+__cUserID))	// Verifica se o usuario atual possui cadastro de Comprador
		
		// Grava Mudan�a de Status para Liberado
	
		If Reclock("SCR",.F.)
			SCR->CR_STATUS  := "03"
			SCR->CR_DATALIB := Date()
			SCR->CR_USERLIB := __cUserId
			SCR->CR_TIPOLIM := SAK->AK_TIPO
			SCR->(MsUnlock())
		Endif		

		//	Variavel de Controle se Existem 1 ou Mais Aprovadores na Fila

		lMaisAprov := .f.
	
	    If SCR->(dbSetOrder(1), dbSeek(xFilial("SCR")+'PG'+cNumTit))
			While SCR->(!Eof()) .And. SCR->(CR_FILIAL+CR_TIPO+CR_NUM) = xFilial("SCR") + "PG" + cNumTit 
				
				// Se Houver Mais Aprovadores com o Mesmo Nivel e N�o Tiverem Liberado a SC Ainda
				// Ent�o Automaticamente j� Libera Todos
				
				If SCR->CR_STATUS <> "03" .And. SCR->CR_NIVEL == cNivel
					If RecLock("SCR",.f.)
						SCR->CR_STATUS  := "03"
						SCR->CR_DATALIB := Date()
						SCR->CR_USERLIB := __cUserId
						SCR->CR_TIPOLIM := SAK->AK_TIPO
						SCR->(MsUnlock())
					Endif
					
				// Se Houver Mais Aprovadores com Niveis Diferentes e que o Status n�o esteja liberado
				// ent�o muda todos os status para aguardando libera��o outro nivel
				
				ElseIf !SCR->CR_STATUS $ "03" .And. SCR->CR_NIVEL <> cNivel
					lMaisAprov := .t.
				Endif
				SCR->(DbSkip(1))
			Enddo
	    Endif

		// Identificacao do Proximo Nivel de Aprovadores para Mudan�a de Status
	
		_cNivel := cNivel
		
	    If SCR->(dbSetOrder(1), dbSeek(xFilial("SCR")+'PG'+PadR(cNumTit,TamSX3("CR_NUM")[1])))
			While SCR->(CR_FILIAL+CR_TIPO+CR_NUM) = xFilial("SCR") + "PG" + PadR(cNumTit,TamSX3("CR_NUM")[1]) .And. SCR->(!Eof())
			
				If SCR->CR_NIVEL > _cNivel .And. !SCR->CR_STATUS $ "03" 
					_cNivel := SCR->CR_NIVEL
					Exit
				Endif
	
				SCR->(DbSkip(1))
			Enddo
	    Endif
	    
	    cNivel := _cNivel

	    If SCR->(dbSetOrder(1), dbSeek(xFilial("SCR")+'PG'+PadR(cNumTit,TamSX3("CR_NUM")[1])))
			While SCR->(CR_FILIAL+CR_TIPO+CR_NUM) = xFilial("SCR") + "PG" + PadR(cNumTit,TamSX3("CR_NUM")[1]) .And. SCR->(!Eof())
			
				If SCR->CR_NIVEL == cNivel .And. !SCR->CR_STATUS $ "03" 
					If RecLock("SCR",.f.)
						SCR->CR_STATUS  := "02"
						SCR->(MsUnlock())
					Endif
				Endif
	
				SCR->(DbSkip(1))
			Enddo
	    Endif

		// Se N�o Houver Mais Aprovadores ent�o Libera a SC

		If !lMaisAprov
			// Reformula o tamanho da variavel cNumTit Para o campo C1_NUM Padr�o, para localizar a SC Corretamente

			If SE2->(dbSetOrder(1), dbSeek(xFilial("SE2")+Left(cNumTit,nTamanho)))
				If RecLock("SE2",.f.)
					SE2->E2_XCONAP	:= 'L'
					If SE2->(FieldPos("E2_XNOMAPR")) > 0
						SE2->E2_XNOMAPR := UsrFullName(__cUserID) 
					Endif
					SE2->(MSUnlock())
				Endif
			Endif
		Endif
	Endif
Else
	// Bloqueia SC
	
	If Reclock("SCR",.F.)
		SCR->CR_STATUS  := "04"
		SCR->CR_DATALIB := Date()
		SCR->CR_USERLIB := __cUserId
		SCR->(MsUnlock())
	Endif
	
    // Localiza a fila de aprova��es e rejeita todos
    
    If SCR->(dbSetOrder(1), dbSeek(xFilial("SCR")+'PG'+cNumTit))
		While SCR->(!Eof()) .And. SCR->(CR_FILIAL+CR_TIPO+CR_NUM) = xFilial("SCR") + "PG" + cNumTit
				
			// Se Houver Mais Aprovadores com o Mesmo Nivel e N�o Tiverem Liberado a SC Ainda
			// Ent�o Automaticamente j� Libera Todos
				
			If RecLock("SCR",.f.)
				SCR->CR_STATUS  := "04"
				SCR->CR_DATALIB := Date()
				SCR->CR_USERLIB := __cUserId
				SCR->(MsUnlock())
			Endif
			SCR->(DbSkip(1))
		Enddo
    Endif

	If SE2->(dbSetOrder(1), dbSeek(xFilial("SE2")+Left(cNumTit,nTamanho)))
		If RecLock("SE2",.f.)
			SE2->E2_XCONAP	:= 'R'
			If SE2->(FieldPos("E2_XNOMAPR")) > 0
				SE2->E2_XNOMAPR := UsrFullName(__cUserID) 
			Endif
			SE2->(MSUnlock())
		Endif
	Endif
Endif

// Restaura o Filtro na Tabela de Filas de Aprovadores.

dbSelectArea("SCR")
dbSetOrder(1)
_bFilSCRBrw 	:= {|| FilBrowse("SCR",@_aIndexSCR,@_cFiltraSCR) }
Eval(_bFilSCRBrw)  
dbGoTop()
Return .t.

//-----------------------------------------------------------------------
/*/{Protheus.doc} LEGSC - Tela de Legendas de Status de Aprova��o

LOCALIZA��O: SACOMA07 - Libera��o de Solicita��o de Compras

@param	 nenhum
@return	 Nenhum
@author  Cassio Faria
@since 	 25/12/2016
@version 1.0
@project MAN0000001 - Savis
/*/
//-----------------------------------------------------------------------
User Function LEGSC() 

Local aLegeUsr   := {}
Local aLegenda   := {       {"DISABLE" , "Bloqueado (Aguardando outros niveis)"},; //Bloqueado (Aguardando outros niveis)
				  		  	{"BR_AZUL" , "Aguardando Liberacao do usuario"},; //Aguardando Liberacao do usuario
   							{"ENABLE"  , "Documento Liberado pelo usuario"},; //Documento Liberado pelo usuario
  					 		{"BR_LARANJA", "Documento Bloqueado pelo usuario"},; //Documento Bloqueado pelo usuario
  					 		{"BR_CINZA", "Documento Liberado por outro usuario"}}  //Documento Liberado por outro usuario
  					 		 
		BrwLegenda("Libera��o - Titulos a Pagar","Status Libera��es",aLegenda)    	

Return(.T.)

