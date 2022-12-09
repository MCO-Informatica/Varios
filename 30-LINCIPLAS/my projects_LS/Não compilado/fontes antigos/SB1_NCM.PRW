#INCLUDE "RWMAKE.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SB1_NCM  º Autor ³ Ilidio Abreu         º Data ³  08/01/15  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Monta arquivo TXT (CSV) com infromações do SB1 e seus NCM´s ±±
±±º          ³ para envio a Base Comum, (que não sei como e onde funciona).±±
±±º          ³ ATENÇÃO: O programa está direcionado para "C:\TEMP".        ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laselva                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±             
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User function SB1_NCM 
/*Sobre os campos 

id_bdcomum = numero da linha na tabela........OK
ind_importacao = sempre deixar 0 .............OK
dat_atualizacao = data da atualização.........OK (data da tabela NCM ou da atualização feita na base comum).
UF = Estado do imposto
COD_PRD = código do produto
COD_IPT = mandar sempre 1 que é o imposto único
COD_NCM =  código do ncm do produto
PER_AQT = soma das alíquotas de todos os impostos nesse produto.

*/

DbSelecArea("SB1")
Dbgotop()

cArqLog:="C:\TEMP\SB1_NCM.CSV"
nHdlArq:=FCreate(cArqLOG)
_cLine := ""
_nInc := 0
_cNL   := CHR(13)+CHR(10)
_cTitulo := "0 ; id_bdcomum ; ind_importacao ; dat_atualizacao ; UF ; COD_PRD  ; COD_IPT ; COD_NCM ; PER_AQT"
fWrite(nHdlArq,_cTitulo,Len(_cTitulo))
fWrite(nHdlArq,cLine,Len(_cNL))


While ! SB1->(eof())
	_nInc ++ 
                                     
	cline := strzero(_nInc,6)+ "0" + "20141106" + "**"//  Incremento + 0 + id_bdcomum + ind_importacao + dat_atualizacao + UF
    
	if SB1_MSBLQL == "1" .or. SB1->B1_ATIVO == "N"
		SB1->(dbskip())
    Endif       
    
fWrite(nHdlArq,cLine,Len(cLine))
cline:=cNL
fWrite(nHdlArq,cLine,Len(cLine))

Enddo
/*Sobre os campos 

id_bdcomum = numero da linha na tabela........OK
ind_importacao = sempre deixar 0 .............OK
dat_atualizacao = data da atualização.........OK (data da tabela NCM ou da atualização feita na base comum).
UF = Estado do imposto
COD_PRD = código do produto
COD_IPT = mandar sempre 1 que é o imposto único
COD_NCM =  código do ncm do produto
PER_AQT = soma das alíquotas de todos os impostos nesse produto.

*/
