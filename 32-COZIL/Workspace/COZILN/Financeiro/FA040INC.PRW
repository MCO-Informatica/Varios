//Bibliotecas
#Include "Totvs.ch"

#Define CRLF CHR(13) + CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FA040INC ºAutor  Marcos Souza         º Data ³  24/02/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada ao incluir título a receber                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINA040                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

/*--------------------------------------------------------------------------------*
| P.E.:  FA040INC                                                                |
| Desc:  Função chamada ao incluir título a receber                              |
| Link:  http://tdn.totvs.com/display/public/mp/FA040INC+-+Valida+dados+--+11845 |
*--------------------------------------------------------------------------------*/

User Function FA040INC()
	Local aArea := GetArea()
	Local lRet  := .T.
	Local aPergs   := {}
	Local cVend1   := Space(TamSX3('E1_VEND1')[01])
	Local cPedido  := Space(TamSX3('E1_PEDIDO')[01])

	aAdd(aPergs, {1, "Vendedor 1",  cVend1,  "", ".T.", "SA3", ".T.", 80,  .T.})
	aAdd(aPergs, {1, "Pedido", cPedido,  "", ".T.", "SC5", ".T.", 80,  .T.})

	While Empty(M->E1_VEND1) .or. Empty(M->E1_PEDIDO)

		If ParamBox(aPergs, "Informe vendedor e pedido",,,,,,,,,.F.,)
			M->E1_VEND1  := mv_par01
			M->E1_PEDIDO := mv_par02
		EndIf

	Enddo
	RestArea(aArea)
Return lRet

// 1 - < aParametros > - Vetor com as configurações
// 2 - < cTitle >      - Título da janela
// 3 - < aRet >        - Vetor passador por referencia que contém o retorno dos parâmetros
// 4 - < bOk >         - Code block para validar o botão Ok
// 5 - < aButtons >    - Vetor com mais botões além dos botões de Ok e Cancel
// 6 - < lCentered >   - Centralizar a janela
// 7 - < nPosX >       - Se não centralizar janela coordenada X para início
// 8 - < nPosY >       - Se não centralizar janela coordenada Y para início
// 9 - < oDlgWizard >  - Utiliza o objeto da janela ativa
//10 - < cLoad >       - Nome do perfil se caso for carregar
//11 - < lCanSave >    - Salvar os dados informados nos parâmetros por perfil
//12 - < lUserSave >   - Configuração por usuário
