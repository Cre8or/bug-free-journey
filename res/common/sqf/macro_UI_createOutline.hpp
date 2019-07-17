/* --------------------------------------------------------------------------------------------------------------------
	Author:		Cre8or
	Description:
		Creates an outline control. Used for every item control that needs to be displayed.
	Arguments:
		MACRO_FNC_UI_CREATEOUTLINE
			MY_CTRLOUTLINE			The variable name of the outline control to be created
			MY_DISPLAY			The display in which to create the outline control
			MY_IDC				The outline control's IDC
			MY_CTRLPARENT			The parent controls group to which the outline control should attach
			MY_CTRLPOS			The position array of the outline control
			MY_OUTLINE_COLOUR		The outline colour

		MACRO_FNC_UI_CREATEOUTLINE_RGBA
			MY_CTRLOUTLINE			The variable name of the outline control to be created
			MY_DISPLAY			The display in which to create the outline control
			MY_IDC				The outline control's IDC
			MY_CTRLPARENT			The parent controls group to which the outline control should attach
			MY_CTRLPOS			The position array of the outline control
			MY_OUTLINE_R			The outline colour's red component
			MY_OUTLINE_G			The outline colour's green component
			MY_OUTLINE_B			The outline colour's blue component
			MY_OUTLINE_A			The outline colour's alpha component

		MACRO_FNC_UI_CREATEOUTLINE_PRIVATE
			(same as MACRO_FNC_UI_CREATEOUTLINE)
			This macro assumes the outline control variable does not exist yet, and will create it (using "private")

		MACRO_FNC_UI_CREATEOUTLINE_RGBA_PRIVATE
			(same as MACRO_FNC_UI_CREATEOUTLINE_RGBA)
			This macro assumes the outline control variable does not exist yet, and will create it (using "private")
-------------------------------------------------------------------------------------------------------------------- */

// First variant - outline control variable already exists - colour is a macro (NOT a variable!) in format R,G,B,A
#define MACRO_FNC_UI_CREATEOUTLINE(MY_CTRLOUTLINE,MY_DISPLAY,MY_IDC,MY_CTRLPARENT,MY_CTRLPOS,MY_OUTLINE_COLOUR)							 \
MY_CTRLOUTLINE = MY_DISPLAY ctrlCreate ["Cre8ive_Inventory_ScriptedOutline", MY_IDC, MY_CTRLPARENT];                                                             \
MY_CTRLOUTLINE ctrlSetPosition MY_CTRLPOS;                                                                                                                       \
MY_CTRLOUTLINE ctrlCommit 0;                                                                                                                                     \
MY_CTRLOUTLINE ctrlSetTextColor [MY_OUTLINE_COLOUR];                                                                                                             \
MY_CTRLOUTLINE ctrlSetPixelPrecision MACRO_GLOBAL_PIXELPRECISIONMODE;

// Second variant - outline control variable already exists - colour components are specified individually
#define MACRO_FNC_UI_CREATEOUTLINE_RGBA(MY_CTRLOUTLINE,MY_DISPLAY,MY_IDC,MY_CTRLPARENT,MY_CTRLPOS,MY_OUTLINE_R,MY_OUTLINE_G,MY_OUTLINE_B,MY_OUTLINE_A)		 \
MY_CTRLOUTLINE = MY_DISPLAY ctrlCreate ["Cre8ive_Inventory_ScriptedOutline", MY_IDC, MY_CTRLPARENT];                                                             \
MY_CTRLOUTLINE ctrlSetPosition MY_CTRLPOS;                                                                                                                       \
MY_CTRLOUTLINE ctrlCommit 0;                                                                                                                                     \
MY_CTRLOUTLINE ctrlSetTextColor [MY_OUTLINE_R, MY_OUTLINE_G, MY_OUTLINE_B, MY_OUTLINE_A];                                                                        \
MY_CTRLOUTLINE ctrlSetPixelPrecision MACRO_GLOBAL_PIXELPRECISIONMODE;

// Third variant - outline control variable does NOT exist yet - colour is a macro (NOT a variable!) in format R,G,B,A
#define MACRO_FNC_UI_CREATEOUTLINE_PRIVATE(MY_CTRLOUTLINE,MY_DISPLAY,MY_IDC,MY_CTRLPARENT,MY_CTRLPOS,MY_OUTLINE_COLOUR)						 \
private MACRO_FNC_UI_CREATEOUTLINE(MY_CTRLOUTLINE,MY_DISPLAY,MY_IDC,MY_CTRLPARENT,MY_CTRLPOS,MY_OUTLINE_COLOUR)

// Fourth variant - outline control variable does NOT exist yet - colour components are specified individually
#define MACRO_FNC_UI_CREATEOUTLINE_RGBA_PRIVATE(MY_CTRLOUTLINE,MY_DISPLAY,MY_IDC,MY_CTRLPARENT,MY_CTRLPOS,MY_OUTLINE_R,MY_OUTLINE_G,MY_OUTLINE_B,MY_OUTLINE_A)	 \
private MACRO_FNC_UI_CREATEOUTLINE_RGBA(MY_CTRLOUTLINE,MY_DISPLAY,MY_IDC,MY_CTRLPARENT,MY_CTRLPOS,MY_OUTLINE_R,MY_OUTLINE_G,MY_OUTLINE_B,MY_OUTLINE_A)
