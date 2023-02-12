function varargout = inv_pend_ani(varargin)
%{
***************************************************************************

This function is intended for use in the inv_pend_ani GUI file. It contains
the code necessary to run the GUI's simulations and controls based on the
designed compensator with steady state error controller.

**************************************************************************
%}
% INV_PEND_ANI MATLAB code for inv_pend_ani.fig
%      INV_PEND_ANI, by itself, creates a new INV_PEND_ANI or raises the existing
%      singleton*.
%
%      H = INV_PEND_ANI returns the handle to a new INV_PEND_ANI or the handle to
%      the existing singleton*.
%
%      INV_PEND_ANI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INV_PEND_ANI.M with the given input arguments.
%
%      INV_PEND_ANI('Property','Value',...) creates a new INV_PEND_ANI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before inv_pend_ani_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to inv_pend_ani_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help inv_pend_ani

% Last Modified by GUIDE v2.5 22-Mar-2019 00:05:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @inv_pend_ani_OpeningFcn, ...
                   'gui_OutputFcn',  @inv_pend_ani_OutputFcn, ...
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


% --- Executes just before inv_pend_ani is made visible.
function inv_pend_ani_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to inv_pend_ani (see VARARGIN)

% Choose default command line output for inv_pend_ani
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes inv_pend_ani wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = inv_pend_ani_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject handle to axes2 (see GCBO)
% eventdata reserved - to be defined in a future version of MATLAB
% handles empty - handles not created until after all CreateFcns called


% --- Executes on button press in Run.
function Run_Callback(hObject, eventdata, handles)
% hObject    handle to Run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global K
global cartpos
global pendangl
global T
global Nbar
global stepval
% Nbar data stored in the Run.UserData
 A = [0 1 0 0;
 51.58 0 0 0.5263;
 0 0 0 1;
 -7.737 0 0 -0.1789];
 B = [0; -5.263; 0; 1.789];
 C = [0 0 1 0;1 0 0 0];
 D = [0;0];
 Cn = [0 0 1 0]; %C matrix when Y=x, or step command only applied to x

% Get the weighing factors from the editable text fields of the GUI
% x=for pendulum angle, y=for cart position
 x=str2num(get(handles.xtext,'string'));
 y=str2num(get(handles.ytext,'String'));

 Q=[x 0 0 0;
 0 0 0 0;
 0 0 y 0;
 0 0 0 0];
 R = 1;
%Finding the state feedback gain K matrix with the lqr command
 disp('state feedback gain vector is:')
 K = lqr(A,B,Q,R)

%The resulting LQR controller matrices
 Ac = [(A-B*K)];
 Bc = [B];
 Cc = [C];
 Dc = [D];

%finding Controller poles

 disp('controller poles are:')
 cp= eig(Ac);

% making the observer poles 10 times faster than the...
%real part of the slowest pole of the controller

 disp('observer poles are:')
 obsr_poles = [real(min(cp))*10 real(min(cp))*10-1
 real(min(cp))*10-2 real(min(cp))*10-3];

% placing observer poles

 disp('gain vector for the output feedback to the observer is:')
 L = place(A',C',obsr_poles)'

%Compensator(controller + observer) matrices
 Acl = [(A-B*K) (B*K);zeros(size(A)) (A-L*C)];
 Bcl = [B;zeros(size(B))];
 Ccl = [C zeros(size(C))];
 Dcl = [0];

%Modifing Ccl because reference step command applied to x only ==> y=x

 Ccln=[Cn zeros(size(Cn))];

%there should be some modification in the input signal for good tracking performance. that means...
%there should be extra gain used to scale the closed loop transfer function to make the steady state step
error=0.
 Nbarval = get(handles.reference,'Value');
 if Nbarval == 0
 Nbar = 1;
 set(handles.Run,'UserData',Nbar);
 stepaxis=stepval/1000;
 elseif Nbarval == 1
 
 %calculating the scale factor for the overall closed-loop system

 Nbar=-inv(Ccln*(Acl\Bcl))
 set(handles.Run,'UserData',Nbar);
 end

%Get the value of the step input from the step slider
 stepval=get(handles.stepslider,'Value');

 T=0:0.1:6;
 U=stepval*ones(size(T));

%modifing Bcl for the steady state error traking purpose

 Bclt = [B*Nbar;zeros(size(B))];
 [Y,X]=lsim(Acl,Bclt,Ccl,Dcl,U,T);
 cartpos=X(:,3);
 pendangl=X(:,1);

%Pendulum and cart data
 cart_length=0.3;
 cl2=cart_length/2;

 ltime=length(cartpos);

 cartl=cartpos-cl2;
 cartr=cartpos+cl2;

 pendang=-pendangl;
 pendl=0.6;

 pendx=pendl*sin(pendang)+cartpos;
 pendy=pendl*cos(pendang)+0.03;

 axes(handles.axes1)
 plot(T(1),cartpos(1), 'r', 'EraseMode', 'none')
 plot(T(1),pendangl(1), 'b', 'EraseMode', 'none')

%Set the axis for the step response plot
 axes(handles.axes1)
 if stepval > 0
 axis([0 6 -stepval/2 stepval*2])
 elseif stepval < 0
 axis([0 6 stepval*2 -stepval/2])
 else
 axis([0 6 -0.5 0.5])
 end

 title(sprintf('Step Response to %0.4f cm input',stepval))
 xlabel('Time (sec)')
 grid on

 hold on

%Plot the first frame of the animation
 axes(handles.axes2)
 cla
 L = plot([cartpos(1) pendx(1)], [0.03 pendy(1)], 'b', 'EraseMode', ...
 'xor','LineWidth',[7]);
 hold on
 J = plot([cartl(1) cartr(1)], [0 0], 'r', 'EraseMode', ...
 'xor','LineWidth',[20]);

 axis([-.7 0.7 -0.1 0.7])
 title('Animation of Inverted pendulum')
 grid on;
 xlabel('X Position (m)')
 ylabel('Y Position (m)')

%Check if the animation is to be advanced manually
 manual=get(handles.manualbox,'Value');
%Run the animation
 for i = 2:ltime-1,
 if manual == 1
 pause
 end

 set(J,'XData', [cartl(i) cartr(i)]);
 set(L,'XData', [cartpos(i) pendx(i)]);
 set(L,'YData', [0.03 pendy(i)]);
 drawnow;

 axes(handles.axes1)
 plot([T(i),T(i+1)],[cartpos(i),cartpos(i+1)], 'r', 'EraseMode', 'none')
 plot([T(i),T(i+1)],[pendangl(i),pendangl(i+1)], 'b', 'EraseMode', 'none')
 end

%Add legend to step plot
 axes(handles.axes1)
 hold on
 legend('Pendulum Angle (rad.)','Cart Position (cm.)')
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Run_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function xtext_Callback(hObject, eventdata, handles)
% hObject    handle to xtext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xtext as text
%        str2double(get(hObject,'String')) returns contents of xtext as a double


% --- Executes during object creation, after setting all properties.
function xtext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xtext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function ytext_Callback(hObject, eventdata, handles)
% hObject    handle to ytext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ytext as text
%        str2double(get(hObject,'String')) returns contents of ytext as a double


% --- Executes during object creation, after setting all properties.
function ytext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ytext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in manualbox.
function manualbox_Callback(hObject, eventdata, handles)
% hObject    handle to manualbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of manualbox

% --- Executes during object creation, after setting all properties.
function manualbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to manualbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in reference.
function reference_Callback(hObject, eventdata, handles)
% hObject    handle to reference (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of reference

% --- Executes during object creation, after setting all properties.
function reference_CreateFcn(hObject, eventdata, handles)
% hObject    handle to reference (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes on slider movement.
function stepslider_Callback(hObject, eventdata, handles)
% hObject    handle to stepslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
stepval=get(hObject,'Value');
 set(handles.text8,'string',sprintf('%6.4f',stepval));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function stepslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stepslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in clear.
function clear_Callback(hObject, eventdata, handles)
% hObject    handle to clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1)
 cla
 axis([0 6 -0.5 0.5])
 title('Step Response')
 xlabel('Time (sec)')

 axes(handles.axes2)
 cartpos=0;
 cart_length=0.3;
 cl2=cart_length/2;

 cartl=cartpos-cl2;
 cartr=cartpos+cl2;

 pendang=0;
 pendl=0.6;

 pendx=pendl*sin(pendang)+cartpos;
 pendy=pendl*cos(pendang)+0.03;
 cla
 K = plot([cartpos(1) pendx(1)], [0.03 pendy(1)], 'b', 'EraseMode', ...
 'xor','LineWidth',[7]);
 hold on
 J = plot([cartl(1) cartr(1)], [0 0], 'r', 'EraseMode', ...
 'xor','LineWidth',[20]);
 guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function clear_CreateFcn(hObject, eventdata, handles)
% hObject    handle to clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes during object creation, after setting all properties.
function text2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes during object creation, after setting all properties.
function text7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes during object creation, after setting all properties.
function text8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject handle to axes1 (see GCBO)
% eventdata reserved - to be defined in a future version of MATLAB
% handles empty - handles not created until after all CreateFcns called
% Hint: place code in OpeningFcn to populate axes1

% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject handle to axes2 (see GCBO)
% eventdata reserved - to be defined in a future version of MATLAB
% handles empty - handles not created until after all CreateFcns called
% Hint: place code in OpeningFcn to populate axes2

% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(inv_pend_ani)

% --- Executes during object creation, after setting all properties.
function exit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
