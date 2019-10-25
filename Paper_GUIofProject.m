function varargout = Paper_GUIofProject(varargin)
% PAPER_GUIOFPROJECT MATLAB code for Paper_GUIofProject.fig
%      PAPER_GUIOFPROJECT, by itself, creates a new PAPER_GUIOFPROJECT or raises the existing
%      singleton*.
%
%      H = PAPER_GUIOFPROJECT returns the handle to a new PAPER_GUIOFPROJECT or the handle to
%      the existing singleton*.
%
%      PAPER_GUIOFPROJECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PAPER_GUIOFPROJECT.M with the given input arguments.
%
%      PAPER_GUIOFPROJECT('Property','Value',...) creates a new PAPER_GUIOFPROJECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Paper_GUIofProject_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Paper_GUIofProject_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Paper_GUIofProject

% Last Modified by GUIDE v2.5 11-Apr-2019 02:59:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Paper_GUIofProject_OpeningFcn, ...
                   'gui_OutputFcn',  @Paper_GUIofProject_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Paper_GUIofProject is made visible.
function Paper_GUIofProject_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Paper_GUIofProject (see VARARGIN)

% Choose default command line output for Paper_GUIofProject
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Paper_GUIofProject wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Paper_GUIofProject_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I;
[a b]=uigetfile({'*.jpg*','Select and Image'});
path = strcat(b,a);
set(handles.edit2,'string',path);
I=imread([b a]);
axes(handles.axes1);
imshow(I);
setappdata(0,'pass',I);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Inputimage;
Inputimage = getappdata(0,'pass') ;
%% PreProcess

if size(Inputimage,3)==3 % RGB image
 Inputimage=rgb2gray(Inputimage);
end
axes(handles.axes2);
imshow(Inputimage);

Inputimage =  medfilt2(Inputimage);

axes(handles.axes3);
imshow(Inputimage);

Inputimage = edge(Inputimage,'log');

axes(handles.axes4);
imshow(Inputimage);

%% Localization and extraction

%threshold = graythresh(Inputimage);
Inputimage =im2bw(Inputimage);
axes(handles.axes5);
imshow(Inputimage);

nhood = [1 1 1 1;1 1 1 1];
Inputimage = imdilate(Inputimage,nhood);
axes(handles.axes6);
imshow(Inputimage);

[L Ne]=bwlabel(Inputimage);
measurements = regionprops(L, 'BoundingBox');
axes(handles.axes7);
imshow(Inputimage);
hold on
for k = 1 : length(measurements)
    thisBB = measurements(k).BoundingBox;
    rectangle('Position',[thisBB(1),thisBB(2),thisBB(3),thisBB(4)],'EdgeColor','b','LineWidth',1 );
end
hold off

%% Component filtering

for n=1:Ne
  [r,c] = find(L==n);
  h = max(r)-min(r);
  w = max(c)-min(c);
  if((w <=(2*h)) && (h*w)>30 )
    n1=Inputimage(min(r):max(r),min(c):max(c));
    figure;
    imshow(n1);
    pause(0.5)
  end
end
