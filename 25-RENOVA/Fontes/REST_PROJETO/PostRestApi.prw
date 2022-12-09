#include 'protheus.ch'
#include 'parmtype.ch'
#Include "totvs.ch"

user function PostRestApi(cPostUrl,aHeadOut,cPostData,cMens) 

Local nTimeOut  := 120
Local cHeaderRet:= ''
Local sPostRet  := ''

_cPostData := EncodeUTF8(cPostData)

sPostRet := HttpPost(cPostUrl,cMens,_cPostData,nTimeOut,aHeadOut,@cHeaderRet)

if empty(sPostRet)
    MsgStop(cHeaderRet,'HttpPost Failed')
    sPostRet := 'ERROR'
Endif

Return(sPostRet)
