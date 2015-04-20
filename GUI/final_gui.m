function SmartHomeGUI
%% Initialize Data:
clear; clc;

%% Global Variables
option = 'Aggregate Power';
counter = 0;

%% Input Data
load('phaseData.mat','phaseData');  %% change to read from a csv file
load('timevec.mat', 'timevec')
latest_data = phaseData(:,1);
current_data = [phaseData(:,1)];
current_time = [timevec(:,1)];

appStatus={'OFF','OFF','OFF','OFF'};  % data input

%% GUI setup
%  Create and then hide the GUI as it is being constructed.
f = figure('Visible','off','Position',[270,1000,900,700]);


%  Construct the components.
ha = axes('Units','Pixels','Position',[150,450,600,200],'Visible','off');
hb = axes('Units','Pixels','Position',[150, 50, 600, 200],'Visible','off');
hpanel = uipanel('Units','Pixels','Title','Appliance Status','FontSize',20,'FontWeight','Bold',...
    'Position',[150,300,300,120],'BackgroundColor','w','FontName','Helvetica');
happ = uicontrol('Parent',hpanel,'Style','text','String',{'HVAC 1','HVAC 2','Hot box','Refridgerator'},...
      'Position',[40,1,120,90],'FontSize',20,'FontName','Helvetica','BackgroundColor','w');
hstatus = uicontrol('Parent',hpanel,'Style','text','String',appStatus,...
      'Position',[200,1,50,90],'FontSize',20,'FontName','Helvetica','BackgroundColor','w');
hpopup = uicontrol('Style','popupmenu',...
    'String',{'HVAC 1','HVAC 2','Hot box','Refridgerator'},...
    'Position',[200,320,200,50],...
    'Callback',{@popup_menu_Callback},...
    'FontSize',20);
  
  

% Initialize the GUI.
% Change units to normalized so components resize automatically.
set([f,ha,hb,hpanel,happ,hstatus,hpopup],...
    'Units','normalized');
% Assign the GUI a name to appear in the window title.
set(f,'Name','Test GUI')
% Move the GUI to the center of the screen.
movegui(f,'center')
% Make the GUI visible.
set(f,'Visible','on' ,'Color','w');
align([ha,hpanel,hpopup],'distribute','none');


%% Live plot
axes(ha);
mplot(1) = plot(linspace(numel(latest_data),1,numel(latest_data)), latest_data);
        title('Smart Home Power Data','FontSize',20,'FontWeight','bold','FontName','Helvetica');
%         xlabel(datestr(latest_time(200,1)/86400+719529,1),'FontSize',14);
        ylabel('Power (W)','FontSize',14);
%         set(gca,'FontSize',12,'XTick',[0,200],...
%             'XTickLabel',{datestr(latest_time(1,1)/86400+719529,13),...
%             datestr(latest_time(200,1)/86400+719529,13)});

%         while(1)
%             axes(ha);
%             current_data = circshift(current_data, [-1,0]);
%             current_time = circshift(current_time, [-1,0]);
%             phaseData(:,1) = circshift(phaseData(:,1), [-1,0]);
%             phaseData(:,2) = circshift(phaseData(:,2), [-1,0]);
%             phaseData(:,3) = circshift(phaseData(:,3), [-1,0]);
%             phaseData(:,4) = circshift(phaseData(:,4), [-1,0]);
%             phaseData(:,5) = circshift(phaseData(:,5), [-1,0]);
%             sampleTime(:,1) = circshift(sampleTime(:,1), [-1,0]);
%             latest_data = flipud(current_data(1:200));
%             latest_time = current_time(1:200);
%             set(mplot(1), 'YData', latest_data);
%             axis([0, 200, 0 , 8000]);
% %             xlabel(datestr(latest_time(200,1)/86400+719529,1),'FontSize',14);
%             ylabel('Power (W)','FontSize',14);
%             set(gca,'FontSize',12,'XTick',[0,200],...
%                 'XTickLabel',{datestr(latest_time(1,1)/86400+719529,13),...
%                 datestr(latest_time(200,1)/86400+719529,13)});
%             counter = counter + 1;
%             if counter == 20
%                 pause(0.01);
%             else
%                 pause(0.5);
%             end
%             drawnow;
%         end

%% Dropdown menu
    function popup_menu_Callback(source,eventdata)
        % Determine the selected data set.
        str = get(source, 'String');
        val = get(source,'Value');
        % Set current data to the selected data set.
        switch str{val};
            case 'HVAC 1'
                current_data = phaseData(:,1);  % data input
                option = 'HVAC 1';
                counter = 20;
            case 'HVAC 2'
                current_data = phaseData(:,2);  % data input
                option = 'HVAC 2';
                counter = 20;
            case 'Hot box'
                current_data = phaseData(:,3);  % data input
                option = 'Hot box';
                counter = 20;
            case 'Refridgerator'
                current_data = phaseData(:,4);  % data input
                option = 'Refridgerator';
                counter = 20;
        end
    end

%% Prediction Plot
axes(hb);
while 1
plot(current_data)
drawnow
end
title('Prediction','FontSize',20,'FontWeight','bold','FontName','Helvetica');
switch option
    case 'HVAC 1'
        plot(current_data)
    case 'HVAC 2'
        plot(current_data)
    case 'Hot box'
        plot(current_data)
    case 'Refridgerator'
        plot(current_data)
end
                         
end