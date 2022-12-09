#Include "Protheus.ch"
User Function TMKBARLA(aBotao, aTitulo)
//_nprod  := aposicoes[1][2]
//_codprd := acols[N][_nprod]
aAdd(aBotao,{"PRODUTO"  ,&("{||u_macom(acols[N,2])}"),"Produto"})	         
aAdd(aBotao,{"NOTE" ,&("{||MATA110()}")              ,"Solic. Compras"})	         
aAdd(aBotao,{"OBJETIVO"       ,&("{||u_cOrdServ()}") ,"Ordem Servico "})	         

Return( aBotao )
