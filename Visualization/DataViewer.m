function DataViewer
%DATAVIEWER This function creates a GUI interface for End-Users

%  Create and then hide the GUI as it is being constructed.
f = figure('Visible','off','Position',[270,1000,900,570]);

%  Construct the components.
hstart = uicontrol('Style','togglebutton','String','Start',...
    'Position',[315,220,70,25],...
    'Callback',{@start_Callback});

htext = uicontrol('Style','text','String','Select dataset from drop-down menu, then click START',...
    'Position',[325,90,60,15]);

hpopup = uicontrol('Style','popupmenu',...
    'String',{'Plot 1', 'Plot 2'},...
    'Position',[300,50,100,25],...
    'Callback',{@popup_menu_Callback});

ha = axes('Units','Pixels','Position',[50,60,185,195]);
hb = axes('Units','Pixels','Position',[50,300,185,195]);
align([hstart,htext,hpopup],'Center','None');

% Initialize the GUI.
% Change units to normalized so components resize
% automatically.
set([f,ha,hstart,htext,hpopup],...
    'Units','normalized');

% Assign the GUI a name to appear in the window title.
set(f,'Name','Anomaly Detection GUI')
% Move the GUI to the center of the screen.
movegui(f,'center')
% Make the GUI visible.
set(f,'Visible','on');

%  Pop-up menu callback. Read the pop-up menu Value property
%  to determine which item is currently displayed and make it
%  the current data.
    function popup_menu_Callback(source,eventdata)
        % Determine the selected data set.
        str = get(source, 'String');
        val = get(source,'Value');
        % Set current data to the selected data set.
        switch str{val};
            case 'Plot1'
                
            case 'Plot2'
                
        end
    end
end

