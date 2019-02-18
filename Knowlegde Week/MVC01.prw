#include "protheus.ch"
#include "fwmvcdef.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} MVC01
Exemplo de modelo e view baseado em uma unica tabela.

@since 01/06/2018
/*/
//-------------------------------------------------------------------
User Function MVC01()
Local oBrowse
	
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('ZB2')
	oBrowse:SetDescription('Cadastro de Alunos')
	oBrowse:Activate()
		
Return

Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.MVC01' OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.MVC01' OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.MVC01' OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.MVC01' OPERATION 5 ACCESS 0
ADD OPTION aRotina TITLE 'Imprimir'   ACTION 'VIEWDEF.MVC01' OPERATION 8 ACCESS 0
ADD OPTION aRotina TITLE 'Copiar'     ACTION 'VIEWDEF.MVC01' OPERATION 9 ACCESS 0

Return aRotina

Static Function ModelDef()
Local oModel
Local oStruZB2 := FWFormStruct(1,"ZB2")

	oModel := MPFormModel():New("MD_ALUNO")
	oModel:SetDescription("Cadastro de Alunos")
	
	oModel:addFields('MASTERZB2',,oStruZB2)
	oModel:getModel('MASTERZB2'):SetDescription('Dados do Aluno')
	 
Return oModel

Static Function ViewDef()
Local oModel := ModelDef()
Local oView
Local oStrZB2:= FWFormStruct(2, 'ZB2')
	
	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField('FORM_ALUNO' , oStrZB2,'MASTERZB2' ) 
	oView:CreateHorizontalBox( 'BOX_FORM_ALUNO', 100)
	oView:SetOwnerView('FORM_ALUNO','BOX_FORM_ALUNO')	
	
Return oView

Static Function ViewDef()
Local oModel := ModelDef()
Local oView
	
	oView := FWFormView():New()
	oView:SetModel(oModel)
	
Return oView
