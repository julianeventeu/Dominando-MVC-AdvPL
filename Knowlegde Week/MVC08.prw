#include "protheus.ch"
#include "fwmvcdef.ch

//-------------------------------------------------------------------
/*/{Protheus.doc} MVC08
Exemplo de copia, com e sem interface.
Exemplo de FWExecView

@since 01/06/2018
/*/
//-------------------------------------------------------------------
User Function MVC08()
Local oBrowse
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('ZB2')
	oBrowse:SetDescription('Cadastro de Aluno')
	oBrowse:Activate()
Return

Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina TITLE 'Visualizar'       ACTION 'VIEWDEF.MVC01' OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Incluir'          ACTION 'VIEWDEF.MVC01' OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE 'Alterar'          ACTION 'VIEWDEF.MVC01' OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE 'Excluir'          ACTION 'VIEWDEF.MVC01' OPERATION 5 ACCESS 0
ADD OPTION aRotina TITLE 'Imprimir'         ACTION 'VIEWDEF.MVC01' OPERATION 8 ACCESS 0
ADD OPTION aRotina TITLE 'Copia Padrao'     ACTION 'VIEWDEF.MVC01' OPERATION 9 ACCESS 0
ADD OPTION aRotina TITLE 'Copia com UI'     ACTION 'UICopy'        OPERATION 9 ACCESS 0
ADD OPTION aRotina TITLE 'Copia sem UI'     ACTION 'NOUICopy'      OPERATION 9 ACCESS 0

Return aRotina

Function UICopy()
Local oModel := FWLoadModel("MVC01")

    oModel:SetOperation(MODEL_OPERATION_INSERT)

    If oModel:Activate(.T.)
        oModel:SetValue("MASTERZB2","ZB2_NOME","NOVO ALUNO COPIADO")
        FWExecView("Copia de Registro", "MVC01",MODEL_OPERATION_INSERT,/*oDlg*/,/*bCloseOnOk*/,/*bOk*/,/*nPercReducao*/,/*aEnableButtons*/,/*bCancel*/,,,oModel)
    Else
        Help( ,, 'HELP',, oModel:GetErrorMessage()[6], 1, 0)   
    EndIf
    
Return

Function NOUICopy()
Local oModel := FWLoadModel("MVC01")
Local cNome 

    oModel:SetOperation(MODEL_OPERATION_INSERT)

    If oModel:Activate(.T.)
        cNome := oModel:GetValue("MASTERZB2","ZB2_NOME")
        oModel:SetValue("MASTERZB2","ZB2_NOME",AllTrim(cNome) + " - REGISTRO COPIADO")

        If oModel:VldData()
            oModel:CommitData()
        Else
            Help( ,, 'HELP',, oModel:GetErrorMessage()[6], 1, 0)   
        EndIf
    EndIf

Return