#include "protheus.ch"

User Function RecupXml 

Local oRecupXml:=WSHARDWAREAVULSOPROVIDER():NEW()
Local lret                   
Local cXml
Local cName:='pedidos_310112150606.xml'
Local cRootPath	:= "\" + CurDir()	//Pega o diretorio do RootPath

cRootPath	:= cRootPath + "vendas_site\"+cName

cXml:=MemoRead(cRootPath)

lret:= oRecupXml:savePedidos(cXml)
msginfo(lret) 

Return lRet




