function figureCloseReq(src,callbackdata)
% Close request function 
% to display a question dialog box 
   selection = questdlg('Close This Figure? This will cause the Disaggregation to stop!',...
      'Are you sure you want to close this window?',...
      'Yes','No','Yes'); 
   switch selection, 
      case 'Yes',
         delete(gcf)
      case 'No'
      return 
   end
end