/* --------------------------------------------------------------------------------------------------------------------
	Author:		Cre8or
	Description:
		Calculates the offset of one (or more) child control(s) to its parent control and saves it for later use.
	Arguments:
		MACRO_FNC_UI_CTRL_CALCULATEOFFSET
			MY_CTRL			The control that we want to calculate the offset for
			MY_CTRLPOS		The variable name of the control's position that that macro writes to
			MY_PARENTPOS		The "parent" position to which the offset will be relative to

		MACRO_FNC_UI_CTRL_CALCULATEOFFSET_PRIVATE
			(same as MACRO_FNC_UI_CTRL_CALCULATEOFFSET)
			This macro assumes the control's position variable does not exit yet, and will create it (using "private")

		MACRO_FNC_UI_CTRL_CALCULATEOFFSET_ARRAY
			MY_CTRLSARRAY		Array of controls that we want to calculate the offset for
			MY_CTRLPOS		The variable name of the control's position that that macro writes to
			MY_PARENTPOS		The "parent" position to which the offset will be relative to

		MACRO_FNC_UI_CTRL_CALCULATEOFFSET_ARRAY_PRIVATE
			(same as MACRO_FNC_UI_CTRL_CALCULATEOFFSET_ARRAY)
			This macro assumes the control's position variable does not exit yet, and will create it (using "private")
		---------------------------------------------------------------------
		---------------------------------------------------------------------
		MACRO_FNC_UI_CTRL_CALCULATEOFFSET_XY
			MY_CTRL			The control that we want to calculate the offset for
			MY_CTRLPOS		The variable name of the control's position that that macro writes to
			MY_POSX			The "parent" position's X component
			MY_POSX			The "parent" position's Y component

		MACRO_FNC_UI_CTRL_CALCULATEOFFSET_XY_PRIVATE
			(same as MACRO_FNC_UI_CTRL_CALCULATEOFFSET_XY)
			This macro assumes the control's position variable does not exit yet, and will create it (using "private")

		MACRO_FNC_UI_CTRL_CALCULATEOFFSET_XY_ARRAY
			MY_CTRLSARRAY		Array of controls that we want to calculate the offset for
			MY_CTRLPOS		The variable name of the control's position that that macro writes to
			MY_POSX			The "parent" position's X component
			MY_POSX			The "parent" position's Y component

		MACRO_FNC_UI_CTRL_CALCULATEOFFSET_XY_ARRAY_PRIVATE
			(same as MACRO_FNC_UI_CTRL_CALCULATEOFFSET_XY_ARRAY)
			This macro assumes the control's position variable does not exit yet, and will create it (using "private")
-------------------------------------------------------------------------------------------------------------------- */

// First variant - control position variable already exists - calculate offset for one individual control - parent position is an array
#define MACRO_FNC_UI_CTRL_CALCULATEOFFSET(MY_CTRL,MY_CTRLPOS,MY_PARENTPOS)						 \
MY_CTRLPOS = ctrlPosition MY_CTRL;                                                                                       \
MY_CTRL setVariable [MACRO_VARNAME_UI_OFFSET, [                                                                          \
	(MY_CTRLPOS select 0) - (MY_PARENTPOS select 0),                                                                 \
	(MY_CTRLPOS select 1) - (MY_PARENTPOS select 1)                                                                  \
]];

// Second variant - control position variable does NOT exist yet - calculate offset for one individual control - parent position is an array
#define MACRO_FNC_UI_CTRL_CALCULATEOFFSET_PRIVATE(MY_CTRL,MY_CTRLPOS,MY_PARENTPOS)					 \
private MACRO_FNC_UI_CTRL_CALCULATEOFFSET(MY_CTRL,MY_CTRLPOS,MY_PARENTPOS)

// Third variant - control position variable already exists - calculate offset for multiple controls - parent position is an array
#define MACRO_FNC_UI_CTRL_CALCULATEOFFSET_ARRAY(MY_CTRLSARRAY,MY_CTRLPOS,MY_PARENTPOS)					 \
MY_CTRLPOS = [];                                                                                                         \
{                                                                                                                        \
	MY_CTRLPOS = ctrlPosition _x;                                                                                    \
	_x setVariable [MACRO_VARNAME_UI_OFFSET, [                                                                       \
		(MY_CTRLPOS select 0) - (MY_PARENTPOS select 0),                                                         \
		(MY_CTRLPOS select 1) - (MY_PARENTPOS select 1)                                                          \
	]];                                                                                                              \
} forEach MY_CTRLSARRAY;

// Fourth variant - control position variable does NOT exist yet - calculate offset for multiple controls - parent position is an array
#define MACRO_FNC_UI_CTRL_CALCULATEOFFSET_ARRAY_PRIVATE(MY_CTRLSARRAY,MY_CTRLPOS,MY_PARENTPOS)				 \
private MACRO_FNC_UI_CTRL_CALCULATEOFFSET_ARRAY(MY_CTRLSARRAY,MY_CTRLPOS,MY_PARENTPOS)





// Fifth variant - control position variable already exists - calculate offset for one individual control - parent position in format X,Y
#define MACRO_FNC_UI_CTRL_CALCULATEOFFSET_XY(MY_CTRL,MY_CTRLPOS,MY_POSX,MY_POSY)					 \
MY_CTRLPOS = ctrlPosition MY_CTRL;                                                                                       \
MY_CTRL setVariable [MACRO_VARNAME_UI_OFFSET, [                                                                          \
	(MY_CTRLPOS select 0) - MY_POSX,                                                                                 \
	(MY_CTRLPOS select 1) - MY_POSY                                                                                  \
]];

// Sixth variant - control position variable does NOT exist yet - calculate offset for one individual control - parent position in format X,Y
#define MACRO_FNC_UI_CTRL_CALCULATEOFFSET_XY_PRIVATE(MY_CTRL,MY_CTRLPOS,MY_POSX,MY_POSY)				 \
private MACRO_FNC_UI_CTRL_CALCULATEOFFSET_XY(MY_CTRL,MY_CTRLPOS,MY_POSX,MY_POSY)

// Seventh variant - control position variable already exists - calculate offset for multiple controls - parent position in format X,Y
#define MACRO_FNC_UI_CTRL_CALCULATEOFFSET_XY_ARRAY(MY_CTRLSARRAY,MY_CTRLPOS,MY_POSX,MY_POSY)				 \
MY_CTRLPOS = [];                                                                                                         \
{                                                                                                                        \
	MY_CTRLPOS = ctrlPosition _x;                                                                                    \
	_x setVariable [MACRO_VARNAME_UI_OFFSET, [                                                                       \
		(MY_CTRLPOS select 0) - MY_POSX,                                                                         \
		(MY_CTRLPOS select 1) - MY_POSY                                                                          \
	]];                                                                                                              \
} forEach MY_CTRLSARRAY;

// Eighth variant - control position variable does NOT exist yet - calculate offset for multiple controls - parent position in format X,Y
#define MACRO_FNC_UI_CTRL_CALCULATEOFFSET_XY_ARRAY_PRIVATE(MY_CTRLSARRAY,MY_CTRLPOS,MY_POSX,MY_POSY)			 \
private MACRO_FNC_UI_CTRL_CALCULATEOFFSET_XY_ARRAY(MY_CTRLSARRAY,MY_CTRLPOS,MY_POSX,MY_POSY)
