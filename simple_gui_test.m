function simple_gui_test
% Select a data set from the pop-up menu, then
% click the toggle button. Clicking the button
% plots the selected data in the axes.

%  Create and then hide the GUI as it is being constructed.
f = figure('Visible','off','Position',[270,1000,900,570]);
a=[linspace(0,2*pi,200)' sin(linspace(0,2*pi,200)')];
b=[linspace(0,2*pi,200)' linspace(1,200,200)'];
current_data = a;

%  Construct the components.
hstart = uicontrol('Style','togglebutton','String','Start',...
    'Position',[630,460,140,50],...
    'Callback',{@start_Callback});

htext = uicontrol('Style','text','String','Select Data',...
    'Position',[650,380,120,30]);

hpopup = uicontrol('Style','popupmenu',...
    'String',{'sin','line'},...
    'Position',[600,300,200,50],...
    'Callback',{@popup_menu_Callback});
ha = axes('Units','Pixels','Position',[100,120,400,370]);
hb = axes('Units', 'Pixels', 'Position', [600, 100, 200, 185]);
align([hstart,htext,hpopup],'Center','None');

% Initialize the GUI.
% Change units to normalized so components resize automatically.
set([f,ha,hstart,htext,hpopup],...
    'Units','normalized');
% Assign the GUI a name to appear in the window title.
set(f,'Name','Test GUI')
% Move the GUI to the center of the screen.
movegui(f,'center')
% Make the GUI visible.
set(f,'Visible','on');


    function popup_menu_Callback(source,eventdata)
        % Determine the selected data set.
        str = get(source, 'String');
        val = get(source,'Value');
        % Set current data to the selected data set.
        switch str{val};
            case 'sin' % User selects Peaks.
                current_data = a;
                
            case 'line' % User selects Membrane.
                current_data = b;
        end
    end

% Push button callbacks. Each callback plots current_data in
% the specified plot type.
    mplot(1) = plot(current_data(:,1),current_data(:,2));
    function start_Callback(hObject,eventdata,handles)
        if get(hObject,'Value')
            set(hObject,'String','Streaming');
        else set(hObject,'String','Start');
        end
        
            axes(hb);
            pie(1:10);
        while get(hObject,'Value')            
            axes(ha)
            plot(current_data(:,1),current_data(:,2));
            current_data(:,2)=circshift(current_data(:,2),[1,0]);
            set(mplot(1),'YData',current_data(:,2));
            pause(0.01)
            drawnow
            
        end        
    end
end