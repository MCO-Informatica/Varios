//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

/*/{Protheus.doc} AltCtr
Função para adicionar campos especificos na liquidação de titulo a pagar
@author Alcouto
@since 15-01-2021

Alteração em 02/02/2021 - LMS - Acrescentados campos no array

/*/   
//TIRAR ENTIDADES CONTÁBEIS E JUROS - CLASSE E RJ = TITULO ORIGINAL MBROWSE - NO FILTRO RESUMIR NATUREZAS DO FORNECEDOR PELO SE2
//      NATUREZA ORIGEM DO FILTRO PARA O TITULO DESTINO

// Esse ponto de entrada não será utilizado para execução automática pois na gravação não preenche o ACols com as informaçoes
// enviadas pelo execauto()

USER FUNCTION A565COL()

Local lAutoExec := Type("cNatAuto") = "C"

Public nI565COL := 0

if lAutoExec
   return
endif

Aadd(aHeader,{"Tp.Classifca","E2_XCLASS" ,"@!"      ,01,0,"","U","C","SE2" })
Aadd(aHeader,{"AGC:S/N"     ,"E2_XRJ"    ,"@!"      ,01,0,"","U","N","SE2" })
Aadd(aHeader,{"Venc Real"   ,"E2_VENCREA","@E"      ,08,0,"","" ,"D","SE2" })
Aadd(aHeader,{"Essencial"   ,"E2_XESSENC","@!"      ,01,0,"","U" ,"C","SE2" })
//Aadd(aHeader,{"% Juros"     ,"E2_PORCJUR","@E 99.99",05,2,"","" ,"N","SE2" })
//Aadd(aHeader,{"Proj Deb"    ,"E2_ITEMD"  ,"@!"      ,09,0,"","" ,"C","SE2" })
//Aadd(aHeader,{"Camada Deb"  ,"E2_CLVLDB" ,"@!"      ,09,0,"","" ,"C","SE2" })
//Aadd(aHeader,{"C Custo Deb" ,"E2_CCD"    ,"@!"      ,09,0,"","" ,"C","SE2" })
//Aadd(aHeader,{"Cl Orç Deb"  ,"E2_EC05DB" ,"@!"      ,11,0,"","" ,"C","SE2" })
//Aadd(aHeader,{"Cta Cont Deb","E2_CONTAD" ,"@!"      ,20,0,"","" ,"C","SE2" })
//Aadd(aHeader,{"Tp Custo Deb","E2_EC07DB" ,"@!"      ,09,0,"","" ,"C","SE2" })

Return

