#Include 'Rwmake.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA110BAR  ºAutor  ³ Pedro Augusto    º Data ³  29/10/2009   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE para Incluir botoes de usuario na visua-                º±±
±±º          ³lizacao da Solicitacao de Compras.                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Workflow RENOVA                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MA110BAR()

Local _aButt := {}

AAdd(_aButt,{ "VENDEDOR", {|| Conaprov() }, 'Consulta Aprovadores' } )

Return(_aButt)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ConAprov  ³ Autor ³ Pedro Augusto       ³ Data ³ 29/10/009  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Consulta os aprovadores do Documento.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Ma110bar.prw                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ConAprov()

Local cPag   := cA110Num, cSituaca := ''
Local aCampos:= {}, _aStru := {}, _aAreaAnt := GetArea()
Local oFont  := TFont():New("Tahoma",9,,,.T.,,,,,.F.) // Com Negrito
Local oMens

// Obter os dados para exibicao:

AADD(aCampos,{"APROVADOR" ,"Aprovador"  ,"@!"})
AADD(aCampos,{"SITUACAO"  ,"Situacao"   ,"@!"})
AADD(aCampos,{"_DATA"     ,"Atualizacao","@!"})
AADD(aCampos,{"OBS"       ,"Observacao"	,"@!"})

AAdd( _aStru, {"APROVADOR" , 'C', 30,0} )
AAdd( _aStru, {"SITUACAO"  , 'C', 20,0} )
AAdd( _aStru, {"_DATA"     , 'D', 08,0} )
AAdd( _aStru, {"OBS"       , 'C',200,0} )

_cTmp := CriaTrab(_aStru,.t. )

If Select(_cTmp) > 0
	&(_cTmp)->(DbCloseArea())
EndIf

DbUseArea(.t.,,_cTmp,_cTmp,.f.)

If DTOS(SC1->C1_EMISSAO) >= '20160822' //Atualizado Ronaldo Bicudo - 25/08/2016        
	AVISO( "Atenção...", "Não existe aprovação para alçadas posterior a 22/08/2016!", {"Ok"} )
	RestArea(_aAreaAnt)
	Return
EndIf

DbSelectArea("SZ9")
DbSetOrder(1)
DbSeek(xFilial("SZ9")+"SC"+cPag)      

While !Eof() .And. Rtrim(SZ9->(Z9_FILIAL+Z9_TIPO+Z9_NUM)) == xFilial("SZ9")+"SC"+cPag
	
	
	DbSelectArea(_cTmp)
	RecLock(_cTmp,.t.)
	APROVADOR := UsrFullName(SZ9->Z9_USER)
	Do Case
		Case SZ9->Z9_STATUS == "01"
			cSituaca := 'Aguardando Aprovacao'
		Case SZ9->Z9_STATUS == "02"
			cSituaca := 'Em Aprovacao'
		Case SZ9->Z9_STATUS == "03"
			cSituaca := 'Aprovado'
		Case SZ9->Z9_STATUS == "04"
			cSituaca := 'Bloqueado'
		Case SZ9->Z9_STATUS == "05"
			cSituaca := 'Nivel Liberado'
	EndCase
	SITUACAO := cSituaca
	_DATA    := SZ9->Z9_DATALIB
	OBS      := SZ9->Z9_OBS
	MsUnLock()
	
	DbSelectArea('SZ9')
	DbSkip()
	
EndDo

If &(_cTmp)->(Eof())
	Aviso("Atencao","Esta Solicitacao de Compras nao possui controle de aprovacao.",{"Voltar"})
	RestArea(_aAreaAnt)
	Return
EndIf

&(_cTmp)->(DbGoTop())

@ 273,193 To 535,748 Dialog Mkwdlg
@ 004,004 To 130,233 Title "Consulta aos Aprovadores da Solicitacao de Compras"
@ 037,236 To 085,271  // "Area do Botao Ok"
@ 031,004 To 130,233 Browse _cTmp Fields aCampos  // "Area do Browse"
@ 017,010 Say "Nro. da SC"   Size 62,08
@ 017,076 Say cA110Num Color 8388608 Object oMens SIZE 96,12
@ 054,240 Button "_Ok" Size 27,16 Action(Close(Mkwdlg))

oMens:ofont:=ofont

Activate Dialog Mkwdlg

DbSelectArea(_cTmp)
DbCloseArea(_cTmp)

RestArea(_aAreaAnt)

Return