

User Function WFALTPED(lQtd,lData)
    Local aArea := GetArea()
    Local cHTML := ""
    Local aFound := {}
    Local cTo := GetMV("MV_WFALTPD")
    Local nA := 0

    cHTML += "<html>"
    cHTML += "  <head>"
    cHTML += "      <style>"
    cHTML += "       * {outline: none;border:none;margin: 0;padding:0;box-sizing: border-box;} "
    cHTML += "       hr {border: 1px solid #eee;margin: 10px 0;width: 600px;} "
    cHTML += "       body { font-family: Arial, Helvetica, sans-serif;color: #181818;} "
    cHTML += "       table { overflow:hidden;padding:6px;border-radius:9px;width:600px;border:1px solid #ccc;margin:15px;font-size:12px;} "
    cHTML += "       tr { line-height:1;height:26px;} "
    cHTML += "       td { line-height:1;padding:5px;height:26px;} "
    cHTML += "     </style> "
    cHTML += "  </head>"
    cHTML += "  <body>"
    cHTML += "      <table>"
    cHTML += "          <tr>"
    cHTML += "              <td align='center'><strong style='font-size:16px;'>Pedido Alterado: "+M->C5_NUM+" - por: "+M->C5_ALTUSER+"</strong></td>"
    cHTML += "          </tr>"
    cHTML += "      </table>"
    // If lData
        cHTML += "      <table style='margin-top:20px;'>"
        cHTML += "              <tr>"
        cHTML += "                  <td colspan='2' align='center' style='font-size: 16px;'>Data de Entrega</td>"
        cHTML += "              </tr>"
        cHTML += "              <tr>"
        cHTML += "                  <td align='center'>Anterior: "+DtoC(SC5->C5_FECENT)+"</td>"
        cHTML += "                  <td align='center'>Nova: "+DtoC(M->C5_FECENT)+"</td>"
        cHTML += "              </tr>"
        cHTML += "      </table>"
    // EndIf
    // If lQtd
        cHTML += "      <table style='margin-top:20px;'>"
        cHTML += "              <tr>"
        cHTML += "                  <td colspan='5' align='center' style='font-size: 16px;'>Produtos</td>"
        cHTML += "              </tr>"
        cHTML += "              <tr>"
        cHTML += "                  <td style='font-size:11px;'>Produto</td>"
        cHTML += "                  <td align='center' style='font-size:11px;'><strong>Quantidade Anterior</strong></td>"
        cHTML += "                  <td align='center' style='font-size:11px;'><strong>Quantidade Nova</strong></td>"
        cHTML += "                  <td align='center' style='font-size:11px;'>Armazém</td>"
        cHTML += "              </tr>"

        DbSelectArea("SC6")
        SC6->(DbSetOrder(1))
        SC6->(DbSeek(xFilial("SC6")+M->C5_NUM))
        While SC6->(!EOF()) .AND. SC6->C6_NUM == M->C5_NUM
            cHTML += "              <tr>"
            cHTML += "                  <td style='border-bottom: 1px solid #efefef;'>"+SC6->C6_PRODUTO+" | "+Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_DESC")+"</td>"
            cHTML += "                  <td style='border-bottom: 1px solid #efefef;' align='center'>"+cValtoChar(SC6->C6_QTDVEN)+"</td>"


            lFound := .F.
            For nA := 1 to len(aCols)
                If aCols[nA,aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_PRODUTO"})] == SC6->C6_PRODUTO .and. aCols[nA,aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_LOCAL"})] == SC6->C6_LOCAL .AND. SC6->C6_ITEM == aCols[nA,aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_ITEM"})] .and. aCols[nA,aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_LOTECTL"})] == SC6->C6_LOTECTL
                    If !aCols[nA,Len(aHeader)+1]
                        cHTML += "                  <td style='border-bottom: 1px solid #efefef;' align='center'>"+cValtoChar(aCols[nA,aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_QTDVEN"})])+"</td>"
                        lFound := .T.
                        aAdd(aFound,nA)
                    EndIf
                EndIf
            Next nA
            If !lFound
                cHTML += "                  <td style='border-bottom: 1px solid #efefef;' align='center'>Removido</td>"
            EndIf

            cHTML += "                  <td style='border-bottom: 1px solid #efefef;' align='center'>"+SC6->C6_LOCAL+"</td>"
            cHTML += "              </tr>"
        SC6->(DbSkip())
        EndDo

        nA := 0
        For nA := 1 to len(aCols)
            If !aCols[nA,Len(aHeader)+1]
                If aScan(aFound, nA ) == 0
                    cHTML += "              <tr>"
                    cHTML += "                  <td style='border-bottom: 1px solid #efefef;'>"+aCols[nA,aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_PRODUTO"})]+" | "+Posicione("SB1",1,xFilial("SB1")+aCols[nA,aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_PRODUTO"})],"B1_DESC")+"</td>"
                    cHTML += "                  <td style='border-bottom: 1px solid #efefef;' align='center'>Novo</td>"
                    cHTML += "                  <td style='border-bottom: 1px solid #efefef;' align='center'>"+cValtoChar(aCols[nA,aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_QTDVEN"})])+"</td>"
                    cHTML += "                  <td style='border-bottom: 1px solid #efefef;' align='center'>"+aCols[nA,aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_LOCAL"})]+"</td>"
                    cHTML += "              </tr>"
                EndIf

            EndIf
        Next nA

        cHTML += "      </table>"
    // EndIf
    cHTML += "  </body>"
    cHTML += "</html>"

    U_zEnvMail(cTo, "Pedido Alterado: "+M->C5_NUM, cHTML, {}, .f., .t., .t.)

    RestArea(aArea)
Return
