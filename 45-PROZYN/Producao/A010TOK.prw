#include 'protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³A010TOK		ºAutor  ³Microsiga	     º Data ³  14/02/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³PE para validação do cadastro de produto					  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User function A010TOK()
    Local aArea	    := GetArea()
    Local lRet	    := .T.
    Local nA        := 0
    Local aCampos   := StrTokarr(SuperGetMV("MV_ALTPROD",,'B1_DESC/B1_DESCINT/B1_TIPO/B1_UM/B1_GRUPO/B1_ATIVO/B1_POSIPI/B1_ORIGEM/B1_PRVALID/B1_DESCETI/B1_TRANSGE/B1_GLUTEN/B1_MANUSEI/B1_CODCOM/B1_ALERGEN/B1_SNALERG/B1_YPREPA2'),'/')
    Local aChanged  := {}

    lRet := U_PZCVV002()

    If lRet .AND. ALTERA

        For nA := 1 to len(aCampos)
            If &('M->'+aCampos[nA]) != &('SB1->'+aCampos[nA])
                If ValType(&('M->'+aCampos[nA])) == 'N'
                    cValor := cValtoChar(&('SB1->'+aCampos[nA]))
                    cValorNovo := cValtoChar(&('M->'+aCampos[nA]))
                ElseIf ValType(&('M->'+aCampos[nA])) == 'D'
                    cValor := DtoC(&('SB1->'+aCampos[nA]))
                    cValorNovo := DtoC(&('M->'+aCampos[nA]))
                Else
                    cValor := &('SB1->'+aCampos[nA])
                    cValorNovo := &('M->'+aCampos[nA])
                EndIf
                aAdd(aChanged, {aCampos[nA],cValor,cValorNovo})
            EndIf
        Next nA

        If len(aChanged) > 0
            cHTML := SetHTML(aChanged)
            cTo := Trim(UsrRetMail(__cUserId))+";"+AllTrim(SuperGetMV("MV_ALTPROE",,"nailson.paixao@prozyn.com.br"))
            U_zEnvMail(cTo, "Cadastro de Produto Alterado", cHTML, {}, .f., .t., .t.)
        EndIf
        
    EndIf

    RestArea(aArea)	
Return lRet

Static Function SetHTML(aChanged)
    Local nA := 0
    cHTML := "<html>
    cHTML += "<head>
    cHTML += "<style>
    cHTML += "* {outline: none;border:none;margin: 0;padding:0;box-sizing: border-box;font-family: Arial;}
    cHTML += "table { width: 100%;max-width: 900px;font-size:10px;}
    cHTML += "table thead {background: #C0D9D9;text-align: center;}
    cHTML += "table td {padding: 5px;border:1px solid #222;}
    cHTML += "p {margin-bottom: 15px;padding:5px;}
    cHTML += "h4 {padding:5px;margin:10px 0;}
    cHTML += "</style>
    cHTML += "</head>
    cHTML += "<body>

    cHTML += "<p>Prezados,</p>
    cHTML += "<p>Segue a relação de alterações realizadas no cadastro do produto "+Trim(SB1->B1_COD)+" - "+Trim(SB1->B1_DESC)+".</p>
    cHTML += "<p>As alterações foram realizadas pelo usuário: "+UsrRetName(__cUserId)+" dia "+DtoC(Date())+" às "+Time()+".</p>
 
    cHTML += "<h4>Atualizações:</h4>
    cHTML += "<table>
    cHTML += "	<thead>
    cHTML += "		<tr>
    cHTML += "			<td align='left'><strong>Campo</strong></td>
    cHTML += "          <td align='left'><strong>Informação Anterior</strong></td>
    cHTML += "          <td align='left'><strong>Informação Nova</strong></td>
    cHTML += "		</tr>
    cHTML += "	</thead>
    cHTML += "	<tbody>
    For nA := 1 to len(aChanged)
        cHTML += "		<tr>
        cHTML += "			<td align='left'>"+aChanged[nA][1]+"</td>
        cHTML += "			<td align='left'>"+aChanged[nA][2]+"</td>
        cHTML += "			<td align='left'>"+aChanged[nA][3]+"</td>
        cHTML += "		</tr>
    Next nA
    cHTML += "	</tbody>
    cHTML += "</table>
    cHTML += "<p>Por favor, libere o produto.</p>

    cHTML += "</body>
    cHTML += "</html>

Return cHTML


