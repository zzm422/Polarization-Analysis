function varargout = LegacyRegistrationSessionMetadataEntry(varargin)
% LEGACYREGISTRATIONSESSIONMETADATAENTRY MATLAB code for LegacyRegistrationSessionMetadataEntry.fig
%      LEGACYREGISTRATIONSESSIONMETADATAENTRY, by itself, creates a new LEGACYREGISTRATIONSESSIONMETADATAENTRY or raises the existing
%      singleton*.
%
%      H = LEGACYREGISTRATIONSESSIONMETADATAENTRY returns the handle to a new LEGACYREGISTRATIONSESSIONMETADATAENTRY or the handle to
%      the existing singleton*.
%
%      LEGACYREGISTRATIONSESSIONMETADATAENTRY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LEGACYREGISTRATIONSESSIONMETADATAENTRY.M with the given input arguments.
%
%      LEGACYREGISTRATIONSESSIONMETADATAENTRY('Property','Value',...) creates a new LEGACYREGISTRATIONSESSIONMETADATAENTRY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LegacyRegistrationSessionMetadataEntry_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LegacyRegistrationSessionMetadataEntry_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LegacyRegistrationSessionMetadataEntry

% Last Modified by GUIDE v2.5 07-Mar-2016 11:32:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LegacyRegistrationSessionMetadataEntry_OpeningFcn, ...
                   'gui_OutputFcn',  @LegacyRegistrationSessionMetadataEntry_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1}) && ~isempty(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
end

% --- Executes just before LegacyRegistrationSessionMetadataEntry is made visible.
function LegacyRegistrationSessionMetadataEntry_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LegacyRegistrationSessionMetadataEntry (see VARARGIN)

% Choose default command line output for LegacyRegistrationSessionMetadataEntry
handles.output = hObject;

%***************************************************************
%INPUT: (importPath, userName, sessionChoices, isEdit, session*)
%        *may be empty)
%***************************************************************

handles.importPath = varargin{1}; %Param is importPath
handles.userName = varargin{2}; %Param is userName
handles.sessionChoices = varargin{3}; %Param is sessionChoices

isEdit = varargin{4};

session = [];

if length(varargin) > 4
    session = varargin{5};
end

if isempty(session)
    session = LegacyRegistrationSession;
end
    
handles.cancel = false;   
    
if isEdit    
    set(handles.importPathTitle, 'Visible', 'off');
    set(handles.importPathDisplay, 'Visible', 'off');
    
    handles.sessionDate = session.sessionDate;    
    handles.sessionDoneBy = session.sessionDoneBy;
    handles.linkedSessionNumbers = session.linkedSessionNumbers;
    handles.registrationType = session.registrationType;
    handles.registrationParams = session.registrationParams;
    handles.rejected = session.rejected;
    handles.rejectedReason = session.rejectedReason;
    handles.rejectedBy = session.rejectedBy;
    handles.sessionNotes = session.notes;
    
else
    defaultSession = LegacyRegistrationSession;
    
    set(handles.importPathDisplay, 'String', handles.importPath);
        
    handles.sessionDate = session.sessionDate;
    
    if isempty(session.sessionDoneBy)
        handles.sessionDoneBy = handles.userName;
    else    
        handles.sessionDoneBy = session.sessionDoneBy;    
    end
    
    handles.linkedSessionNumbers = session.linkedSessionNumbers;
    handles.registrationType = session.registrationType;
    handles.registrationParams = session.registrationParams;
    handles.rejected = defaultSession.rejected;
    handles.rejectedReason = defaultSession.rejectedReason;
    handles.rejectedBy = defaultSession.rejectedBy;
    handles.sessionNotes = defaultSession.notes;
end


% ** SET TEXT FIELDS **

if isempty(handles.sessionDate) || handles.sessionDate == 0
    set(handles.sessionDateDisplay, 'String', '');
else    
    set(handles.sessionDateDisplay, 'String', displayDate(handles.sessionDate));
end

set(handles.sessionDoneByInput, 'String', handles.sessionDoneBy);
set(handles.registrationParamsInput, 'String', handles.registrationParams);
set(handles.sessionNotesInput, 'String', handles.sessionNotes);


% ** SET POP UP MENUS **

[choices, ~] = choicesFromEnum('RegistrationTypes');
defaultChoiceString = 'Select a Registration Type';

selectedChoice = handles.registrationType;

setPopUpMenu(handles.registrationTypeList, defaultChoiceString, choices, selectedChoice);


% ** SET LISTBOXES **

listBoxHandle = handles.sessionListbox;

setSessionListBox(listBoxHandle, handles.sessionChoices, handles.linkedSessionNumbers);


% ** SET REJECTED INPUTS **

handles = setRejectedInputFields(handles);

% ** SET DONE BUTTON **

checkToEnableOkButton(handles)

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LegacyRegistrationSessionMetadataEntry wait for user response (see UIRESUME)
uiwait(handles.legacyRegistrationSessionMetadataEntry);
end

% --- Outputs from this function are returned to the command line.
function varargout = LegacyRegistrationSessionMetadataEntry_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%*******************************************************************************************************************************
%OUTPUT: [cancel, sessionDate, sessionDoneBy, notes, registrationType, registrationParams, rejected, rejectedReason, rejectedBy, sessionChoices]
%*******************************************************************************************************************************

handles.linkedSessionNumbers = getSessionNumbersFromListBox(handles.sessionListbox, handles.sessionChoices);
get(handles.sessionListbox, 'Value');
guidata(hObject, handles);

% Get default command line output from handles structure
varargout{1} = handles.cancel;
varargout{2} = handles.sessionDate;
varargout{3} = handles.sessionDoneBy;
varargout{4} = handles.sessionNotes;
varargout{5} = handles.registrationType;
varargout{6} = handles.registrationParams;
varargout{7} = handles.rejected;
varargout{8} = handles.rejectedReason;
varargout{9} = handles.rejectedBy;
varargout{10} = handles.linkedSessionNumbers;

close(handles.legacyRegistrationSessionMetadataEntry);
end


function importPathDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to importPathDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of importPathDisplay as text
%        str2double(get(hObject,'String')) returns contents of importPathDisplay as a double

set(handles.importPathDisplay, 'String', handles.importPath);
guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function importPathDisplay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to importPathDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function sessionDateDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to sessionDateDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sessionDateDisplay as text
%        str2double(get(hObject,'String')) returns contents of sessionDateDisplay as a double
end

% --- Executes during object creation, after setting all properties.
function sessionDateDisplay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sessionDateDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in sessionDatePick.
function sessionDatePick_Callback(hObject, eventdata, handles)
% hObject    handle to sessionDatePick (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

justDate = true;

serialDate = guiDatePicker(now, justDate);

handles.sessionDate = serialDate;

setDateInput(handles.sessionDateDisplay, serialDate, justDate);

checkToEnableOkButton(handles);

guidata(hObject, handles);

end


function sessionDoneByInput_Callback(hObject, eventdata, handles)
% hObject    handle to sessionDoneByInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sessionDoneByInput as text
%        str2double(get(hObject,'String')) returns contents of sessionDoneByInput as a double

handles.sessionDoneBy = get(hObject, 'String');

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function sessionDoneByInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sessionDoneByInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function sessionNotesInput_Callback(hObject, eventdata, handles)
% hObject    handle to sessionNotesInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sessionNotesInput as text
%        str2double(get(hObject,'String')) returns contents of sessionNotesInput as a double

handles.sessionNotes = strjoin(rot90(cellstr(get(hObject, 'String'))));

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function sessionNotesInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sessionNotesInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

enableLineScrolling(hObject);

end


function registrationParamsInput_Callback(hObject, eventdata, handles)
% hObject    handle to registrationParamsInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of registrationParamsInput as text
%        str2double(get(hObject,'String')) returns contents of registrationParamsInput as a double

handles.registrationParams = get(hObject, 'String');

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function registrationParamsInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to registrationParamsInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in registrationTypeList.
function registrationTypeList_Callback(hObject, eventdata, handles)
% hObject    handle to registrationTypeList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns registrationTypeList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from registrationTypeList

[choices, ~] = choicesFromEnum('RegistrationTypes');


% Check if value is default value
if get(hObject, 'Value') == 1 
    handles.registrationType = [];
else
    handles.registrationType = choices(get(hObject, 'Value')-1); 
end

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function registrationTypeList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to registrationTypeList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function rejectedReasonInput_Callback(hObject, eventdata, handles)
% hObject    handle to rejectedReasonInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rejectedReasonInput as text
%        str2double(get(hObject,'String')) returns contents of rejectedReasonInput as a double

handles.rejectedReason = strjoin(rot90(cellstr(get(hObject, 'String'))));

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function rejectedReasonInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rejectedReasonInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

enableLineScrolling(hObject);

end


function rejectedByInput_Callback(hObject, eventdata, handles)
% hObject    handle to rejectedByInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rejectedByInput as text
%        str2double(get(hObject,'String')) returns contents of rejectedByInput as a double

handles.rejectedBy = get(hObject, 'String');

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function rejectedByInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rejectedByInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in Cancel.
function Cancel_Callback(hObject, eventdata, handles)
% hObject    handle to Cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

exit = questdlg('Are you sure you want to quit?','Quit','Yes','No','No'); 
switch exit
    case 'Yes'
        %Clears variables in the case that they wish to exit the program
        handles.cancel = true;
        handles.sessionDate = [];
        handles.sessionDoneBy = '';
        handles.sessionNotes = '';
        handles.registrationType = [];
        handles.registrationParams = '';
        handles.rejected = [];
        handles.rejectedReason = '';
        handles.rejectedBy = '';
        guidata(hObject, handles);
        uiresume(handles.legacyRegistrationSessionMetadataEntry);
    case 'No'
end

end

% --- Executes on button press in OK.
function OK_Callback(hObject, eventdata, handles)
% hObject    handle to OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

guidata(hObject, handles);
uiresume(handles.legacyRegistrationSessionMetadataEntry);

end

% --- Executes on button press in yesRejectedButton.
function yesRejectedButton_Callback(hObject, eventdata, handles)
% hObject    handle to yesRejectedButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of yesRejectedButton

set(handles.noRejectedButton, 'Value', 0);

handles.rejected = true;

set(handles.yesRejectedButton, 'Value', 1);

set(handles.rejectedReasonInput, 'enable', 'on');
set(handles.rejectedByInput, 'enable', 'on');
set(handles.rejectedByInput, 'String', handles.userName);

handles.rejectedBy = handles.userName;

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes on button press in noRejectedButton.
function noRejectedButton_Callback(hObject, eventdata, handles)
% hObject    handle to noRejectedButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of noRejectedButton

set(handles.noRejectedButton, 'Value', 1);

handles.rejected = false;

set(handles.yesRejectedButton, 'Value', 0);

set(handles.rejectedReasonInput, 'enable', 'off');
set(handles.rejectedByInput, 'enable', 'off');
set(handles.rejectedReasonInput, 'String', '');
set(handles.rejectedByInput, 'String', '');

handles.rejectedBy = '';
handles.rejectedReason = '';

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes when user attempts to close legacyRegistrationSessionMetadataEntry.
function legacyRegistrationSessionMetadataEntry_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to legacyRegistrationSessionMetadataEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    handles.cancel = true;
    handles.sessionDate = [];
    handles.sessionDoneBy = '';
    handles.sessionNotes = '';
    handles.registrationType = [];
    handles.registrationParams = '';
    handles.rejected = [];
    handles.rejectedReason = '';
    handles.rejectedBy = '';
    guidata(hObject, handles);
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    handles.cancel = true;
    handles.sessionDate = [];
    handles.sessionDoneBy = '';
    handles.sessionNotes = '';
    handles.registrationType = [];
    handles.registrationParams = '';
    handles.rejected = [];
    handles.rejectedReason = '';
    handles.rejectedBy = '';
    guidata(hObject, handles);
    delete(hObject);
end
end

% --- Executes on selection change in sessionListbox.
function sessionListbox_Callback(hObject, eventdata, handles)
% hObject    handle to sessionListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns sessionListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from sessionListbox

checkToEnableOkButton(handles);

end

% --- Executes during object creation, after setting all properties.
function sessionListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sessionListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

%% Local Functions

function checkToEnableOkButton(handles)

%This function will check to see if any of the input variables are empty,
%and if not it will enable the OK button

if ~isempty(handles.sessionDate) && ~isempty(handles.sessionDoneBy) && ~isempty(handles.registrationType) && ~isempty(handles.rejected) && ~isempty(get(handles.sessionListbox, 'Value'))
    if handles.rejected 
        if ~isempty(handles.rejectedReason) && ~isempty(handles.rejectedBy)
            set(handles.OK, 'enable', 'on');
        else
            set(handles.OK, 'enable', 'off');
        end
    else
        set(handles.OK, 'enable', 'on');
    end
else
    set(handles.OK, 'enable', 'off');
end

end





